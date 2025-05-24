
import os
import numpy as np
import pandas as pd
import cv2
import tensorflow as tf
import tensorflow_hub as hub

movenet = hub.load("https://tfhub.dev/google/movenet/singlepose/lightning/4").signatures['serving_default']

KEYPOINT_DICT = {
    0: 'nose', 1: 'left_eye', 2: 'right_eye', 3: 'left_ear', 4: 'right_ear',
    5: 'left_shoulder', 6: 'right_shoulder', 7: 'left_elbow', 8: 'right_elbow',
    9: 'left_wrist', 10: 'right_wrist', 11: 'left_hip', 12: 'right_hip',
    13: 'left_knee', 14: 'right_knee', 15: 'left_ankle', 16: 'right_ankle'
}

try:
   REFERENCE_COLUMNS = pd.read_csv("video_summary_features_engineered (6).csv", nrows=0).columns.tolist()
   REFERENCE_COLUMNS = [col for col in REFERENCE_COLUMNS if col != 'label']
except FileNotFoundError:
    raise FileNotFoundError("Missing reference CSV: 'video_summary_features_engineered (6).csv'")

def detect_pose(img):
    input_img = tf.image.resize_with_pad(tf.expand_dims(img, axis=0), 192, 192)
    input_img = tf.cast(input_img, dtype=tf.int32)
    outputs = movenet(input_img)
    keypoints = outputs['output_0'].numpy()[0, 0, :, :]
    return keypoints

def compute_angle(a, b, c):
    a, b, c = np.array(a), np.array(b), np.array(c)
    ba, bc = a - b, c - b
    if np.linalg.norm(ba) == 0 or np.linalg.norm(bc) == 0:
        return np.nan
    cosine_angle = np.dot(ba, bc) / (np.linalg.norm(ba) * np.linalg.norm(bc))
    return np.degrees(np.arccos(np.clip(cosine_angle, -1.0, 1.0)))

def extract_features_from_video(video_path):
    cap = cv2.VideoCapture(video_path)
    if not cap.isOpened():
        raise IOError(f"Failed to open video: {video_path}")

    fps = cap.get(cv2.CAP_PROP_FPS) or 30
    data, visibility = [], []
    frame_idx = 0

    while cap.isOpened():
        ret, frame = cap.read()
        if not ret:
            break

        rgb = cv2.cvtColor(frame, cv2.COLOR_BGR2RGB)
        keypoints = detect_pose(rgb)
        visibility.append(np.mean(keypoints[:, 2]))

        row = {'frame': frame_idx}
        for idx, name in KEYPOINT_DICT.items():
            y, x, c = keypoints[idx]
            row[f'{name}_x'] = x
            row[f'{name}_y'] = y
            row[f'{name}_c'] = c
        data.append(row)
        frame_idx += 1

    cap.release()
    df = pd.DataFrame(data)
    duration = len(df) / fps

    def stats(joint):
        s = {}
        for axis in ['x', 'y']:
            vals = df[f'{joint}_{axis}']
            s[f'{joint}_{axis}_min'] = vals.min()
            s[f'{joint}_{axis}_max'] = vals.max()
            s[f'{joint}_{axis}_avg'] = vals.mean()
            s[f'{joint}_{axis}_std'] = vals.std()
            s[f'{joint}_{axis}_norm'] = (vals.max() - vals.min()) / (vals.std() + 1e-6)
        return s

    feats = {'video': os.path.basename(video_path)}
    feats['duration_sec'] = duration
    feats['stroke_peak_frame'] = int(df['frame'].iloc[df['right_wrist_y'].idxmin()]) if 'right_wrist_y' in df else -1

    try:
        df['wrist_speed'] = np.sqrt(df['right_wrist_x'].diff()*2 + df['right_wrist_y'].diff()*2) * fps
        feats['wrist_speed_avg'] = df['wrist_speed'].mean()
        feats['wrist_speed_max'] = df['wrist_speed'].max()
    except:
        feats['wrist_speed_avg'] = feats['wrist_speed_max'] = np.nan

    feats['explosiveness_index'] = feats['wrist_speed_max'] / (feats['wrist_speed_avg'] + 1e-6)
    feats['fluidity'] = 1 / (df['wrist_speed'].std() + 1e-6) if 'wrist_speed' in df else np.nan
    feats['mean_visibility'] = np.mean(visibility)

    for side in ['left', 'right']:
        elbow_angles = [
            compute_angle(
                [df.at[i, f'{side}_shoulder_x'], df.at[i, f'{side}_shoulder_y']],
                [df.at[i, f'{side}_elbow_x'], df.at[i, f'{side}_elbow_y']],
                [df.at[i, f'{side}_wrist_x'], df.at[i, f'{side}_wrist_y']]
            ) for i in df.index
        ]
        knee_angles = [
            compute_angle(
                [df.at[i, f'{side}_hip_x'], df.at[i, f'{side}_hip_y']],
                [df.at[i, f'{side}_knee_x'], df.at[i, f'{side}_knee_y']],
                [df.at[i, f'{side}_ankle_x'], df.at[i, f'{side}_ankle_y']]
            ) for i in df.index
        ]
        for typ, angles in zip(['elbow', 'knee'], [elbow_angles, knee_angles]):
            prefix = f'{typ}_{side}'
            feats[f'{prefix}_avg'] = np.nanmean(angles)
            feats[f'{prefix}_min'] = np.nanmin(angles)
            feats[f'{prefix}_max'] = np.nanmax(angles)
            feats[f'{prefix}_std'] = np.nanstd(angles)

    hips_y = df[['left_hip_y', 'right_hip_y']].mean(axis=1)
    feats['hip_avg'] = hips_y.mean()
    feats['hip_min'] = hips_y.min()
    feats['hip_max'] = hips_y.max()
    feats['hip_std'] = hips_y.std()

    torso_leans = [
        compute_angle(
            [df.at[i, 'left_shoulder_x'], df.at[i, 'left_shoulder_y']],
            [df.at[i, 'right_shoulder_x'], df.at[i, 'right_shoulder_y']],
            [df.at[i, 'right_hip_x'], df.at[i, 'right_hip_y']]
        ) for i in df.index
    ]
    feats['torso_lean_avg'] = np.nanmean(torso_leans)
    feats['torso_lean_min'] = np.nanmin(torso_leans)
    feats['torso_lean_max'] = np.nanmax(torso_leans)
    feats['torso_lean_std'] = np.nanstd(torso_leans)

    feats['elbow_symmetry'] = abs(feats['elbow_left_avg'] - feats['elbow_right_avg'])
    feats['knee_symmetry'] = abs(feats['knee_left_avg'] - feats['knee_right_avg'])
    feats['shoulder_width'] = np.nanmean(np.abs(df['right_shoulder_x'] - df['left_shoulder_x']))
    feats['hip_width'] = np.nanmean(np.abs(df['right_hip_x'] - df['left_hip_x']))

    joint_feats = {}
    for joint in ['left_eye', 'right_eye', 'left_shoulder', 'right_shoulder', 'left_elbow', 'right_elbow',
                  'left_wrist', 'right_wrist', 'left_hip', 'right_hip', 'left_knee', 'right_knee',
                  'left_ankle', 'right_ankle']:
        joint_feats.update(stats(joint))

    feats.update(joint_feats)
    

    output = pd.DataFrame([feats])
    for col in REFERENCE_COLUMNS:
        if col not in output.columns:
            output[col] = np.nan
    output = output[REFERENCE_COLUMNS]
    return output

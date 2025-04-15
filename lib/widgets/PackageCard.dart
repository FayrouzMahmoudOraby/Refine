import 'package:flutter/material.dart';

class PackageCard extends StatelessWidget {
  final String title;
  final Color headerColor;
  final String price;
  final String descriptionLine1;
  final String descriptionLine2;
  final String buttonText;
  final List<String> features;
  final VoidCallback onButtonPressed;

  const PackageCard({
    super.key,
    required this.title,
    required this.headerColor,
    required this.price,
    required this.descriptionLine1,
    required this.descriptionLine2,
    required this.buttonText,
    required this.features,
    required this.onButtonPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 8,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      color: Colors.black.withOpacity(0.7),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header with Gradient and Shadow
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  headerColor.withOpacity(0.7),
                  headerColor.withOpacity(0.3),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.6),
                  blurRadius: 12,
                  spreadRadius: 4,
                ),
              ],
            ),
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 1.2,
                fontFamily: 'RobotoMono', // Modern font for AI theme
              ),
            ),
          ),

          // Content section with Padding
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // Price Text
                Text(
                  price,
                  style: const TextStyle(
                    fontSize: 34,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontFamily: 'RobotoMono', // AI-inspired font
                  ),
                ),
                const SizedBox(height: 12),

                // Description lines
                Text(
                  descriptionLine1,
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 4),
                Text(
                  descriptionLine2,
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 24),

                // Professional Button with smooth hover effect
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: onButtonPressed,
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          30,
                        ), // Rounded edges for a modern look
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor:
                          headerColor, // Match header color for consistency
                      side: BorderSide(
                        color: Colors.white.withOpacity(0.3),
                        width: 1.5,
                      ),
                      shadowColor: Colors.blue.withOpacity(0.8),
                      elevation: 6,
                    ),
                    child: Text(
                      buttonText,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight:
                            FontWeight
                                .w500, // Less bold for a more subtle appearance
                        color: Colors.white,
                        fontFamily: 'RobotoMono', // Consistent with the theme
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Feature checklist with AI-inspired icons
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children:
                      features.map((feature) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.check_circle_outline,
                                color: Colors.greenAccent,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  feature,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

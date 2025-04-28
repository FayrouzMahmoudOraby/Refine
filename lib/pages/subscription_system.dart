import 'package:flutter/material.dart';
import '../widgets/PackageCard.dart'; // Adjust path as necessary

class SubscriptionPage extends StatefulWidget {
  const SubscriptionPage({super.key});

  @override
  State<SubscriptionPage> createState() => _SubscriptionPageState();
}

class _SubscriptionPageState extends State<SubscriptionPage> {
  String selectedType = 'freelance';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(
        255,
        12,
        9,
        80,
      ), // Dark Blue Background
      appBar: AppBar(
        title: const Text(
          'Choose Your Plan',
          style: TextStyle(fontSize: 22, color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(
          255,
          12,
          9,
          80,
        ), // Match background color
        elevation: 0,
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),

          // Toggle buttons with futuristic design
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ChoiceChip(
                label: const Text(
                  'Freelance',
                  style: TextStyle(
                    fontSize: 18,
                    color: Color.fromARGB(255, 9, 9, 9),
                    fontFamily: 'RobotoMono',
                  ),
                ),
                selected: selectedType == 'freelance',
                onSelected: (_) {
                  setState(() => selectedType = 'freelance');
                },
                selectedColor: Colors.deepPurpleAccent,
                backgroundColor: Colors.transparent,
                labelStyle: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 10),
              ChoiceChip(
                label: const Text(
                  'Club',
                  style: TextStyle(
                    fontSize: 18,
                    color: Color.fromARGB(255, 0, 0, 0),
                    fontFamily: 'RobotoMono',
                  ),
                ),
                selected: selectedType == 'club',
                onSelected: (_) {
                  setState(() => selectedType = 'club');
                },
                selectedColor: Colors.deepPurpleAccent, // Glowing AI color
                backgroundColor: Colors.transparent,
                labelStyle: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Content Section
          Expanded(
            child:
                selectedType == 'freelance'
                    ? ListView(
                      children: [
                        PackageCard(
                          title: "Daily",
                          headerColor: const Color.fromARGB(255, 38, 31, 179),
                          price: "\$4.99",
                          descriptionLine1: "Quick access for one day.",
                          descriptionLine2: "Perfect for short tasks.",
                          buttonText: "Choose Daily",
                          features: [
                            "1-day full access",
                            "Standard support",
                            "Limited customization",
                          ],
                          onButtonPressed: () {
                            // Handle subscription logic
                          },
                        ),
                        PackageCard(
                          title: "Monthly",
                          headerColor: const Color.fromARGB(255, 1, 24, 216),
                          price: "\$14.99",
                          descriptionLine1: "Unlimited access for 30 days.",
                          descriptionLine2: "For ongoing work needs.",
                          buttonText: "Choose Monthly",
                          features: [
                            "30-day full access",
                            "Priority support",
                            "Access to all templates",
                          ],
                          onButtonPressed: () {},
                        ),
                        PackageCard(
                          title: "Yearly",
                          headerColor: const Color.fromARGB(255, 27, 86, 253),
                          price: "\$99.99",
                          descriptionLine1: "Best value for long term use.",
                          descriptionLine2: "Save over 40% annually.",
                          buttonText: "Choose Yearly",
                          features: [
                            "365-day full access",
                            "24/7 support",
                            "Advanced customization",
                          ],
                          onButtonPressed: () {},
                        ),
                      ],
                    )
                    : Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.info_outline,
                              size: 64,
                              color: Colors.white,
                            ),
                            const SizedBox(height: 20),
                            const Text(
                              'For club subscriptions, please contact us to set up a custom agreement tailored to your organization.',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 30),
                            ElevatedButton.icon(
                              onPressed: () {
                                // Handle contact logic
                              },
                              icon: const Icon(
                                Icons.mail_outline,
                                color: Colors.white,
                              ),
                              label: const Text("Contact Us"),
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 14,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                backgroundColor:
                                    Colors
                                        .deepPurpleAccent, // Updated from `primary`
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
          ),
        ],
      ),
    );
  }
}

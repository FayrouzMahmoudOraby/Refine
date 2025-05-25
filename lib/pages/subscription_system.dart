import 'package:flutter/material.dart';
import '../widgets/PackageCard.dart';

class SubscriptionPage extends StatefulWidget {
  const SubscriptionPage({super.key});

  @override
  State<SubscriptionPage> createState() => _SubscriptionPageState();
}

class _SubscriptionPageState extends State<SubscriptionPage> {
  String selectedType = 'freelance';

  @override
  Widget build(BuildContext context) {
    final backgroundColor = const Color(0xFF0C0950);
    final accentColor = Colors.deepPurpleAccent;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Choose Your Plan',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(height: 20),

            // Toggle buttons
            Container(
              decoration: BoxDecoration(
                color: Colors.white10,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => selectedType = 'freelance'),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color:
                              selectedType == 'freelance'
                                  ? accentColor
                                  : Colors.transparent,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Text(
                            'Freelance',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color:
                                  selectedType == 'freelance'
                                      ? Colors.white
                                      : Colors.white70,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => selectedType = 'club'),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color:
                              selectedType == 'club'
                                  ? accentColor
                                  : Colors.transparent,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Text(
                            'Club',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color:
                                  selectedType == 'club'
                                      ? Colors.white
                                      : Colors.white70,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Content
            Expanded(
              child:
                  selectedType == 'freelance'
                      ? ListView(
                        children: [
                          PackageCard(
                            title: "Athlete Plan",
                            headerColor: const Color(0xFF261FB3),
                            price: "\$20",
                            descriptionLine1: "Quick access for one day.",
                            descriptionLine2: "Perfect for short tasks.",
                            buttonText: "Choose Daily",
                            features: [
                              "1-day full access",
                              "Standard support",
                              "Limited customization",
                            ],
                            onButtonPressed: () {},
                          ),
                          PackageCard(
                            title: "Coach Plan",
                            headerColor: const Color(0xFF0118D8),
                            price: "\$49",
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
                            title: "Club Plan",
                            headerColor: const Color(0xFF1B56FD),
                            price: "\$122",
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
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.business_center_outlined,
                                size: 60,
                                color: Colors.white70,
                              ),
                              const SizedBox(height: 20),
                              const Text(
                                'For club subscriptions, please contact us to set up a custom agreement tailored to your organization.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 30),
                              ElevatedButton.icon(
                                onPressed: () {
                                  // handle contact
                                },
                                icon: const Icon(Icons.mail_outline),
                                label: const Text("Contact Us"),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: accentColor,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 24,
                                    vertical: 14,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
            ),
          ],
        ),
      ),
    );
  }
}

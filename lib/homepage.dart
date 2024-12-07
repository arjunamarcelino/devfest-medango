import 'package:flutter/material.dart';
import 'package:medan_go/chatbot.dart';
import 'package:medan_go/planner.dart';

import 'explore.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  int _selectedIndex = 0; // Track the selected tab index

  // List of screens for navigation
  final List<Widget> _pages = [
    const HomeScreen(), // Home screen (You can keep your HomePage or create a new one)
    const PlannerPage(), // Planner screen
    const ChatbotPage(), // Chatbot screen
    const ExplorePage(), // Explore screen
  ];

  // Handle bottom navigation item tap
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // Handle navigation for feature cards to also change the selected index
  // void _onFeatureCardTapped(int index) {
  //   setState(() {
  //     _selectedIndex = index; // Update selected index based on the feature
  //   });
  //   // You can also navigate to the specific screen if needed:
  //   if (index == 1) {
  //     Navigator.pushNamed(context, '/planner');
  //   } else if (index == 2) {
  //     Navigator.pushNamed(context, '/chatbot');
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _selectedIndex == 0 // Only show app bar on Home Screen
          ? AppBar(
              backgroundColor: Colors.teal,
              elevation: 0,
              title: const Text("Explore Medan Your Way",
                  style: TextStyle(color: Colors.white)),
              actions: [
                IconButton(
                  icon: const Icon(Icons.notifications, color: Colors.white),
                  onPressed: () {
                    // Navigate to notifications page
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.settings, color: Colors.white),
                  onPressed: () {
                    // Navigate to settings page
                  },
                ),
              ],
            )
          : null, // No app bar for other screens
      body: _pages[
          _selectedIndex], // Display the selected screen from _pages list

      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.teal,
        unselectedItemColor: Colors.grey,
        currentIndex: _selectedIndex, // Track the selected index
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: "Planner",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_outline),
            label: "Chatbot",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.explore),
            label: "Explore",
          ),
        ],
        onTap: _onItemTapped, // Handle navigation
      ),
    );
  }
}

// Home Screen Widget
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hi there! Ready to explore Medan?',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal[800],
                ),
              ),
              const SizedBox(height: 20),
              // Feature Cards
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context,
                            '/planner'); // Navigate to Itinerary Planner
                      },
                      child: const FeatureCard(
                        icon: Icons.map,
                        title: 'Plan Your Trip',
                        description: 'Create personalized itineraries.',
                        color: Colors.teal,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(
                            context, '/chatbot'); // Navigate to Chatbot
                      },
                      child: const FeatureCard(
                        icon: Icons.chat_bubble_outline,
                        title: 'Ask LekGo',
                        description: 'Get quick recommendations.',
                        color: Colors.orange,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Suggested Plans or Quick Options Section
              const Text(
                "Your Trips",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 200,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    SavedTripCard(
                      title: "Explore Medan",
                      description: "3 Days | Culture & Culinary",
                      onTap: () {
                        // Open saved itinerary
                      },
                    ),
                    SavedTripCard(
                      title: "Family Weekend",
                      description: "2 Days | Nature & Fun",
                      onTap: () {
                        // Open saved itinerary
                      },
                    ),
                    SavedTripCard(
                      title: "Adventure Awaits",
                      description: "4 Days | History & Exploration",
                      onTap: () {
                        // Open saved itinerary
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Explore Nearby Section
              const Text(
                "Explore Nearby",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 12),
              NearbyPlaceCard(
                title: "Masjid Raya",
                description: "Landmark Mosque - 1km away",
                onTap: () {
                  // Navigate to Explore
                },
              ),
              NearbyPlaceCard(
                title: "Durian Ucok",
                description: "Famous Durian Spot - 2km away",
                onTap: () {
                  // Navigate to Explore
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FeatureCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final Color color;

  const FeatureCard({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color, width: 1.5),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 40, color: color),
          const SizedBox(height: 10),
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            description,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 12, color: Colors.black87),
          ),
        ],
      ),
    );
  }
}

// Saved Trip Card Widget
class SavedTripCard extends StatelessWidget {
  final String title;
  final String description;
  final VoidCallback onTap;

  const SavedTripCard({
    required this.title,
    required this.description,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: 16),
        width: 150,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.orange[100],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              description,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12, color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }
}

// Nearby Place Card Widget
class NearbyPlaceCard extends StatelessWidget {
  final String title;
  final String description;
  final VoidCallback onTap;

  const NearbyPlaceCard({
    required this.title,
    required this.description,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.purple[100],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            const Icon(Icons.place, size: 40, color: Colors.purple),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(fontSize: 12, color: Colors.black54),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

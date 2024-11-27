import 'package:flutter/material.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({Key? key}) : super(key: key);

  @override
  ExplorePageState createState() => ExplorePageState();
}

class ExplorePageState extends State<ExplorePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Explore Nearby"),
        backgroundColor: Colors.teal,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Section Header
          const Text(
            'Nearby Places & Events',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 20),

          // Dummy Nearby Places Data
          _buildNearbyPlaceCard(
            title: "Masjid Raya",
            description: "Landmark mosque - 1 km away",
            context: context,
          ),
          const SizedBox(height: 16),
          _buildNearbyPlaceCard(
            title: "Durian Ucok",
            description: "Famous durian spot - 2 km away",
            context: context,
          ),
          const SizedBox(height: 16),
          _buildNearbyPlaceCard(
            title: "Taman Mini Medan",
            description: "Park with cultural exhibitions - 3 km away",
            context: context,
          ),
          const SizedBox(height: 16),
          _buildNearbyPlaceCard(
            title: "Merdeka Walk",
            description:
                "A bustling street with food and shopping - 1.5 km away",
            context: context,
          ),
          const SizedBox(height: 16),
          _buildNearbyPlaceCard(
            title: "Sri Deli Food Court",
            description: "Popular food court - 2.5 km away",
            context: context,
          ),
        ],
      ),
    );
  }

  // Helper function to build each place card
  Widget _buildNearbyPlaceCard({
    required String title,
    required String description,
    required BuildContext context,
  }) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: const Icon(Icons.location_on, color: Colors.teal),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        subtitle: Text(
          description,
          style: const TextStyle(fontSize: 14, color: Colors.black54),
        ),
        trailing: ElevatedButton(
          onPressed: () {
            // Handle button tap, for now, just print the place name
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Exploring $title')),
            );
          },
          style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
          child: const Text('Explore'),
        ),
      ),
    );
  }
}

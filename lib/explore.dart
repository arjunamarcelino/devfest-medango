import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'package:url_launcher/url_launcher.dart';

final backendApi = dotenv.env['BACKEND_API']; // Read from .env

class ExplorePage extends StatefulWidget {
  const ExplorePage({Key? key}) : super(key: key);

  @override
  ExplorePageState createState() => ExplorePageState();
}

class ExplorePageState extends State<ExplorePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isLoading = true;
  List<dynamic> _tempatMakan = [];
  List<dynamic> _tempatWisata = [];
  double? _latitude;
  double? _longitude;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _fetchLocationAndData();
  }

  Future<void> _fetchLocationAndData() async {
    try {
      // Fetch user's location
      Position position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high, // Specify desired accuracy
          distanceFilter:
              100, // Minimum distance (in meters) to trigger a location update
        ),
      );

      // Update the latitude and longitude
      _latitude = position.latitude;
      _longitude = position.longitude;

      // Fetch data from API
      await _fetchData();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: ${e.toString()}")),
        );
      }
      // Ensure to stop loading state if needed
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _fetchData() async {
    try {
      if (_latitude == null || _longitude == null) {
        throw Exception("Location not available");
      }

      final location = '$_latitude,$_longitude';
      const radius = 5000; // Search radius in meters
      const language = 'id';
      const keyword = 'populer';

      // Fetch Tempat Makan
      final makanResponse = await http.get(Uri.parse(
          "$backendApi/places/nearby?location=$location&radius=$radius&type=restaurant&keyword=$keyword&language=$language"));

      // Fetch Tempat Wisata
      final wisataResponse = await http.get(Uri.parse(
          "$backendApi/places/nearby?location=$location&radius=$radius&type=tourist_attraction&keyword=$keyword&language=$language"));

      if (makanResponse.statusCode == 200 && wisataResponse.statusCode == 200) {
        setState(() {
          _tempatMakan = jsonDecode(makanResponse.body)["places"];
          _tempatWisata = jsonDecode(wisataResponse.body)["places"];
          _isLoading = false;
        });
      } else {
        throw Exception("Failed to fetch data");
      }
    } catch (e) {
      // Ensure the widget is still mounted before showing SnackBar or calling setState
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: ${e.toString()}")),
        );
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Explore Nearby"),
        backgroundColor: Colors.teal,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: "Tempat Makan"),
            Tab(text: "Tempat Wisata"),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
              controller: _tabController,
              children: [
                _buildPlaceList(_tempatMakan),
                _buildPlaceList(_tempatWisata),
              ],
            ),
    );
  }

  Widget _buildPlaceList(List<dynamic> places) {
    if (places.isEmpty) {
      return const Center(
          child: Text("No places found",
              style: TextStyle(fontSize: 16, color: Colors.black54)));
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: places.length,
      itemBuilder: (context, index) {
        final place = places[index];
        // Extract latitude and longitude from API response
        final latitude = place["geometry"]["location"]["lat"];
        final longitude = place["geometry"]["location"]["lng"];

        return _buildNearbyPlaceCard(
          title: place["name"] ?? "Unknown Place",
          description: place["vicinity"] ?? "No description available",
          context: context,
          latitude: latitude,
          longitude: longitude,
        );
      },
    );
  }

  Widget _buildNearbyPlaceCard({
    required String title,
    required String description,
    required BuildContext context,
    required double latitude,
    required double longitude,
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
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Exploring $title')),
            );
            // onPressed: () async {
            //   final url = Uri.parse(
            //       'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude');
            //   if (await canLaunchUrl(url)) {
            //     await launchUrl(url);
            //   } else {
            //     {
            //       ScaffoldMessenger.of(context).showSnackBar(
            //         const SnackBar(content: Text('Could not open Google Maps')),
            //       );
            //     }
            //   }
          },
          style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
          child: const Text('Explore'),
        ),
      ),
    );
  }
}

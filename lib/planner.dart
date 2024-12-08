import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // Import http package
import 'dart:convert'; // Import for JSON decoding
import 'package:flutter_dotenv/flutter_dotenv.dart';

final backendApi = dotenv.env['BACKEND_API'];

class PlannerPage extends StatefulWidget {
  const PlannerPage({super.key});

  @override
  PlannerPageState createState() => PlannerPageState();
}

class PlannerPageState extends State<PlannerPage> {
  final _formKey = GlobalKey<FormState>();
  String? _duration;
  final List<String> _activityTypes = [];
  String? _travelPreferences;
  String? _visitorType;
  String? _cityPreference; // For Dalam or Luar Kota
  String? _tripType;
  double _budget = 0;

  // Predefined options for activity types, travel preferences, etc.
  final List<String> activityOptions = [
    'Nature',
    'Food',
    'Culture',
    'Religious',
    'History'
  ];
  final List<String> travelPreferencesOptions = [
    'Budget-friendly',
    'Family-friendly',
    'Luxury',
    'Adventure'
  ];
  final List<String> visitorOptions = ['Turis', 'Warga Lokal'];
  final List<String> cityPreferenceOptions = [
    'Dalam Kota Medan',
    'Luar Kota (Sekitaran Medan, Sumatera Utara)'
  ];
  final List<String> tripTypeOptions = ['Solo', 'Couple', 'Group', 'Family'];

  // Fetch itinerary from the API endpoint
  Future<void> _generateItinerary() async {
    final response = await http.post(
      Uri.parse("$backendApi/itinerary/ask-itinerary"), // Your API endpoint
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        "duration": _duration,
        "trip_type": _tripType,
        "visitor_type": _visitorType,
        "activity_types": _activityTypes,
        "travel_preferences": _travelPreferences,
        "preferences": _cityPreference,
        "budget": _budget,
      }),
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      final List itinerary = responseData['itinerary'];

      // Pass the itinerary data to the ItineraryPage
      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ItineraryPage(
              itinerary: itinerary,
            ),
          ),
        );
      }
    } else {
      // Handle error if API call fails
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to load itinerary')),
        );
      }
    }
  }

  void _openSavedItineraries() {
    final user = FirebaseAuth.instance.currentUser;

    // Check if user is authenticated and handle the user ID properly
    if (user == null) {
      // User is not logged in, handle this case as appropriate (e.g., show an error or prompt login)
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User is not logged in')),
      );
      return; // Exit early if the user is not authenticated
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SavedItinerariesPage(
          userUid: user.uid,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Itinerary Planner'),
        actions: [
          IconButton(
            icon: const Icon(Icons.bookmark),
            onPressed:
                _openSavedItineraries, // When tapped, open saved itineraries
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Duration (e.g., 1 Day, Weekend)',
                    ),
                    onSaved: (value) => _duration = value,
                  ),
                  const SizedBox(height: 16),
                  const Text("Trip Type:"),
                  Wrap(
                    spacing: 8.0,
                    children: tripTypeOptions.map((option) {
                      return ChoiceChip(
                        label: Text(option),
                        selected: _tripType == option,
                        onSelected: (selected) {
                          setState(() {
                            if (selected) {
                              _tripType = option;
                            } else {
                              _tripType = null;
                            }
                          });
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),
                  const Text("Visitor Type:"),
                  Wrap(
                    spacing: 8.0,
                    children: visitorOptions.map((option) {
                      return ChoiceChip(
                        label: Text(option),
                        selected: _visitorType == option,
                        onSelected: (selected) {
                          setState(() {
                            if (selected) {
                              _visitorType = option;
                            } else {
                              _visitorType = null;
                            }
                          });
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),
                  const Text("Activity Types:"),
                  Wrap(
                    spacing: 8.0,
                    children: activityOptions.map((option) {
                      return ChoiceChip(
                        label: Text(option),
                        selected: _activityTypes.contains(option),
                        onSelected: (selected) {
                          setState(() {
                            if (selected) {
                              _activityTypes.add(option);
                            } else {
                              _activityTypes.remove(option);
                            }
                          });
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    decoration:
                        const InputDecoration(labelText: 'Travel Preferences'),
                    value: _travelPreferences,
                    onChanged: (value) {
                      setState(() {
                        _travelPreferences = value;
                      });
                    },
                    items: travelPreferencesOptions.map((preference) {
                      return DropdownMenuItem(
                        value: preference,
                        child: Text(preference),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    decoration:
                        const InputDecoration(labelText: 'City Preference'),
                    value: _cityPreference,
                    onChanged: (value) {
                      setState(() {
                        _cityPreference = value;
                      });
                    },
                    items: cityPreferenceOptions.map((option) {
                      return DropdownMenuItem(
                        value: option,
                        child: Text(option),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Budget (in IDR)',
                      prefixIcon: Icon(Icons.attach_money),
                    ),
                    keyboardType: TextInputType.number,
                    onSaved: (value) {
                      _budget = double.tryParse(value ?? '0') ?? 0;
                    },
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        _generateItinerary(); // Generate itinerary after form submission
                      }
                    },
                    child: const Text('Generate Plan'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ItineraryPage extends StatefulWidget {
  final List itinerary;

  const ItineraryPage({required this.itinerary, Key? key}) : super(key: key);

  @override
  ItineraryPageState createState() => ItineraryPageState();
}

class ItineraryPageState extends State<ItineraryPage> {
  String? _tripTitle;
  final TextEditingController _customStopController = TextEditingController();
  final List<String> _customStops = [];

  // Method to show a dialog for saving the trip title
  void _showSaveDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Enter Trip Title'),
          content: TextField(
            onChanged: (value) {
              setState(() {
                _tripTitle = value;
              });
            },
            decoration: const InputDecoration(hintText: 'Enter title here'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog without saving
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (_tripTitle != null && _tripTitle!.isNotEmpty) {
                  _saveItinerary();
                  Navigator.of(context).pop(); // Close the dialog after saving
                } else {
                  // Optionally show a message if title is empty
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please enter a title.')),
                  );
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  // Method to save the itinerary
  Future<void> _saveItinerary() async {
    // Determine the maximum value for 'duration' based on the 'day' field in itinerary
    int? maxDay = widget.itinerary.isNotEmpty
        ? widget.itinerary
            .map((item) => item['day'] as int)
            .reduce((a, b) => a > b ? a : b)
        : 0; // Default to 0 if itinerary is empty

    // Get unique activity types from the itinerary
    String activityTypesString = widget.itinerary
        .map((item) =>
            item['activity_type'] ??
            'Unknown') // Default to 'Unknown' if activity_type is null
        .toSet() // Set ensures uniqueness
        .join('|'); // Join the unique activity types with '|'

    final user = FirebaseAuth.instance.currentUser;

    // Check if user is authenticated and handle the user ID properly
    if (user == null) {
      // User is not logged in, handle this case as appropriate (e.g., show an error or prompt login)
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User is not logged in')),
      );
      return; // Exit early if the user is not authenticated
    }

    // Convert Set to List before passing it to the API
    final itineraryData = {
      "user_uid": user.uid, // Use the user UID directly here
      "title": _tripTitle,
      "duration": maxDay, // Default value if duration is null
      "activity_type": activityTypesString, // Convert Set to List here
      "activities": widget.itinerary.map((item) {
        return {
          "day": item['day'] ?? 0, // Ensure `day` is provided (default to 0)
          "time":
              item['time'] ?? "N/A", // Provide default value for missing time
          "location": item['location'] ?? "Unknown", // Default for location
          "full_address":
              item['full_address'] ?? "Unknown", // Default for address
          "activity_type":
              item['activity_type'] ?? "Unknown", // Default activity type
          "notes": item['notes'] ?? "No notes", // Default for notes
        };
      }).toList(),
    };

    try {
      final response = await http.post(
        Uri.parse("$backendApi/itinerary/save"), // Your API endpoint
        headers: {'Content-Type': 'application/json'},
        body: json.encode(itineraryData),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Trip "$_tripTitle" saved successfully!')),
        );
      } else {
        // Handle error if the save request fails
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to save itinerary')),
        );
      }
    } catch (e) {
      // Handle error if there is an exception
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  // Method to share the itinerary (e.g., using a share plugin)
  void _shareItinerary(BuildContext context) {
    // Logic for sharing the itinerary (e.g., using a share plugin)
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Itinerary shared!')),
    );
  }

  // Add a custom stop
  void _addCustomStop() {
    if (_customStopController.text.isNotEmpty) {
      setState(() {
        _customStops.add(_customStopController.text);
      });
      _customStopController.clear(); // Clear the text field after adding
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Itinerary'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Display itinerary
            Expanded(
              child: ListView.builder(
                itemCount: widget.itinerary.length,
                itemBuilder: (context, index) {
                  final item = widget.itinerary[index];
                  return Card(
                    child: ListTile(
                      title: Text("${item['time']} - ${item['activity_type']}"),
                      subtitle: Text(
                        "${item['location']}\n${item['full_address']}",
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),

            // Custom stop input field
            TextField(
              controller: _customStopController,
              decoration: const InputDecoration(
                labelText: 'Add a custom stop',
                border: OutlineInputBorder(),
              ),
            ),
            ElevatedButton(
              onPressed: _addCustomStop,
              child: const Text('Add Stop'),
            ),
            const SizedBox(height: 16),

            // Row with Save and Share buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton.icon(
                  onPressed: _showSaveDialog,
                  icon: const Icon(Icons.save),
                  label: const Text('Save'),
                ),
                ElevatedButton.icon(
                  onPressed: () => _shareItinerary(context),
                  icon: const Icon(Icons.share),
                  label: const Text('Share'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class SavedItinerariesPage extends StatelessWidget {
  final String userUid;

  SavedItinerariesPage({required this.userUid});

  // Fetch saved itineraries for a specific user
  Future<List<dynamic>> _fetchSavedItineraries() async {
    final response = await http.get(
      Uri.parse('$backendApi/itinerary/user/$userUid'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data; // Directly return the list of itineraries
    } else {
      throw Exception('Failed to load saved itineraries');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Saved Itineraries'),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _fetchSavedItineraries(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No saved itineraries'));
          } else {
            final itineraries = snapshot.data!;
            return ListView.builder(
              itemCount: itineraries.length,
              itemBuilder: (context, index) {
                final itinerary = itineraries[index];
                return Card(
                  child: ListTile(
                    title: Text(itinerary['title']),
                    subtitle: Text(
                        'Duration: ${itinerary['duration']} - Activity Type: ${itinerary['activity_type']}'),
                    onTap: () {
                      // Navigate to the detailed page showing activities
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ItineraryDetailPage(
                            itinerary: itinerary,
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}

class ItineraryDetailPage extends StatelessWidget {
  final dynamic itinerary;

  ItineraryDetailPage({required this.itinerary});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(itinerary['title']),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Duration: ${itinerary['duration']}',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 10),
            Text(
              'Activity Type: ${itinerary['activity_type']}',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 20),
            const Text(
              'Activities:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: itinerary['activities'].length,
                itemBuilder: (context, index) {
                  final activity = itinerary['activities'][index];
                  return Card(
                    child: ListTile(
                      title: Text(
                          "${activity['time']} - ${activity['activity_type']}"),
                      subtitle: Text(
                        "${activity['location']}\n${activity['full_address']}",
                        style: const TextStyle(color: Colors.grey),
                      ),
                      trailing: const Icon(Icons.info),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

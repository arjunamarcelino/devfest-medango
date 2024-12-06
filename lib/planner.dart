import 'package:flutter/material.dart';

class PlannerPage extends StatefulWidget {
  const PlannerPage({super.key});

  @override
  PlannerPageState createState() => PlannerPageState();
}

class PlannerPageState extends State<PlannerPage> {
  final _formKey = GlobalKey<FormState>();
  String? _duration;
  List<String> _activityTypes = [];
  String? _travelPreferences;
  TextEditingController _customStopController = TextEditingController();
  List<String> _itinerary = [];

  // Predefined options for activity types and travel preferences
  final List<String> activityOptions = [
    'Nature',
    'Food',
    'Culture',
    'Religious',
    'History'
  ];
  final List<String> travelPreferencesOptions = [
    'Budget-friendly',
    'Family-friendly'
  ];

  // This method generates an AI-based itinerary (simulated here for simplicity)
  void _generateItinerary() {
    setState(() {
      _itinerary = [
        "Morning: Visit Masjid Raya",
        "Afternoon: Try Soto Medan at a local restaurant",
        "Evening: Explore Maimun Palace",
      ];
    });
  }

  // Add custom stop entered by user
  void _addCustomStop() {
    if (_customStopController.text.isNotEmpty) {
      setState(() {
        _itinerary.add("Custom Stop: ${_customStopController.text}");
        _customStopController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Itinerary Planner'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Input Preferences Form
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    decoration: const InputDecoration(
                        labelText: 'Duration (e.g., 1 Day, Weekend)'),
                    onSaved: (value) => _duration = value,
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
            const SizedBox(height: 32),

            // Display generated itinerary
            if (_itinerary.isNotEmpty) ...[
              const Text(
                'Your Itinerary:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              ListView.builder(
                shrinkWrap: true,
                itemCount: _itinerary.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      title: Text(_itinerary[index]),
                    ),
                  );
                },
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

              // Edit itinerary (example of how to rearrange)
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    // Simulating an edit (rearranging the itinerary)
                    _itinerary.insert(
                        0, "Custom Activity: Explore Durian Ucok");
                  });
                },
                child: const Text('Edit Itinerary'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

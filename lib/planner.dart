import 'package:flutter/material.dart';

class PlannerPage extends StatefulWidget {
  const PlannerPage({super.key});

  @override
  PlannerPageState createState() => PlannerPageState();
}

class PlannerPageState extends State<PlannerPage> {
  final _formKey = GlobalKey<FormState>();
  String? _duration;
  String? _tripType;
  String? _visitorType; // New field for "Turis or Warga Lokal"
  List<String> _activityTypes = [];
  String? _travelPreferences;
  double _budget = 0;
  List<String> _itinerary = [];

  // Predefined options
  final List<String> tripTypeOptions = ['Solo', 'Couple', 'Group', 'Family'];
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

  // Generate itinerary based on inputs
  void _generateItinerary() {
    _itinerary = [
      "Morning: Visit Masjid Raya",
      "Afternoon: Try Soto Medan at a local restaurant",
      "Evening: Explore Maimun Palace",
    ];

    if (_tripType == 'Family') {
      _itinerary.add("Bonus Stop: Visit Rahmat International Wildlife Museum");
    }
    if (_budget < 500) {
      _itinerary
          .add("Pro Tip: Explore street food for budget-friendly options!");
    }
    if (_visitorType == 'Warga Lokal') {
      _itinerary.add("Extra: Discover hidden gems around Medan's suburbs.");
    } else if (_visitorType == 'Turis') {
      _itinerary.add("Extra: Visit iconic landmarks for the best experience!");
    }

    // Navigate to the itinerary display page
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ItineraryPage(
          itinerary: _itinerary,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Itinerary Planner'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  decoration: const InputDecoration(
                      labelText: 'Duration (e.g., 1 Day, Weekend)'),
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
                          _tripType = selected ? option : null;
                        });
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),
                const Text("Visitor Type:"),
                Column(
                  children: [
                    RadioListTile<String>(
                      title: const Text('Turis'),
                      value: 'Turis',
                      groupValue: _visitorType,
                      onChanged: (value) {
                        setState(() {
                          _visitorType = value;
                        });
                      },
                    ),
                    RadioListTile<String>(
                      title: const Text('Warga Lokal'),
                      value: 'Warga Lokal',
                      groupValue: _visitorType,
                      onChanged: (value) {
                        setState(() {
                          _visitorType = value;
                        });
                      },
                    ),
                  ],
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
                      _generateItinerary();
                    }
                  },
                  child: const Text('Generate Plan'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ItineraryPage extends StatefulWidget {
  final List<String> itinerary;

  const ItineraryPage({required this.itinerary, Key? key}) : super(key: key);

  @override
  _ItineraryPageState createState() => _ItineraryPageState();
}

class _ItineraryPageState extends State<ItineraryPage> {
  TextEditingController _customStopController = TextEditingController();

  // Add custom stop entered by user
  void _addCustomStop() {
    if (_customStopController.text.isNotEmpty) {
      setState(() {
        widget.itinerary.add("Custom Stop: ${_customStopController.text}");
        _customStopController.clear();
      });
    }
  }

  void _shareItinerary(BuildContext context) {
    // Logic for sharing the itinerary (e.g., using a share plugin)
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Itinerary shared!')),
    );
  }

  void _saveItinerary(BuildContext context) {
    // Logic for saving the itinerary locally or to a database
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Itinerary saved!')),
    );
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: widget.itinerary.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      title: Text(widget.itinerary[index]),
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

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton.icon(
                  onPressed: () => _saveItinerary(context),
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

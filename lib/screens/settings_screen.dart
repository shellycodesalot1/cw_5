import 'package:flutter/material.dart';
import 'package:cw_5/services/db_helper.dart';

class SettingsScreen extends StatefulWidget {
  final Function(int, double, String) onSettingsChanged;

  SettingsScreen({required this.onSettingsChanged});

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final DatabaseHelper dbHelper = DatabaseHelper.instance;

  int fishCount = 1;
  double fishSpeed = 1.0;
  String fishColor = "blue";
  List<String> availableColors = ['blue', 'red', 'green', 'yellow', 'purple'];

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  // Load settings from the local database
  Future<void> _loadSettings() async {
    final settings = await dbHelper.getSettings();
    if (settings != null) {
      setState(() {
        fishCount = settings['fishCount'] ?? 1;
        fishSpeed = settings['fishSpeed'] ?? 1.0;
        fishColor = settings['fishColor'] ?? "blue";
      });
    }
  }

  // Save settings to the local database
  Future<void> _saveSettings() async {
    await dbHelper.saveSettings(fishCount, fishSpeed, fishColor);
    widget.onSettingsChanged(fishCount, fishSpeed, fishColor);
    Navigator.pop(context); // Close the settings screen
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              "Customize Aquarium",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            
            // Fish Count Slider
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Number of Fish'),
                Slider(
                  value: fishCount.toDouble(),
                  min: 1,
                  max: 10,
                  divisions: 9,
                  label: fishCount.toString(),
                  onChanged: (value) {
                    setState(() {
                      fishCount = value.toInt();
                    });
                  },
                ),
              ],
            ),

            // Fish Speed Slider
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Fish Speed'),
                Slider(
                  value: fishSpeed,
                  min: 0.5,
                  max: 5.0,
                  divisions: 9,
                  label: fishSpeed.toStringAsFixed(1),
                  onChanged: (value) {
                    setState(() {
                      fishSpeed = value;
                    });
                  },
                ),
              ],
            ),

            // Fish Color Dropdown
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Fish Color'),
                DropdownButton<String>(
                  value: fishColor,
                  onChanged: (String? newValue) {
                    setState(() {
                      fishColor = newValue!;
                    });
                  },
                  items: availableColors.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ],
            ),

            SizedBox(height: 20),

            // Save Settings Button
            ElevatedButton(
              onPressed: _saveSettings,
              child: Text('Save Settings'),
            ),
          ],
        ),
      ),
    );
  }
}

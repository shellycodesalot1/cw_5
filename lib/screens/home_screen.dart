import 'package:flutter/material.dart';
import 'package:cw_5/widgets/fish_widget.dart';
import 'package:cw_5/models/fish_model.dart';
import 'package:cw_5/screens/settings_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Fish> fishList = [];
  int fishCount = 1;
  double fishSpeed = 1.0;

  // Use the provided aquarium background URL
  String backgroundUrl = "https://t4.ftcdn.net/jpg/04/34/07/97/360_F_434079732_QaYqs2nBOiRRVu2AOAyqE5EiKzQ5zudG.jpg";

  void addFish() {
    setState(() {
      // Create a new Fish instance and add it to the list
      Fish newFish = Fish(speed: fishSpeed);
      fishList.add(newFish);
    });
  }

  void updateSettings(int count, double speed, String url) {
    setState(() {
      fishCount = count;
      fishSpeed = speed;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Virtual Aquarium"),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SettingsScreen(onSettingsChanged: updateSettings),
                ),
              );
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          // Aquarium Background from URL
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(backgroundUrl),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Display Fish using Fish Model
          Positioned.fill(
            child: Stack(
              children: fishList.map((fish) {
                return FishWidget(
                  speed: fish.speed,
                  imageUrl: fish.imageUrl,
                );
              }).toList(),
            ),
          ),
          // Button to Add Fish
          Positioned(
            bottom: 20,
            left: 20,
            child: ElevatedButton(
              onPressed: addFish,
              child: Text('Add Fish'),
            ),
          ),
        ],
      ),
    );
  }
}

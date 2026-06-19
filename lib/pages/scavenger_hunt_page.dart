import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';

class ScavengerHuntPage extends StatefulWidget {
  const ScavengerHuntPage({super.key});

  @override
  State<ScavengerHuntPage> createState() => _ScavengerHuntPageState();
}

class _ScavengerHuntPageState extends State<ScavengerHuntPage> {
  StreamSubscription<Position>? _positionStreamSubscription;
  Position? _currentPosition;
  bool _isLoading = true;

  // Mock locations for the scavenger hunt
  final List<Map<String, dynamic>> _locations = [
    {
      'name': 'The Great Gate',
      'description': 'Find the main entrance with the large arch.',
      'lat': 27.1751, // Example coordinates (Taj Mahal Gate area)
      'lng': 78.0421,
      'isUnlocked': false,
    },
    {
      'name': 'The Reflection Pool',
      'description': 'Stand by the water pool that reflects the monument.',
      'lat': 27.1750,
      'lng': 78.0425,
      'isUnlocked': false,
    },
    {
      'name': 'The Secret Garden',
      'description': 'Find the ancient garden behind the main building.',
      'lat': 27.1745,
      'lng': 78.0430,
      'isUnlocked': false,
    },
  ];

  @override
  void initState() {
    super.initState();
    _startLocationTracking();
  }

  Future<void> _startLocationTracking() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() => _isLoading = false);
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setState(() => _isLoading = false);
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      setState(() => _isLoading = false);
      return;
    }

    // Get initial position
    _currentPosition = await Geolocator.getCurrentPosition();
    _checkProximity();

    // Listen to location updates
    const LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 5,
    );

    _positionStreamSubscription = Geolocator.getPositionStream(locationSettings: locationSettings).listen(
      (Position? position) {
        if (position != null) {
          setState(() {
            _currentPosition = position;
            _isLoading = false;
          });
          _checkProximity();
        }
      },
    );
  }

  void _checkProximity() {
    if (_currentPosition == null) return;

    for (var i = 0; i < _locations.length; i++) {
      if (!_locations[i]['isUnlocked']) {
        double distanceInMeters = Geolocator.distanceBetween(
          _currentPosition!.latitude,
          _currentPosition!.longitude,
          _locations[i]['lat'],
          _locations[i]['lng'],
        );

        // If user is within 50 meters, unlock the badge
        if (distanceInMeters <= 50.0) {
          setState(() {
            _locations[i]['isUnlocked'] = true;
          });
          _showUnlockDialog(_locations[i]['name']);
        }
      }
    }
  }

  void _showUnlockDialog(String name) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.emoji_events,
                  color: Colors.orange,
                  size: 60,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "Badge Unlocked!",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                "You found $name.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff6351ec),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: const Text("Awesome!", style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _positionStreamSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    int unlockedCount = _locations.where((l) => l['isUnlocked'] == true).length;
    double progress = unlockedCount / _locations.length;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text("Monument Scavenger Hunt"),
        backgroundColor: const Color(0xff6351ec),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Color(0xff6351ec))))
          : Column(
              children: [
                // Progress Header
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: const BoxDecoration(
                    color: Color(0xff6351ec),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Your Progress",
                            style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "$unlockedCount/${_locations.length} Found",
                            style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      LinearProgressIndicator(
                        value: progress,
                        backgroundColor: Colors.white.withOpacity(0.3),
                        valueColor: const AlwaysStoppedAnimation<Color>(Colors.orangeAccent),
                        minHeight: 10,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _locations.length,
                    itemBuilder: (context, index) {
                      final loc = _locations[index];
                      final isUnlocked = loc['isUnlocked'];
                      
                      return Semantics(
                        label: "${loc['name']}. Status: ${isUnlocked ? 'Found' : 'Hidden'}",
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 10,
                                offset: const Offset(0, 5),
                              ),
                            ],
                            border: Border.all(
                              color: isUnlocked ? Colors.orangeAccent : Colors.transparent,
                              width: 2,
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(15),
                                decoration: BoxDecoration(
                                  color: isUnlocked ? Colors.orange.withOpacity(0.1) : Colors.grey.withOpacity(0.1),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  isUnlocked ? Icons.emoji_events : Icons.lock_outline,
                                  color: isUnlocked ? Colors.orange : Colors.grey,
                                  size: 30,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      loc['name'],
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      isUnlocked ? "Badge Unlocked!" : loc['description'],
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: isUnlocked ? Colors.green : Colors.grey[600],
                                        fontWeight: isUnlocked ? FontWeight.bold : FontWeight.normal,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}

import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Sample profile data
    final profiles = [
      {
        "name": "Ry Corps",
        "program": "Bachelor of Science in Computer Science",
        "image": 'assets/raymond.png',
      },
      {
        "name": "Sai Eder",
        "program": "Bachelor of Science in Computer Science",
        "image": 'assets/sairose.png',
      },
    ];

    return Scaffold(
      // Custom AppBar
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset(
            'assets/Designer.png',
            height: 30, // Adjust the height for better fit
            width: 30,
          ),
        ),
        title: const Text(
          "Profiles",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.white, // Title font color changed to blue
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue, // White background for the AppBar
        elevation: 5, // Subtle shadow effect
        iconTheme:
            const IconThemeData(color: Colors.blue), // Subtle shadow effect
      ),

      // Main Body
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView.builder(
          itemCount: profiles.length,
          itemBuilder: (context, index) {
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 10),
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    // Profile Image
                    ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: Image.asset(
                        profiles[index]["image"]!,
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 20),

                    // Profile Details
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Name
                          Text(
                            profiles[index]["name"]!,
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.blueAccent,
                            ),
                          ),
                          const SizedBox(height: 5),

                          // Program
                          Text(
                            profiles[index]["program"]!,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black54,
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
    );
  }
}

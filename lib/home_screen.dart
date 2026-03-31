import 'package:flutter/material.dart';
import 'available_donors.dart';
import 'rare_blood_groups.dart';
import 'select_district_page.dart';
import 'post_to_donate.dart';
import 'request_for_blood.dart';
import 'requests_for_blood.dart';
import 'drawer_page.dart';
import 'user_profile.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    double buttonSize = 250;

    Widget buildButton(String imagePath, String title, VoidCallback onTap) {
      return SizedBox(
        width: buttonSize,
        height: buttonSize,
        child: ElevatedButton(
          onPressed: onTap,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.zero,
            ),
            padding: const EdgeInsets.all(10),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(imagePath, height: 120),
              const SizedBox(height: 8),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 18, color: Colors.black),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      drawer: const DrawerPage(),
      appBar: AppBar(
        backgroundColor: const Color(0xff9f2026),
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
        title: const Text(
          "LifeDrop",
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: IconButton(
              iconSize: 60,
              padding: EdgeInsets.zero,
              icon: SizedBox(
                height: 60,
                width: 60,
                child: Image.asset("assets/images/user_icon.png"),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => UserProfile()),
                );
              },
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  buildButton(
                    "assets/images/donor.png",
                    "Available Donors",
                        () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const AvailableDonorsPage(), // ← FIXED
                        ),
                      );
                    },
                  ),
                  buildButton(
                    "assets/images/request.png",
                    "Requests",
                        () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const RequestsPage()),
                      );
                    },
                  ),
                  buildButton(
                    "assets/images/blood.png",
                    "Request For Blood",
                        () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const RequestForBlood()),
                      );
                    },
                  ),
                ],
              ),

              const SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  buildButton(
                    "assets/images/post.png",
                    "Post To Donate",
                        () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const PostToDonatePage()),
                      );
                    },
                  ),
                  buildButton(
                    "assets/images/rare.png",
                    "Rare Blood Group",
                        () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const RareBloodGroups()),
                      );
                    },
                  ),
                  buildButton(
                    "assets/images/hospital.png",
                    "Nearby Hospital & Ambulance",
                        () {
                      // Hospital page - add later
                    },
                  ),
                ],
              ),

              const SizedBox(height: 30),

              Image.asset("assets/images/chart.png", height: 500),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'select_district_page.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SelectBloodGroupPage extends StatelessWidget {
  const SelectBloodGroupPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> bloodGroups = [
      "A+", "A-", "B+", "B-", "AB+", "AB-", "O+", "O-"
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff9f2026),
        title: const Text("Select Blood Group", style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: bloodGroups.length,
        separatorBuilder: (_, index) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final bloodGroup = bloodGroups[index];
          return ListTile(
            title: Text(bloodGroup, style: const TextStyle(fontSize: 20, color: Color(0xFF5A5A5A))),
            onTap: () {
              // Pass selected blood group to district page
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => SelectDistrictPage(selectedBloodGroup: bloodGroup),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
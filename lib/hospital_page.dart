import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
class HospitalPage extends StatelessWidget {
  final String selectedBloodGroup;
  final String selectedDistrict;

  const HospitalPage({
    super.key,
    required this.selectedBloodGroup,
    required this.selectedDistrict,
  });

  @override
  Widget build(BuildContext context) {
    print("Querying for BloodGroup=$selectedBloodGroup, District=$selectedDistrict");

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff9f2026),
        title: const Text("Hospitals & Ambulance Services", style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('services')
            .where('bloodGroup', isEqualTo: selectedBloodGroup)
            .where('district', isEqualTo: selectedDistrict)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No hospitals available"));
          }

          final hospitals = snapshot.data!.docs;

          return ListView.builder(
            itemCount: hospitals.length,
            itemBuilder: (context, index) {
              final data = hospitals[index].data() as Map<String, dynamic>;
              return ListTile(
                leading: const Icon(Icons.local_hospital, color: Color(0xff9f2026), size: 50),
                title: Text(data['name'] ?? ''),
                subtitle: Text("${data['location'] ?? ''}\n${data['phone'] ?? ''}"),
                isThreeLine: true,
                trailing: IconButton(
                  icon: const Icon(Icons.call, color: Color(0xff9f2026), size: 30),
                  onPressed: () {
                    final phone = data['phone'] ?? '';
                    if (phone.isNotEmpty) {
                      // Placeholder: real call works on mobile with url_launcher
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Call: $phone")),
                      );
                    }
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
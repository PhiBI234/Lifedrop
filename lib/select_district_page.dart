import 'package:flutter/material.dart';
import 'hospital_page.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SelectDistrictPage extends StatelessWidget {
  final String selectedBloodGroup;

  const SelectDistrictPage({super.key, required this.selectedBloodGroup});

  final List<String> districts = const [
    "Bogura","Bhola","Bagerhat","Barisal","Chittagong","Cumilla","Dhaka","Feni",
    "Jessore","Khulna","Noakhali","Pabna","Rangpur","Sylhet","Tangail",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff9f2026),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("Select District", style: TextStyle(color: Colors.white)),
      ),
      body: ListView.builder(
        itemCount: districts.length,
        itemBuilder: (context, index) {
          final district = districts[index];
          return ListTile(
            title: Text(district),
            onTap: () {
              // Pass blood group + district to hospital page
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => HospitalPage(
                    selectedBloodGroup: selectedBloodGroup,
                    selectedDistrict: district,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
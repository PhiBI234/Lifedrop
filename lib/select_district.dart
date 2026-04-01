import 'package:flutter/material.dart';
import 'hospital_page.dart';

class SelectDistrictPage extends StatelessWidget {
  final String selectedBloodGroup;

  const SelectDistrictPage({super.key, required this.selectedBloodGroup});

  final List<String> districts = const [
    "Bogura",
    "Bhola",
    "Bagerhat",
    "Barisal",
    "Chittagong",
    "Cumilla",
    "Dhaka",
    "Feni",
    "Jessore",
    "Khulna",
    "Noakhali",
    "Pabna",
    "Rangpur",
    "Sylhet",
    "Tangail",
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
        title: const Text(
          "Select District",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: ListView.builder(
        itemCount: districts.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(districts[index]),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => HospitalPage(
                    selectedDistrict: districts[index],
                    selectedBloodGroup: selectedBloodGroup,
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
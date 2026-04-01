import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';

class AvailableDonorsPage extends StatelessWidget {
  const AvailableDonorsPage({super.key});

  void _callNumber(BuildContext context, String phoneNumber) async {
    final Uri callUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(callUri)) {
      await launchUrl(callUri);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Cannot make a call to $phoneNumber')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Available Donors", style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: const Color(0xff9f2026),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('donors').orderBy('time', descending: true).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          final donors = snapshot.data!.docs;
          if (donors.isEmpty) return const Center(child: Text("No donors available"));

          return ListView.builder(
            padding: const EdgeInsets.all(10),
            itemCount: donors.length,
            itemBuilder: (context, index) {
              final donor = donors[index];
              final blood = donor['blood'] ?? '';
              final name = donor['name'] ?? '';
              final address = donor['address'] ?? '';
              final phone = donor['phone'] ?? '';
              final date = donor['date'] ?? '';
              final district = donor['district'] ?? '';
              final gender = donor['gender'] ?? '';

              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.white,
                  boxShadow: [BoxShadow(color: Colors.grey.shade300, blurRadius: 5, offset: const Offset(0, 3))],
                ),
                child: Row(
                  children: [
                    Container(
                      width: 80,
                      height: 150,
                      color: const Color(0xff9f2026),
                      child: Center(child: Text(blood, style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold))),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                            const SizedBox(height: 6),
                            Text("$address, $district", style: const TextStyle(fontSize: 14)),
                            const SizedBox(height: 6),
                            Text("Last Donation: $date", style: const TextStyle(fontSize: 14, color: Colors.red)),
                            const SizedBox(height: 6),
                            Text("Gender: $gender", style: const TextStyle(fontSize: 14)),
                            const SizedBox(height: 6),
                            Text("Contact: $phone", style: const TextStyle(fontSize: 14)),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: InkWell(
                        onTap: () => _callNumber(context, phone),
                        child: const Icon(Icons.phone, color: Color(0xff9f2026), size: 50),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';

class RequestsPage extends StatelessWidget {
  const RequestsPage({super.key});

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
        title: const Text("Requests", style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: const Color(0xff9f2026),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('requests').orderBy('timestamp', descending: true).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          final requests = snapshot.data!.docs;
          if (requests.isEmpty) return const Center(child: Text("No requests available"));

          return ListView.builder(
            padding: const EdgeInsets.all(10),
            itemCount: requests.length,
            itemBuilder: (context, index) {
              final req = requests[index];
              final blood = req['blood'] ?? '';
              final name = req['name'] ?? '';
              final location = req['location'] ?? '';
              final status = req['status'] ?? '';
              final contact = req['contact'] ?? '';

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
                      height: 120,
                      color: const Color(0xff9f2026),
                      child: Center(
                        child: Text(blood, style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                            const SizedBox(height: 6),
                            Text(location, style: const TextStyle(fontSize: 14)),
                            const SizedBox(height: 6),
                            Text(status, style: const TextStyle(fontSize: 14, color: Colors.red)),
                            const SizedBox(height: 6),
                            Text("Contact: $contact", style: const TextStyle(fontSize: 14)),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: InkWell(
                        onTap: () => _callNumber(context, contact),
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
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:url_launcher/url_launcher.dart';

class RequestForBlood extends StatefulWidget {
  const RequestForBlood({super.key});

  @override
  State<RequestForBlood> createState() => _RequestForBloodState();
}

class _RequestForBloodState extends State<RequestForBlood> {
  final nameController = TextEditingController();
  final locationController = TextEditingController();
  final bloodController = TextEditingController();
  final statusController = TextEditingController();
  final contactController = TextEditingController();

  Future<void> submitRequest() async {
    try {
      if (FirebaseAuth.instance.currentUser == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("You must login first"), backgroundColor: Colors.red),
        );
        return;
      }

      await FirebaseFirestore.instance.collection('requests').add({
        "name": nameController.text,
        "location": locationController.text,
        "blood": bloodController.text,
        "status": statusController.text,
        "contact": contactController.text,
        "uid": FirebaseAuth.instance.currentUser!.uid,
        "timestamp": FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Request Added"), backgroundColor: Colors.green),
      );

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e"), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff9f2026),
      appBar: AppBar(
        backgroundColor: const Color(0xff9f2026),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("Make Request For Blood", style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: Center(
        child: Container(
          margin: const EdgeInsets.all(20),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextField(controller: nameController, decoration: const InputDecoration(hintText: "Full Name")),
                const SizedBox(height: 15),
                TextField(controller: locationController, decoration: const InputDecoration(hintText: "Address")),
                const SizedBox(height: 15),
                TextField(controller: bloodController, decoration: const InputDecoration(hintText: "Required Blood Group")),
                const SizedBox(height: 15),
                TextField(controller: statusController, decoration: const InputDecoration(hintText: "Why Do You Need Blood")),
                const SizedBox(height: 15),
                TextField(controller: contactController, decoration: const InputDecoration(hintText: "Phone No")),
                const SizedBox(height: 40),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xff9f2026)),
                    onPressed: submitRequest,
                    child: const Text("Request", style: TextStyle(color: Colors.white, fontSize: 18)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
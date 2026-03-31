import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PostToDonatePage extends StatefulWidget {
  const PostToDonatePage({super.key});

  @override
  State<PostToDonatePage> createState() => _PostToDonatePageState();
}

class _PostToDonatePageState extends State<PostToDonatePage> {

  final nameController = TextEditingController();
  final addressController = TextEditingController();
  final phoneController = TextEditingController();
  final dateController = TextEditingController();

  String selectedDistrict = "Dhaka";
  String selectedBlood = "A+";
  String selectedGender = "Male";

  bool isLoading = false;  // ← ADDED

  Future<void> postData() async {
    // Validation
    if (nameController.text.trim().isEmpty ||
        addressController.text.trim().isEmpty ||
        phoneController.text.trim().isEmpty ||
        dateController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all fields")),
      );
      return;
    }

    setState(() => isLoading = true);  // ← show loading

    try {
      await FirebaseFirestore.instance.collection('donors').add({
        'name': nameController.text.trim(),
        'address': addressController.text.trim(),
        'phone': phoneController.text.trim(),
        'date': dateController.text.trim(),
        'district': selectedDistrict,
        'blood': selectedBlood,
        'gender': selectedGender,
        'time': FieldValue.serverTimestamp(),
        'userId': FirebaseAuth.instance.currentUser?.uid ?? 'anonymous',
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Posted Successfully!")),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: $e")),  // ← shows real error
        );
      }
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    addressController.dispose();
    phoneController.dispose();
    dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff9f2026),
      appBar: AppBar(
        backgroundColor: const Color(0xff9f2026),
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text("POST TO DONATE",
            style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: Center(
        child: Container(
          margin: const EdgeInsets.all(20),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [

                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(hintText: "Full Name"),
                ),

                const SizedBox(height: 15),

                TextField(
                  controller: addressController,
                  decoration: const InputDecoration(hintText: "Address"),
                ),

                const SizedBox(height: 15),

                buildDropdown(
                  "District",
                  ["Dhaka", "Chittagong", "Khulna"],
                  selectedDistrict,
                      (val) => setState(() => selectedDistrict = val!),
                ),

                const SizedBox(height: 15),

                buildDropdown(
                  "Blood Group",
                  ["A+", "A-", "B+", "B-", "O+", "O-", "AB+", "AB-"],
                  selectedBlood,
                      (val) => setState(() => selectedBlood = val!),
                ),

                const SizedBox(height: 15),

                buildDropdown(
                  "Gender",
                  ["Male", "Female"],
                  selectedGender,
                      (val) => setState(() => selectedGender = val!),
                ),

                const SizedBox(height: 15),

                TextField(
                  controller: phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(hintText: "Phone No"),
                ),

                const SizedBox(height: 15),

                TextField(
                  controller: dateController,
                  decoration: const InputDecoration(
                      hintText: "Last Donation Date (e.g. 31-01-2026)"),
                ),

                const SizedBox(height: 30),

                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff9f2026),
                    ),
                    onPressed: isLoading ? null : postData,  // ← FIXED
                    child: isLoading
                        ? const CircularProgressIndicator(color: Colors.white)  // ← FIXED
                        : const Text("Post",
                        style: TextStyle(color: Colors.white)),
                  ),
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildDropdown(String hint, List<String> items, String value,
      Function(String?) onChanged) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(
        labelText: hint,
        border: const OutlineInputBorder(),
      ),
      items: items
          .map((item) =>
          DropdownMenuItem(value: item, child: Text(item)))
          .toList(),
      onChanged: onChanged,
    );
  }
}
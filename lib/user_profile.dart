import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserProfile extends StatelessWidget {
  UserProfile({super.key});

  final String uid = FirebaseAuth.instance.currentUser!.uid;

  Future<DocumentSnapshot> getUserData() async {
    return await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .get();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],

      body: FutureBuilder<DocumentSnapshot>(
        future: getUserData(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          var userData =
          snapshot.data!.data() as Map<String, dynamic>;

          return SingleChildScrollView(
            child: Column(
              children: [

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.only(
                    top: 50,
                    left: 15,
                    right: 15,
                    bottom: 30,
                  ),
                  decoration: const BoxDecoration(
                    color: Color(0xFF9F2026),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(35),
                      bottomRight: Radius.circular(35),
                    ),
                  ),
                  child: Column(
                    children: [

                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                          const SizedBox(width: 10),
                          const Text(
                            "Profile",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      const CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.white,
                        child: Icon(
                          Icons.person,
                          size: 60,
                          color: Color(0xFF9F2026),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 25),

                _buildInfoCard("Name", userData['name']),
                _buildInfoCard("District", userData['district']),
                _buildInfoCard("Mobile Number", userData['phone']),
                _buildInfoCard("Blood Group", userData['bloodGroup']),
                _buildInfoCard("Email", userData['email']),
              ],
            ),
          );
        },
      ),
    );
  }


  Widget _buildInfoCard(String title, String value) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            blurRadius: 5,
            spreadRadius: 2,
          ),
        ],
      ),
      child: RichText(
        text: TextSpan(
          style: const TextStyle(
            fontSize: 16,
            color: Colors.black,
          ),
          children: [
            TextSpan(
              text: "$title: ",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            TextSpan(
              text: value,
            ),
          ],
        ),
      ),
    );
  }
}
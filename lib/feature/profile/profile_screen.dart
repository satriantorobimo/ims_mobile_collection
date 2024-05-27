import 'package:flutter/material.dart';
import 'package:mobile_collection/utility/string_router_util.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Profile',
          style: TextStyle(
              color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Color(0xFF9BBFB6),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Align(
              alignment: Alignment.center,
              child: Container(
                height: 70,
                width: 70,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.grey,
                ),
                alignment: Alignment.center,
                child: const Icon(
                  Icons.person_2_rounded,
                  color: Colors.white,
                  size: 32,
                ),
              ),
            ),
            SizedBox(height: 8),
            Align(
              alignment: Alignment.center,
              child: Text(
                'Bagas Hari',
                style: const TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 32),
            SizedBox(
              height: 75,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'ID',
                    style: const TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    height: 45,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey.withOpacity(0.1)),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          blurRadius: 6,
                          offset: const Offset(-6, 4), // Shadow position
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        '27407307352343',
                        style: const TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(height: 12),
            SizedBox(
              height: 75,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Branch',
                    style: const TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    height: 45,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey.withOpacity(0.1)),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          blurRadius: 6,
                          offset: const Offset(-6, 4), // Shadow position
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Head Office',
                        style: const TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 12),
            SizedBox(
              height: 75,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Email',
                    style: const TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    height: 45,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey.withOpacity(0.1)),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          blurRadius: 6,
                          offset: const Offset(-6, 4), // Shadow position
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'hari.bagas@ims.com',
                        style: const TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 12),
            SizedBox(
              height: 75,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Phone Number',
                    style: const TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    height: 45,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey.withOpacity(0.1)),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          blurRadius: 6,
                          offset: const Offset(-6, 4), // Shadow position
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        '+628 1123 2924',
                        style: const TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 12),
            Align(
              alignment: Alignment.center,
              child: Text(
                'version - 1.0.0+1',
                style: const TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                    fontWeight: FontWeight.w400),
              ),
            ),
            SizedBox(height: 16),
            InkWell(
              onTap: () {
                Navigator.pushNamedAndRemoveUntil(context,
                    StringRouterUtil.loginScreenRoute, (route) => false);
              },
              child: Container(
                width: double.infinity,
                height: 66,
                decoration: BoxDecoration(
                  color: Color(0xFFDF0000),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Center(
                    child: Text('Log Out',
                        style: TextStyle(
                            fontSize: 15,
                            color: Colors.white,
                            fontWeight: FontWeight.w600))),
              ),
            )
          ],
        ),
      ),
    );
  }
}

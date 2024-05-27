import 'package:flutter/material.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Notification',
          style: TextStyle(
              color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Color(0xFF9BBFB6),
      ),
      body: ListView.separated(
        separatorBuilder: (context, index) => const SizedBox(height: 16),
        itemCount: 5,
        itemBuilder: (context, index) {
          return const ListTile(
            title: Text(
              'New Assignment!',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              'Lorem ipsum dolor sit amet, consectetur adipiscing elit!',
              style: TextStyle(
                  color: Color(0xFF7C7C7C),
                  fontSize: 14,
                  fontWeight: FontWeight.w400),
            ),
            trailing: SizedBox(
              height: double.infinity,
              child: Text(
                '2 days ago',
                style: TextStyle(
                    color: Color(0xFF7C7C7C),
                    fontSize: 12,
                    fontWeight: FontWeight.w400),
              ),
            ),
          );
        },
      ),
    );
  }
}

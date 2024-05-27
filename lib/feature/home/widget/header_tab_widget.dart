import 'package:flutter/material.dart';
import 'package:mobile_collection/utility/database_helper.dart';

class HeaderTabWidget extends StatefulWidget {
  const HeaderTabWidget({super.key});

  @override
  State<HeaderTabWidget> createState() => _HeaderTabWidgetState();
}

class _HeaderTabWidgetState extends State<HeaderTabWidget> {
  String name = '';
  String uid = '';
  String branchName = '';

  @override
  void initState() {
    getData();
    super.initState();
  }

  Future<void> getData() async {
    final data = await DatabaseHelper.getUserData2();
    setState(() {
      name = data[0]['name'];
      uid = data[0]['uid'];
      branchName = data[0]['branch_name'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 50,
              width: 50,
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
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  '$uid - $branchName',
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w400),
                ),
              ],
            )
          ],
        ),
        InkWell(
          onTap: () {},
          child: Container(
            width: MediaQuery.of(context).size.width * 0.2,
            height: 35,
            decoration: BoxDecoration(
              color: Color(0xFF3C3D3D),
              borderRadius: BorderRadius.circular(22),
            ),
            child: const Center(
                child: Text('Sync',
                    style: TextStyle(
                        fontSize: 15,
                        color: Colors.white,
                        fontWeight: FontWeight.w600))),
          ),
        )
      ],
    );
  }
}

import 'package:flutter/material.dart';

class AmortizationScreen extends StatefulWidget {
  const AmortizationScreen({super.key});

  @override
  State<AmortizationScreen> createState() => _AmortizationScreenState();
}

class _AmortizationScreenState extends State<AmortizationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.black, //change your color here
        ),
        title: const Text(
          'Amortization',
          style: TextStyle(
              color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Color(0xFF9BBFB6),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 8),
            Container(
              width: double.infinity,
              height: 1,
              color: Color(0xFFE7E7E7),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.1,
                    child: Text(
                      'No',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.28,
                    child: Text(
                      'Due Date',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.37,
                    child: Text(
                      'Installment Amount',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.2,
                    child: Text(
                      'Paid by',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w600),
                    ),
                  )
                ],
              ),
            ),
            Container(
              width: double.infinity,
              height: 1,
              color: Color(0xFFE7E7E7),
            ),
            Container(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 8.0, right: 8.0, top: 4.0, bottom: 4.0),
                child: Row(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.1,
                      child: Text(
                        '1',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.28,
                      child: Text(
                        '20 Sep 2024',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.37,
                      child: Text(
                        'Rp. 7.000.000,00',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.2,
                      child: RichText(
                        text: const TextSpan(
                          text: 'Transfer\n',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.w400),
                          children: [
                            TextSpan(
                              text: '20 Sep 2024',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w400),
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Container(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 8.0, right: 8.0, top: 4.0, bottom: 4.0),
                child: Row(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.1,
                      child: Text(
                        '2',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.28,
                      child: Text(
                        '20 Oct 2024',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.37,
                      child: Text(
                        'Rp. 7.000.000,00',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.2,
                      child: RichText(
                        text: const TextSpan(
                          text: 'Cash\n',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.w400),
                          children: [
                            TextSpan(
                              text: '20 Oct 2024',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w400),
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Container(
              color: Color(0xFFFF6C6C).withOpacity(0.3),
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 8.0, right: 8.0, top: 4.0, bottom: 4.0),
                child: Row(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.1,
                      child: Text(
                        '3',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.28,
                      child: Text(
                        '20 Nov 2024',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.37,
                      child: Text(
                        'Rp. 7.000.000,00',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.2,
                    )
                  ],
                ),
              ),
            ),
            Container(
              color: Color(0xFFFF6C6C).withOpacity(0.3),
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 8.0, right: 8.0, top: 4.0, bottom: 4.0),
                child: Row(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.1,
                      child: Text(
                        '4',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.28,
                      child: Text(
                        '20 Dec 2024',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.37,
                      child: Text(
                        'Rp. 7.000.000,00',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.2,
                    )
                  ],
                ),
              ),
            ),
            Container(
              color: Color(0xFFFF6C6C).withOpacity(0.3),
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 8.0, right: 8.0, top: 4.0, bottom: 4.0),
                child: Row(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.1,
                      child: Text(
                        '5',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.28,
                      child: Text(
                        '20 Jan 2025',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.37,
                      child: Text(
                        'Rp. 7.000.000,00',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.2,
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mobile_collection/components/color_comp.dart';
import 'package:mobile_collection/feature/home/provider/home_provider.dart';
import 'package:mobile_collection/feature/tab/provider/tab_provider.dart';
import 'package:mobile_collection/router.dart';
import 'package:mobile_collection/utility/firebase_notification_service.dart';
import 'package:mobile_collection/utility/string_router_util.dart';
import 'package:provider/provider.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final FirebaseNotificationService _firebaseNotificationService =
  FirebaseNotificationService();

  @override
  void initState() {
    handleStartUpNotification();

    super.initState();
  }

  Future<dynamic> handleStartUpNotification() async {
    await _firebaseNotificationService.initialize();
  }
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TabProvider()),
        ChangeNotifierProvider(create: (_) => HomeProvider()),
      ],
      child: MaterialApp(
        title: 'Mobile Collection',
        theme: ThemeData(primaryColor: primaryColor, fontFamily: 'Jakarta'),
        onGenerateRoute: Routers.generateRoute,
        initialRoute: StringRouterUtil.splashScreenRoute,
      ),
    );
  }
}

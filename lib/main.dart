import 'package:flutter/material.dart';
import 'package:mobile_collection/components/color_comp.dart';
import 'package:mobile_collection/feature/tab/provider/tab_provider.dart';
import 'package:mobile_collection/router.dart';
import 'package:mobile_collection/utility/string_router_util.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TabProvider()),
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

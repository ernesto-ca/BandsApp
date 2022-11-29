import 'package:band_name_app/pages/home_page.dart';
import 'package:band_name_app/pages/status_page.dart';
import 'package:band_name_app/services/socket_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => SocketService())],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "App Title",
        initialRoute: 'home',
        routes: {
          "home": (_) => const HomePage(),
          "status": (_) => const StatusPage(),
        },
      ),
    );
  }
}

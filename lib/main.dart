import 'package:band_name_app/pages/home_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "App Title",
      initialRoute: 'home',
      routes: {
        "home": (_) => const HomePage(),
      },
    ),
  );
}

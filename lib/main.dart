import 'package:flutter/material.dart';
import 'package:food_app/Pages/CartPage.dart';
import 'package:food_app/Pages/HomePage.dart';
import 'package:food_app/Pages/AddPage.dart';
import 'package:food_app/Pages/FormPage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'supabase.dart';

Future<void> main() async {
  const url = 'https://uimrlipemschuvujgljw.supabase.co';
  const anonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InVpbXJsaXBlbXNjaHV2dWpnbGp3Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzExNDczMDIsImV4cCI6MjA0NjcyMzMwMn0.jmMk92qtlmJnOemnSkO77bxHv2DVyrDJGXQiUjxnMKg';
  await Supabase.initialize(
    url: url,
    anonKey: anonKey,
  );

  runApp(const MyApp());
}

final supabase = Supabase.instance.client;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App Makanan',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(scaffoldBackgroundColor: const Color(0xffff5f5f3)),
      routes: {
        "/": (context) => Homepage(),
        "/CartPage": (context) => Cartpage(),
        "/AddPage": (context) => AddPage(),
        "/FormPage":(context) => Formpage()
      },
    );
  }
}

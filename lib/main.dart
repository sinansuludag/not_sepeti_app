// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:not_sepeti_app/constants/thema_constants.dart';
import 'package:not_sepeti_app/pages/not_listesi.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  //Durum çubuğunun arka plan rengini belirler
  SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: CustomTheme.themeData,
      home: const NotListesi(),
    );
  }
}

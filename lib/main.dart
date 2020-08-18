import 'package:flutter/material.dart';
import 'package:login_phone_number/services/authservice.dart';
import 'package:mpesa_flutter_plugin/mpesa_flutter_plugin.dart';

void main() {
  MpesaFlutterPlugin.setConsumerKey("q4EXwkP7u5OjQ7tKjEKGWupbZ7lGKOXH");
  MpesaFlutterPlugin.setConsumerSecret("TMF0TYJwIkpPQrS5");
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'login Demo',
      theme: ThemeData(
        primarySwatch: Colors.cyan,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: AuthService().handleAuth(),
    );
  }
}

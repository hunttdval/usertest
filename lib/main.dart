import 'package:flutter/material.dart';
import 'package:login_phone_number/services/authservice.dart';
import 'package:mpesa_flutter_plugin/mpesa_flutter_plugin.dart';
import 'package:firebase_core/firebase_core.dart';
//import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:splashscreen/splashscreen.dart';

void main() {
  MpesaFlutterPlugin.setConsumerKey("q4EXwkP7u5OjQ7tKjEKGWupbZ7lGKOXH");
  MpesaFlutterPlugin.setConsumerSecret("TMF0TYJwIkpPQrS5");
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  //final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: '🛒 Shopit',
        theme: ThemeData(
          primarySwatch: Colors.blueGrey,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: FutureBuilder(
          // Initialize FlutterFire:
          future: Firebase.initializeApp(),
          builder: (context, snapshot) {
            // Check for errors
            if (snapshot.hasError) {
              return Scaffold(
                  body: Container(
                      color: Colors.red,
                      child: Center(
                          child: Column(
                        children: [
                          Icon(Icons.warning),
                          Text('something went wrong!! 🤔')
                        ],
                      ))));
            }

            // Once complete, show your application
            if (snapshot.connectionState == ConnectionState.done) {
              return SplashScreen(
                seconds: 10,
                routeName: "/",
                navigateAfterSeconds: AuthService().handleAuth(),
                // image: Image.asset(
                //   'assets/icons/splash.png',
                //   fit: BoxFit.cover,
                // ),
                title: Text('🛒 ShopIt'),
              );
            }

            // Otherwise, show something whilst waiting for initialization to complete
            return SplashScreen(
              seconds: 10,
              routeName: "/",
              // image: Image.asset(
              //   'assets/icons/splash.png',
              //   fit: BoxFit.cover,
              // ),
              title: Text('🛒 ShopIt'),
            );
          },
        ));
  }
}
//(),

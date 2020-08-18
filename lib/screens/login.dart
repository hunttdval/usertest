import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:login_phone_number/services/authservice.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formkey = GlobalKey<FormState>();
  TextEditingController phoneNoController = TextEditingController();
  String phoneNo, verificationId, smsCode;
  bool codeSent = false;
  void onPhoneNumberChange(
      String number, String internationalizedPhoneNumber, String isoCode) {
    setState(() {
      phoneNo = internationalizedPhoneNumber;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('log in'),
      ),
      body: SizedBox(
        height: double.infinity,
        width: double.infinity,
        child: Container(
          color: Colors.greenAccent,
          child: Form(
            key: formkey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(right: 25, left: 25),
                  child:
//                   InternationalPhoneInput(
//                     decoration:
//                     InputDecoration(hintText: ' enter phone number'),
//                     initialPhoneNumber: phoneNo,
//                     onPhoneNumberChange: onPhoneNumberChange,
//                     initialSelection: "KE",
//                     enabledCountries: ['+254'],
//                     showCountryCodes: true,
//                     showCountryFlags: true,
//                   ),

                      TextFormField(
                    // ignore: missing_return
                    validator: (value) {
                      if ((value).isEmpty || !(value).startsWith("+254")) {
                        return 'please enter a valid phone number';
                      }
                    },
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                        hintText:
                            'phone number(example: ' + '+254 xxx-xxx-xxx)'),
                    onChanged: (val) {
                      setState(() {
                        this.phoneNo = val;
                      });
                    },
                  ),
                ),
                codeSent
                    ? Padding(
                        padding: EdgeInsets.only(right: 25, left: 25),
                        child: TextFormField(
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                              hintText: 'Enter verification code sent'),
                          onChanged: (val) {
                            setState(() {
                              this.smsCode = val;
                            });
                          },
                        ),
                      )
                    : Container(),
                Padding(
                  padding: EdgeInsets.only(left: 65, right: 65),
                  child: SizedBox(
                    child: RaisedButton(
                      onPressed: () {
                        if (formkey.currentState.validate()) {
                          codeSent
                              ? AuthService()
                                  .signInWithOTP(smsCode, verificationId)
                              : verifyPhone(phoneNo);
                        } else {
                          print('invalid phone number');
                        }
                      },
                      child: Center(
                        child: codeSent ? Text('verify') : Text('login'),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> verifyPhone(phoneNo) async {
    final PhoneVerificationCompleted verified = (AuthCredential authResult) {
      AuthService().signIn(authResult);
    };
    final PhoneVerificationFailed verificationFailed =
        (AuthException authException) {
      print('${authException.message}');
    };
    final PhoneCodeSent smsSent = (String verId, [int forceResend]) {
      this.verificationId = verId;
      setState(() {
        this.codeSent = true;
      });
    };
    final PhoneCodeAutoRetrievalTimeout autoTimeout = (String verId) {
      this.verificationId = verId;
    };
    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phoneNo,
        timeout: Duration(seconds: 5),
        verificationCompleted: verified,
        verificationFailed: verificationFailed,
        codeSent: smsSent,
        codeAutoRetrievalTimeout: autoTimeout);
    // print(phoneNo.toString());
  }
}

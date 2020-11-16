import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:login_phone_number/screens/cart.dart';
import 'package:login_phone_number/screens/login.dart';
import 'package:login_phone_number/services/authservice.dart';
import 'package:splashscreen/splashscreen.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
  }

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth _auth = FirebaseAuth.instance;
  DocumentReference reference = FirebaseFirestore.instance
      .collection('cashier')
      .doc(FirebaseAuth.instance.currentUser.uid);
  DocumentReference ref = FirebaseFirestore.instance
      .collection('user')
      .doc(FirebaseAuth.instance.currentUser.uid)
      .collection('cart')
      .doc();
  final usercartdoc = FirebaseFirestore.instance
      .collection('user')
      .doc(FirebaseAuth.instance.currentUser.uid);
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: firestore.collection('items').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SplashScreen(
            seconds: 10,
            routeName: "/",
            // image: Image.asset(
            //   'assets/icons/splash.png',
            //   fit: BoxFit.cover,
            // ),
            title: Text('🛒 ShopIt'),
          );
        }
        return DefaultTabController(
          length: 2,
          child: Scaffold(
            drawer: Drawer(
              child: Column(
                children: [
                  DrawerHeader(child: Text('header')),
                  FlatButton(
                      onPressed: () async {
                        await firestore
                            .collection('receipts')
                            .where('receiptNumber', isEqualTo: 'OIN0STOX7E')
                            .get()
                            .then((value) async {
                          value.docs.forEach((element) {
                            Map fieldnames = element.data()['map'];
                            if (element.data()['checkedOut'] == true) {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                    content: Text('nothing to show')),
                              );
                            } else
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Text('test'),
                                    content: SingleChildScrollView(
                                      child: Stack(
                                        fit: StackFit.loose,
                                        children: [
                                          ListBody(
                                            children:
                                                fieldnames.keys.map((mapinfo) {
                                              return Text('     *' + mapinfo);
                                            }).toList(),
                                          ),
                                          ListBody(
                                            children: fieldnames.values
                                                .map((mapinfo) {
                                              return Text(mapinfo.toString());
                                            }).toList(),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              );
                          });
                        });
                      },
                      child: Text('info'))
                ],
              ),
            ),
            appBar: AppBar(
              elevation: 0,
              bottom: TabBar(
                tabs: [
                  Tab(
                    icon: Icon(Icons.home),
                    text: "Home",
                  ),
                  Tab(icon: Icon(Icons.shopping_cart), text: "Cart"),
                ],
              ),
              title: Text('🛒 ShopIt'),
              actions: [
                IconButton(
                  icon: Icon(
                    Icons.exit_to_app,
                    size: 30.0,
                  ),
                  onPressed: () {
                    showDialog(
                        barrierDismissible: false,
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                            title: Text('Wanna SignOut?'),
                            actions: [
                              FlatButton(
                                onPressed: () => Navigator.pop(context, false),
                                child: Text('No'),
                              ),
                              FlatButton(
                                onPressed: () {
                                  Navigator.pop(context, true);
                                  AuthService().signOut();
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => LoginPage()));
                                },
                                child: Text('Yes'),
                              ),
                            ],
                          );
                        });
                  },
                ),
              ],
            ),
            body: TabBarView(
              children: [
                ListView(
                  children: snapshot.data.docs.map((DocumentSnapshot document) {
                    firestore.runTransaction((transaction) async {
                      DocumentSnapshot snapshot =
                          await transaction.get(reference);

                      if (document.data()['quantity'] <
                          snapshot.data()[document.data()['name']]) {
                        await firestore
                            .collection('user')
                            .doc(_auth.currentUser.uid)
                            .collection('cart')
                            .doc(document.data()['name'])
                            .update(
                                {'in stock': false, 'price': 0, 'quantity': 0});

                        await firestore
                            .collection('cashier')
                            .doc(_auth.currentUser.uid)
                            .update(
                                {document.data()['name']: FieldValue.delete()});
                      }
                    });

                    if (document.data()['quantity'] < 1) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundImage:
                                NetworkImage(document.data()['url']),
                            radius: 30,
                          ),
                          title: Text(document.data()['name']),
                          subtitle: Text('out of stock'),
                        ),
                      );
                    }

                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(document.data()['url']),
                          radius: 30,
                        ),
                        title: Text(document.data()['name']),
                        subtitle: Text(document.data()['quantity'].toString()),
                        trailing: IconButton(
                            icon: Icon(Icons.add_shopping_cart),
                            color: Colors.green,
                            onPressed: () async {
                              try {
                                await firestore
                                    .collection('user')
                                    .doc(_auth.currentUser.uid)
                                    .collection('cart')
                                    .doc(document.data()['name'])
                                    .get()
                                    .then((doc) {
                                  if (document.data()['quantity'] == 0) {
                                    Fluttertoast.showToast(
                                        msg: document.data()['name'] +
                                            ' is out of stock',
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.CENTER,
                                        timeInSecForIosWeb: 1,

                                        //backgroundColor: Colors.grey,

                                        textColor: Colors.brown,
                                        fontSize: 16.0);
                                  } else {
                                    if (!doc.exists) {
                                      firestore
                                          .collection('user')
                                          .doc(_auth.currentUser.uid)
                                          .collection('cart')
                                          .doc(document.data()['name'])
                                          .set({
                                        'image': document.data()['url'],
                                        'name': document.data()['name'],
                                        'price': document.data()['price'],
                                        'quantity': 0,
                                        'in stock': true
                                      });

                                      firestore
                                          .collection('cashier')
                                          .doc(_auth.currentUser.uid)
                                          .set({document.data()['name']: 0});

                                      Fluttertoast.showToast(
                                          msg: document.data()['name'] +
                                              ' added to cart ✔',
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.CENTER,
                                          timeInSecForIosWeb: 1,

                                          //backgroundColor: Colors.grey,

                                          textColor: Colors.brown,
                                          fontSize: 16.0);
                                    } else {
                                      Fluttertoast.showToast(
                                          msg: document.data()['name'] +
                                              ' is already in cart',
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.CENTER,
                                          timeInSecForIosWeb: 1,

                                          //backgroundColor: Colors.grey,

                                          textColor: Colors.brown,
                                          fontSize: 16.0);
                                    }
                                  }
                                });
                              } catch (e) {
                                print(e);
                              }
                            }),
                      ),
                    );
                  }).toList(),
                ),
                Mycart()
              ],
            ),
          ),
        );
      },
    );
  }
}

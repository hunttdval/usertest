import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mpesa_flutter_plugin/mpesa_flutter_plugin.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  Future<void> startCheckout({String userPhone, String amount}) async {
    dynamic transactionInitialization;
    try {
      transactionInitialization = await MpesaFlutterPlugin.initializeMpesaSTKPush(
          businessShortCode: "174379",
          transactionType: TransactionType.CustomerPayBillOnline,
          amount: double.parse(amount),
          partyA: userPhone,
          partyB: "174379",
          callBackURL: Uri(
              scheme: "https",
              host: "us-central1-phone-login-414b0.cloudfunctions.net",
              path: "/main/lmno/callback"),
          accountReference: 'mpesa test',
          phoneNumber: userPhone,
          transactionDesc: 'purchase',
          baseUri: Uri(scheme: "https", host: "sandbox.safaricom.co.ke"),
          passKey:
              "bfb279f9aa9bdbcf158e97dd71a467cd2e0c893059b10f78e6b72ada1ed2c919");

      print('transaction result: \n' + transactionInitialization.toString());
      return transactionInitialization;
    } catch (e) {
      print('exception' + e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: double.infinity,
      width: double.infinity,
      child: Container(
        color: Colors.pinkAccent,
        child: MyItems(),
      ),
    );
  }
}

class MyItems extends StatefulWidget {
  @override
  _MyItemsState createState() => _MyItemsState();
}

class _MyItemsState extends State<MyItems> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: Firestore.instance.collection('items').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData)
            return Center(child: CircularProgressIndicator());
          return ListView(
            children: snapshot.data.documents.map((document) {
              int quantitySelected = 0;

              var price = quantitySelected * document['price'];
              return Card(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    ListTile(
                      leading: CircleAvatar(
                        radius: 35,
                        backgroundImage: NetworkImage(document['image']),
                      ),
                      title: Text(document['name']),
                      subtitle: Row(
                        children: [
                          Text('price: ' +
                              document['price'].toString() +
                              ' ksh'),
                          SizedBox(
                            width: 10,
                          ),
                          Text(document['quantity'].toString() + ' remaining'),
                          SizedBox(
                            width: 10,
                          ),
                          Text('In Cart: ' + quantitySelected.toString())
                        ],
                      ),
                    ),
                    ButtonBar(
                      children: <Widget>[
                        FlatButton(
                          child: Text('ADD'),
                          onPressed: () {
                            setState(() {
                              quantitySelected += 1;
                            });
                          },
                        ),
                        FlatButton(
                          child: Text('DEDUCT'),
                          onPressed: () {
                            setState(() {
                              if (quantitySelected > 0) {
                                quantitySelected -= 1;
                              }
                            });
                          },
                        ),
                        FlatButton(
                          child: Text('PURCHASE'),
                          onPressed: () {
                            print('quantity purchased: ' +
                                quantitySelected.toString());
                            print('total price:' + price.toString());
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }).toList(),
          );
        });
  }
}

class ExploreView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: double.infinity,
      width: double.infinity,
      child: Container(
        color: Colors.amberAccent,
      ),
    );
  }
}

class ProfileView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: double.infinity,
      width: double.infinity,
      child: Container(
        color: Colors.greenAccent,
      ),
    );
  }
}

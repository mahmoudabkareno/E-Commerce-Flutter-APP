import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce/pages/usersPages/GlobalState.dart';
import 'package:flutter/material.dart';

class OrderDetails extends StatefulWidget {
  @override
  _OrderDetailsState createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  static const Xcolor = Color(0x9FF9B9F9);

  CollectionReference orderdetails =
      FirebaseFirestore.instance.collection('Order');

  GlobalState _store = GlobalState.ins;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: viewOrders(),
    );
  }

  Widget viewOrders() {
    return StreamBuilder<QuerySnapshot>(
        stream: orderdetails
            .where('orderProductname', isEqualTo: _store.get('name'))
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Something went wrong'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasData) {
            return ListView(
              children: snapshot.data.docs.map((DocumentSnapshot document) {
                print(document.data()['orderProductname']);
                print('donne');
                return Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    children: <Widget>[
                      Container(
                        color: _OrderDetailsState.Xcolor,
                        height: MediaQuery.of(context).size.height * 0.2,
                        child: Padding(
                          padding: EdgeInsets.all(10),
                          child: ListTile(
                            title: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  'Product Name: ${document.data()['orderProductname']}',
                                  style: TextStyle(
                                      fontSize: 22, fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                Text(
                                  'Product Quantity: ${document.data()['orderProductquantity'].toString()}',
                                  style: TextStyle(
                                      fontSize: 20, fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                Text(
                                  'Phone: ${document.data()['phone'].toString()}\$',
                                  style: TextStyle(
                                      fontSize: 20, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            trailing: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  IconButton(
                                      icon: Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                      ),
                                      onPressed: () {
                                        orderdetails.doc(document.id).delete();
                                        Scaffold.of(context).showSnackBar(SnackBar(content: Text('order deleted')));
                                      }),
                                ],
                              ),
                          ),
                        ),
                      ),
                      RaisedButton(
                        onPressed: (){
                          bool notificationstatus = true;
                          FirebaseFirestore.instance
                              .collection('Notification')
                              .doc()
                              .set({
                            'name' : notificationstatus
                              });
                          Scaffold.of(context).showSnackBar(SnackBar(content: Text('order confirmed')));
                        },
                        child: Text('Confirm the order'),
                      ),
                    ],
                  ),
                );
              }).toList(),
            );
          } else {
            return Center(
              child: Text('No data'),
            );
          }
        });
  }
}

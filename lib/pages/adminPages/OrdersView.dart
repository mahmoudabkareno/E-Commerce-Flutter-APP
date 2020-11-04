import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce/pages/usersPages/GlobalState.dart';
import 'package:flutter/material.dart';


class OrderPage extends StatefulWidget {
  @override
  _OrderPageState createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {

  static const Xcolor = Color(0x9FF9B9F9);

  CollectionReference orders = FirebaseFirestore.instance.collection('Order');

  GlobalState _store = GlobalState.ins;
  var productName;
  void initState(){
    _store.set('name', '');
    productName = _store.get('name');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: viewOrders(),
    );
  }

 Widget viewOrders() {
    return StreamBuilder<QuerySnapshot>(
      stream: orders.snapshots(),
        builder: (BuildContext context , AsyncSnapshot<QuerySnapshot> snapshot){
        if(snapshot.hasError){
          return  Center(child: Text('Something went wrong'));
        }
        if(snapshot.connectionState == ConnectionState.waiting){
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        return ListView(
          children: snapshot.data.docs.map((DocumentSnapshot document) {
            return GestureDetector(
                onTap: (){
                  productName = document.data()['orderProductname'];
                  _store.set('name', productName);
                  Navigator.pushNamed(context, '/OrderDetails');
                },
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Container(
                    color: _OrderPageState.Xcolor,
                    height: MediaQuery.of(context).size.height* 0.2,
                    child: Padding(
                        padding: EdgeInsets.all(10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Address: ${document.data()['address']}',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Text(
                            'Total Price: ${document.data()['totalprice'].toString()}\$',
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            );
          }).toList(),
        );
        });
 }
}

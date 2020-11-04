import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce/pages/adminPages/manageProduct.dart';
import 'package:flutter/material.dart';

import 'GlobalState.dart';

class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  static const Xcolor = Color(0x9FF9B9F9);

  CollectionReference productsInCarts =
      FirebaseFirestore.instance.collection('CartItems');
  TextEditingController _addressController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();


  @override
  void deposit() {
    super.dispose();
    _addressController.dispose();
    _phoneController.dispose();
  }

  GlobalState _store = GlobalState.ins;
  var productImage;
  void initState() {
    _store.set('name', '');
    productImage = _store.get('name');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('My Cart'),
          elevation: 0,
          leading: GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Icon(Icons.arrow_back_ios),
          ),
          backgroundColor: _CartPageState.Xcolor,
        ),
        body: cartItem());
  }

  Widget cartItem() {
    return StreamBuilder<QuerySnapshot>(
      stream: productsInCarts.snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Something went wrong'));
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: Center(child: CircularProgressIndicator()),
          );
        }
        return ListView(
          children: snapshot.data.docs.map((DocumentSnapshot document) {
            return GestureDetector(
              onTapUp: (details) {
                double dx = details.globalPosition.dx;
                double dy = details.globalPosition.dy;
                double dx2 = MediaQuery.of(context).size.width - dx;
                double dy2 = MediaQuery.of(context).size.width - dy;
                showMenu(
                    context: context,
                    position: RelativeRect.fromLTRB(dx, dy, dx, dy),
                    items: [
                      MyPopupMenuItem(
                        onClick: () {
                          Navigator.pop(context);
                          productsInCarts.doc(document.id).delete();
                          productImage =
                              document.data()['ProductimageLocation'];
                          _store.set('name', productImage);
                          Navigator.pushNamed(context, '/ProductInfo');
                        },
                        child: Text('Edit'),
                      ),
                      MyPopupMenuItem(
                        onClick: () {
                          productsInCarts.doc(document.id).delete();
                        },
                        child: Text('delete'),
                      )
                    ]);
              },
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: Container(
                      color: _CartPageState.Xcolor,
                      height: MediaQuery.of(context).size.height * 0.15,
                      child: Row(
                        children: <Widget>[
                          CircleAvatar(
                            backgroundImage: AssetImage(
                                document.data()['ProductimageLocation']),
                            radius:
                                (MediaQuery.of(context).size.height * 0.15) / 2,
                          ),
                          Padding(padding: EdgeInsets.only(left: 15)),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                document.data()['Productname'],
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 19),
                              ),
                              Padding(padding: EdgeInsets.only(top: 5)),
                              Text(
                                '${document.data()['Productprice']} \$',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 15),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 60),
                            child: Row(
                              children: <Widget>[
                                Text(
                                  '${document.data()['Productquantity']}',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15),
                                ),
                                Padding(padding: EdgeInsets.only(left: 25)),
                                GestureDetector(
                                  onTap: () {
                                    showDialog<void>(
                                      context: context,
                                      barrierDismissible:
                                          false, // user must tap button!
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text(
                                              document.data()['Productname']),
                                          content: SingleChildScrollView(
                                            child: ListBody(
                                              children: <Widget>[
                                                Text(
                                                    'Total Price: ${document.data()['Productquantity'] * int.parse(document.data()['Productprice'])}\$'),
                                                Column(
                                                  children: <Widget>[
                                                    TextFormField(
                                                      controller:
                                                          _addressController,
                                                      decoration: InputDecoration(
                                                        hintText:
                                                            'Enter Your Address',
                                                        enabledBorder:
                                                            OutlineInputBorder(
                                                                borderSide:
                                                                    BorderSide(
                                                                        color: Colors
                                                                            .orange),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            20.0)),
                                                        filled: true,
                                                        fillColor: Colors.white70,
                                                        prefixIcon: Icon(
                                                          Icons.home,
                                                          color: Colors.green,
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 7,
                                                    ),
                                                    TextFormField(
                                                      controller:
                                                      _phoneController,
                                                      decoration: InputDecoration(
                                                        hintText:
                                                        'Enter Your Phone Number',
                                                        enabledBorder:
                                                        OutlineInputBorder(
                                                            borderSide:
                                                            BorderSide(
                                                                color: Colors
                                                                    .orange),
                                                            borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                                20.0)),
                                                        filled: true,
                                                        fillColor: Colors.white70,
                                                        prefixIcon: Icon(
                                                          Icons.phone,
                                                          color: Colors.green,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                          actions: <Widget>[
                                            Builder(
                                              builder: (BuildContext context) => FlatButton(
                                                    child: Text('Order'),
                                                    onPressed: () {
                                                      try{
                                                        FirebaseFirestore.instance
                                                            .collection('Order')
                                                            .doc(document.id).set({
                                                          'orderProductname': document.data()['Productname'],
                                                          'address': _addressController.text,
                                                          'totalprice': document.data()['Productquantity'] * int.parse(document.data()['Productprice']),
                                                          'orderProductquantity': document.data()['Productquantity'],
                                                          'orderProductcategory': document.data()['Productcategory'],
                                                          'phone': _phoneController.text,
                                                        });
//                                                          .set({
//                                                        'address': _addressController.text,
//                                                        'totalprice': document.data()['Productquantity'] * int.parse(document.data()['Productprice']),
//                                                      });
                                                        Navigator.of(context).pop();
//                                                        Scaffold.of(context).showSnackBar(SnackBar(
//                                                          content: Text('Order Created'),
//                                                        ));
                                                    }catch(e){
                                                        print(e.message);
                                                      }
                                                    }
                                                  ),
                                            ),

                                          ],
                                        );
                                      },
                                    );
                                  },
                                  child: Icon(
                                    Icons.shop,
                                    color: Colors.green,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        );
      },
    );
  }
}

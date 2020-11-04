import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'GlobalState.dart';

class ProductInfo extends StatefulWidget {
  @override
  _ProductInfoState createState() => _ProductInfoState();
}

class _ProductInfoState extends State<ProductInfo> {
  CollectionReference products =
      FirebaseFirestore.instance.collection('Products');
  CollectionReference cartItems =
      FirebaseFirestore.instance.collection('CartItems');

  static const Xcolor = Color(0x9FF9B9F9);

  GlobalState _store = GlobalState.ins;

  @override
  void dispose() {
    super.dispose();
  }

  int productQuantity = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
          child: Container(
              height: MediaQuery.of(context).size.height,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Icon(
                      Icons.arrow_back_ios,
                      color: Colors.black,
                    ),
                  ),
                  GestureDetector(
                    child: Icon(Icons.shopping_cart),
                    onTap: () {
                      Navigator.pushNamed(context, '/CartPage');
                    },
                  ),
                ],
              )),
        ),
        automaticallyImplyLeading: false,
      ),
      body: Stack(
        children: <Widget>[showProductInfo()],
      ),
    );
  }

  Widget showProductInfo() {
    return StreamBuilder<QuerySnapshot>(
      stream: products
          .where('imageLocation', isEqualTo: _store.get('name'))
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Something went wrong'));
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: Center(child: CircularProgressIndicator()),
          );
        }
        return Container(
            padding: EdgeInsets.only(top: 25),
            child: ListView(
              children: snapshot.data.docs.map((DocumentSnapshot document) {
                return Stack(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(top: 1),
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      child: Image(
                        image: AssetImage(document.data()['imageLocation']),
                        fit: BoxFit.fill,
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      child: Column(
                        children: <Widget>[
                          Opacity(
                            child: Container(
                              color: Colors.white,
                              height: MediaQuery.of(context).size.height * .2,
                              alignment: Alignment.topLeft,
                              width: MediaQuery.of(context).size.width,
                              child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Column(
                                  children: <Widget>[
                                    Text(
                                      '${document.data()['name']}      ${document.data()['price']} \$',
                                      textDirection: TextDirection.ltr,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                          color: Colors.black),
                                    ),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    Text(
                                      document.data()['description'],
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                          color: Colors.black),
                                    ),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        ClipOval(
                                          child: Material(
                                            color: Colors.deepPurple,
                                            child: GestureDetector(
                                              onTap: () {
                                                add();
                                              },
                                              child: SizedBox(
                                                child: Icon(Icons.add,
                                                    color: Colors.white),
                                                height: 20,
                                                width: 20,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Text(
                                          productQuantity.toString(),
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 31,
                                              color: Colors.black),
                                        ),
                                        ClipOval(
                                          child: Material(
                                            color: Colors.deepPurple,
                                            child: GestureDetector(
                                              onTap: () {
                                                sub();
                                              },
                                              child: SizedBox(
                                                child: Icon(Icons.remove,
                                                    color: Colors.white),
                                                height: 20,
                                                width: 20,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                            opacity: .4,
                          ),
                          ButtonTheme(
                            height: MediaQuery.of(context).size.height * .069,
                            minWidth: MediaQuery.of(context).size.width,
                            child: RaisedButton(
                              // ignore: missing_return
                              onPressed: () {
                                bool x = true;
                                cartItems
                                    .get()
                                    .then((QuerySnapshot querySnapshot) {
                                          querySnapshot.docs.forEach((doc) {
                                            if (doc.data()['Productname'] == document.data()['name']) {
                                               x = true;
                                            }
                                          });
                                        });
                                if(x){
                                  cartItems.doc()
                                      .set({
                                    'Productname': document.data()['name'],
                                    'Productprice': document.data()['price'],
                                    'Productdescription':
                                    document.data()['description'],
                                    'Productcategory':
                                    document.data()['category'],
                                    'ProductimageLocation':
                                    document.data()['imageLocation'],
                                    'Productquantity': productQuantity
                                  });
                                  Scaffold.of(context).showSnackBar(SnackBar(
                                      content: Text('Add to shopping cart')));
                                }
                                Scaffold.of(context).showSnackBar(SnackBar(
                                    content: Text('Aleardy Exist in shopping cart')));
                              },
                              color: _ProductInfoState.Xcolor,
                              child: Text(
                                'Add To Shopping Cart'.toUpperCase(),
                                style: TextStyle(
                                    fontSize: 20,
                                    fontStyle: FontStyle.italic,
                                    color: Colors.black),
                              ),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                );
              }).toList(),
            ));
      },
    );
  }

  void sub() {
    if (productQuantity > 1) {
      setState(() {
        productQuantity--;
      });
    }
  }

  void add() {
    setState(() {
      productQuantity++;
    });
  }
}

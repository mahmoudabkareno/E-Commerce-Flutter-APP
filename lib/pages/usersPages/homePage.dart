import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce/firebaseServices/firebaseAuthentaction.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'GlobalState.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  static const Xcolor = Color(0x9FF9B9F9);

  int indexTabBar = 0;

  int indexBottomBar = 0;

  FireBaseAuthentication fireBaseAuthentication = FireBaseAuthentication();

  CollectionReference products = FirebaseFirestore.instance.collection('Products');

  GlobalState _store = GlobalState.ins;
  var productImage;
  void initState(){
    _store.set('name', '');
    productImage = _store.get('name');
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        DefaultTabController(
          length: 4,
          child: Scaffold(
            bottomNavigationBar: BottomNavigationBar(
                items: [
                  BottomNavigationBarItem(
                      icon: Icon(Icons.home),
                      title: Text('home'.toUpperCase(),
                    style: TextStyle(
                      color: indexBottomBar == 0 ? Colors.deepPurpleAccent : Colors.black,
                      fontSize: indexBottomBar == 0 ? 15 : null,
                    ),)
                  ),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.notifications),
                      title: Text('Notification'.toUpperCase(),
                        style: TextStyle(
                          color: indexBottomBar == 1 ? Colors.deepPurpleAccent : Colors.black,
                          fontSize: indexBottomBar == 1 ? 15 : null,
                        ),)
                  ),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.close),
                      title: Text('SignOut'.toUpperCase(),
                        style: TextStyle(
                          color: indexBottomBar == 2 ? Colors.deepPurpleAccent : Colors.black,
                          fontSize: indexBottomBar == 2 ? 15 : null,
                        ),)
                  ),
                ],
              onTap: (v) async{
                setState(() {
                  indexBottomBar = v;
                });
                if(v == 0){
                  goodsView('jackets');
                }else
                if(v == 1){
                  Navigator.pushNamed(context, '/Notifaction');
                }else
                if(v == 2){
                  SharedPreferences preference = await SharedPreferences.getInstance();
                  preference.clear();
                  fireBaseAuthentication.signOut();
                  Navigator.popAndPushNamed(context , '/LoginScreen');
                }
              },
              currentIndex: 0,
              selectedItemColor: Colors.deepPurpleAccent,

              backgroundColor: _HomePageState.Xcolor,
            ),
              appBar: AppBar(
                backgroundColor: _HomePageState.Xcolor,
                elevation: 0,
                bottom: TabBar(
                  indicatorColor: Colors.deepPurple,
                  onTap: (v) {
                    setState(() {
                      indexTabBar = v;
                    });
                  },
                  tabs: <Widget>[
                    Text(
                      'Jackets',
                      style: TextStyle(
                        color: indexTabBar == 0 ? Colors.deepPurpleAccent : Colors.black,
                        fontSize: indexTabBar == 0 ? 15 : null,
                      ),
                    ),
                    Text(
                      'Trousers',
                      style: TextStyle(
                        color: indexTabBar == 1 ? Colors.deepPurpleAccent : Colors.black,
                        fontSize: indexTabBar == 1 ? 15 : null,
                      ),
                    ),
                    Text(
                      'T-shirts',
                      style: TextStyle(
                        color: indexTabBar == 2 ? Colors.deepPurpleAccent : Colors.black,
                        fontSize: indexTabBar == 2 ? 15 : null,
                      ),
                    ),
                    Text(
                      'Shoes',
                      style: TextStyle(
                        color: indexTabBar == 3 ? Colors.deepPurpleAccent : Colors.black,
                        fontSize: indexTabBar == 3 ? 15 : null,
                      ),
                    ),
                  ],
                ),
              ),
              backgroundColor: Colors.white,
              body: TabBarView(children: <Widget>[
                goodsView('jackets'),
                goodsView('trousers'),
                goodsView('t-shirts'),
                goodsView('shoes')
//                  trouserView(),
//                  tShirtView(),
//                  shoesView(),
              ])),
        ),
        Material(
          color: _HomePageState.Xcolor,
          child: Padding(
            padding: EdgeInsets.fromLTRB(20, 30, 20, 0),
            child: Container(
                color: _HomePageState.Xcolor,
                height: MediaQuery.of(context).size.height * 0.085,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'Discover'.toUpperCase(),
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    GestureDetector(
                        onTap: (){
                          Navigator.pushNamed(context, '/CartPage');
                        },
                        child: Icon(Icons.shopping_cart)),
                  ],
                )),
          ),
        ),
      ],
    );
  }

  Widget goodsView(String _category) {
    return StreamBuilder<QuerySnapshot>(
      stream: products.where('category', isEqualTo: _category).snapshots(),
      // ignore: missing_return
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Something went wrong'));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: Center(child: CircularProgressIndicator()),
          );
        }

        DocumentSnapshot document;

        if(snapshot.hasData)
        {

          return GridView(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: .7,
          ),
          // ignore: missing_return
          children: snapshot.data.docs.map((document) {
              return GestureDetector(
                onTap: (){
                  productImage = document.data()['imageLocation'];
                  _store.set('name', productImage);
                  Navigator.pushNamed(context, '/ProductInfo');
                },
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                  child: Stack(
                    children: <Widget>[
                      Positioned.fill(
                        child: Image(
                          image: AssetImage(document.data()['imageLocation']),
                          height: 200,
                          fit: BoxFit.fill,
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        child: Opacity(
                          opacity: .8,
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            height: 55,
                            color: Colors.white,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 9, vertical: 6),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    document.data()['name'],
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.deepPurple),
                                  ),
                                  Text(
                                    '${document.data()['price']} \$',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.deepPurple),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
          }).toList(),
        );}
      },
    );
  }
}


//Widget trouserView() {
//  return StreamBuilder<QuerySnapshot>(
//    stream: products.snapshots(),
//    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
//      if (snapshot.hasError) {
//        return Center(child: Text('Something went wrong'));
//      }
//
//      if (snapshot.connectionState == ConnectionState.waiting) {
//        return Center(
//          child: Center(child: CircularProgressIndicator()),
//        );
//      }
//      return GridView(
//        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//          crossAxisCount: 2,
//          childAspectRatio: .7,
//        ),
//        children: snapshot.data.docs.map((DocumentSnapshot document) {
//          if(document.data()['category'] == 'trousers'){
//            return Padding(
//              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
//              child: Stack(
//                children: <Widget>[
//                  Positioned.fill(
//                    child: Image(
//                      image: AssetImage(document.data()['imageLocation']),
//                      height: 200,
//                      fit: BoxFit.fill,
//                    ),
//                  ),
//                  Positioned(
//                    bottom: 0,
//                    child: Opacity(
//                      opacity: .8,
//                      child: Container(
//                        width: MediaQuery.of(context).size.width,
//                        height: 55,
//                        color: Colors.white,
//                        child: Padding(
//                          padding: const EdgeInsets.symmetric(
//                              horizontal: 9, vertical: 6),
//                          child: Column(
//                            crossAxisAlignment: CrossAxisAlignment.start,
//                            children: <Widget>[
//                              Text(
//                                document.data()['name'],
//                                style: TextStyle(
//                                    fontWeight: FontWeight.bold,
//                                    color: Colors.deepPurple),
//                              ),
//                              Text(
//                                '${document.data()['price']} \$',
//                                style: TextStyle(
//                                    fontWeight: FontWeight.bold,
//                                    color: Colors.deepPurple),
//                              ),
//                            ],
//                          ),
//                        ),
//                      ),
//                    ),
//                  ),
//                ],
//              ),
//
//            );
//          }
//        }).toList(),
//      );
//    },
//  );
//}
//
//Widget tShirtView() {
//  return StreamBuilder<QuerySnapshot>(
//    stream: products.snapshots(),
//    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
//      if (snapshot.hasError) {
//        return Center(child: Text('Something went wrong'));
//      }
//
//      if (snapshot.connectionState == ConnectionState.waiting) {
//        return Center(
//          child: Center(child: CircularProgressIndicator()),
//        );
//      }
//      return GridView(
//        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//          crossAxisCount: 2,
//          childAspectRatio: .7,
//        ),
//        children: snapshot.data.docs.map((DocumentSnapshot document) {
//          if(document.data()['category'] == 't-shirts'){
//            return Padding(
//              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
//              child: Stack(
//                children: <Widget>[
//                  Positioned.fill(
//                    child: Image(
//                      image: AssetImage(document.data()['imageLocation']),
//                      height: 200,
//                      fit: BoxFit.fill,
//                    ),
//                  ),
//                  Positioned(
//                    bottom: 0,
//                    child: Opacity(
//                      opacity: .8,
//                      child: Container(
//                        width: MediaQuery.of(context).size.width,
//                        height: 55,
//                        color: Colors.white,
//                        child: Padding(
//                          padding: const EdgeInsets.symmetric(
//                              horizontal: 9, vertical: 6),
//                          child: Column(
//                            crossAxisAlignment: CrossAxisAlignment.start,
//                            children: <Widget>[
//                              Text(
//                                document.data()['name'],
//                                style: TextStyle(
//                                    fontWeight: FontWeight.bold,
//                                    color: Colors.deepPurple),
//                              ),
//                              Text(
//                                '${document.data()['price']} \$',
//                                style: TextStyle(
//                                    fontWeight: FontWeight.bold,
//                                    color: Colors.deepPurple),
//                              ),
//                            ],
//                          ),
//                        ),
//                      ),
//                    ),
//                  ),
//                ],
//              ),
//
//            );
//          }
//        }).toList(),
//      );
//    },
//  );
//}
//
//Widget shoesView() {
//  return StreamBuilder<QuerySnapshot>(
//    stream: products.snapshots(),
//    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
//      if (snapshot.hasError) {
//        return Center(child: Text('Something went wrong'));
//      }
//
//      if (snapshot.connectionState == ConnectionState.waiting) {
//        return Center(
//          child: Center(child: CircularProgressIndicator()),
//        );
//      }
//      return GridView(
//        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//          crossAxisCount: 2,
//          childAspectRatio: .7,
//        ),
//        children: snapshot.data.docs.map((DocumentSnapshot document) {
//          if(document.data()['category'] == 'shoes'){
//            return Padding(
//              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
//              child: Stack(
//                children: <Widget>[
//                  Positioned.fill(
//                    child: Image(
//                      image: AssetImage(document.data()['imageLocation']),
//                      height: 200,
//                      fit: BoxFit.fill,
//                    ),
//                  ),
//                  Positioned(
//                    bottom: 0,
//                    child: Opacity(
//                      opacity: .8,
//                      child: Container(
//                        width: MediaQuery.of(context).size.width,
//                        height: 55,
//                        color: Colors.white,
//                        child: Padding(
//                          padding: const EdgeInsets.symmetric(
//                              horizontal: 9, vertical: 6),
//                          child: Column(
//                            crossAxisAlignment: CrossAxisAlignment.start,
//                            children: <Widget>[
//                              Text(
//                                document.data()['name'],
//                                style: TextStyle(
//                                    fontWeight: FontWeight.bold,
//                                    color: Colors.deepPurple),
//                              ),
//                              Text(
//                                '${document.data()['price']} \$',
//                                style: TextStyle(
//                                    fontWeight: FontWeight.bold,
//                                    color: Colors.deepPurple),
//                              ),
//                            ],
//                          ),
//                        ),
//                      ),
//                    ),
//                  ),
//                ],
//              ),
//
//            );
//          }
//        }).toList(),
//      );
//    },
//  );
//}
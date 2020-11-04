import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ManageProduct extends StatefulWidget {
  @override
  _ManageProductState createState() => _ManageProductState();
}

class _ManageProductState extends State<ManageProduct> {
  static const Xcolor = Color(0x9FF9B9F9);

  CollectionReference products =
      FirebaseFirestore.instance.collection('Products');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product'),
        backgroundColor: _ManageProductState.Xcolor,
      ),
      backgroundColor: _ManageProductState.Xcolor,
      body: getProducts(),
    );
  }

  Widget getProducts() {
    return StreamBuilder<QuerySnapshot>(
      stream: products.snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Something went wrong'));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: Center(child: CircularProgressIndicator()),
          );
        }
        return GridView(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: .7,
          ),
          children: snapshot.data.docs.map((DocumentSnapshot document) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              child: GestureDetector(
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
                          onClick: (){
                            Navigator.pushNamed(context, '/EditProduct',
                                arguments: products.doc(document.id));
                          },
                          child: Text('Edit'),),
                        MyPopupMenuItem(
                          onClick: (){
                            products.doc(document.id).delete();
                          },
                          child: Text('delete'),
                        )
                      ]);
                },
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
        );
      },
    );
  }
}
//GridView.builder(
//gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
//itemBuilder: (context, position){
//});


class MyPopupMenuItem<T> extends PopupMenuItem<T>{
  final Widget child;
  final Function onClick;
  MyPopupMenuItem({@required this.child, @required this.onClick}): super(child :child);
  @override
  PopupMenuItemState<T, PopupMenuItem<T>> createState() {
    return MyPopupMenuItemState();
  }
}
class MyPopupMenuItemState<T, PopupMenuItem> extends PopupMenuItemState<T, MyPopupMenuItem<T>>{
@override
  void handleTap(){
  widget.onClick();
  print('helo');
  }
}
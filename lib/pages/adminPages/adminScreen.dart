import 'package:flutter/material.dart';
class AdminScreen extends StatefulWidget {
  @override
  _AdminScreenState createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  static const Xcolor = Color(0x9FF9B9F9);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _AdminScreenState.Xcolor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            FlatButton(
              onPressed: () async {
                Navigator.pushNamed(context, '/OrderPage');
              },
              child: Text(
                'View Orders',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              color: Colors.black,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
            ),
            SizedBox(
              height: 20,
            ),
            FlatButton(
              onPressed: () async {
                Navigator.pushNamed(context, '/ViewProducts');
              },
              child: Text(
                'View Products',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              color: Colors.black,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
            ),
            SizedBox(
              height: 20,
            ),
            FlatButton(
              onPressed: (){
                Navigator.pushNamed(context, '/AddProduct');
              },
              child: Text(
                'Add Products',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              color: Colors.black,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
            ),
            SizedBox(
              height: 20,
            ),
            FlatButton(
              onPressed: () async {
                Navigator.pushNamed(context, '/ManageProduct');
              },
              child: Text(
                'Edit Products',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              color: Colors.black,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
            ),
          ],
        ),
      ),
    );
  }
}

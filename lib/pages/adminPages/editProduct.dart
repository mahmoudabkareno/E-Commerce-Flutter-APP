import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class EditProduct extends StatefulWidget {
  @override
  _EditProductState createState() => _EditProductState();
}

class _EditProductState extends State<EditProduct> {
  static const Xcolor = Color(0x9FF9B9F9);


  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  TextEditingController _nameController = TextEditingController();
  TextEditingController _priceController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _categoryController = TextEditingController();
  TextEditingController _imageLocationController = TextEditingController();

  String _name;
  String _price;
  String _description;
  String _category;
  String _imageLocation;

  CollectionReference products =
      FirebaseFirestore.instance.collection('Products');

  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    _categoryController.dispose();
    _imageLocationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product'),
        backgroundColor: _EditProductState.Xcolor,
      ),
      backgroundColor: _EditProductState.Xcolor,
      body: editProducts(),
    );
  }

  Widget editProducts() {
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
        ModalRoute.of(context).settings.arguments;
        return Container(
            padding: EdgeInsets.only(top: 25),
            child: ListView(
              children: snapshot.data.docs.map((DocumentSnapshot _document) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40.1),
                  child: Container(
                    height: MediaQuery.of(context).size.height,
                    child: Form(
                      child: Column(
                        children: <Widget>[
                          TextFormField(
                            controller: _nameController,
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Product name should be entered';
                              } else {
                                return null;
                              }
                            },
                            decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.white),
                                    borderRadius: BorderRadius.circular(20.0)),
                                filled: true,
                                fillColor: Colors.white70,
                                prefixIcon: Icon(
                                  Icons.ac_unit,
                                  color: Colors.black,
                                ),
                                hintText: 'Product Name'),
                          ),
                          SizedBox(
                            height: 22,
                          ),
                          TextFormField(
                            controller: _priceController,
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Product Price should be entered';
                              } else {
                                return null;
                              }
                            },
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.white),
                                    borderRadius: BorderRadius.circular(20.0)),
                                filled: true,
                                fillColor: Colors.white70,
                                prefixIcon: Icon(
                                  Icons.payment,
                                  color: Colors.black,
                                ),
                                hintText: 'Product Price'),
                          ),
                          SizedBox(
                            height: 22,
                          ),
                          TextFormField(
                            controller: _descriptionController,
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Product description should be entered';
                              } else {
                                return null;
                              }
                            },
                            maxLines: 3,
                            decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.white),
                                    borderRadius: BorderRadius.circular(20.0)),
                                filled: true,
                                fillColor: Colors.white70,
                                prefixIcon: Icon(
                                  Icons.description,
                                  color: Colors.black,
                                ),
                                hintText: 'Product Description'),
                          ),
                          SizedBox(
                            height: 22,
                          ),
                          TextFormField(
                            controller: _categoryController,
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Product category should be entered';
                              } else {
                                return null;
                              }
                            },
                            decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.white),
                                    borderRadius: BorderRadius.circular(20.0)),
                                filled: true,
                                fillColor: Colors.white70,
                                prefixIcon: Icon(
                                  Icons.category,
                                  color: Colors.black,
                                ),
                                hintText: 'Product Catergory'),
                          ),
                          SizedBox(
                            height: 22,
                          ),
                          TextFormField(
                            controller: _imageLocationController,
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Product image location should be entered';
                              } else {
                                return null;
                              }
                            },
                            decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.white),
                                    borderRadius: BorderRadius.circular(20.0)),
                                filled: true,
                                fillColor: Colors.white70,
                                prefixIcon: Icon(
                                  Icons.add_location,
                                  color: Colors.black,
                                ),
                                //
                                hintText: 'Product Location image'),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          Builder(
                            builder: (context) => FlatButton(
                              onPressed: () async {
                                DocumentSnapshot _currentDocument;
                                _name = _nameController.text;
                                _price = _priceController.text;
                                _description = _descriptionController.text;
                                _category = _categoryController.text;
                                _imageLocation = _imageLocationController.text;
                                  FirebaseFirestore.instance
                                      .collection('Products')
                                      .doc(_document.id)
                                      .update({
                                    'name': _name,
                                    'price': _price,
                                    'description': _description,
                                    'category': _category,
                                    'imageLocation': _imageLocation,
                                  });
                                Scaffold.of(context).showSnackBar(SnackBar(
                                    content: Text('Product Updated')));
                              },
                              child: Text(
                                'Edit Product',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                              color: Colors.black,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  side: BorderSide(
                                    color: Colors.white,
                                  )),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ));
      },
    );
  }
}

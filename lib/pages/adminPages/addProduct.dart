import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddProduct extends StatefulWidget {
  @override
  _AddProductState createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  static const Xcolor = Color(0x9FF9B9F9);

  final _keyValue = GlobalKey<FormState>();

  //final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;


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
        title: Text('Add Products'),
      ),
      backgroundColor: _AddProductState.Xcolor,
      body: Container(
        padding: EdgeInsets.only(top: 25),
        child: ListView(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40.1),
              child: Container(
                height: MediaQuery.of(context).size.height,
                child: Form(
                  key: _keyValue,
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
                            _name = _nameController.text;
                            _price = _priceController.text;
                            _description = _descriptionController.text;
                            _category = _categoryController.text;
                            _imageLocation =_imageLocationController.text;

                            if(_keyValue.currentState.validate()){
                              _keyValue.currentState.save();
                              FirebaseFirestore.instance
                                  .collection('Products')
                                  .doc()
                                  .set({
                                'name' : _name,
                                'price' : _price,
                                'description' : _description,
                                'category' : _category,
                                'imageLocation' : _imageLocation,
                              });
                              Scaffold.of(context).showSnackBar(SnackBar(
                                  content: Text('Product Added')));
                            }
                          },
                          child: Text(
                            'Add Product',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          color: Colors.black,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            side: BorderSide(color: Colors.white,)
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

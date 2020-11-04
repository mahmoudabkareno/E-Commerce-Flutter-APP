import 'package:e_commerce/firebaseServices/firebaseAuthentaction.dart';
import 'file:///C:/Users/SmartGate_3/AndroidStudioProjects/e_commerce/lib/providers/modelHub.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _keyValue = GlobalKey<FormState>();
  static const Xcolor = Color(0x9FF9B9F9);

  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  FireBaseAuthentication _authentication = FireBaseAuthentication();

  @override
  void dispose() {
    super.dispose();
    _passwordController.dispose();
    _emailController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _SignUpScreenState.Xcolor,
      body: ListView(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 25.0),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.3,
              child: Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  Image(
                    image: AssetImage('icons/saleicon.png'),
                    color: Colors.black,
                  ),
                  Positioned(
                    bottom: 42,
                    child: Text(
                      'Pay your Needs Now',
                      style: TextStyle(
                          fontFamily: 'Pacifico',
                          fontSize: 19,
                          color: Colors.white),
                    ),
                  )
                ],
              ),
            ),
          ),
          Form(
              key: _keyValue,
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.1),
                    child: Column(
                      children: <Widget>[
                        TextFormField(
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Your Name should be entered';
                            } else {
                              return null;
                            }
                          },
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                  borderRadius: BorderRadius.circular(20.0)),
                              filled: true,
                              fillColor: Colors.white70,
                              prefixIcon: Icon(
                                Icons.person,
                                color: Colors.black,
                              ),
                              hintText: 'Enter Your Name'),
                        ),
                        SizedBox(
                          height: 22,
                        ),
                        TextFormField(
                          controller: _emailController,
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Email should be entered';
                            } else {
                              return null;
                            }
                          },
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                  borderRadius: BorderRadius.circular(20.0)),
                              filled: true,
                              fillColor: Colors.white70,
                              prefixIcon: Icon(
                                Icons.email,
                                color: Colors.black,
                              ),
                              hintText: 'Enter Your Email'),
                        ),
                        SizedBox(
                          height: 22,
                        ),
                        TextFormField(
                          controller: _passwordController,
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Password should be entered';
                            } else {
                              return null;
                            }
                          },
                          obscureText: true,
                          decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                  borderRadius: BorderRadius.circular(20.0)),
                              filled: true,
                              fillColor: Colors.white70,
                              prefixIcon: Icon(
                                Icons.lock,
                                color: Colors.black,
                              ),
                              hintText: 'Enter Your Password'),
                        ),
                        SizedBox(
                          height: 35,
                        ),
                        Builder(
                          builder: (context) => FlatButton(
                            onPressed: () async {
                              if (_keyValue.currentState.validate()) {
                                _keyValue.currentState.save();
                                String email = _emailController.text;
                                String pass = _passwordController.text;
                                try {
                                  await _authentication.registeration(
                                      email, pass);
                                  Navigator.pushNamed(context, '/LoginScreen');
                                } catch (ex) {
                                  Scaffold.of(context).showSnackBar(SnackBar(
                                    content: Text(ex.message),
                                  ));
                                }
                              }
                            },
                            child: Text(
                              'Sign Up',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            color: Colors.black,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                          ),
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        Row(
                          children: <Widget>[
                            Text(
                              'Do have an account?',
                              style:
                                  TextStyle(fontSize: 19, color: Colors.white),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.pushNamed((context), '/LoginScreen');
                              },
                              child: Text(
                                'LogIn',
                                style: TextStyle(
                                    fontSize: 22,
                                    color: Colors.deepPurple,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ))
        ],
      ),
    );
  }
}

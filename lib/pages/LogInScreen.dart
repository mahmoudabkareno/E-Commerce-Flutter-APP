import 'package:e_commerce/providers/adminMode.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:e_commerce/firebaseServices/firebaseAuthentaction.dart';
import 'package:flutter/services.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';
import 'package:e_commerce/providers/modelHub.dart';
import 'dart:io';

import 'package:shared_preferences/shared_preferences.dart';

class LogInScreen extends StatefulWidget {
  @override
  _LogInScreenState createState() => _LogInScreenState();
}

const loginkey = 'login';

class _LogInScreenState extends State<LogInScreen> {
  static const Xcolor = Color(0x9FF9B9F9);

  final _keyValue = GlobalKey<FormState>();

  final adminPass = 'admin123';

  bool logInStatus = false;

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
      backgroundColor: _LogInScreenState.Xcolor,
      body: ModalProgressHUD(
        inAsyncCall: Provider.of<ModelHub>(context).isLoading,
        child: ListView(
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Theme(
                              data: ThemeData(
                                unselectedWidgetColor: Colors.white
                              ),
                              child: Checkbox(
                                  value: logInStatus,
                                  onChanged: (v){
                                    setState(() {
                                      logInStatus = v;
                                    });
                                  }),
                            ),
                            Text(
                                'Remmeber Me LogIn',
                              style: TextStyle(
                                color: Colors.white
                              ),
                            ),
                          ],
                        ),
                        Builder(
                          builder: (context) => FlatButton(
                            onPressed: () async {
                              if(logInStatus == true){
                                keepUserLogIn();
                              }
                              _logInValidation(context);
                            },
                            child: Text(
                              'Log In',
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
                              'Don\'t have an account?',
                              style:
                                  TextStyle(fontSize: 19, color: Colors.white),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.pushNamed((context), '/SignupScreen');
                              },
                              child: Text(
                                'Sign Up',
                                style: TextStyle(
                                    fontSize: 22,
                                    color: Colors.deepPurple,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 19.0,
                        ),
                        Row(
                          children: <Widget>[
                            GestureDetector(
                              onTap: () {
                                Provider.of<AdminMode>(context, listen: false)
                                    .changeIsAdmin(true);
                              },
                              child: Text(
                                'I\'m an admin',
                                style: TextStyle(
                                    fontSize: 15,
                                    color:
                                        Provider.of<AdminMode>(context).isAdmin
                                            ? _LogInScreenState.Xcolor
                                            : Colors.white),
                              ),
                            ),
                            SizedBox(
                              width: 19.0,
                            ),
                            GestureDetector(
                              onTap: () {
                                Provider.of<AdminMode>(context, listen: false)
                                    .changeIsAdmin(false);
                              },
                              child: Text(
                                'I\'m a user',
                                style: TextStyle(
                                    fontSize: 15,
                                    color:
                                        Provider.of<AdminMode>(context).isAdmin
                                            ? Colors.white
                                            : _LogInScreenState.Xcolor),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _logInValidation(BuildContext context) async {

    String _email = _emailController.text;
    String _pass = _passwordController.text;

    final mudelHub = Provider.of<ModelHub>(context, listen: false);
    mudelHub.changIsLoading(true);

    if (_keyValue.currentState.validate()) {
      _keyValue.currentState.save();
      if (Provider.of<AdminMode>(context, listen: false).isAdmin) {
        if (_pass == adminPass) {
          try {
            await _authentication.signIn(_email.trim(), _pass.trim());
            Navigator.pushNamed(context, '/AdminScreen');
            print('add products');
          } catch (e) {
            mudelHub.changIsLoading(false);
            Scaffold.of(context)
                .showSnackBar(SnackBar(content: Text(e.message)));
          }
        } else {
          mudelHub.changIsLoading(false);
          Scaffold.of(context)
              .showSnackBar(SnackBar(content: Text('retry enter password')));
        }
      } else {
        try {
          await _authentication.signIn(_email, _pass);
          Navigator.pushNamed(context, '/HomePage');
        } catch (e) {
          Scaffold.of(context).showSnackBar(SnackBar(content: Text(e.message)));
        }
      }
    }
    mudelHub.changIsLoading(false);
  }
  void keepUserLogIn() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setBool(loginkey, logInStatus);
  }
}

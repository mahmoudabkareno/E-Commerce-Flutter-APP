import 'package:e_commerce/pages/LogInScreen.dart';
import 'package:e_commerce/pages/adminPages/OrdersView.dart';
import 'package:e_commerce/pages/adminPages/addProduct.dart';
import 'package:e_commerce/pages/adminPages/adminScreen.dart';
import 'package:e_commerce/pages/adminPages/editProduct.dart';
import 'package:e_commerce/pages/adminPages/manageProduct.dart';
import 'package:e_commerce/pages/adminPages/orderDetails.dart';
import 'package:e_commerce/pages/adminPages/viewProduct.dart';
import 'package:e_commerce/pages/signupScreen.dart';
import 'package:e_commerce/pages/usersPages/homePage.dart';
import 'package:e_commerce/pages/usersPages/notification.dart';
import 'package:e_commerce/pages/usersPages/productInfo.dart';
import 'package:e_commerce/pages/usersPages/shoppingCartPage.dart';
import 'package:e_commerce/providers/adminMode.dart';
import 'package:e_commerce/providers/modelHub.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}
class MyApp extends StatelessWidget {

  bool isUserLogIn = false;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<SharedPreferences>(
      future: SharedPreferences.getInstance(),
        builder: (context , snapshot){
        if(!snapshot.hasData){
          return MaterialApp(
            home: Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          );
        }else{
          isUserLogIn = snapshot.data.getBool(loginkey) ?? false;
          return MultiProvider(
            providers: [
              ChangeNotifierProvider<ModelHub>(
                  create: (context) => ModelHub()),
              ChangeNotifierProvider<AdminMode>(
                  create: (context) => AdminMode()),
            ],
            child: MaterialApp(

              home: isUserLogIn? HomePage() : LogInScreen(),
              routes: {
                '/LoginScreen' :(context) => LogInScreen(),
                '/SignupScreen' :(context) => SignUpScreen(),
                '/AdminScreen' : (context) => AdminScreen(),
                '/HomePage' : (context) => HomePage(),
                '/AddProduct' : (context) => AddProduct(),
                '/ViewProducts' : (context) => ViewProducts(),
                '/ManageProduct' : (context) => ManageProduct(),
                '/EditProduct' : (context) => EditProduct(),
                '/ProductInfo' : (context) => ProductInfo(),
                '/CartPage' : (context) => CartPage(),
                '/OrderPage' : (context) => OrderPage(),
                '/OrderDetails' : (context) => OrderDetails(),
                '/Notifaction' : (context) => Notifaction(),
              },
            ),
          );
        }
    });
  }
}


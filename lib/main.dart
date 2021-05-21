import 'package:flutter/material.dart';
import 'package:smartshop_manager/screens/welcome_screen.dart';
import 'package:smartshop_manager/screens/login_screen.dart';
import 'package:smartshop_manager/screens/registration_screen.dart';
import 'package:smartshop_manager/screens/products_screen.dart';
import 'package:smartshop_manager/screens/landing_screen.dart';
import 'package:smartshop_manager/screens/inventory_screen.dart';
import 'package:smartshop_manager/screens/employees_screen.dart';
import 'package:smartshop_manager/screens/add_employee.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:smartshop_manager/screens/store_screen.dart';
import 'package:provider/provider.dart';
import 'package:smartshop_manager/models/model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(FlashChat());
}

class FlashChat extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider<Song>(create: (context) => Song())],
      child: MaterialApp(
        theme: ThemeData.dark(),
        initialRoute: WelcomeScreen.id,
        routes: {
          WelcomeScreen.id: (context) => WelcomeScreen(),
          LoginScreen.id: (context) => LoginScreen(),
          RegistrationScreen.id: (context) => RegistrationScreen(),
          ProductScreen.id: (context) => ProductScreen(),
          LandingScreen.id: (context) => LandingScreen(),
          InventoryScreen.id: (context) => InventoryScreen(),
          EmployeesScreen.id: (context) => EmployeesScreen(),
          AddEmployee.id: (context) => AddEmployee(),
          StoreScreen.id: (context) => StoreScreen(),
        },
      ),
    );
  }
}

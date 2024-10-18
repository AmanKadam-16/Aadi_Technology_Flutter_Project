// import 'package:crud_opration/Components/form.dart';
import 'package:crud_opration/Components/CRUD/mainPage.dart';
// import 'package:crud_opration/Components/myform1.dart';
// import 'package:crud_opration/Components/ptactice.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
     title: 'Crud Opration in flutter',
     theme: ThemeData(
      primarySwatch: Colors.purple, 
     ),
      home:  
      // MyForm(),
      // MyForm1(),
      // MyForm1(),
      const Mainpage(),
      // CrudPractice(),

    );
  }
}


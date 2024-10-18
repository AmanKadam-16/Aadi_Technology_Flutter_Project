import 'package:crud_opration/Components/CRUD/mainPage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MyForm1 extends StatefulWidget {
  final int id;

  const MyForm1({Key? key, this.id=0 }) : super(key: key);

  @override
  State<MyForm1> createState() => _MyForm1State();
}

class _MyForm1State extends State<MyForm1> {
  var empNameText = TextEditingController();
  var emailText = TextEditingController();
  String selectedDesignation = 'Admin';
  DateTime selectedDate = DateTime.now();
  String selectedGender = 'Male';
  bool isSubmitting = false;

  @override
  void initState() {
    super.initState();
    if (widget.id > 0) {
      _fetchEmployeeDetails(widget.id); 
    }
  }

  Future<void> _fetchEmployeeDetails(int id) async {
    var url = Uri.parse("https://localhost:44349/GetFormDetailsById");
    var body = json.encode({
      'Id': id > 0 ? id : null 
    });

    try {
      var response = await http.post(url,
          headers: {"Content-Type": "application/json"}, body: body);
      var responseBody = json.decode(response.body);
      print('$responseBody');

      empNameText.text = responseBody['EmpName'] ?? '';
      emailText.text = responseBody['Email'] ?? '';
      selectedDesignation = responseBody['Designation'] ?? 'Admin';
      selectedDate = DateTime.parse(responseBody['BirthDate']); 
      selectedGender = responseBody['Gender'] ?? 'Male';

  
      setState(() {});
    } catch (e) {
     
      print("Error fetching employee details: $e");
    }
  }

  Future<void> _pickDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(1753),
      lastDate: DateTime(9999),
    );

    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate;
      });
    }
  }

  Future<void> _submitForm() async {
    setState(() {
      isSubmitting = true;
    });

    String formattedDate =
        "${selectedDate.year}-${selectedDate.month}-${selectedDate.day}";

    
    var url = widget.id > 0
        ? Uri.parse("https://localhost:44349/UpdateFormDetails")
        : Uri.parse("https://localhost:44349/AddFormDetails");
        
    var body = json.encode({
      'EmpName': empNameText.text,
      'Email': emailText.text,
      'BirthDate': formattedDate,
      'Designation': selectedDesignation,
      'Gender': selectedGender,
      'Id': widget.id > 0 ? widget.id : null 
    });

    try {
      var response = await http.post(url,
          headers: {"Content-Type": "application/json"}, body: body);

      if (response.statusCode == 200) {
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text("Success"),
            content: Text(widget.id > 0 
              ? "Employee details updated successfully!" 
              : "Form submitted successfully!"),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const Mainpage()),
                  );
                },
                child: Text("OK"),
              )
            ],
          ),
        );
      } else {
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text("Error"),
            content: Text("Failed to submit the form. Please try again later."),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(ctx).pop();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => MyForm1(id: widget.id)),
                  );
                },
                child: Text("OK"),
              )
            ],
          ),
        );
      }
    } catch (error) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text("Error"),
          content: Text("An error occurred: $error"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop();
              },
              child: Text("OK"),
            )
          ],
        ),
      );
    }

    setState(() {
      isSubmitting = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Center(
        child: Card(
          elevation: 5,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: Container(
            padding: EdgeInsets.all(20),
            width: 350,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  widget.id > 0 ? 'Edit Employee' : 'Employee Registration Form',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: const Color.fromARGB(255, 121, 152, 255),
                  ),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: empNameText,
                  decoration: InputDecoration(
                    labelText: 'Employee Name',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                SizedBox(height: 15),
                TextField(
                  controller: emailText,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                SizedBox(height: 15),
                DropdownButtonFormField<String>(
                  value: selectedDesignation,
                  decoration: InputDecoration(
                    labelText: 'Designation',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  items: ['Admin', 'Employee'].map((String designation) {
                    return DropdownMenuItem<String>(
                      value: designation,
                      child: Text(designation),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedDesignation = newValue!;
                    });
                  },
                ),
                SizedBox(height: 15),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        "Date of Birth: ${selectedDate.toLocal()}".split(' ')[0],
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: _pickDate,
                      child: Text('Select Date'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 121, 152, 255),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 15),
                DropdownButtonFormField<String>(
                  value: selectedGender,
                  decoration: InputDecoration(
                    labelText: 'Gender',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  items: ['Male', 'Female'].map((String gender) {
                    return DropdownMenuItem<String>(
                      value: gender,
                      child: Text(gender),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedGender = newValue!;
                    });
                  },
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: isSubmitting ? null : _submitForm,
                  child: Text('Submit'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 121, 152, 255),
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

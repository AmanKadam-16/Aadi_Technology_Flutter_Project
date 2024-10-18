import 'dart:convert';
import 'package:crud_opration/Components/Model/postModel.dart';
import 'package:crud_opration/Components/myform1.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Mainpage extends StatefulWidget {
  const Mainpage({super.key});

  @override
  State<Mainpage> createState() => _MainpageState();
}

class _MainpageState extends State<Mainpage> {
  List<FormDetails> formDetailsList = [];

  Future<List<FormDetails>> getFormDetails() async {
    final response =
        await http.post(Uri.parse('https://localhost:44349/GetFormList'));

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body.toString());
      formDetailsList =
          (data as List).map((i) => FormDetails.fromJson(i)).toList();
      return formDetailsList;
    } else {
      throw Exception('Failed to load form details');
    }
  }

  void editForm(int index) {
   
    Navigator.push(
      context,
      MaterialPageRoute(
      
        builder: (context) => MyForm1(id: formDetailsList[index].id),
      ),
    );
  }

  Future<void> deleteForm(int id) async {
    final index = formDetailsList.indexWhere((item) => item.id == id);
    if (index == -1) {
      print('Item not found for id: $id');
      return;
    }

    setState(() {
      formDetailsList.removeAt(index);
    });

    print('Delete form for: $id');
    var url = Uri.parse("https://localhost:44349/DeleteFormDetails");
    var body = json.encode({'ID': id});
    print(url);
    try {
      var response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: body,
      );
      if (response.statusCode == 200) {
        print('Form deleted successfully');
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Success'),
              content: Text('The form has been deleted successfully.'),
              actions: [
                TextButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      } else {
        print('Failed to delete form: ${response.statusCode}');
      }
    } catch (e) {
      print('Error deleting form: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Employee Management'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Employee Information',
              style: TextStyle(fontSize: 30),
            ),
            const SizedBox(
              height: 20,
            ),
            Expanded(
              child: FutureBuilder<List<FormDetails>>(
                future: getFormDetails(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }

                  if (snapshot.hasData) {
                    final formDetailsList = snapshot.data!;
                    return ListView.builder(
                      itemCount: formDetailsList.length,
                      itemBuilder: (context, index) {
                        return Card(
                          elevation: 4,
                          margin: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 15),
                          child: Padding(
                            padding: const EdgeInsets.all(15),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  formDetailsList[index].empName,
                                  style: const TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  'Email: ${formDetailsList[index].email}',
                                  style: const TextStyle(fontSize: 16),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  'Birth Date: ${formDetailsList[index].birthDate}',
                                  style: const TextStyle(fontSize: 16),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  'Designation: ${formDetailsList[index].designation}',
                                  style: const TextStyle(fontSize: 16),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  'Gender: ${formDetailsList[index].gender}',
                                  style: const TextStyle(fontSize: 16),
                                ),
                                const SizedBox(height: 15),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        editForm(index);
                                      },
                                      child: const Icon(Icons.edit,
                                          color:
                                              Color.fromARGB(255, 0, 255, 255),
                                          size: 30),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        deleteForm(formDetailsList[index].id);
                                      },
                                      child: const Icon(Icons.delete,
                                          color:
                                              Color.fromARGB(255, 255, 0, 0)),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }

                  return const Center(child: Text('No data available.'));
                },
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MyForm1()),
                );
              },
              child: const Text('Add Employee'),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

enum Character { Male, Femail }

class MyForm extends StatefulWidget {
  const MyForm({super.key});

  @override
  State<MyForm> createState() => _MyFormState();
}

class _MyFormState extends State<MyForm> {
  var EmpName = TextEditingController();
  var Brithdate = TextEditingController();
  var EmpDesignation = TextEditingController();
  var Email = TextEditingController();
  var MobailNumber = TextEditingController();
  var Gender = TextEditingController();
  String _dropDownValue = 'Admin';
  var _items = ['Admin', 'Emplyee'];

  Character? _character = Character.Male;

  void setCharacter(Character? value) {
    setState(() {
      _character = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Form'),
      ),
      body: Center(
        child: Container(
          width: 500,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: EmpName,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Employee Name: ',
                      prefixIcon: Icon(Icons.person),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: Brithdate,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Brith Date',
                      prefixIcon: Icon(Icons.today),
                    ),
                    readOnly: true,
                    onTap: () {
                      _selectDate();
                    },
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DropdownButton(
                      items: _items.map((String item) {
                        return DropdownMenuItem(
                          value: item,
                          child: Text(item),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          _dropDownValue = newValue!;
                        });
                      },
                      value: _dropDownValue,
                      borderRadius: BorderRadius.circular(10),
                      icon: Icon(Icons.arrow_circle_down_sharp),
                      iconSize: 30,
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: Email,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Email',
                        prefixIcon: Icon(Icons.email_outlined)),
                  ),
                ),
                ListTile(
                  title: const Text('Male'),
                  leading: Radio<Character>(
                    value: Character.Male,
                    groupValue: _character,
                    onChanged: setCharacter,
                  ),
                ),
                ListTile(
                  title: const Text('Femail'),
                  leading: Radio<Character>(
                    value: Character.Femail,
                    groupValue: _character,
                    onChanged: setCharacter,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: MobailNumber,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'PhoneNumber',
                      prefixIcon: Icon(Icons.phone),
                    ),
                  ),
                ),
                ElevatedButton.icon(onPressed: () {}, label: Text('Submite'))
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _selectDate() async {
    DateTime? _picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime(2100));
    if (_picked != null) {
      setState(() {
        Brithdate.text = _picked.toString().split(" ")[0];
      });
    }
  }
}

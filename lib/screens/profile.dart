import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:red_cell/models/user.dart';

import 'package:red_cell/services/database.dart';
import 'package:red_cell/utilities/spinner.dart';

class Profile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text("Profile"),
        centerTitle: true,
      ),
      body: Container(
          padding: EdgeInsets.all(30),
          child: SingleChildScrollView(child: PD())),
    );
  }
}

class PD extends StatefulWidget {
  @override
  _PDState createState() => _PDState();
}

class _PDState extends State<PD> {
  final _formKey = GlobalKey<FormState>();
  final List<String> blood_groups = [
    'A+',
    'B+',
    'O+',
    'AB+',
    'A-',
    'B-',
    'O-',
    'AB-'
  ];
  final List<String> sexes = ['male', 'female', 'third gender'];

  // form values
  String _name, _sex, _group;

  int _age, _phone;

  @override
  Widget build(BuildContext context) {
    User user = Provider.of<User>(context);

    return StreamBuilder<UserData>(
        stream: DatabaseService(uid: user.uid).userData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            UserData userData = snapshot.data;
            return Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  SizedBox(height: 20.0),
                  TextFormField(
                    initialValue: userData.name,
                    decoration: InputDecoration(labelText: "NAME"),
                    validator: (val) =>
                        val.isEmpty ? 'Please enter a name' : null,
                    onChanged: (val) => setState(() => _name = val),
                  ),
                  SizedBox(height: 20.0),
                  TextFormField(
                    initialValue: '${userData.phone}',
                    decoration: InputDecoration(labelText: "PHONE NUMBER"),
                    validator: (val) =>
                        val.isEmpty ? 'Please enter a valid phone' : null,
                    onChanged: (val) => setState(() => _phone = int.parse(val)),
                  ),
                  SizedBox(height: 20.0),
                  TextFormField(
                    initialValue: '${userData.age}',
                    decoration: InputDecoration(labelText: "AGE"),
                    validator: (val) =>
                        val.isEmpty ? 'Please enter a valid age' : null,
                    onChanged: (val) => setState(() => _age = int.parse(val)),
                  ),
                  SizedBox(height: 20.0),
                  DropdownButtonFormField(
                    decoration: InputDecoration(labelText: "SEX"),
                    value: _sex ?? userData.sex,
                    items: sexes.map((g) {
                      return DropdownMenuItem(
                        value: g,
                        child: Text(g),
                      );
                    }).toList(),
                    onChanged: (val) => setState(() => _sex = val),
                  ),
                  SizedBox(height: 20.0),
                  RaisedButton(
                      color: Colors.red,
                      child: Text(
                        'Update',
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () async {
                        if (_formKey.currentState.validate()) {
                          await DatabaseService(uid: user.uid).updateUserData(
                            _name ?? snapshot.data.name,
                            _group ?? snapshot.data.bg,
                            _sex ?? snapshot.data.sex,
                            _age ?? snapshot.data.age,
                            _phone ?? snapshot.data.phone,
                          );
                          Navigator.pop(context);
                        }
                      }),
                ],
              ),
            );
          } else {
            return Loader();
          }
        });
  }
}

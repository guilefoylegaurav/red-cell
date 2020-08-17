import 'package:flutter/material.dart';
import 'package:red_cell/services/auth.dart';
import 'package:red_cell/utilities/spinner.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final List<String> sexes = ['male', 'female', 'third gender'];
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
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  String error = '';
  bool loading = false;
  // text field state
  String email = '';
  String password = '';
  String name = '';
  int phone;
  int age;
  String sex = '';
  String group;
  @override
  Widget build(BuildContext context) {
    return (loading)
        ? Loader()
        : Scaffold(
            appBar: AppBar(
              elevation: 0,
              title: Text("Sign Up"),
              centerTitle: true,
              actions: [],
            ),
            body: Container(
              padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: 20.0),
                      TextFormField(
                        decoration: InputDecoration(
                          hintText: "name",
                        ),
                        validator: (val) =>
                            val.isEmpty ? 'Please enter a name' : null,
                        onChanged: (val) => setState(() => name = val),
                      ),
                      SizedBox(height: 20.0),
                      TextFormField(
                        decoration: InputDecoration(hintText: "phone number"),
                        keyboardType: TextInputType.phone,
                        validator: (val) => (val.length < 10)
                            ? 'Enter a valid phone number'
                            : null,
                        onChanged: (val) =>
                            setState(() => phone = int.parse(val)),
                      ),
                      SizedBox(height: 20.0),
                      TextFormField(
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(hintText: "age"),
                        validator: (val) => (int.tryParse(val) < 18)
                            ? 'You need to be 18+ to sign up'
                            : null,
                        onChanged: (val) =>
                            setState(() => age = int.parse(val)),
                      ),
                      SizedBox(height: 20.0),
                      DropdownButtonFormField(
                        decoration: InputDecoration(hintText: "sex"),
                        items: sexes.map((g) {
                          return DropdownMenuItem(
                            value: g,
                            child: Text(g),
                          );
                        }).toList(),
                        onChanged: (val) => setState(() => sex = val),
                      ),
                      SizedBox(height: 20.0),
                      DropdownButtonFormField(
                        decoration: InputDecoration(hintText: "blood group"),
                        items: blood_groups.map((g) {
                          return DropdownMenuItem(
                            value: g,
                            child: Text(g),
                          );
                        }).toList(),
                        onChanged: (val) => setState(() => group = val),
                      ),
                      SizedBox(height: 20.0),
                      TextFormField(
                        decoration: InputDecoration(hintText: "email"),
                        validator: (val) =>
                            val.isEmpty ? 'Enter an email' : null,
                        onChanged: (val) => setState(() => email = val),
                      ),
                      SizedBox(height: 20.0),
                      TextFormField(
                        decoration: InputDecoration(hintText: "password"),
                        obscureText: true,
                        validator: (val) => (val.length < 6)
                            ? 'Enter a valid password having 6+ characters'
                            : null,
                        onChanged: (val) => setState(() => password = val),
                      ),
                      SizedBox(height: 20.0),
                      RaisedButton(
                          color: Colors.red,
                          child: Text(
                            'Register',
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () async {
                            if (_formKey.currentState.validate()) {
                              setState(() {
                                loading = true;
                              });
                              dynamic result =
                                  await _auth.registerWithEmailAndPassword(
                                      email,
                                      password,
                                      name,
                                      group,
                                      sex,
                                      age,
                                      phone);
                              if (result == null) {
                                setState(() {
                                  loading = false;
                                  error = 'Error! Could not sign up.';
                                });
                              } else {
                                Navigator.pop(context);
                              }
                            }
                          }),
                      SizedBox(height: 12.0),
                      Text(
                        error,
                        style: TextStyle(color: Colors.red, fontSize: 14.0),
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
  }
}

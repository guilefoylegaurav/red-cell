import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:red_cell/models/user.dart';
import 'package:red_cell/screens/home.dart';
import 'package:red_cell/screens/register.dart';
import 'package:red_cell/screens/signin.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    dynamic user = Provider.of<User>(context);
    if (user == null) {
      return SignIn();
    } else {
      return Home();
    }
  }
}

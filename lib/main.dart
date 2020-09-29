/*will be adding notifs soon */
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:red_cell/screens/myRequests.dart';
import 'package:red_cell/screens/profile.dart';
import 'package:red_cell/screens/register.dart';
import 'package:red_cell/screens/wrapper.dart';
import 'package:red_cell/services/auth.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StreamProvider.value(
      value: AuthService().user,
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primaryIconTheme: IconThemeData(color: Colors.red),
          primaryColor: Colors.white,
          primaryTextTheme: TextTheme(
            headline6: TextStyle(color: Colors.red),
          ),
        ),
        routes: {
          "/": (context) => Wrapper(),
          "/register": (context) => SignUp(),
          "/profile": (context) => Profile(),
          "/myreq": (context) => MyPage(),
        },
      ),
    );
  }
}

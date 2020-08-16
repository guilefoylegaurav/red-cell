import 'package:flutter/material.dart';
import 'package:red_cell/services/auth.dart';

class DrawerList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    AuthService auth = AuthService();
    return Column(
      children: [
        Container(
          height: 200,
          width: double.infinity,
          color: Colors.redAccent,
        ),
        ListTile(
          title: Text(
            "About RedCell",
            style: TextStyle(color: Colors.red),
            textAlign: TextAlign.right,
          ),
        ),
        ListTile(
          title: Text(
            "My Requests",
            style: TextStyle(color: Colors.red),
            textAlign: TextAlign.right,
          ),
        ),
        ListTile(
          onTap: () {
            Navigator.of(context).pushNamed("/profile");
          },
          title: Text(
            "My Profile",
            style: TextStyle(color: Colors.red),
            textAlign: TextAlign.right,
          ),
        ),
        ListTile(
          onTap: () async {
            await auth.signOut();
          },
          title: Text(
            "Logout",
            style: TextStyle(color: Colors.red),
            textAlign: TextAlign.right,
          ),
        )
      ],
    );
  }
}

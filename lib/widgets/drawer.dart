import 'package:flutter/material.dart';
import 'package:red_cell/services/auth.dart';

class DrawerList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    AuthService auth = AuthService();
    return Container(
      color: Colors.redAccent,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Stack(children: [
              Image(
                image: AssetImage('assets/logox.jpg'),
              ),
              Positioned(
                  right: 10,
                  bottom: 10,
                  child: Text(
                    "RedCell Inc",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ))
            ]),
            ListTile(
              onTap: () {
                Navigator.of(context).pushNamed("/myreq");
              },
              title: Text(
                "My Requests",
                style: TextStyle(color: Colors.white, fontSize: 18),
                textAlign: TextAlign.right,
              ),
            ),
            ListTile(
              onTap: () {
                Navigator.of(context).pushNamed("/profile");
              },
              title: Text(
                "My Profile",
                style: TextStyle(color: Colors.white, fontSize: 18),
                textAlign: TextAlign.right,
              ),
            ),
            ListTile(
              onTap: () async {
                await auth.signOut();
              },
              title: Text(
                "Logout",
                style: TextStyle(color: Colors.white, fontSize: 18),
                textAlign: TextAlign.right,
              ),
            )
          ],
        ),
      ),
    );
  }
}

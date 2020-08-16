import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:red_cell/models/user.dart';
import 'package:red_cell/services/database.dart';
import 'package:red_cell/widgets/drawer.dart';
import 'package:red_cell/widgets/requestForm.dart';
import 'package:red_cell/widgets/request_tiles.dart';

final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    void _showSettingsPanel() {
      showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          builder: (context) {
            dynamic user = Provider.of<User>(context);
            String uid = user.uid;

            return Container(
              height: MediaQuery.of(context).size.height * 0.25,
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 60.0),
              child: StreamProvider.value(
                  value: DatabaseService(uid: uid).userData,
                  child: SettingsForm(
                    quantity: 2,
                    rid: null,
                  )),
            );
          });
    }

    User user = Provider.of<User>(context);

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text("Requests"),
        centerTitle: true,
        actions: [
          IconButton(
              icon: Icon(
                Icons.add,
                color: Colors.red,
              ),
              onPressed: () {
                _showSettingsPanel();
              })
        ],
      ),
      drawer: Drawer(
        child: DrawerList(),
      ),
      body: Container(
        child: StreamProvider.value(
            value: DatabaseService(uid: user.uid).requests,
            child: RequestTiles()),
      ),
    );
  }
}

import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:red_cell/models/request.dart';
import 'package:red_cell/models/user.dart';
import 'package:red_cell/screens/home.dart';
import 'package:red_cell/services/database.dart';
import 'package:red_cell/widgets/requestForm.dart';

class MyReq extends StatelessWidget {
  BloodRequest request;
  MyReq({this.request});

  @override
  Widget build(BuildContext context) {
    void openPage(int quantity, String rid) {
      showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          builder: (context) {
            dynamic user = Provider.of<User>(context);
            String uid = user.uid;

            return StreamProvider.value(
              value: DatabaseService(uid: uid).userData,
              child: Container(
                  height: MediaQuery.of(context).size.height * 0.25,
                  padding:
                      EdgeInsets.symmetric(vertical: 10.0, horizontal: 60.0),
                  child: SettingsForm(
                    quantity: quantity,
                    rid: rid,
                  )),
            );
          });
    }

    return Dismissible(
      key: UniqueKey(),
      onDismissed: (direction) async {
        await DatabaseService(uid: request.uid).updateRequest(
            request.rid,
            request.name,
            request.bg,
            request.sex,
            request.age,
            request.quantity,
            false,
            request.phone);
        Flushbar(
          // There is also a messageText property for when you want to
          // use a Text widget and not just a simple String
          message: 'Request Archived',
          // Even the button can be styled to your heart's content
          mainButton: FlatButton(
            child: Text(
              'UNDO',
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () async {
              await DatabaseService(uid: request.uid).updateRequest(
                  request.rid,
                  request.name,
                  request.bg,
                  request.sex,
                  request.age,
                  request.quantity,
                  true,
                  request.phone);
            },
          ),
          duration: Duration(seconds: 3),
          // Show it with a cascading operator
        )..show(scaffoldKey.currentContext);
      },
      background: Container(color: Colors.red),
      child: Card(
        color: Colors.white,
        child: ListTile(
          onTap: () {
            openPage(request.quantity, request.rid);
          },
          leading: CircleAvatar(
            child: Text(
              request.bg,
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.redAccent,
          ),
          title: RichText(
            text: TextSpan(
              children: <TextSpan>[
                TextSpan(
                    text: '${request.name}',
                    style: TextStyle(
                        color: Colors.red,
                        fontSize: 18,
                        fontWeight: FontWeight.bold)),
                TextSpan(
                    text: ' requires ${request.quantity} units',
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 18,
                    )),
              ],
            ),
          ),
          subtitle: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                Chip(
                  avatar: CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Icon(Icons.accessibility, color: Colors.red),
                  ),
                  label: Text(request.sex, style: TextStyle(color: Colors.red)),
                  shape: StadiumBorder(side: BorderSide(color: Colors.red)),
                  backgroundColor: Colors.transparent,
                ),
                SizedBox(
                  width: 5,
                ),
                Chip(
                  label: Text(
                    '${request.age} years',
                    style: TextStyle(color: Colors.red),
                  ),
                  shape: StadiumBorder(side: BorderSide(color: Colors.red)),
                  backgroundColor: Colors.transparent,
                ),
                SizedBox(
                  width: 5,
                ),
                FilterChip(
                  shape: StadiumBorder(side: BorderSide(color: Colors.red)),
                  backgroundColor: Colors.transparent,
                  avatar: CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.call,
                      color: Colors.red,
                    ),
                  ),
                  label: Text("${request.phone}",
                      style: TextStyle(color: Colors.red)),
                  onSelected: (value) {},
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

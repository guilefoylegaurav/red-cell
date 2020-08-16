import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:red_cell/models/request.dart';
import 'package:red_cell/models/user.dart';
import 'package:red_cell/services/database.dart';
import 'package:red_cell/utilities/spinner.dart';
import 'package:red_cell/widgets/requestForm.dart';
import '../screens/home.dart';

class RequestTiles extends StatefulWidget {
  @override
  _RequestTilesState createState() => _RequestTilesState();
}

class _RequestTilesState extends State<RequestTiles> {
  @override
  Widget build(BuildContext context) {
    User user = Provider.of<User>(context);
    List<BloodRequest> raw_requests = Provider.of<List<BloodRequest>>(context);
    if (raw_requests == null) {
      return Loading();
    } else {
      List<BloodRequest> requests =
          raw_requests.where((element) => element.status).toList();
      return Container(
        padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
        child: SingleChildScrollView(
          child: Column(
            children: requests.map((e) {
              if (e.uid == user.uid) {
                return MyReq(
                  request: e,
                );
              }
              return OtherReq(
                request: e,
              );
            }).toList(),
          ),
        ),
      );
    }
  }
}

class OtherReq extends StatelessWidget {
  BloodRequest request;
  OtherReq({this.request});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      child: ListTile(
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
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.bold)),
              TextSpan(
                  text: ' requires ${request.quantity} L',
                  style: TextStyle(color: Colors.black, fontSize: 18)),
            ],
          ),
        ),
        subtitle: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Chip(
              avatar: CircleAvatar(
                backgroundColor: Colors.red,
                child: Text(request.sex[0].toUpperCase()),
              ),
              label: Text('sex'),
            ),
            Chip(
              avatar: CircleAvatar(
                backgroundColor: Colors.red,
                child: Text(
                  '${request.age}',
                ),
              ),
              label: Text('age'),
            ),
            FilterChip(
              label: Text("${request.phone}",
                  style: TextStyle(color: Colors.blue[700])),
              onSelected: (value) {},
            )
          ],
        ),
      ),
    );
  }
}

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
                    text: ' requires ${request.quantity} L',
                    style: TextStyle(color: Colors.black, fontSize: 18)),
              ],
            ),
          ),
          subtitle: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Chip(
                avatar: CircleAvatar(
                  backgroundColor: Colors.red,
                  child: Text(request.sex[0].toUpperCase()),
                ),
                label: Text('sex'),
              ),
              Chip(
                avatar: CircleAvatar(
                  backgroundColor: Colors.red,
                  child: Text(
                    '${request.age}',
                  ),
                ),
                label: Text('age'),
              ),
              FilterChip(
                label: Text("${request.phone}",
                    style: TextStyle(color: Colors.blue[700])),
                onSelected: (value) {},
              )
            ],
          ),
        ),
      ),
    );
  }
}

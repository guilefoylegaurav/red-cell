import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:red_cell/models/user.dart';
import 'package:red_cell/services/database.dart';
import 'package:red_cell/utilities/spinner.dart';
import 'package:uuid/uuid.dart';

String randomId() {
  var uuid = Uuid();
  return uuid.v1();
}

class SettingsForm extends StatefulWidget {
  int quantity;
  String rid;
  SettingsForm({this.quantity, this.rid});
  @override
  _SettingsFormState createState() => _SettingsFormState();
}

class _SettingsFormState extends State<SettingsForm> {
  final _formKey = GlobalKey<FormState>();
  int quantity;
  String rid;
  @override
  void initState() {
    quantity = widget.quantity;
    rid = widget.rid;
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    dynamic user = Provider.of<User>(context);
    String uid = user.uid;

    UserData data = Provider.of<UserData>(context);

    return (data == null)
        ? Loader()
        : Form(
            key: _formKey,
            child: StreamProvider.value(
              value: DatabaseService(uid: uid).userData,
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    '${quantity} L',
                    style: TextStyle(
                        fontSize: 20.0,
                        color:
                            Colors.red[(quantity > 9) ? 900 : quantity * 100]),
                  ),
                  SizedBox(height: 10.0),
                  Slider(
                    value: quantity.toDouble(),
                    activeColor:
                        Colors.red[(quantity > 9) ? 900 : quantity * 100],
                    inactiveColor:
                        Colors.red[(quantity > 9) ? 900 : quantity * 100],
                    min: 1.0,
                    max: 10.0,
                    divisions: 10,
                    onChanged: (val) => setState(() => quantity = val.round()),
                  ),
                  SizedBox(height: 10.0),
                  RaisedButton(
                      color: Colors.red,
                      child: Text(
                        'Make Request',
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () async {
                        await DatabaseService(uid: uid).updateRequest(
                            rid ?? randomId(),
                            data.name,
                            data.bg,
                            data.sex,
                            data.age,
                            quantity,
                            true,
                            data.phone);

                        Navigator.of(context).pop();
                      }),
                ],
              ),
            ),
          );
  }
}

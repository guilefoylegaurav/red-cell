import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:red_cell/models/request.dart';
import 'package:red_cell/models/user.dart';
import 'package:red_cell/services/database.dart';
import 'package:red_cell/utilities/spinner.dart';
import 'package:red_cell/widgets/myTiles.dart';

class MyPage extends StatefulWidget {
  @override
  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  @override
  Widget build(BuildContext context) {
    User user = Provider.of<User>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("My Requests"),
        elevation: 0,
        centerTitle: true,
      ),
      body: StreamProvider.value(
        value: DatabaseService(uid: user.uid).requests,
        child: PersonalFeed(),
      ),
    );
  }
}

class PersonalFeed extends StatefulWidget {
  @override
  _PersonalFeedState createState() => _PersonalFeedState();
}

class _PersonalFeedState extends State<PersonalFeed> {
  @override
  Widget build(BuildContext context) {
    User user = Provider.of<User>(context);

    List<BloodRequest> requests = Provider.of<List<BloodRequest>>(context);
    if (requests == null) {
      return Loading();
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                child: Text("Tap to edit. Swipe right to archive."),
              ),
            ],
          ),
          Container(
            child: Column(
              children: requests
                  .where(
                      (element) => (element.uid == user.uid && element.status))
                  .map((e) => MyReq(
                        request: e,
                      ))
                  .toList(),
            ),
          ),
        ],
      );
    }
  }
}

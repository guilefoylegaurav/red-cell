import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:red_cell/models/request.dart';
import 'package:red_cell/models/user.dart';
import 'package:red_cell/services/database.dart';
import 'package:red_cell/utilities/compat.dart';
import 'package:red_cell/utilities/spinner.dart';

import 'myTiles.dart';
import 'otherTiles.dart';

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

      return StreamProvider.value(
        value: DatabaseService(uid: user.uid).userData,
        child: Feed(requests: requests, id: user.uid),
      );
    }
  }
}

class Feed extends StatefulWidget {
  const Feed({
    Key key,
    @required this.requests,
    @required this.id,
  }) : super(key: key);

  final List<BloodRequest> requests;
  final String id;
  @override
  _FeedState createState() => _FeedState();
}

class _FeedState extends State<Feed> {
  List<BloodRequest> filteredRequests;
  bool filter;

  @override
  void initState() {
    filter = false;
    print(filter);

    filteredRequests = widget.requests;
    super.initState();
  }

  bool c = false;
  @override
  Future<Null> _reload() async {
    await Future.delayed(Duration(seconds: 3));

    setState(() {
      filteredRequests = widget.requests;
    });

    return null;
  }

  Widget build(BuildContext context) {
    UserData data = Provider.of<UserData>(context);

    if (data == null) {
      return Loading();
    } else {
      dynamic canDonate = check(data.bg);

      return RefreshIndicator(
        onRefresh: _reload,
        child: Container(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Card(
                  color: Colors.red,
                  child: SwitchListTile(
                      inactiveThumbColor: Colors.redAccent[700],
                      activeColor: Colors.white,
                      title: Text(
                        "Compatible groups only",
                        style: TextStyle(color: Colors.white),
                      ),
                      value: c,
                      onChanged: (newV) {
                        setState(() {
                          c = newV;
                          if (c == true) {
                            filteredRequests = widget.requests.where((element) {
                              return canDonate.contains(element.bg);
                            }).toList();
                          } else {
                            filteredRequests = widget.requests;
                          }
                        });
                      }),
                ),
                Container(
                  child: Column(
                    children: filteredRequests.map((e) {
                      return OtherReq(
                        request: e,
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
  }
}

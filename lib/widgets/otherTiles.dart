import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:red_cell/models/request.dart';

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
                  text: ' urgently needs',
                  style: TextStyle(color: Colors.black, fontSize: 15)),
              TextSpan(
                  text: ' ${request.quantity} units',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold)),
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
    );
  }
}

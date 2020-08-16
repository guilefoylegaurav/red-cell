import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:red_cell/models/request.dart';
import 'package:red_cell/models/user.dart';

class DatabaseService {
  // collection reference
  final CollectionReference blood_requests =
      Firestore.instance.collection('blood_requests');
  final CollectionReference profile_info =
      Firestore.instance.collection('profiles');

  final String uid;
  DatabaseService({this.uid});

  UserData _userDataFromSnapshot(DocumentSnapshot snapshot) {
    return UserData(
      uid: uid,
      name: snapshot.data['name'] ?? "Glenn",
      bg: snapshot.data['bg'] ?? "A+",
      sex: snapshot.data['sex'] ?? "female",
      age: snapshot.data['age'] ?? 18,
      phone: snapshot.data['phone'] ?? 1234567890,
    );
  }

  Future<void> updateUserData(
      String name, String bg, String sex, int age, int phone) async {
    return await profile_info.document(uid).setData(
        {'name': name, 'bg': bg, 'sex': sex, 'age': age, 'phone': phone});
  }

  Future<void> updateRequest(String rid, String name, String bg, String sex,
      int age, int quantity, bool status, int phone) async {
    return await blood_requests.document(rid).setData({
      "uid": uid,
      "name": name,
      "bg": bg,
      "sex": sex,
      "rid": rid,
      "age": age,
      "quantity": quantity,
      "phone": phone,
      "status": status
    });
  }

  Stream<UserData> get userData {
    return profile_info.document(uid).snapshots().map((event) {
      return _userDataFromSnapshot(event);
    });
  }

  Stream<List<BloodRequest>> get requests {
    return blood_requests.snapshots().map(_reqListFromSnapshot);
  }

  List<BloodRequest> _reqListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      //print(doc.data);
      return BloodRequest(
          rid: doc.data['rid'] ?? 'cdv',
          uid: doc.data['uid'] ?? uid,
          name: doc.data['name'] ?? '',
          bg: doc.data['bg'] ?? 'A+',
          sex: doc.data['sex'] ?? 'female',
          age: doc.data['age'] ?? 35,
          quantity: doc.data['quantity'] ?? 1,
          phone: doc.data['phone'] ?? 1234567891,
          status: doc.data['status'] ?? true);
    }).toList();
  }
}

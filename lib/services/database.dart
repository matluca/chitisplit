import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final CollectionReference groups =
      FirebaseFirestore.instance.collection('groups');
  
  Stream<List<String>> groupList() {
    return groups.snapshots().map(_groupsFromSnapshot);
  }
  
  List<String> _groupsFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return (doc.data() as Map)['name'].toString();
    }).toList();
  }
  
  Stream<List<String>> members(String groupName) {
    CollectionReference members = groups.doc(groupName).collection('members');
    return members.snapshots().map(_membersFromSnapshot);
  }

  List<String> _membersFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return (doc.data() as Map)['name'].toString();
    }).toList();
  }
}

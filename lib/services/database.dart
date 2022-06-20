import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:chitisplit/classes/group.dart' as group;
import 'package:fraction/fraction.dart';

class DatabaseService {
  final CollectionReference groups =
      FirebaseFirestore.instance.collection('groups');

  Future<List<String>> groupList() {
    return groups.get().then(_groupsFromSnapshot);
  }

  List<String> _groupsFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return (doc.data() as Map)['name'].toString();
    }).toList();
  }

  Future addMember(String groupName, String name) async {
    Map<String, dynamic> data = {'name': name};
    return await groups.doc(groupName).collection('members').doc(name).set(data);
  }

  Future addTransaction(String groupName, group.Transaction trans) async {
    Map<String, dynamic> transaction = {
      'name': trans.name,
      'date': trans.date,
      'payer': trans.payer,
      'amount': trans.amount,
      'type': trans.type.index,
    };
    Map<String, String> shares = {};
    for (var entry in trans.shares.entries) {
      shares[entry.key] = entry.value.toString();
    }
    transaction['shares'] = shares;
    return await groups.doc(groupName).collection('transactions').add(transaction);
  }
  
  Future<List<String>> members(String groupName) {
    CollectionReference members = groups.doc(groupName).collection('members');
    return members.get().then(_membersFromSnapshot);
  }

  List<String> _membersFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return (doc.data() as Map)['name'].toString();
    }).toList();
  }
  
  Future<List<group.Transaction>> transactions(String groupName) {
    CollectionReference transactions = groups.doc(groupName).collection('transactions');
    return transactions.orderBy('date', descending: true).get().then(_transactionsFromSnapshot);
  }

  List<group.Transaction> _transactionsFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      Map data = doc.data() as Map;
      String name = data['name'].toString();
      DateTime date;
      var timestamp = data['date'];
      date = DateTime.parse(timestamp.toDate().toString());
      String payer = data['payer'].toString();
      int amount = data['amount'] ?? 0;
      group.TransactionType type = group.TransactionType.values[data['type']];
      Map sharesFromDB = data['shares'] as Map;
      Map<String, Fraction> shares = {};
      for (var entry in sharesFromDB.entries) {
        shares[entry.key] = Fraction.fromString(entry.value);
      }
      group.Transaction transaction = group.Transaction(name, date, payer, amount, type);
      transaction.shares = shares;
      return transaction;
    }).toList();
  }
}

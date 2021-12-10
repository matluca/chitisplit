import 'package:fraction/fraction.dart';

enum TransactionType {
  expense,
  transfer,
}

Group group = Group(name: "Gruppo bellissimo", members: <String>["Federico", "Luca", "Stfnzblnnnnnnnnnn"], currentUser: "Federico");

class Group {
  String name;
  String currentUser;
  List<String> members;
  List<Transaction> transactions;

  Group({this.name, this.members, this.currentUser}) {
    transactions = [];
  }

  bool isMember(String name) {
    return this.members.contains(name);
  }

  addMember(String name) {
    if (name == "") {
      throw new ArgumentError("user name cannot be empty");
    }
    if (this.isMember(name)) {
      throw new ArgumentError("user already member of the group");
    }
    this.members.add(name);
  }

  addTransaction(String name, DateTime date, String payer, int amount, Map<String, int> shares, TransactionType type) {
    if (!this.isMember(payer)) {
      throw new ArgumentError(payer + " not member of the group");
    }
    for (var entry in shares.entries) {
      if (!this.isMember(entry.key)) {
        throw new ArgumentError(entry.key + " not member of the group");
      }
      if (entry.value < 0) {
        throw new ArgumentError("negative share not allowed");
      }
    }
    Transaction trans = new Transaction(name: name, date: date, payer: payer, amount: amount, type: type);
    trans.shares = new Map();
    int sumShares;
    for (var v in shares.values) {
      sumShares = sumShares + v;
    }
    for (var share in shares.entries) {
      Fraction fraction = new Fraction(share.value, sumShares);
      trans.shares[share.key] = fraction;
    }
  }

  addExpense(String name, DateTime date, String payer, int amount, Map<String, int> shares) {
    addTransaction(name, date, payer, amount, shares, TransactionType.expense);
  }
  
  addTransfer(String name, DateTime date, String payer, String receiver, int amount) {
    if (name == "") {
      name = "Transfer " + payer + "->" + receiver;
    }
    Map<String, int> shares = new Map();
    shares[receiver] = 1;
    shares[payer] = 0;
    addTransaction(name, date, payer, amount, shares, TransactionType.transfer);
  }

  int totalGroupExpenses() {
    int tot = 0;
    for (var trans in transactions) {
      if (trans.type == TransactionType.expense) {
        tot = tot + trans.amount;
      }
    }
    return tot;
  }

  int totalPayments(String name) {
    int tot = 0;
    for (var trans in transactions) {
      if ((trans.type == TransactionType.expense) && (trans.payer == name)) {
        tot = tot + trans.amount;
      }
    }
    return tot;
  }

  int totalExpenses(String name) {
    Fraction tot = 0.toFraction();
    for (var trans in transactions) {
      if ((trans.type == TransactionType.expense) && (trans.shares.containsKey(name))) {
        tot = tot + trans.amount.toFraction()*trans.shares[name];
      }
    }
    return tot.toDouble().toInt();
  }

  int personalBalance(String name) {
    Fraction tot = 0.toFraction();
    for (var trans in transactions) {
      if (trans.payer == name) {
        tot = tot + trans.amount.toFraction();
      }
      if (trans.shares.containsKey(name)) {
        tot = tot - trans.amount.toFraction()*trans.shares[name];
      }
    }
    return tot.toDouble().toInt();
  }
}

class Transaction {
  String name;
  DateTime date;
  String payer;
  int amount; // amount in cents
  Map<String, Fraction> shares;
  TransactionType type;

  Transaction({this.name, this.date, this.payer, this.amount, this.type});
}

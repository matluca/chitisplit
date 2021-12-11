import 'package:fraction/fraction.dart';

enum TransactionType {
  expense,
  transfer,
}

Group group = Group("Gruppo bellissimo", ["Federico", "Luca", "Stfnzblnnnnnnnnnn"], "Federico");

class Group {
  String name;
  String currentUser;
  List<String> members;
  List<Transaction> transactions;

  Group(this.name, this.members, this.currentUser): transactions=[];

  bool isMember(String name) {
    return members.contains(name);
  }

  addMember(String name) {
    if (name.isEmpty) {
      throw ArgumentError("user name cannot be empty");
    }
    if (isMember(name)) {
      throw ArgumentError("user already member of the group");
    }
    members.add(name);
  }

  addTransaction(String name, DateTime date, String payer, double amount, Map<String, int> shares, TransactionType type) {
    int finalAmount = (amount*100).toInt();
    if (!isMember(payer)) {
      throw ArgumentError(payer + " not member of the group");
    }
    for (var entry in shares.entries) {
      if (!isMember(entry.key)) {
        throw ArgumentError(entry.key + " not member of the group");
      }
      if (entry.value < 0) {
        throw ArgumentError("negative share not allowed");
      }
    }
    Transaction trans = Transaction(name, date, payer, finalAmount, type);
    trans.shares = <String, Fraction>{};
    int sumShares = 0;
    for (var v in shares.values) {
      sumShares = sumShares + v;
    }
    for (var share in shares.entries) {
      Fraction fraction = Fraction(share.value, sumShares);
      trans.shares[share.key] = fraction;
    }
    transactions.add(trans);
  }

  addExpense(String name, DateTime date, String payer, double amount, Map<String, int> shares) {
    addTransaction(name, date, payer, amount, shares, TransactionType.expense);
  }

  addTransfer(String name, DateTime date, String payer, String receiver, double amount) {
    if (name.isEmpty) {
      name = "Transfer " + payer + "->" + receiver;
    }
    Map<String, int> shares = <String, int>{};
    shares[receiver] = 1;
    shares[payer] = 0;
    addTransaction(name, date, payer, amount, shares, TransactionType.transfer);
  }

  double totalGroupExpenses() {
    int tot = 0;
    for (var trans in transactions) {
      if (trans.type == TransactionType.expense) {
        tot = tot + trans.amount;
      }
    }
    return tot/100;
  }

  double totalPayments(String name) {
    int tot = 0;
    for (var trans in transactions) {
      if ((trans.type == TransactionType.expense) && (trans.payer == name)) {
        tot = tot + trans.amount;
      }
    }
    return tot/100;
  }

  double totalExpenses(String name) {
    Fraction tot = 0.toFraction();
    for (var trans in transactions) {
      if ((trans.type == TransactionType.expense) && (trans.shares.containsKey(name))) {
        tot = tot + trans.amount.toFraction()*(trans.shares[name] as Fraction);
      }
    }
    return tot.toDouble().toInt()/100;
  }

  double personalBalance(String name) {
    Fraction tot = 0.toFraction();
    for (var trans in transactions) {
      if (trans.payer == name) {
        tot = tot + trans.amount.toFraction();
      }
      if (trans.shares.containsKey(name)) {
        tot = tot - trans.amount.toFraction()*(trans.shares[name] as Fraction);
      }
    }
    return tot.toDouble().toInt()/100;
  }
}

class Transaction {
  String name;
  DateTime date;
  String payer;
  int amount; // amount in cents
  Map<String, Fraction> shares;
  TransactionType type;

  Transaction(this.name, this.date, this.payer, this.amount, this.type): shares=<String, Fraction>{};
}

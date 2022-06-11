import 'package:chitisplit/services/database.dart';
import 'package:fraction/fraction.dart';

enum TransactionType {
  expense,
  transfer,
}

class Group {
  String name;
  String currentUser;

  Group(this.name, this.currentUser);

  Future<List<String>> members() async {
    return await DatabaseService().members(name);
  }

  Future<List<Transaction>> transactions() async {
    return await DatabaseService().transactions(name);
  }

  Future<bool> isMember(String name) async {
    List<String> members = await DatabaseService().members(this.name);
    return members.contains(name);
  }

  Future addMember(String name) async {
    if (name.isEmpty) {
      throw ArgumentError("user name cannot be empty");
    }
    if (await isMember(name)) {
      throw ArgumentError("user already member of the group");
    }
    await DatabaseService().addMember(this.name, name);
  }

  Future addTransaction(String name, DateTime date, String payer, double amount,
      Map<String, int> shares, TransactionType type) async {
    int finalAmount = (amount * 100).toInt();
    if (!(await isMember(payer))) {
      throw ArgumentError(payer + " not member of the group");
    }
    for (var entry in shares.entries) {
      if (!(await isMember(entry.key))) {
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
    await DatabaseService().addTransaction(this.name, trans);
  }

  Future addExpense(String name, DateTime date, String payer, double amount,
      Map<String, int> shares) async {
    await addTransaction(
        name, date, payer, amount, shares, TransactionType.expense);
  }

  Future addTransfer(String name, DateTime date, String payer, String receiver,
      double amount) async {
    if (name.isEmpty) {
      name = "Transfer " + payer + "->" + receiver;
    }
    Map<String, int> shares = <String, int>{};
    shares[receiver] = 1;
    shares[payer] = 0;
    await addTransaction(
        name, date, payer, amount, shares, TransactionType.transfer);
  }

  Future<double> totalGroupExpenses() async {
    int tot = 0;
    for (var trans in await transactions()) {
      if (trans.type == TransactionType.expense) {
        tot = tot + trans.amount;
      }
    }
    return tot / 100;
  }

  Future<double> totalPayments(String name) async {
    int tot = 0;
    for (var trans in await transactions()) {
      if ((trans.type == TransactionType.expense) && (trans.payer == name)) {
        tot = tot + trans.amount;
      }
    }
    return tot / 100;
  }

  Future<double> totalExpenses(String name) async {
    Fraction tot = 0.toFraction();
    for (var trans in await transactions()) {
      if ((trans.type == TransactionType.expense) &&
          (trans.shares.containsKey(name))) {
        tot =
            tot + trans.amount.toFraction() * (trans.shares[name] as Fraction);
      }
    }
    return tot.toDouble().toInt() / 100;
  }

  Future<double> personalBalance(String name) async {
    Fraction tot = 0.toFraction();
    for (var trans in await transactions()) {
      if (trans.payer == name) {
        tot = tot + trans.amount.toFraction();
      }
      if (trans.shares.containsKey(name)) {
        tot =
            tot - trans.amount.toFraction() * (trans.shares[name] as Fraction);
      }
    }
    return tot.toDouble().toInt() / 100;
  }
}

class Transaction {
  String name;
  DateTime date;
  String payer;
  int amount; // amount in cents
  Map<String, Fraction> shares;
  TransactionType type;

  Transaction(this.name, this.date, this.payer, this.amount, this.type)
      : shares=<String, Fraction>{};
}

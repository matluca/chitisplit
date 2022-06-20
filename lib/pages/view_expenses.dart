import 'package:chitisplit/pages/view_expense.dart';
import 'package:flutter/material.dart';
import 'package:fraction/fraction.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:chitisplit/classes/group.dart';

import '../utils.dart';

class ViewExpenses extends StatefulWidget {
  final Group currentGroup;

  const ViewExpenses(this.currentGroup, {Key? key}) : super(key: key);

  @override
  _ViewExpensesState createState() => _ViewExpensesState();
}

class _ViewExpensesState extends State<ViewExpenses> {
  @override
  Widget build(BuildContext context) {
    return futurify<List<Transaction>>(widget.currentGroup.transactions(),
        (context, snapshot, allTransactions) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Group expenses'),
          centerTitle: true,
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.home, color: Colors.white),
              onPressed: () {
                Navigator.popUntil(context, ModalRoute.withName('/'));
              },
            ),
          ],
        ),
        backgroundColor: Colors.blueAccent,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 40),
          child: SingleChildScrollView(
            child: ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: allTransactions.length,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    title: Text(getExpenseInfo(allTransactions[index])),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ViewExpense(widget.currentGroup, allTransactions[index])),
                      ).then((value) => setState(() {}));
                    },
                  ),
                );
              },
            ),
          ),
        ),
      );
    });
  }
}

String getExpenseInfo(Transaction trans) {
  CurrencyTextInputFormatter _formatter = CurrencyTextInputFormatter(
    symbol: '€ ',
  );
  String amount = _formatter.format(trans.amount.toString());
  String description = trans.name.isEmpty ? "" : " for " + trans.name;
  if (trans.type == TransactionType.expense) {
    return trans.payer + " paid " + amount + description;
  } else {
    String receiver = "";
    for (var m in trans.shares.keys) {
      if (trans.shares[m] == 1.toFraction()) {
        receiver = m;
      }
    }
    return trans.payer + " gave " + amount + " to " + receiver + description;
  }
}

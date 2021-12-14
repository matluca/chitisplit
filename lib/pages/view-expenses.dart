import 'package:flutter/material.dart';
import 'package:fraction/fraction.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:chitisplit/classes/group.dart';

class ViewExpenses extends StatefulWidget {
  final Group currentGroup;

  const ViewExpenses(this.currentGroup, {Key? key}) : super(key: key);

  @override
  _ViewExpensesState createState() => _ViewExpensesState();
}

class _ViewExpensesState extends State<ViewExpenses> {
  @override
  Widget build(BuildContext context) {
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
        child: ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: widget.currentGroup.allTransactions().length,
            itemBuilder: (context, index) {
              return Card(
                child: ListTile(
                  title: Text(getExpenseInfo(widget.currentGroup.allTransactions()[index])),
                  onTap: () {},
                ),
              );
            },
        ),
      ),
    );
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

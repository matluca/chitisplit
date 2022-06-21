import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:chitisplit/classes/group.dart';
import 'package:fraction/fraction.dart';

class ViewExpense extends StatefulWidget {
  final Group currentGroup;
  final Transaction transaction;

  const ViewExpense(this.currentGroup, this.transaction, {Key? key})
      : super(key: key);

  @override
  State<ViewExpense> createState() => _ViewExpenseState();
}

class _ViewExpenseState extends State<ViewExpense> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Expense details'),
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
            child: Column(children: [
          expenseDetails(widget.transaction),
          const SizedBox(height: 10),
          ElevatedButton(
            style: ElevatedButton.styleFrom(primary: Colors.redAccent),
            child: const Text(
              'Delete',
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return confirmationDialog(
                      context, widget.currentGroup, widget.transaction.id);
                },
              );
            },
          ),
        ])),
      ),
    );
  }
}

Column expenseDetails(Transaction transaction) {
  CurrencyTextInputFormatter _formatter = CurrencyTextInputFormatter(
    symbol: '€ ',
  );
  List<Widget> details = [
    Text('Date: ' + formatDate(transaction.date), style: myStyle),
    Text('Description: ' + transaction.name, style: myStyle),
    Text('Amount: ' + _formatter.format(transaction.amount.toString()),
        style: myStyle),
    Text('Payer: ' + transaction.payer, style: myStyle),
    Text('Type: ' + transaction.type.name, style: myStyle),
    Text('Shares: ', style: myStyle),
  ];
  var sortedMembers = transaction.shares.keys.toList()..sort();
  for (var member in sortedMembers) {
    Fraction share = transaction.shares[member]!;
    if (share.numerator != 0) {
      int amount = (share.toDouble() * transaction.amount).round();
      details.add(Text(
          '\t\t\t' + member + ': ' + _formatter.format(amount.toString()),
          style: myStyle));
    }
  }
  return Column(
      crossAxisAlignment: CrossAxisAlignment.start, children: details);
}

String formatDate(DateTime date) {
  return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
}

TextStyle myStyle = const TextStyle(
  fontSize: 25,
);

AlertDialog confirmationDialog(
    BuildContext context, Group group, String? transactionId) {
  return AlertDialog(
    content: const Text("Are you sure you want to delete this transaction?"),
    actions: [
      TextButton(
        child: const Text("Cancel"),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      TextButton(
        child: const Text("OK"),
        onPressed: () async {
          await group.deleteTransaction(transactionId);
          Navigator.pop(context);
          Navigator.pop(context);
        },
      ),
    ],
  );
}

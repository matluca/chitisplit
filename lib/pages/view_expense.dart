import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:chitisplit/classes/group.dart';

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
            onPressed: () async {
              //TODO ask for confirmation before deleting
              await widget.currentGroup.deleteTransaction(widget.transaction.id);
              Navigator.pop(context);
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
  for (var sharesEntry in transaction.shares.entries) {
    if (sharesEntry.value.numerator != 0) {
      int amount = (sharesEntry.value.toDouble() * transaction.amount).round();
      details.add(Text(
          '\t\t\t' +
              sharesEntry.key +
              ': ' +
              _formatter.format(amount.toString()),
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

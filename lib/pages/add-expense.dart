import 'package:flutter/material.dart';
import 'package:chitisplit/classes/group.dart';
import 'package:chitisplit/utils.dart';
import 'package:flutter/services.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:expandable/expandable.dart';

// ignore: must_be_immutable
class AddExpense extends StatefulWidget {
  final Group currentGroup;
  String payer;

  AddExpense(this.currentGroup, {Key? key})
      : payer = currentGroup.currentUser,
        super(key: key);

  @override
  _AddExpenseState createState() => _AddExpenseState();
}

class _AddExpenseState extends State<AddExpense> {
  String _name = "";
  DateTime _date = DateTime.now();
  double _amount = 0;
  final Map<String, int> _shares = {};

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final CurrencyTextInputFormatter _formatter = CurrencyTextInputFormatter(
    symbol: '€ ',
  );

  Widget _buildSelectPayer(List<String> members) {
    return DropdownButton<String>(
      value: widget.payer,
      elevation: 16,
      style: const TextStyle(fontSize: 20, color: Colors.black54),
      underline: Container(
        height: 2,
        color: Colors.black54,
      ),
      onChanged: (String? newValue) {
        widget.payer = newValue ??= widget.currentGroup.currentUser;
        setState(() {});
      },
      items: members.map<DropdownMenuItem<String>>((String value) {
        int l = value.length;
        String text = value;
        if (l > 15) {
          text = value.replaceRange(15, l, "...");
        }
        return DropdownMenuItem<String>(
          value: value,
          child: Text(text),
        );
      }).toList(),
    );
  }

  Future pickDate(BuildContext context) async {
    final initialDate = _date;
    final newDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(DateTime.now().year - 5),
      lastDate: DateTime(DateTime.now().year + 5),
    );
    if (newDate == null) {
      return;
    }
    setState(() {
      _date = newDate;
    });
  }

  Widget _buildSharesFormFields(List<String> members) {
    List<TextFormField> shares = [];
    for (var member in members) {
      TextFormField shareField = TextFormField(
        initialValue: _shares[member].toString(),
        decoration: InputDecoration(labelText: member),
        keyboardType: TextInputType.number,
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.digitsOnly
        ],
        validator: (String? v) {
          int share = (v != null) ? int.parse(v) : 0;
          if (share < 0) {
            return "Share can not be negative";
          }
          return null;
        },
        onSaved: (String? v) {
          _shares[member] = (v != null) ? int.parse(v) : 0;
        },
      );
      shares.add(shareField);
    }
    return Column(
      children: shares,
    );
  }

  @override
  Widget build(BuildContext context) {
    return futurify<List<String>>(widget.currentGroup.members(),
        (context, snapshot, members) {
      for (var member in members) {
        _shares[member] = 1;
      }
      return Scaffold(
        appBar: AppBar(
          title: const Text('Add expense'),
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
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  FormField(
                    builder: (FormFieldState<dynamic> state) {
                      return _buildSelectPayer(members);
                    },
                    onSaved: (String? value) {},
                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: "Amount"),
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[_formatter],
                    validator: (String? v) {
                      double amount =
                          _formatter.getUnformattedValue().toDouble();
                      if (amount <= 0) {
                        return "Amount should be positive";
                      }
                      return null;
                    },
                    onSaved: (String? value) {
                      _amount = _formatter.getUnformattedValue().toDouble();
                    },
                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: "Description"),
                    maxLength: 25,
                    onSaved: (String? value) {
                      _name = value ??= "";
                    },
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                        hintText: "${_date.day}/${_date.month}/${_date.year}"),
                    onTap: () => pickDate(context),
                  ),
                  const SizedBox(height: 20),
                  ExpandablePanel(
                    header:
                        const Text('Shares', style: TextStyle(fontSize: 20)),
                    collapsed: Container(),
                    expanded: _buildSharesFormFields(members),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(primary: Colors.cyan),
                    child: const Text(
                      'Confirm',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () async {
                      if (!(_formKey.currentState!).validate()) {
                        return;
                      }
                      (_formKey.currentState!).save();
                      await widget.currentGroup.addExpense(
                          _name, _date, widget.payer, _amount, _shares);
                      Navigator.popUntil(context, ModalRoute.withName('/'));
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}

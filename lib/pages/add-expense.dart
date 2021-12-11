import 'package:flutter/material.dart';
import 'package:chitisplit/classes/group.dart';
import 'package:flutter/services.dart';

class AddExpense extends StatefulWidget {
  final Group currentGroup;
  String? payer;

  AddExpense(this.currentGroup) : payer = currentGroup.currentUser;

  @override
  _AddExpenseState createState() => _AddExpenseState();
}

class _AddExpenseState extends State<AddExpense> {
  String _name = "";
  DateTime _date = DateTime.now();
  int _amount = 0;
  Map<String, int> _shares = {};

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Widget _buildSelectPayer() {
    return DropdownButton<String>(
      value: widget.payer,
      elevation: 16,
      style: const TextStyle(fontSize: 20, color: Colors.black54),
      underline: Container(
        height: 2,
        color: Colors.black54,
      ),
      onChanged: (String? newValue) {
        widget.payer = newValue;
        setState(() {});
        print(widget.payer);
      },
      items: widget.currentGroup.members
          .map<DropdownMenuItem<String>>((String value) {
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

  @override
  Widget build(BuildContext context) {
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
                    return _buildSelectPayer();
                  },
                  onSaved: (String? value) {},
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: "Amount"),
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  validator: (String? value) {
                    if (value == null) {
                      return "Invalid amount";
                    }
                    int? amount = int.tryParse(value);
                    if (amount == null) {
                      return "Invalid amount";
                    }
                    if (amount <= 0) {
                      return "Amount should be positive";
                    }
                    return null;
                  },
                  onSaved: (String? value) {
                    _amount = int.parse(value as String);
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: "Description"),
                  maxLength: 25,
                  onSaved: (String? value) {
                    _name = value ??= "";
                  },
                ),
                // TextFormField(
                //   decoration: InputDecoration(labelText: "Date"),
                //   keyboardType: TextInputType.datetime,
                //   onSaved: (String value) {
                //     _date = DateTime.parse(value);
                //   },
                // ),
                const SizedBox(height: 10),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(primary: Colors.purple),
                  child: const Text(
                    'Confirm',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    if (!(_formKey.currentState!).validate()) {
                      print("error");
                      return;
                    }
                    print("success");
                    print("payer is ${widget.payer}");

                    (_formKey.currentState!).save();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

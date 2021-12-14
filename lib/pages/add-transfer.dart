import 'package:flutter/material.dart';
import 'package:chitisplit/classes/group.dart';
import 'package:flutter/services.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';

// ignore: must_be_immutable
class AddTransfer extends StatefulWidget {
  final Group currentGroup;
  String payer;
  String receiver;

  AddTransfer(this.currentGroup, {Key? key})
      : payer = currentGroup.currentUser,
        receiver = (currentGroup.members[0] == currentGroup.currentUser)
            ? currentGroup.members[1]
            : currentGroup.members[0], super(key: key);

  @override
  _AddTransferState createState() => _AddTransferState();
}

class _AddTransferState extends State<AddTransfer> {
  String _name = "";
  DateTime _date = DateTime.now();
  double _amount = 0;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final CurrencyTextInputFormatter _formatter = CurrencyTextInputFormatter(
    symbol: '€ ',
  );

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
        widget.payer = newValue ??= widget.currentGroup.currentUser;
        if (widget.receiver == widget.payer) {
          widget.receiver = (widget.currentGroup.members[0] == widget.payer)
              ? widget.currentGroup.members[1]
              : widget.currentGroup.members[0];
        }
        setState(() {});
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

  Widget _buildSelectReceiver() {
    String defaultValue = widget.receiver;
    List<String> allowedReceivers = List<String>.from(widget.currentGroup.members);
    allowedReceivers.removeWhere((element) => (element == widget.payer));

    return DropdownButton<String>(
      value: widget.receiver,
      elevation: 16,
      style: const TextStyle(fontSize: 20, color: Colors.black54),
      underline: Container(
        height: 2,
        color: Colors.black54,
      ),
      onChanged: (String? newValue) {
        widget.receiver = newValue ??= defaultValue;
        setState(() {});
      },
      items: allowedReceivers
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
                FormField(
                  builder: (FormFieldState<dynamic> state) {
                    return _buildSelectReceiver();
                  },
                  onSaved: (String? value) {},
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: "Amount"),
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[_formatter],
                  validator: (String? v) {
                    double amount = _formatter.getUnformattedValue().toDouble();
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
                const SizedBox(height: 10),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(primary: Colors.cyan),
                  child: const Text(
                    'Confirm',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    if (!(_formKey.currentState!).validate()) {
                      return;
                    }
                    (_formKey.currentState!).save();
                    Map<String, int> shares = <String, int>{};
                    for (String person in widget.currentGroup.members) {
                      shares[person] = 1;
                    }
                    widget.currentGroup.addTransfer(
                        _name, _date, widget.payer, widget.receiver, _amount);
                    Navigator.popUntil(context, ModalRoute.withName('/'));
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

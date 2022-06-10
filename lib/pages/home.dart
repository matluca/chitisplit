import 'package:chitisplit/pages/add-expense.dart';
import 'package:chitisplit/pages/add-transfer.dart';
import 'package:chitisplit/pages/add-person-to-group.dart';
import 'package:chitisplit/pages/settings.dart';
import 'package:chitisplit/pages/loading.dart';
import 'package:chitisplit/pages/view-expenses.dart';
import 'package:chitisplit/services/database.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:chitisplit/classes/group.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: DatabaseService().groupList(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<String> groups = snapshot.data as List<String>;
          return StreamBuilder(
              stream: DatabaseService().members('Gruppo1'),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<String> members = snapshot.data as List<String>;
                  return Scaffold(
                    appBar: AppBar(
                      title: const Text('Chi Ti Split'),
                      centerTitle: true,
                      actions: <Widget>[
                        IconButton(
                          icon: const Icon(Icons.settings, color: Colors.white),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Settings(group)),
                            ).then((value) => setState(() {}));
                          },
                        ),
                      ],
                    ),
                    backgroundColor: Colors.blueAccent,
                    body: SingleChildScrollView(
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(groups[0]),
                                Text(members.toString()),
                                GroupOverview(group),
                                const SizedBox(height: 20),
                                Menu(setState, group),
                              ],
                            ),
                          ),
                        )),
                  );
                } else {
                  return const Loading();
                }
              }
          );
        } else {
          return const Loading();
        }
      }
    );
  }
}

class GroupOverview extends StatefulWidget {
  final Group currentGroup;

  const GroupOverview(this.currentGroup, {Key? key}): super(key: key);

  @override
  _GroupOverviewState createState() => _GroupOverviewState();
}

class _GroupOverviewState extends State<GroupOverview> {

  final CurrencyTextInputFormatter _formatter = CurrencyTextInputFormatter(
    symbol: '€ ',
  );

  DataRow _buildPersonalBalanceRow() {
    double balance = widget.currentGroup.personalBalance(widget.currentGroup.currentUser);
    return DataRow(cells: [
      DataCell(Text(balance > 0 ? "You are owed:" : "You owe")),
      DataCell(Text(_formatter.format(balance.abs().toStringAsFixed(2)))),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text("Overview - ${group.currentUser}",
            style: const TextStyle(fontSize: 25)),
        DataTable(
          headingRowHeight: 15,
          columns: [
            DataColumn(label: Container()),
            DataColumn(label: Container()),
          ],
          rows: [
            DataRow(cells: [
              const DataCell(Text("This event cost the group:")),
              DataCell(Text(_formatter.format(widget.currentGroup.totalGroupExpenses().toStringAsFixed(2)))),
            ]),
            DataRow(cells: [
              const DataCell(Text("It cost you:")),
              DataCell(Text(_formatter.format(widget.currentGroup.totalExpenses(widget.currentGroup.currentUser).toStringAsFixed(2)))),
            ]),
            DataRow(cells: [
              const DataCell(Text("You have paid:")),
              DataCell(Text(_formatter.format(widget.currentGroup.totalPayments(widget.currentGroup.currentUser).toStringAsFixed(2)))),
            ]),
            _buildPersonalBalanceRow(),
          ],
        ),
      ],
    );
  }
}

class Menu extends StatelessWidget {
  final void Function(void Function()) setParentState;
  final Group currentGroup;

  const Menu(this.setParentState, this.currentGroup, {Key? key}): super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Card(
        child: ListTile(
          leading: const Icon(MdiIcons.pencilPlus),
          trailing: const Icon(Icons.play_arrow),
          title: const Text('Add expense', textAlign: TextAlign.center),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddExpense(currentGroup)),
            ).then((value) => setParentState(() {}));
          },
        ),
      ),
      Card(
        child: ListTile(
          leading: const Icon(MdiIcons.cashRefund),
          trailing: const Icon(Icons.play_arrow),
          title: const Text('Transfer', textAlign: TextAlign.center),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddTransfer(currentGroup)),
            ).then((value) => setParentState(() {}));
          },
        ),
      ),
      Card(
        child: ListTile(
          leading: const Icon(MdiIcons.formatListBulletedSquare),
          trailing: const Icon(Icons.play_arrow),
          title: const Text('View expenses', textAlign: TextAlign.center),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ViewExpenses(currentGroup)))
                .then((value) => setParentState(() {}));
          },
        ),
      ),
      Card(
        child: ListTile(
          leading: const Icon(Icons.person_add),
          trailing: const Icon(Icons.play_arrow),
          title: const Text('Add person to group', textAlign: TextAlign.center),
          onTap: () {
            Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AddPersonToGroup(currentGroup)))
                .then((value) => setParentState(() {}));
          },
        ),
      ),
    ]);
  }
}

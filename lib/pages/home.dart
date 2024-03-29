import 'package:chitisplit/pages/add-expense.dart';
import 'package:chitisplit/services/database.dart';
import 'package:chitisplit/utils.dart';
import 'package:chitisplit/pages/add-transfer.dart';
import 'package:chitisplit/pages/add-person-to-group.dart';
import 'package:chitisplit/pages/settings.dart';
import 'package:chitisplit/pages/view_expenses.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:chitisplit/classes/group.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class HomeState {
  Group group;

  HomeState(this.group);
}

class _HomeState extends State<Home> {
  HomeState? defaultState;

  @override
  Widget build(BuildContext context) {
    return futurify<HomeState>(setDefaultsFromPreferences(defaultState),
        (context, snapshot, state) {
      return futurify<List<String>>(state.group.members(),
          (context, snapshot, members) {
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
                    MaterialPageRoute(builder: (context) => Settings(state)),
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
                  GroupOverview(state.group),
                  const SizedBox(height: 20),
                  Menu(setState, state.group),
                ],
              ),
            ),
          )),
        );
      });
    });
  }
}

class GroupOverview extends StatefulWidget {
  final Group currentGroup;

  const GroupOverview(this.currentGroup, {Key? key}) : super(key: key);

  @override
  _GroupOverviewState createState() => _GroupOverviewState();
}

class _GroupOverviewState extends State<GroupOverview> {
  final CurrencyTextInputFormatter _formatter = CurrencyTextInputFormatter(
    symbol: '€ ',
  );

  @override
  Widget build(BuildContext context) {
    return futurify<List<Object>>(
        Future.wait([
          widget.currentGroup.totalGroupExpenses(),
          widget.currentGroup.totalExpenses(widget.currentGroup.currentUser),
          widget.currentGroup.totalPayments(widget.currentGroup.currentUser),
          _buildPersonalBalanceRow(widget.currentGroup)
        ]), (context, snapshot, groupFutures) {
      double totalGroupExpenses = groupFutures[0] as double;
      double totalExpenses = groupFutures[1] as double;
      double totalPayments = groupFutures[2] as double;
      DataRow personalBalanceRow = groupFutures[3] as DataRow;
      return Column(
        children: [
          Text(
              "${widget.currentGroup.name} - ${widget.currentGroup.currentUser}",
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
                DataCell(Text(
                    _formatter.format(totalGroupExpenses.toStringAsFixed(2)))),
              ]),
              DataRow(cells: [
                const DataCell(Text("It cost you:")),
                DataCell(
                    Text(_formatter.format(totalExpenses.toStringAsFixed(2)))),
              ]),
              DataRow(cells: [
                const DataCell(Text("You have paid:")),
                DataCell(
                    Text(_formatter.format(totalPayments.toStringAsFixed(2)))),
              ]),
              personalBalanceRow,
            ],
          ),
        ],
      );
    });
  }
}

class Menu extends StatelessWidget {
  final void Function(void Function()) setParentState;
  final Group currentGroup;

  const Menu(this.setParentState, this.currentGroup, {Key? key})
      : super(key: key);

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
              MaterialPageRoute(
                  builder: (context) => AddTransfer(currentGroup)),
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

Future<DataRow> _buildPersonalBalanceRow(Group group) async {
  final CurrencyTextInputFormatter _formatter = CurrencyTextInputFormatter(
    symbol: '€ ',
  );
  double balance = await group.personalBalance(group.currentUser);
  return DataRow(cells: [
    DataCell(Text(balance > 0 ? "You are owed:" : "You owe")),
    DataCell(Text(_formatter.format(balance.abs().toStringAsFixed(2)))),
  ]);
}

Future<HomeState> setDefaultsFromPreferences(HomeState? state) async {
  if (state != null) {
    return state;
  }
  state = HomeState(Group('PROD', 'Federico'));
  List<String> groups = await DatabaseService().groupList();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? prefGroup = prefs.getString('group');
  String? prefUser = prefs.getString('user');
  if ((prefGroup != null) && groups.contains(prefGroup)) {
    state.group.name = prefGroup;
  }
  List<String> members = await state.group.members();
  if ((prefUser != null) && members.contains(prefUser)) {
    state.group.currentUser = prefUser;
  } else {
    state.group.currentUser = members[0];
  }
  return state;
}

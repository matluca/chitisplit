import 'package:chitisplit/pages/add-expense.dart';
import 'package:chitisplit/pages/add-person-to-group.dart';
import 'package:chitisplit/pages/settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:chitisplit/classes/group.dart';
import 'package:chitisplit/pages/add-expense.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chi Ti Split'),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.settings, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Settings(currentGroup: group)),
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
              GroupOverview(currentGroup: group),
              SizedBox(height: 20),
              Menu(setParentState: this.setState, currentGroup: group),
            ],
          ),
        ),
      )),
    );
  }
}

class GroupOverview extends StatefulWidget {
  final Group currentGroup;

  GroupOverview({this.currentGroup});

  @override
  _GroupOverviewState createState() => _GroupOverviewState();
}

class _GroupOverviewState extends State<GroupOverview> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text("Overview - ${group.currentUser}", style: TextStyle(fontSize: 25)),
        DataTable(
          headingRowHeight: 15,
          columns: [
            DataColumn(label: Container()),
            DataColumn(label: Container()),
          ],
          rows: [
            DataRow(cells: [
              DataCell(Text("This event cost the group:")),
              DataCell(Text("€${widget.currentGroup.totalGroupExpenses()}")),
            ]),
            DataRow(cells: [
              DataCell(Text("It cost you:")),
              DataCell(Text(
                  "€${widget.currentGroup.totalExpenses(widget.currentGroup.currentUser)}")),
            ]),
            DataRow(cells: [
              DataCell(Text("You have paid:")),
              DataCell(Text(
                  "€${widget.currentGroup.totalPayments(widget.currentGroup.currentUser)}")),
            ]),
            DataRow(cells: [
              DataCell(Text("You owe:")),
              DataCell(Text(
                  "€${widget.currentGroup.personalBalance(widget.currentGroup.currentUser)}")),
            ]),
          ],
        ),
      ],
    );
  }
}

class Menu extends StatelessWidget {
  final void Function(void Function()) setParentState;
  final Group currentGroup;

  Menu({this.setParentState, this.currentGroup});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Card(
        child: ListTile(
          leading: Icon(MdiIcons.pencilPlus),
          trailing: Icon(Icons.play_arrow),
          title: Text('Add expense', textAlign: TextAlign.center),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => AddExpense(currentGroup: currentGroup)),
            ).then((value) => setParentState(() {}));
          },
        ),
      ),
      Card(
        child: ListTile(
          leading: Icon(MdiIcons.cashRefund),
          trailing: Icon(Icons.play_arrow),
          title: Text('Transfer', textAlign: TextAlign.center),
        ),
      ),
      Card(
        child: ListTile(
          leading: Icon(MdiIcons.formatListBulletedSquare),
          trailing: Icon(Icons.play_arrow),
          title: Text('View expenses', textAlign: TextAlign.center),
        ),
      ),
      Card(
        child: ListTile(
          leading: Icon(Icons.person_add),
          trailing: Icon(Icons.play_arrow),
          title: Text('Add person to group', textAlign: TextAlign.center),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      AddPersonToGroup(currentGroup: currentGroup)),
            ).then((value) => setParentState(() {}));
          },
        ),
      ),
    ]);
  }
}

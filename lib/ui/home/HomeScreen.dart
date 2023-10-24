import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/Providers/AuthProvider.dart';
import 'package:todo_app/ui/DialogUtils.dart';
import 'package:todo_app/ui/home/AddTaskSheet.dart';
import 'package:todo_app/ui/home/settings/SettingsTab.dart';
import 'package:todo_app/ui/home/tasksList/TasksListTab.dart';
import 'package:todo_app/ui/login/LoginScreen.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = 'home';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tasks App'),
        leading: IconButton(
          icon: Icon(Icons.logout),
          onPressed: () {
            logout();
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showAddTaskBottomSheet();
        },
        child: Icon(Icons.add),
        shape: StadiumBorder(side: BorderSide(color: Colors.white, width: 4)),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        notchMargin: 8,
        child: BottomNavigationBar(
          currentIndex: selectedIndex,
          onTap: (index) {
            selectedIndex = index;
            setState(() {});
          },
          backgroundColor: Colors.transparent,
          elevation: 0,
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.list), label: ''),
            BottomNavigationBarItem(icon: Icon(Icons.settings), label: ''),
          ],
        ),
      ),
      body: tabs[selectedIndex],
    );
  }

  int selectedIndex = 0;

  var tabs = [TasksListTab(), SettingsTab()];

  void logout() {
    var authProvider = Provider.of<AuthProvider>(context, listen: false);
    DialogUtils.showMessage(context, 'Are you sure to logout ?',
        positiveActionTitle: 'Yes',
        positiveAction: () {
          authProvider.logout();
          Navigator.pushReplacementNamed(context, LoginScreen.routeName);
        },
        negativeActionTitle: 'Cancel',
        negativeAction: () {
          DialogUtils.hideDialog(context);
        });
  }

  void showAddTaskBottomSheet() {
    showModalBottomSheet(context: context, builder: (buildcontext){
      return AddTaskSheet();
    }
    );
  }
}

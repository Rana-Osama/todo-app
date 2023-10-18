import 'package:flutter/material.dart';
import 'package:todo_app/ui/home/settings/SettingsTab.dart';
import 'package:todo_app/ui/home/tasksList/TasksListTab.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = 'home';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: (){

        },child: Icon(Icons.add),
        shape:StadiumBorder(
          side: BorderSide(
            color: Colors.white,
            width: 4
          )
        ) ,
      ),
      floatingActionButtonLocation:FloatingActionButtonLocation.centerDocked ,
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        notchMargin: 8,
        child: BottomNavigationBar(
          currentIndex: selectedIndex,
          onTap: (index){
            selectedIndex = index;
            setState(() {

            });

          },
          backgroundColor: Colors.transparent,
          elevation: 0,
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.list),label: ''),
            BottomNavigationBarItem(icon: Icon(Icons.settings),label: ''),

          ],
        ),
      ),
      body: tabs[selectedIndex],
    );
  }

  int selectedIndex = 0 ;

  var tabs = [TasksListTab(),SettingsTab()];
}

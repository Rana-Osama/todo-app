import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/database/TasksDao.dart';
import 'package:calendar_timeline/calendar_timeline.dart';
import '../../../Providers/AuthProvider.dart';
import 'TaskWidget.dart';


class TasksListTab extends StatefulWidget {
  @override
  State<TasksListTab> createState() => _TasksListTabState();
}

class _TasksListTabState extends State<TasksListTab> {
  DateTime selectedDay =DateTime.now();

  @override
  Widget build(BuildContext context) {
    var authprovider = Provider.of<AuthProvider>(context);
    return Column(
      children: [
        CalendarTimeline(
            initialDate: DateTime.now(),
            firstDate: DateTime.now().subtract(Duration(days: 365)),
            lastDate: DateTime.now().add(Duration(days: 365)),
            onDateSelected:  (date) => setState(() => selectedDay = date)),
        Expanded(child: StreamBuilder(
            stream: TasksDao.listenForTasks(authprovider.databaseUser?.id??"",selectedDay),
            builder: (context, snapshot) {
              if(snapshot.connectionState == ConnectionState.waiting){
                return Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError){
                return Center(
                  child: Column(
                    children: [
                      Text('Something went wrong '),
                      Text('${snapshot.error}'),
                      ElevatedButton(onPressed: (){}, child: Text('Try again'))
                    ],
                  ),
                );
              }
              var tasksList = snapshot.data;
              return ListView.builder(itemBuilder: (context, index) {
                return TaskWidget(tasksList![index]);
              },itemCount: tasksList?.length??0,);
            }
            ,)
        ),
      ],
    );
  }
}

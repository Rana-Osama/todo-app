import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/database/TasksDao.dart';
import 'package:todo_app/ui/DialogUtils.dart';
import 'package:todo_app/ui/home/HomeScreen.dart';
import 'package:todo_app/ui/home/EditTask.dart';
import '../../../Providers/AuthProvider.dart';
import '../../../database/model/Task.dart';

class TaskWidget extends StatefulWidget {
  Task task ;
  TaskWidget (this.task);



  @override
  State<TaskWidget> createState() => _TaskWidgetState();
}

class _TaskWidgetState extends State<TaskWidget> {
  @override
  Widget build(BuildContext context) {
    var authprovider = Provider.of<AuthProvider>(context);
    return Slidable(
      startActionPane: ActionPane(
        children: [
          SlidableAction(onPressed: (context){
            deleteTask();
          },icon: Icons.delete,backgroundColor: Colors.red,label: 'Delete',
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12),
              bottomLeft: Radius.circular(12)
            ),
          ),
          SlidableAction(onPressed: (context){
            Navigator.push(context, MaterialPageRoute(builder:
                (context) =>EditTask(widget.task),));
          },icon: Icons.edit,
            backgroundColor:Theme.of(context).primaryColor,
            label: 'Edit',

          ),
        ],
        motion: DrawerMotion(),
      ),
      child: Container(
        padding: EdgeInsets.all(8),
        margin: EdgeInsets.symmetric(vertical: 25 , horizontal: 15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18)
        ),
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                  color:widget.task.isDone? Color(0xff61E757) :Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(12)
              ),
              width: 4,
              height: 70,
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.task.title??"",style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color:widget.task.isDone? Color(0xff61E757) :Theme.of(context).primaryColor,
                    ),),
                    SizedBox(height: 5,),
                    Text(widget.task.description??"",
                    style: TextStyle(
                      fontSize: 12
                    ),)
                  ],
                ),
              ),
            ),
            Container(
              child:widget.task.isDone? Text('Done !', style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 22,
                  color :  Color(0xff61E757)
              ),): InkWell(
                    onTap: (){
                    setState(() {
                      widget.task.isDone = true ;
                      TasksDao.editTask(widget.task, authprovider.databaseUser!.id!);
                    });},
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 8 ,horizontal: 24),
                  decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(12)
                  ),
                  child:ImageIcon(
                    AssetImage('assets/images/check.png'),
                    color: Colors.white,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void deleteTask() {
    DialogUtils.showMessage(context, 'Are you sure to delete this task ?',
    positiveActionTitle: 'Yes',
    negativeActionTitle: 'Cancel',
    positiveAction: (){
      deleteTaskFromFirestore();
      Navigator.pop(context);
    },
    negativeAction: (){
      Navigator.pop(context);
    });
  }

  void deleteTaskFromFirestore()  async {
    var authprovider = Provider.of<AuthProvider>(context , listen: false);
     await TasksDao.removeTask(widget.task.id!, authprovider.databaseUser!.id!
    );
  }
}

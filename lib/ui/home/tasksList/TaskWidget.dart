import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/database/TasksDao.dart';
import 'package:todo_app/ui/DialogUtils.dart';
import 'package:todo_app/ui/home/HomeScreen.dart';
import 'package:todo_app/ui/home/EditTask.dart';
import '../../../Providers/AuthProvider.dart';
import '../../../database/model/Task.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TaskWidget extends StatefulWidget {
  Task task;
  TaskWidget(this.task);

  @override
  State<TaskWidget> createState() => _TaskWidgetState();
}

class _TaskWidgetState extends State<TaskWidget> {
  @override
  Widget build(BuildContext context) {
    var authprovider = Provider.of<AuthProvider>(context);
    return Container(
      margin: EdgeInsets.all(15),
      child: Slidable(
        startActionPane: ActionPane(
          children: [
            SlidableAction(
              onPressed: (context) {
                deleteTask();
              },
              icon: Icons.delete,
              backgroundColor: Colors.red,
              label: AppLocalizations.of(context)!.delete,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12),
                  bottomLeft: Radius.circular(12)),
            ),
            SlidableAction(
              onPressed: (context) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditTask(widget.task),
                    ));
              },
              icon: Icons.edit,
              backgroundColor: Theme.of(context).primaryColor,
              label: AppLocalizations.of(context)!.edit,
            ),
          ],
          motion: DrawerMotion(),
        ),
        child: Container(
          padding: EdgeInsets.all(8),
          margin: EdgeInsets.symmetric(horizontal: 15),
          decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.onPrimary,
              borderRadius: BorderRadius.circular(18)),
          child: Row(
            children: [
              Container(
                decoration: BoxDecoration(
                    color: widget.task.isDone
                        ? Theme.of(context).colorScheme.tertiary
                        : Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(12)),
                width: 4,
                height: 70,
              ),
              Expanded(
                flex: 3,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.task.title ?? "",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: widget.task.isDone
                              ? Theme.of(context).colorScheme.tertiary
                              : Theme.of(context).primaryColor,
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        widget.task.description ?? "",
                        style: TextStyle(fontSize: 12),
                      )
                    ],
                  ),
                ),
              ),
              Container(
                child: widget.task.isDone
                    ? Text(
                        AppLocalizations.of(context)!.done,
                        style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 22,
                            color: Theme.of(context).colorScheme.tertiary),
                      )
                    : InkWell(
                        onTap: () {
                          setState(() {
                            widget.task.isDone = true;
                            TasksDao.editTask(
                                widget.task, authprovider.databaseUser!.id!);
                          });
                        },
                        child: Container(
                          padding:
                              EdgeInsets.symmetric(vertical: 8, horizontal: 24),
                          decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor,
                              borderRadius: BorderRadius.circular(12)),
                          child: ImageIcon(
                            AssetImage('assets/images/check.png'),
                            color: Colors.white,
                          ),
                        ),
                      ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void deleteTask() {
    DialogUtils.showMessage(
        context, AppLocalizations.of(context)!.delete_assurance,
        positiveActionTitle: AppLocalizations.of(context)!.yes,
        negativeActionTitle: AppLocalizations.of(context)!.cancel,
        positiveAction: () {
      deleteTaskFromFirestore();
      Navigator.pop(context);
    }, negativeAction: () {
      Navigator.pop(context);
    });
  }

  void deleteTaskFromFirestore() async {
    var authprovider = Provider.of<AuthProvider>(context, listen: false);
    await TasksDao.removeTask(widget.task.id!, authprovider.databaseUser!.id!);
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/database/TasksDao.dart';
import 'package:todo_app/ui/DialogUtils.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../Providers/AuthProvider.dart';
import '../../database/model/Task.dart';
import '../common/CustomFormField.dart';

class EditTask extends StatefulWidget {
  Task task;
  EditTask(this.task);

  @override
  State<EditTask> createState() => _EditTaskState();
}

class _EditTaskState extends State<EditTask> {
  TextEditingController title = TextEditingController();
  TextEditingController description = TextEditingController();
  bool showDateError = false;
  DateTime? selectedDate = null;

  @override
  void initState() {
    title.text = widget.task.title!;
    description.text = widget.task.description!;
    selectedDate = widget.task.dateTime?.toDate();
  }

  @override
  Widget build(BuildContext context) {
    var authprovider = Provider.of<AuthProvider>(context);
    return Scaffold(
        appBar: AppBar(
          title: Center(child: Text('Todo App         ')),
          titleTextStyle: Theme.of(context).textTheme.headlineSmall,
          backgroundColor: Theme.of(context).primaryColor,
        ),
        body: SingleChildScrollView(
          child: Card(
            margin: EdgeInsets.symmetric(vertical: 100, horizontal: 30),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                      child: Text(
                    AppLocalizations.of(context)!.edit_task,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(fontWeight: FontWeight.bold),
                  )),
                  SizedBox(
                    height: 20,
                  ),
                  CustomFormField(
                    hint: AppLocalizations.of(context)!.title,
                    validator: (text) {
                      if (text == null || text.trim().isEmpty) {
                        return AppLocalizations.of(context)!.title_error;
                      }
                      return null;
                    },
                    controller: title,
                  ),
                  CustomFormField(
                    hint: AppLocalizations.of(context)!.description,
                    lines: 4,
                    validator: (text) {
                      if (text == null || text.trim().isEmpty) {
                        return AppLocalizations.of(context)!.description_error;
                      }
                      return null;
                    },
                    controller: description,
                  ),
                  GestureDetector(
                    child: InkWell(
                      onTap: () {
                        showTaskDatePicker();
                      },
                      child: Container(
                          padding: EdgeInsets.symmetric(vertical: 18),
                          decoration: BoxDecoration(
                            border: Border(
                                bottom:
                                    BorderSide(width: 1, color: Colors.grey)),
                          ),
                          child: Text(
                              selectedDate == null
                                  ? AppLocalizations.of(context)!.date
                                  : '${selectedDate?.day}/'
                                      '${selectedDate?.month}/ ${selectedDate?.year}',
                              style: Theme.of(context).textTheme.bodyMedium)),
                    ),
                  ),
                  Visibility(
                    visible: showDateError,
                    child: Text(
                      AppLocalizations.of(context)!.select_task_date,
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.error,
                          fontSize: 12),
                    ),
                  ),
                  SizedBox(
                    height: 120,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Task task = Task(
                          title: title.text,
                          description: description.text,
                          dateTime: Timestamp.fromMillisecondsSinceEpoch(
                              selectedDate!.millisecondsSinceEpoch),
                          id: widget.task.id,
                          isDone: widget.task.isDone);
                      TasksDao.editTask(task, authprovider.databaseUser!.id!);
                      Navigator.pop(context);
                    },
                    child: Text(AppLocalizations.of(context)!.save_changes),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor),
                  ),
                  SizedBox(
                    height: 90,
                  )
                ],
              ),
            ),
          ),
        ));
  }

  void showTaskDatePicker() async {
    var date = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: selectedDate ?? DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 365)),
    );

    setState(() {
      selectedDate = date!;
      if (selectedDate != null) {
        showDateError = false;
      }
    });
  }
}

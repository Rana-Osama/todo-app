import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/Providers/AuthProvider.dart';
import 'package:todo_app/database/TasksDao.dart';
import 'package:todo_app/ui/DialogUtils.dart';
import 'package:todo_app/ui/common/CustomFormField.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../database/model/Task.dart';

class AddTaskSheet extends StatefulWidget {
  @override
  State<AddTaskSheet> createState() => _AddTaskSheetState();
}

class _AddTaskSheetState extends State<AddTaskSheet> {
  var formKey = GlobalKey<FormState>();

  TextEditingController title = TextEditingController();
  TextEditingController description = TextEditingController();

  bool showDateError = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Text(AppLocalizations.of(context)!.add_new_task,
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .copyWith(fontWeight: FontWeight.bold)),
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
            InkWell(
              onTap: () {
                showTaskDatePicker();
              },
              child: Container(
                  padding: EdgeInsets.symmetric(vertical: 18),
                  decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(width: 1, color: Colors.grey))),
                  child: Text(
                    selectedDate == null
                        ? AppLocalizations.of(context)!.date
                        : '${selectedDate?.day}/'
                            '${selectedDate?.month}/ ${selectedDate?.year}',
                    style: Theme.of(context).textTheme.bodyMedium,
                  )),
            ),
            Visibility(
              visible: showDateError,
              child: Text(
                AppLocalizations.of(context)!.select_task_date,
                style: TextStyle(
                    color: Theme.of(context).colorScheme.error, fontSize: 12),
              ),
            ),
            SizedBox(
              height: 40,
            ),
            ElevatedButton(
                onPressed: () {
                  addTask();
                },
                child: Text(AppLocalizations.of(context)!.add_task),
                style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor))
          ],
        ),
      ),
    );
  }

  void addTask() async {
    if (!isValidForm()) {
      return;
    }
    Task task = Task(
      title: title.text,
      description: description.text,
      dateTime: Timestamp.fromMillisecondsSinceEpoch(
          selectedDate!.millisecondsSinceEpoch),
    );
    var authprovider = Provider.of<AuthProvider>(context, listen: false);
    DialogUtils.showLoading(
        context, AppLocalizations.of(context)!.creating_task);
    await TasksDao.createTask(task, authprovider.databaseUser!.id!);
    DialogUtils.hideDialog(context);
    DialogUtils.showMessage(
        context, AppLocalizations.of(context)!.task_created_successfully,
        isCancelable: false,
        positiveActionTitle: AppLocalizations.of(context)!.ok,
        positiveAction: () {
      Navigator.pop(context);
    });
  }

  DateTime? selectedDate = null;

  void showTaskDatePicker() async {
    var date = await showDatePicker(
        context: context,
        initialDate: selectedDate ?? DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime.now().add(Duration(days: 365)));
    setState(() {
      selectedDate = date;
      if (selectedDate != null) {
        showDateError = false;
      }
    });
  }

  bool isValidForm() {
    bool isValid = true;
    if (formKey.currentState?.validate() == false) {
      isValid = false;
    }
    if (selectedDate == null) {
      setState(() {
        showDateError = true;
      });
      isValid = false;
    }
    return isValid;
  }
}

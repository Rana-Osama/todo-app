import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/database/TasksDao.dart';
import 'package:todo_app/ui/DialogUtils.dart';

import '../../Providers/AuthProvider.dart';
import '../../database/model/Task.dart';
import '../common/CustomFormField.dart';

class EditTask extends StatefulWidget {
  Task task ;
  EditTask(this.task);



  @override
  State<EditTask> createState() => _EditTaskState();

}

class _EditTaskState extends State<EditTask> {

  TextEditingController title = TextEditingController();
  TextEditingController description = TextEditingController();
  bool showDateError = false ;
  DateTime ? selectedDate = null ;


  @override
  void initState() {
    title.text = widget.task.title!;
    description.text = widget.task.description!;
    selectedDate = widget.task.dateTime?.toDate();


  }

  @override
  Widget build(BuildContext context) {
    var authprovider = Provider.of<AuthProvider>(context );
    return Scaffold(
        appBar: AppBar(
          title: Center(child: Text('Todo App         ')),
          titleTextStyle: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold
          ),
          backgroundColor: Theme.of(context).primaryColor,
        ),
        body: SingleChildScrollView(
          child: Card(
            margin: EdgeInsets.symmetric(vertical: 100 , horizontal: 30),
            elevation: 0,
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(child: Text('Edit Task', style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w700,
                    fontSize: 18
                  ),)),

                  SizedBox(height:20 ,),


                  CustomFormField(hint: 'Title',validator: (text){
                    if (text == null || text.trim().isEmpty){
                      return 'Enter task title';
                    }
                    return null;
                  }, controller: title,
                  ),


                  CustomFormField(hint:'Description',lines: 4,validator: (text){
                    if (text == null || text.trim().isEmpty){
                      return 'Enter task description';
                    }
                    return null;
                  }, controller: description,
                  ),


                  GestureDetector(
                    child: InkWell(
                      onTap: (){
                        showTaskDatePicker();
                      },
                      child: Container(
                          padding: EdgeInsets.symmetric(vertical: 18),
                          decoration: BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(
                                      width: 1,
                                      color: Colors.grey
                                  )
                              ),
                          ),
                          child:  Text(selectedDate == null ? 'Date': '${selectedDate?.day}/'
                              '${selectedDate?.month}/ ${selectedDate?.year}')
                      ),
                    ),
                  ),
                  Visibility(
                    visible: showDateError,
                    child: Text('Select task date',style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                        fontSize: 12
                    ),),
                  ),
                  SizedBox(height: 120,),
                  ElevatedButton(onPressed: (){
                    Task task = Task(title: title.text, description: description.text,
                    dateTime: Timestamp.fromMillisecondsSinceEpoch(
                        selectedDate!.millisecondsSinceEpoch),
                    id: widget.task.id,
                    isDone: widget.task.isDone);
                    TasksDao.editTask(task,authprovider.databaseUser!.id!);
                    Navigator.pop(context);
                  }, child: Text('Save Changes'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor
                  ),),
                  SizedBox(height: 90,)
                ],
              ),
            ),
          ),
        )



    );
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

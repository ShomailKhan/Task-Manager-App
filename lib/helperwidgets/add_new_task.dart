// ignore_for_file: avoid_print, use_build_context_synchronously, unused_local_variable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:todo_list_app/helperwidgets/tasks_provider.dart';
import 'package:todo_list_app/helperwidgets/textfields.dart';
import 'package:todo_list_app/utils/components.dart';

class AddNewTask extends StatefulWidget {
  const AddNewTask({super.key});

  @override
  State<AddNewTask> createState() => _AddNewTaskState();
}

class _AddNewTaskState extends State<AddNewTask> {
  late DateTime selectedDate;
  late TimeOfDay selectedTime;

  final titleCtrl = TextEditingController();
  final notesCtrl = TextEditingController();

  String selectedCategory = 'work';
  final List<String> categories = [
    'work',
    'personal',
    'shopping',
    'healthcare',
  ];

  @override
  void dispose() {
    titleCtrl.dispose();
    notesCtrl.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    selectedDate = DateTime.now();
    selectedTime = TimeOfDay.now();
  }

  void _pickDate() async {
    try {
      DateTime? date = await showDatePicker(
        context: context,
        currentDate: DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime(2100),
      );
      if (date != null) {
        setState(() {
          selectedDate = date;
        });
      }
    } catch (e) {
      print(e);
    }
  }

  void _pickTime() async {
    try {
      TimeOfDay? time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );
      if (time != null) {
        setState(() {
          selectedTime = time;
        });
      }
    } catch (e) {
      print(e);
    }
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'work':
        return Icons.work;
      case 'personal':
        return Icons.person;
      case 'shopping':
        return Icons.shopping_bag;
      case 'healthcare':
        return Icons.health_and_safety;
      default:
        return Icons.category;
    }
  }

  Future<void> uploadDataToFireStore() async {
    final newTaskData = {
      'creatorId': FirebaseAuth.instance.currentUser!.uid,
      'title': titleCtrl.text,
      'catagory': selectedCategory,
      'time': selectedTime.format(context),
      'notes': notesCtrl.text,
      'status': 'pending',
      'date': selectedDate,
    };
    try {
      final document = await FirebaseFirestore.instance
          .collection('tasks')
          .add(newTaskData);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('task added successfully')));
      titleCtrl.clear();
      notesCtrl.clear();
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  @override
  Widget build(BuildContext context) {
    final headingTempelate = Theme.of(context).textTheme.titleSmall!.copyWith(
      color: Color.fromRGBO(33, 150, 243, 1.0),
      fontWeight: FontWeight.bold,
    );
    return Scaffold(
      appBar: AppBar(
        foregroundColor: primaryColor,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Add task', style: headingTempelate),
            GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'cancel',
                style: Theme.of(
                  context,
                ).textTheme.titleSmall!.copyWith(color: Colors.red),
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Textfields(
              hintText: 'add your task title',
              controllerType: titleCtrl,
            ),
            SizedBox(height: 20),
            Text('Category', style: headingTempelate),
            SizedBox(height: 20),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(10),
              ),
              child: DropdownButton<String>(
                value: selectedCategory,
                isExpanded: true,
                underline: SizedBox(),
                items: categories.map((String category) {
                  return DropdownMenuItem<String>(
                    value: category,
                    child: Row(
                      children: [
                        Icon(
                          _getCategoryIcon(category),
                          color: Color.fromRGBO(33, 150, 243, 1.0),
                        ),
                        SizedBox(width: 10),
                        Text(
                          category,
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedCategory = newValue!;
                  });
                },
              ),
            ),
            SizedBox(height: 20),
            Text('Date', style: headingTempelate),
            SizedBox(height: 20),
            Row(
              children: [
                IconButton(
                  onPressed: () {
                    _pickDate();
                  },
                  icon: Icon(
                    Icons.calendar_month_outlined,
                    color: Colors.redAccent,
                  ),
                ),
                Text(
                  '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall!.copyWith(color: Colors.grey),
                ),
              ],
            ),
            Row(
              children: [
                IconButton(
                  onPressed: () {
                    _pickTime();
                  },
                  icon: Icon(Icons.watch, color: Colors.amberAccent),
                ),
                Text(
                  selectedTime.format(context),
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall!.copyWith(color: Colors.grey),
                ),
              ],
            ),
            SizedBox(height: 20),
            Text('Notes', style: headingTempelate),
            SizedBox(height: 20),
            Textfields(
              hintText: 'add some notes to your task',
              controllerType: notesCtrl,
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.1),
            ElevatedButton(
              onPressed: () {
                uploadDataToFireStore();
                // final newTaskData = {
                //   'title': titleCtrl.text,
                //   'catagory': selectedCategory,
                //   'time': selectedTime.format(context),
                //   'notes': notesCtrl.text,
                //   'status': 'pending',
                //   'date': selectedDate,
                // };
                // try {
                //   setState(() {
                //     Provider.of<TasksProvider>(
                //       context,
                //       listen: false,
                //     ).addTask(newTaskData);
                //     ScaffoldMessenger.of(context).showSnackBar(
                //       SnackBar(content: Text('task added successfully')),
                //     );
                //   });
                // } catch (e) {
                //   ScaffoldMessenger.of(
                //     context,
                //   ).showSnackBar(SnackBar(content: Text(e.toString())));
                // }
              },
              style: ElevatedButton.styleFrom(
                fixedSize: Size(MediaQuery.of(context).size.width * 1, 50),
                backgroundColor: Color.fromRGBO(33, 150, 243, 1.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                'Add',
                style: Theme.of(
                  context,
                ).textTheme.titleSmall!.copyWith(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

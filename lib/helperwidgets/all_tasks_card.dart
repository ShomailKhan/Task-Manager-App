// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:todo_list_app/helperwidgets/task_information.dart';

class AllTasksCard extends StatelessWidget {
  const AllTasksCard({
    super.key,
    required this.taskTitle,
    required this.taskTime,
    required this.taskDate,
    required this.taskItem,
    required this.taskStatus,
    required this.documentId, // Add this parameter
  });
  final String taskTitle;
  final String taskTime;
  final String taskDate;
  final String taskStatus;
  final String documentId; // Add this field

  final Map<String, dynamic> taskItem;

  @override
  Widget build(BuildContext context) {
    final headingTempelate = Theme.of(context).textTheme.titleSmall!.copyWith(
      color: Color.fromRGBO(33, 150, 243, 1.0),
      fontWeight: FontWeight.bold,
    );
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.16,
        width: MediaQuery.of(context).size.width * 1,
        
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Color.fromRGBO(245, 247, 249, 1),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Color.fromRGBO(222, 235, 249, 1)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            TaskInformation(taskItem: taskItem),
                      ),
                    );
                  },
                  child: Text(taskDate, style: headingTempelate),
                ),
                GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text('Delete Task?'),
                          content: Text('are you sure to delete this task ?'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text(
                                'no',
                                style: Theme.of(context).textTheme.titleSmall!
                                    .copyWith(color: Colors.red),
                              ),
                            ),
                            TextButton(
                              onPressed: () async {
                                try {
                                  await FirebaseFirestore.instance
                                      .collection('tasks')
                                      .doc(documentId)
                                      .delete();
                                  Navigator.of(context).pop();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Task deleted successfully'),
                                      backgroundColor: Colors.green,
                                    ),
                                  );
                                } catch (e) {
                                  Navigator.of(context).pop();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Error deleting task: $e'),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                }
                              },
                              child: Text(
                                'yes',
                                style: Theme.of(context).textTheme.titleSmall!
                                    .copyWith(color: Colors.green),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: Text(
                    'delete',
                    style: Theme.of(context).textTheme.titleSmall!.copyWith(
                      color: Colors.redAccent,
                      fontSize: 15,
                    ),
                  ),
                ),
              ],
            ),
            Text(
              taskTime,
              style: Theme.of(context).textTheme.titleSmall!.copyWith(
                fontSize: 15,
                color: Colors.grey,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(taskTitle, style: Theme.of(context).textTheme.titleSmall),
                Text(
                  taskStatus,
                  style: Theme.of(context).textTheme.titleSmall!.copyWith(
                    color: taskStatus == 'done'
                        ? Colors.blue
                        : taskStatus == 'overdue'
                        ? Colors.red
                        : Colors.grey,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

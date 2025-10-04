import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todo_list_app/helperwidgets/all_tasks_card.dart';

class AllTasksScreen extends StatelessWidget {
  const AllTasksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final primaryColor = Color.fromRGBO(33, 150, 243, 1.0);
    final headingTempelate = Theme.of(context).textTheme.titleSmall!.copyWith(
      color: Colors.white,
      fontWeight: FontWeight.bold,
    );
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          centerTitle: false,
          title: Row(children: [Text('Your Tasks', style: headingTempelate)]),
          bottom: TabBar(
            unselectedLabelColor: Colors.white,
            indicatorColor: Colors.white,
            labelStyle: headingTempelate,
            tabs: [
              Tab(text: 'All Tasks'),
              Tab(text: 'Done'),
              Tab(text: 'Overdue'),
            ],
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(15),
          child: TabBarView(
            children: [
              // All Tasks Tab
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('tasks')
                    .where('creatorId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator(color: primaryColor));
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(
                      child: Text(
                        'No tasks found',
                        style: TextStyle(color: Colors.grey, fontSize: 16),
                      ),
                    );
                  }
                  return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      var taskItem = snapshot.data!.docs[index];
                      var taskData = taskItem.data() as Map<String, dynamic>;
                      return AllTasksCard(
                        taskTitle: taskData['title'] ?? 'No Title',
                        taskTime: taskData['time'] ?? 'No Time',
                        taskDate: _formatDate(taskData['date']),
                        taskItem: taskData,
                        taskStatus: taskData['status'] ?? 'pending',
                        documentId: taskItem.id,
                      );
                    },
                  );
                },
              ),
              // Done Tasks Tab
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('tasks')
                    .where('creatorId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                    .where('status', isEqualTo: 'done')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator(color: primaryColor));
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(
                      child: Text(
                        'No completed tasks',
                        style: TextStyle(color: Colors.grey, fontSize: 16),
                      ),
                    );
                  }
                  return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      var taskItem = snapshot.data!.docs[index];
                      var taskData = taskItem.data() as Map<String, dynamic>;
                      return AllTasksCard(
                        taskTitle: taskData['title'] ?? 'No Title',
                        taskTime: taskData['time'] ?? 'No Time',
                        taskDate: _formatDate(taskData['date']),
                        taskItem: taskData,
                        taskStatus: taskData['status'] ?? 'pending',
                        documentId: taskItem.id,
                      );
                    },
                  );
                },
              ),
              // Overdue Tasks Tab
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('tasks')
                    .where('creatorId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                    .where('status', isEqualTo: 'pending')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator(color: primaryColor));
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(
                      child: Text(
                        'No overdue tasks',
                        style: TextStyle(color: Colors.grey, fontSize: 16),
                      ),
                    );
                  }
                  
                  // Filter overdue tasks from pending tasks
                  final now = DateTime.now();
                  final overdueDocs = snapshot.data!.docs.where((doc) {
                    var taskData = doc.data() as Map<String, dynamic>;
                    var dateValue = taskData['date'];
                    if (dateValue != null && dateValue is Timestamp) {
                      DateTime taskDate = dateValue.toDate();
                      return taskDate.isBefore(DateTime(now.year, now.month, now.day));
                    }
                    return false;
                  }).toList();
                  
                  if (overdueDocs.isEmpty) {
                    return Center(
                      child: Text(
                        'No overdue tasks',
                        style: TextStyle(color: Colors.grey, fontSize: 16),
                      ),
                    );
                  }
                  
                  return ListView.builder(
                    itemCount: overdueDocs.length,
                    itemBuilder: (context, index) {
                      var taskItem = overdueDocs[index];
                      var taskData = taskItem.data() as Map<String, dynamic>;
                      return AllTasksCard(
                        taskTitle: taskData['title'] ?? 'No Title',
                        taskTime: taskData['time'] ?? 'No Time',
                        taskDate: _formatDate(taskData['date']),
                        taskItem: taskData,
                        taskStatus: 'overdue',
                        documentId: taskItem.id,
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  String _formatDate(dynamic dateValue) {
    if (dateValue != null) {
      DateTime dateTime;
      if (dateValue is Timestamp) {
        dateTime = dateValue.toDate();
      } else if (dateValue is DateTime) {
        dateTime = dateValue;
      } else {
        return 'Invalid Date';
      }
      return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    }
    return 'No Date';
  }
}

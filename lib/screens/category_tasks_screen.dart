import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todo_list_app/helperwidgets/all_tasks_card.dart';

class CategoryTasksScreen extends StatelessWidget {
  const CategoryTasksScreen({super.key, required this.categoryName});

  final String categoryName;

  @override
  Widget build(BuildContext context) {
    final primaryColor = Color.fromRGBO(33, 150, 243, 1.0);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          '$categoryName Tasks',
          style: Theme.of(context).textTheme.titleSmall!.copyWith(
            fontSize: 25,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('tasks')
              .where(
                'creatorId',
                isEqualTo: FirebaseAuth.instance.currentUser!.uid,
              )
              .where('catagory', isEqualTo: categoryName)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator.adaptive());
            }
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      _getCategoryIcon(categoryName),
                      size: 64,
                      color: Colors.grey,
                    ),
                    SizedBox(height: 16),
                    Text(
                      'No $categoryName tasks yet',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Add some tasks in this category to see them here',
                      style: TextStyle(color: Colors.grey, fontSize: 14),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            }
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                var taskItem = snapshot.data!.docs[index];
                return AllTasksCard(
                  taskTitle: taskItem.data()['title'] ?? 'No Title',
                  taskTime: taskItem.data()['time'] ?? 'No Time',
                  taskDate: () {
                    var dateValue = taskItem.data()['date'];
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
                  }(),
                  taskItem: taskItem.data(),
                  taskStatus: taskItem.data()['status'] ?? 'pending',
                  documentId: taskItem.id,
                );
              },
            );
          },
        ),
      ),
    );
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
}

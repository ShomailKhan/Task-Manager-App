import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todo_list_app/helperwidgets/catagory_cards.dart';
import 'package:todo_list_app/helperwidgets/dailytasks_card.dart';
import 'package:todo_list_app/screens/all_tasks_screen.dart';
import 'package:todo_list_app/utils/taskdata.dart';

class HomepageBody extends StatefulWidget {
  const HomepageBody({super.key});

  @override
  State<HomepageBody> createState() => _HomepageBodyState();
}

class _HomepageBodyState extends State<HomepageBody> {
  final TextEditingController _searchController = TextEditingController();
  String searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var primaryColor = Color.fromRGBO(33, 150, 243, 1.0);
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _searchController,
              onChanged: (value) {
                setState(() {
                  searchQuery = value.toLowerCase().trim();
                });
              },
              decoration: InputDecoration(
                fillColor: Color.fromRGBO(245, 247, 249, 1),
                filled: true,
                label: Row(children: [Icon(Icons.search), Text('search')]),
                hintText: 'Search for Tasks, Events',
                labelStyle: TextStyle(color: Colors.black),
                suffixIcon: searchQuery.isNotEmpty
                    ? IconButton(
                        icon: Icon(Icons.clear, color: Colors.grey),
                        onPressed: () {
                          setState(() {
                            _searchController.clear();
                            searchQuery = '';
                          });
                        },
                      )
                    : null,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    color: Color.fromRGBO(222, 235, 249, 1),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    color: Color.fromRGBO(222, 235, 249, 1),
                  ),
                ),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
            Text(
              'Catagories',
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                fontWeight: FontWeight.bold,
                color: primaryColor,
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.3,
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                ),
                itemCount: catagoryInfo.length,
                itemBuilder: (context, index) {
                  var catagoryItem = catagoryInfo[index];
                  var categoryName = catagoryItem['catagoryName'];
                  
                  return StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('tasks')
                        .where('creatorId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                        .where('catagory', isEqualTo: categoryName)
                        .snapshots(),
                    builder: (context, snapshot) {
                      int taskCount = 0;
                      if (snapshot.hasData) {
                        taskCount = snapshot.data!.docs.length;
                      }
                      
                      return CatagoryCards(
                        catagoryName: categoryName,
                        catagoryIconPath: catagoryItem['catagoryIconPath'],
                        taskCount: taskCount,
                      );
                    },
                  );
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  searchQuery.isEmpty ? 'Today\'s Tasks' : 'Search Results',
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                  ),
                ),
                if (searchQuery.isEmpty)
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => AllTasksScreen()),
                      );
                    },
                    child: Text(
                      'see all',
                      style: Theme.of(context).textTheme.titleSmall!.copyWith(
                        color: Color.fromRGBO(33, 150, 243, 1.0),
                      ),
                    ),
                  ),
              ],
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
            StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('tasks')
                  .where(
                    'creatorId',
                    isEqualTo: FirebaseAuth.instance.currentUser!.uid,
                  )
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
                        Icon(Icons.task_outlined, size: 64, color: Colors.grey),
                        SizedBox(height: 16),
                        Text(
                          'No tasks found',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                // Filter tasks based on search query
                final filteredDocs = snapshot.data!.docs.where((doc) {
                  if (searchQuery.isEmpty) return true;
                  final title = (doc.data()['title'] ?? '').toString().toLowerCase();
                  return title.contains(searchQuery);
                }).toList();

                // Show empty state if no results after filtering
                if (filteredDocs.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.search_off,
                            size: 80,
                            color: Colors.grey.shade400,
                          ),
                          SizedBox(height: 20),
                          Text(
                            'No tasks found matching',
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            '"$searchQuery"',
                            style: TextStyle(
                              color: primaryColor,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 16),
                          Text(
                            'Try searching with different keywords',
                            style: TextStyle(
                              color: Colors.grey.shade500,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: filteredDocs.length,
                  itemBuilder: (context, index) {
                    var taskItem = filteredDocs[index];
                    return Dismissible(
                      key: ValueKey(
                        '${taskItem['title']}_${taskItem['time']}_${taskItem.hashCode}',
                      ),
                      direction: DismissDirection.horizontal,
                      background: Container(
                        color: Colors.green,
                        alignment: Alignment.centerLeft,
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Icon(Icons.check, color: Colors.white, size: 30),
                      ),
                      secondaryBackground: Container(
                        color: Colors.red,
                        alignment: Alignment.centerRight,
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Icon(
                          Icons.delete,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                      confirmDismiss: (direction) async {
                        if (direction == DismissDirection.endToStart) {
                          return await showDialog<bool>(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text('Delete Task?'),
                              content: Text(
                                'Are you sure you want to delete this task?',
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () =>
                                      Navigator.of(context).pop(false),
                                  child: Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () =>
                                      Navigator.of(context).pop(true),
                                  child: Text(
                                    'Delete',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }
                        return true; // Allow mark as done without confirmation
                      },
                      onDismissed: (direction) {
                        if (direction == DismissDirection.startToEnd) {
                          // Mark as done
                          FirebaseFirestore.instance.collection('tasks').doc(taskItem.id).update({'status':'done'});
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Task marked as "done"')),
                          );
                        } else if (direction == DismissDirection.endToStart) {
                          // Remove task
                          FirebaseFirestore.instance.collection('tasks').doc(taskItem.id).delete();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Task removed successfully'),
                            ),
                          );
                        }
                      },
                      child: DailytasksCard(
                        taskTitle: taskItem.data()['title'] ?? 'No Title',
                        taskTime: taskItem.data()['time'] ?? 'No Time',
                        taskItem: taskItem.data(),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

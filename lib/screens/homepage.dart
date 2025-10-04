// ignore_for_file: deprecated_member_use, sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'package:todo_list_app/helperwidgets/add_new_task.dart';
import 'package:todo_list_app/helperwidgets/homepagebody.dart';
import 'package:todo_list_app/screens/all_tasks_screen.dart';
import 'package:todo_list_app/screens/signout_screen.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final List<Widget> pages = [HomepageBody(), AllTasksScreen(), SignoutScreen()];
  int currentPage = 0;
  @override
  Widget build(BuildContext context) {
    final primaryColor = Color.fromRGBO(33, 150, 243, 1.0);
    
    return Scaffold(
      body: IndexedStack(index: currentPage, children: pages),
      floatingActionButton: FloatingActionButton(
        tooltip: 'add a new task',
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddNewTask()),
          );
        },
        backgroundColor: primaryColor,
        child: Icon(Icons.add, color: Colors.white, size: 40),
      ),
      bottomNavigationBar: Container(
        margin: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: primaryColor,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: primaryColor.withOpacity(0.3),
              blurRadius: 20,
              offset: Offset(0, 10),
            ),
          ],
        ),
        child: Container(
          height: 65,
          child: SafeArea(
            top: false,
            child: BottomNavigationBar(
              currentIndex: currentPage,
              onTap: (value) {
                setState(() {
                  currentPage = value;
                });
              },
              type: BottomNavigationBarType.fixed,
              backgroundColor: Colors.transparent,
              elevation: 0,
              selectedItemColor: Colors.white,
              unselectedItemColor: Colors.white.withOpacity(0.6),
              selectedFontSize: 0,
              unselectedFontSize: 0,
              items: [
                BottomNavigationBarItem(
                  tooltip: 'Home',
                  label: '',
                  icon: Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: currentPage == 0 ? Colors.white.withOpacity(0.2) : Colors.transparent,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.home,
                      size: currentPage == 0 ? 28 : 26,
                      color: currentPage == 0 ? Colors.white : Colors.white.withOpacity(0.7),
                    ),
                  ),
                ),
                BottomNavigationBarItem(
                  tooltip: 'All Tasks',
                  label: '',
                  icon: Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: currentPage == 1 ? Colors.white.withOpacity(0.2) : Colors.transparent,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.edit_document,
                      size: currentPage == 1 ? 28 : 26,
                      color: currentPage == 1 ? Colors.white : Colors.white.withOpacity(0.7),
                    ),
                  ),
                ),
                BottomNavigationBarItem(
                  tooltip: 'Profile',
                  label: '',
                  icon: Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: currentPage == 2 ? Colors.white.withOpacity(0.2) : Colors.transparent,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.person,
                      size: currentPage == 2 ? 28 : 26,
                      color: currentPage == 2 ? Colors.white : Colors.white.withOpacity(0.7),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

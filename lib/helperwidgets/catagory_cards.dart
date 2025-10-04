import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:todo_list_app/screens/category_tasks_screen.dart';

class CatagoryCards extends StatelessWidget {
  const CatagoryCards({super.key, required this.catagoryName, required this.catagoryIconPath, required this.taskCount});
  final String catagoryName;
  final String catagoryIconPath;
  final int taskCount;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CategoryTasksScreen(categoryName: catagoryName),
          ),
        );
      },
      child: Card(
        color: Color.fromRGBO(245, 247, 249, 1),
        borderOnForeground: true,
        elevation: 2,
        child: Stack(
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(catagoryIconPath, height: 30),
                  SizedBox(height: 10),
                  Text(
                    catagoryName,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                  )
                ],
              ),
            ),
            if (taskCount > 0)
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(33, 150, 243, 1.0),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    taskCount.toString(),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
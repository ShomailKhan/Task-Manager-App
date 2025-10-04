import 'package:flutter/material.dart';

class TasksProvider extends ChangeNotifier{
  final List<Map<String, dynamic>> tasks = [];

  void addTask(Map<String, dynamic> taskItem){
    tasks.add(taskItem);
    notifyListeners();
  }
  
  void removeTask(Map taskItem){
    tasks.remove(taskItem);
    notifyListeners();
  }
  
  void updateTaskStatus(Map taskItem, String newStatus) {
    taskItem['status'] = newStatus;
    notifyListeners();
  }
  
  // Check and update overdue tasks (without notifying during build)
  void _checkOverdueTasks() {
    DateTime now = DateTime.now();
    DateTime today = DateTime(now.year, now.month, now.day);
    
    for (var task in tasks) {
      if (task['status'] != 'done' && task['date'] != null) {
        DateTime taskDate = task['date'] as DateTime;
        DateTime taskDay = DateTime(taskDate.year, taskDate.month, taskDate.day);
        
        if (taskDay.isBefore(today)) {
          task['status'] = 'overdue';
        }
      }
    }
  }

  // Helper methods to get filtered tasks
  List<Map<String, dynamic>> get pendingTasks {
    _checkOverdueTasks();
    return tasks.where((task) => task['status'] == 'pending').toList();
  }
  
  List<Map<String, dynamic>> get doneTasks => tasks.where((task) => task['status'] == 'done').toList();
  
  List<Map<String, dynamic>> get overdueTasks {
    _checkOverdueTasks();
    return tasks.where((task) => task['status'] == 'overdue').toList();
  }
}
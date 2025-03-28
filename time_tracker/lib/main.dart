import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'time_entry_provider.dart';
import 'home_screen.dart';
import 'add_time_entry_screen.dart';
import 'project_task_management_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final provider = TimeEntryProvider();
  await provider.loadData();

  runApp(
    ChangeNotifierProvider(
      create: (context) => provider,
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Time Tracker',
      theme: ThemeData(primarySwatch: Colors.blue),
      routes: {
        '/': (context) => HomeScreen(),
        '/add-entry': (context) => AddTimeEntryScreen(),
        '/manage-projects': (context) => ProjectTaskManagementScreen(),
      },
    );
  }
}
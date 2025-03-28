import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'models.dart';

class TimeEntryProvider with ChangeNotifier {
  SharedPreferences? _prefs;
  static const String _entriesKey = 'time_entries';
  static const String _projectsKey = 'projects';
  static const String _tasksKey = 'tasks';

  List<TimeEntry> _entries = [];
  List<Project> _projects = [];
  List<Task> _tasks = [];

  List<TimeEntry> get entries => _entries;
  List<Project> get projects => _projects;
  List<Task> get tasks => _tasks;

  Future<void> _initializePrefs() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  Future<void> loadData() async {
    await _initializePrefs();
    await _loadProjects();
    await _loadTasks();
    await _loadEntries();
    notifyListeners();
  }

  Future<void> _loadProjects() async {
    try {
      final String? projectsString = _prefs?.getString(_projectsKey);
      if (projectsString != null) {
        _projects = (jsonDecode(projectsString) as List)
            .map((p) => Project.fromJson(p)).toList();
      } else {
        _projects = [
          Project(id: '1', name: 'Project Alpha'),
          Project(id: '2', name: 'Project Beta'),
          Project(id: '3', name: 'Project Gamma'),
        ];
        await _saveProjects();
      }
    } catch (e) {
      if (kDebugMode) print('Error loading projects: $e');
      _projects = [
        Project(id: '1', name: 'Project Alpha'),
        Project(id: '2', name: 'Project Beta'),
        Project(id: '3', name: 'Project Gamma'),
      ];
    }
  }

  Future<void> _loadTasks() async {
    try {
      final String? tasksString = _prefs?.getString(_tasksKey);
      if (tasksString != null) {
        _tasks = (jsonDecode(tasksString) as List)
            .map((t) => Task.fromJson(t)).toList();
      } else {
        _tasks = [
          Task(id: '1', projectId: '1', name: 'Task A'),
          Task(id: '2', projectId: '1', name: 'Task B'),
          Task(id: '3', projectId: '2', name: 'Task C'),
        ];
        await _saveTasks();
      }
    } catch (e) {
      if (kDebugMode) print('Error loading tasks: $e');
      _tasks = [
        Task(id: '1', projectId: '1', name: 'Task A'),
        Task(id: '2', projectId: '1', name: 'Task B'),
        Task(id: '3', projectId: '2', name: 'Task C'),
      ];
    }
  }

  Future<void> _loadEntries() async {
    try {
      final String? entriesString = _prefs?.getString(_entriesKey);
      if (entriesString != null) {
        _entries = (jsonDecode(entriesString) as List)
            .map((e) => TimeEntry.fromJson(e)).toList();
      }
    } catch (e) {
      if (kDebugMode) print('Error loading entries: $e');
      _entries = [];
    }
  }

  String getTaskName(String taskId) {
    try {
      return _tasks.firstWhere((t) => t.id == taskId).name;
    } catch (e) {
      if (kDebugMode) print('Error finding task: $e');
      return 'Unknown Task';
    }
  }

  Future<void> addEntry(TimeEntry entry) async {
    _entries.add(entry);
    await _saveEntries();
    notifyListeners();
  }

  Future<void> deleteEntry(String id) async {
    _entries.removeWhere((e) => e.id == id);
    await _saveEntries();
    notifyListeners();
  }

  Future<void> addProject(Project project) async {
    if (_projects.any((p) => p.name == project.name)) {
      throw 'Project name already exists';
    }
    _projects.add(project);
    await _saveProjects();
    notifyListeners();
  }

  Future<void> deleteProject(String id) async {
    if (_tasks.any((t) => t.projectId == id)) {
      throw 'Cannot delete project with existing tasks';
    }
    _projects.removeWhere((p) => p.id == id);
    await _saveProjects();
    notifyListeners();
  }

  Future<void> addTask(Task task) async {
    if (_tasks.any((t) => t.name == task.name && t.projectId == task.projectId)) {
      throw 'Task name already exists for this project';
    }
    _tasks.add(task);
    await _saveTasks();
    notifyListeners();
  }

  Future<void> deleteTask(String id) async {
    if (_entries.any((e) => e.taskId == id)) {
      throw 'Cannot delete task with existing time entries';
    }
    _tasks.removeWhere((t) => t.id == id);
    await _saveTasks();
    notifyListeners();
  }

  Future<void> _saveEntries() async {
    await _initializePrefs();
    await _prefs?.setString(
      _entriesKey,
      jsonEncode(_entries.map((e) => e.toJson()).toList()),
    );
  }

  Future<void> _saveProjects() async {
    await _initializePrefs();
    await _prefs?.setString(
      _projectsKey,
      jsonEncode(_projects.map((p) => p.toJson()).toList()),
    );
  }

  Future<void> _saveTasks() async {
    await _initializePrefs();
    await _prefs?.setString(
      _tasksKey,
      jsonEncode(_tasks.map((t) => t.toJson()).toList()),
    );
  }
}
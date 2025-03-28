import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models.dart';
import 'time_entry_provider.dart';

class ProjectTaskManagementScreen extends StatefulWidget {
  const ProjectTaskManagementScreen({super.key});

  @override
  State<ProjectTaskManagementScreen> createState() => 
      _ProjectTaskManagementScreenState();
}

class _ProjectTaskManagementScreenState 
    extends State<ProjectTaskManagementScreen> {
  final _newProjectNameController = TextEditingController();
  String? _selectedProjectIdForTask;
  final _newTaskNameController = TextEditingController();

  @override
  void dispose() {
    _newProjectNameController.dispose();
    _newTaskNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TimeEntryProvider>(context);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Manage Projects & Tasks'),
          bottom: TabBar(
            tabs: [
              Tab(text: 'Projects'),
              Tab(text: 'Tasks'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildProjectsTab(provider, context),
            _buildTasksTab(provider, context),
          ],
        ),
      ),
    );
  }

  Widget _buildProjectsTab(TimeEntryProvider provider, BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: provider.projects.length,
            itemBuilder: (context, index) {
              final project = provider.projects[index];
              return Dismissible(
                key: Key(project.id),
                background: Container(color: Colors.red),
                onDismissed: (_) async {
                  try {
                    await provider.deleteProject(project.id);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Project deleted')),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(e.toString())),
                    );
                  }
                },
                child: ListTile(
                  title: Text(project.name),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () async {
                      try {
                        await provider.deleteProject(project.id);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Project deleted')),
                        );
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(e.toString())),
                        );
                      }
                    },
                  ),
                ),
              );
            },
          ),
        ),
        Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Add New Project', 
                  style: TextStyle(fontWeight: FontWeight.bold)),
              TextField(
                controller: _newProjectNameController,
                decoration: InputDecoration(hintText: 'Project Name'),
                onSubmitted: (value) async {
                  if (value.isNotEmpty) {
                    try {
                      await provider.addProject(Project(
                        id: DateTime.now().millisecondsSinceEpoch.toString(),
                        name: value,
                      ));
                      _newProjectNameController.clear();
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(e.toString())),
                      );
                    }
                  }
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTasksTab(TimeEntryProvider provider, BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: provider.tasks.length,
            itemBuilder: (context, index) {
              final task = provider.tasks[index];
              final project = provider.projects
                  .firstWhere((p) => p.id == task.projectId);
              return Dismissible(
                key: Key(task.id),
                background: Container(color: Colors.red),
                onDismissed: (_) async {
                  try {
                    await provider.deleteTask(task.id);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Task deleted')),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(e.toString())),
                    );
                  }
                },
                child: ListTile(
                  title: Text(task.name),
                  subtitle: Text('Project: ${project.name}'),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () async {
                      try {
                        await provider.deleteTask(task.id);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Task deleted')),
                        );
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(e.toString())),
                        );
                      }
                    },
                  ),
                ),
              );
            },
          ),
        ),
        Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Add New Task', 
                  style: TextStyle(fontWeight: FontWeight.bold)),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: 'Project'),
                value: _selectedProjectIdForTask,
                items: provider.projects.map((project) {
                  return DropdownMenuItem<String>(
                    value: project.id,
                    child: Text(project.name),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() => _selectedProjectIdForTask = value);
                },
              ),
              SizedBox(height: 16),
              TextField(
                controller: _newTaskNameController,
                decoration: InputDecoration(hintText: 'Task Name'),
                onSubmitted: (value) async {
                  if (value.isNotEmpty && _selectedProjectIdForTask != null) {
                    try {
                      await provider.addTask(Task(
                        id: DateTime.now().millisecondsSinceEpoch.toString(),
                        projectId: _selectedProjectIdForTask!,
                        name: value,
                      ));
                      _newTaskNameController.clear();
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(e.toString())),
                      );
                    }
                  } else if (_selectedProjectIdForTask == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Select a project first')),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'models.dart';
import 'time_entry_provider.dart';

class AddTimeEntryScreen extends StatefulWidget {
  const AddTimeEntryScreen({super.key});

  @override
  _AddTimeEntryScreenState createState() => _AddTimeEntryScreenState();
}

class _AddTimeEntryScreenState extends State<AddTimeEntryScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedProjectId;
  String? _selectedTaskId;
  DateTime _selectedDate = DateTime.now();
  double _hours = 1;
  String? _notes;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TimeEntryProvider>(context);
    final tasksForProject = _selectedProjectId != null
        ? provider.tasks.where((t) => t.projectId == _selectedProjectId).toList()
        : [];

    return Scaffold(
      appBar: AppBar(title: Text('Add Time Entry')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(16),
          children: [
            Text('Project', style: Theme.of(context).textTheme.titleMedium),
            DropdownButtonFormField<String>(
              value: _selectedProjectId,
              items: provider.projects.map((project) {
                return DropdownMenuItem(
                  value: project.id,
                  child: Text(project.name),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedProjectId = value;
                  _selectedTaskId = null;
                });
              },
              validator: (value) => value == null ? 'Select a project' : null,
            ),
            SizedBox(height: 16),
            Text('Task', style: Theme.of(context).textTheme.titleMedium),
            DropdownButtonFormField<String>(
              value: _selectedTaskId,
              items: tasksForProject.map((task) {
                return DropdownMenuItem<String>(
                  value: task.id,
                  child: Text(task.name),
                );
              }).toList(),
              onChanged: (value) => setState(() => _selectedTaskId = value),
              validator: (value) => value == null ? 'Select a task' : null,
            ),
            SizedBox(height: 16),
            Text('Date', style: Theme.of(context).textTheme.titleMedium),
            ListTile(
              title: Text(DateFormat('yyyy-MM-dd').format(_selectedDate)),
              trailing: Icon(Icons.calendar_today),
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: _selectedDate,
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                );
                if (date != null) setState(() => _selectedDate = date);
              },
            ),
            SizedBox(height: 16),
            Text('Total Time (in hours)', style: Theme.of(context).textTheme.titleMedium),
            TextFormField(
              initialValue: '1',
              keyboardType: TextInputType.number,
              onChanged: (value) => _hours = double.tryParse(value) ?? 1,
              validator: (value) => value == null || value.isEmpty ? 'Enter hours' : null,
            ),
            SizedBox(height: 16),
            Text('Note', style: Theme.of(context).textTheme.titleMedium),
            TextFormField(
              onChanged: (value) => _notes = value,
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton(
                child: Text('Cancel'),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: ElevatedButton(
                child: Text('Add'),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    provider.addEntry(TimeEntry(
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      projectId: _selectedProjectId!,
                      taskId: _selectedTaskId!,
                      date: _selectedDate,
                      hours: _hours,
                      notes: _notes,
                    ));
                    Navigator.pop(context);
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
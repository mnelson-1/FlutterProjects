import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:collection/collection.dart';
import 'time_entry_provider.dart';
import 'models.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TimeEntryProvider>(context);
    final groupedEntries = groupBy(provider.entries, (e) => e.projectId);

    return DefaultTabController(
      length: 2,
      initialIndex: 0,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Time Tracking',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.blue,
          bottom: const TabBar(
            tabs: [
              Tab(
                icon: Icon(Icons.list_alt),
                text: 'All Entries',
              ),
              Tab(
                icon: Icon(Icons.folder),
                text: 'Projects',
              ),
            ],
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            indicatorColor: Colors.white,
          ),
        ),
        body: TabBarView(
          children: [
            // Tab 1: All Entries (Grouped by Projects)
            provider.entries.isEmpty
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.timer_off,
                          size: 64,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 16),
                        Text(
                          'No time entries yet!',
                          style: TextStyle(fontSize: 18),
                        ),
                        Text(
                          'Tap + to add your first entry',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  )
                : ListView(
                    children: [
                      const Padding(
                        padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
                        child: Text(
                          'All Entries',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
                        child: Text(
                          'Grouped by Projects',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                      ...groupedEntries.entries.map((entry) {
                        final project = provider.projects.firstWhere(
                          (p) => p.id == entry.key,
                          orElse: () => Project(id: '', name: 'Unknown Project'),
                        );
                        return
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                              child: Text(
                                project.name,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                              ),
                            ),
                            ...entry.value.map((e) => Dismissible(
                                  key: Key(e.id),
                                  background: Container(color: Colors.red[100]),
                                  onDismissed: (_) => provider.deleteEntry(e.id),
                                  child: ListTile(
                                    title: Text(provider.getTaskName(e.taskId)),
                                    subtitle: Text(
                                      '${e.hours} hours • ${DateFormat('MMM dd, yyyy').format(e.date)}',
                                    ),
                                    trailing: IconButton(
                                      icon: const Icon(Icons.delete),
                                      onPressed: () =>
                                          provider.deleteEntry(e.id),
                                    ),
                                  ),
                                )),
                            const Divider(height: 1),
                          ],
                        );
                      }),
                    ],
                  ),

            // Tab 2: Projects List
            provider.projects.isEmpty
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.folder_off,
                          size: 64,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 16),
                        Text(
                          'No projects yet!',
                          style: TextStyle(fontSize: 18),
                        ),
                        Text(
                          'Add projects in management screen',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: provider.projects.length,
                    itemBuilder: (context, index) {
                      final project = provider.projects[index];
                      final entryCount = provider.entries
                          .where((e) => e.projectId == project.id)
                          .length;
                      return ListTile(
                        title: Text(project.name),
                        subtitle: Text(
                          '$entryCount ${entryCount == 1 ? 'entry' : 'entries'}'),
                        trailing: IconButton(
                          icon: const Icon(Icons.arrow_forward_ios, size: 16),
                          onPressed: () {},
                        ),
                        onTap: () {
                          // Optional: Could implement project detail view
                        },
                      );
                    },
                  ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.blue,
          child: const Icon(Icons.add, color: Colors.white),
          onPressed: () => Navigator.pushNamed(context, '/add-entry'),
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: const BoxDecoration(color: Colors.blue),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Time Tracker',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${provider.entries.length} total entries',
                      style: const TextStyle(color: Colors.white70),
                    ),
                  ],
                ),
              ),
              ListTile(
                leading: const Icon(Icons.home),
                title: const Text('Home'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.list),
                title: const Text('Manage Projects/Tasks'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/manage-projects');
                },
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.settings),
                title: const Text('Settings'),
                onTap: () {
                  // Optional: Implement settings screen
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
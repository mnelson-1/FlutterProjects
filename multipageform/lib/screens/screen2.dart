import 'package:flutter/material.dart';

class Screen2 extends StatelessWidget {
  final String name;
  final String email;
  final String phone;

  const Screen2({
    super.key,
    required this.name,
    required this.email,
    required this.phone,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thank you!'),
      ),
      body: Container(
        color: const Color.fromARGB(137, 245, 89, 185), // Matching background color
        child: Center(
          child: Card(
            elevation: 8,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Name: $name', style: const TextStyle(fontSize: 18)),
                  const SizedBox(height: 8),
                  Text('Email: $email', style: const TextStyle(fontSize: 18)),
                  const SizedBox(height: 8),
                  Text('Phone: $phone', style: const TextStyle(fontSize: 18)),
                  const SizedBox(height: 24),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(137, 245, 89, 185), // Button color
                        foregroundColor: Colors.white, // Text color
                        padding: const EdgeInsets.symmetric(
                            horizontal: 32, vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('Go Back'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
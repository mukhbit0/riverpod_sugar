import 'package:flutter/material.dart';
import 'package:riverpod_sugar/riverpod_sugar.dart';

/// Comprehensive examples showcasing all Riverpod Sugar features
/// This file serves as both documentation and testing for the library

// Example providers using Sugar extensions
/// Counter provider for demonstration
final counter = 0.state;

/// User name provider for demonstration
final userName = 'Guest'.text;

/// Dark mode toggle provider
final isDarkMode = false.toggle;

/// Loading state provider
final isLoading = false.loading;

/// Volume control provider (using .price for any double)
final volume = 50.0.price; // Using .price for any double

/// Color selection provider using Sugar class
final selectedColor =
    Sugar.list<Color>([Colors.blue, Colors.red, Colors.green]);

/// Notifications enabled provider
final notifications = true.enabled;

/// Todo list provider
final todos = <String>[].items;

/// Rating provider
final rating = 4.5.price;

/// Main showcase widget demonstrating all Sugar features
class SugarShowcase extends RxWidget {
  /// Creates a Sugar showcase widget
  const SugarShowcase({super.key});

  @override
  Widget buildRx(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🍯 Riverpod Sugar Showcase'),
        actions: [
          // Dark mode toggle using Sugar
          IconButton(
            icon: Icon(ref.watchValue(isDarkMode)
                ? Icons.light_mode
                : Icons.dark_mode),
            onPressed: () => isDarkMode.toggle(ref),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section 1: Basic Provider Display
            _buildSection(
              title: '1. Basic Provider Display',
              children: [
                ref.text(counter,
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold)),
                ref.text(userName, style: const TextStyle(fontSize: 18)),
                ref.chip(rating, backgroundColor: Colors.amber),
                ref.showWhen(isLoading, const CircularProgressIndicator()),
              ],
            ),

            // Section 2: Interactive Controls
            _buildSection(
              title: '2. Interactive Controls',
              children: [
                ref.stepper(counter, step: 1, min: 0, max: 100),
                ref.slider(volume, min: 0, max: 100, divisions: 10),
                ref.switchTile(notifications, title: 'Notifications'),
                ref.checkboxTile(isDarkMode, title: 'Dark Mode'),
              ],
            ),

            // Section 3: Conditional Widgets
            _buildSection(
              title: '3. Conditional Widgets',
              children: [
                ref.showEither(
                  isDarkMode,
                  const Icon(Icons.dark_mode, size: 48, color: Colors.orange),
                  const Icon(Icons.light_mode, size: 48, color: Colors.yellow),
                ),
                ref.card(
                  const Text('This card is conditionally visible'),
                  visible: notifications,
                  padding: const EdgeInsets.all(16),
                ),
              ],
            ),

            // Section 4: List Management
            _buildSection(
              title: '4. List Management',
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        decoration: const InputDecoration(
                          labelText: 'Add todo',
                          border: OutlineInputBorder(),
                        ),
                        onSubmitted: (value) {
                          if (value.isNotEmpty) {
                            todos.addItem(ref, value);
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      onPressed: () => todos.clearAll(ref),
                      icon: const Icon(Icons.clear_all),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text('Total todos: ${todos.getLength(ref)}'),
                ...ref.watchValue(todos).asMap().entries.map((entry) {
                  final index = entry.key;
                  final todo = entry.value;
                  return Card(
                    child: ListTile(
                      title: Text(todo),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => todos.removeAt(ref, index),
                      ),
                    ),
                  );
                }),
              ],
            ),

            // Section 5: Advanced Features
            _buildSection(
              title: '5. Advanced Features',
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Demonstrate batch updates
                    counter.setValue(ref, 42);
                    userName.updateText(ref, 'John Doe');
                    rating.setValue(ref, 5.0);
                    volume.setValue(ref, 75.0);
                  },
                  child: const Text('Batch Update All Values'),
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () {
                    // Reset all to defaults
                    counter.resetToZero(ref);
                    userName.updateText(ref, 'Guest');
                    isDarkMode.setFalse(ref);
                    isLoading.setFalse(ref);
                    notifications.setTrue(ref);
                    rating.setValue(ref, 4.5);
                    volume.setValue(ref, 50.0);
                    todos.clearAll(ref);
                  },
                  child: const Text('Reset All to Defaults'),
                ),
              ],
            ),

            // Section 6: Performance Demo
            _buildSection(
              title: '6. Performance Demo',
              children: [
                Text('Counter rebuilds: ${ref.watchValue(counter)}'),
                ElevatedButton(
                  onPressed: () {
                    // Rapid updates to test performance
                    for (int i = 0; i < 10; i++) {
                      Future.delayed(Duration(milliseconds: i * 100), () {
                        counter.increment(ref);
                      });
                    }
                  },
                  child: const Text('Rapid Counter Updates'),
                ),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => counter.increment(ref),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required List<Widget> children,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 12),
            ...children.map((child) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: child,
                )),
          ],
        ),
      ),
    );
  }
}

/// Example showcasing AsyncValue with Sugar
class AsyncExampleWidget extends RxWidget {
  /// Creates an async example widget
  const AsyncExampleWidget({super.key});

  @override
  Widget buildRx(BuildContext context, WidgetRef ref) {
    final userProvider = FutureProvider<String>((ref) async {
      await Future.delayed(const Duration(seconds: 2));
      return 'John Doe';
    });

    return ref.watch(userProvider).easyWhen(
          data: (name) => Column(
            children: [
              Text('Welcome, $name!', style: const TextStyle(fontSize: 20)),
              ref.chip(userName, backgroundColor: Colors.green),
            ],
          ),
          loading: () => const Column(
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 8),
              Text('Loading user...'),
            ],
          ),
          error: (error, stack) => Column(
            children: [
              const Icon(Icons.error, color: Colors.red, size: 48),
              Text('Error: $error'),
            ],
          ),
        );
  }
}

/// Example showcasing form management with Sugar
class FormExampleWidget extends RxWidget {
  /// Creates a form example widget
  const FormExampleWidget({super.key});

  @override
  Widget buildRx(BuildContext context, WidgetRef ref) {
    final email = ''.text;
    final password = ''.text;
    final agreeToTerms = false.toggle;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) => email.updateText(ref, value),
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
              onChanged: (value) => password.updateText(ref, value),
            ),
            const SizedBox(height: 16),
            ref.checkboxTile(agreeToTerms, title: 'I agree to the terms'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: ref.watchValue(agreeToTerms) &&
                      ref.watchValue(email).isNotEmpty &&
                      ref.watchValue(password).isNotEmpty
                  ? () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                              'Form submitted for ${ref.watchValue(email)}'),
                        ),
                      );
                    }
                  : null,
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}

/// Example showcasing provider combinations
class CombinedProviderExample extends RxWidget {
  /// Creates a combined provider example widget
  const CombinedProviderExample({super.key});

  @override
  Widget buildRx(BuildContext context, WidgetRef ref) {
    // Combine multiple providers into one
    final combinedProvider = Provider<String>((ref) {
      final name = ref.watch(userName);
      final count = ref.watch(counter);
      final isDark = ref.watch(isDarkMode);

      return '$name has clicked $count times in ${isDark ? 'dark' : 'light'} mode';
    });

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              'Combined Provider Example:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(ref.watch(combinedProvider)),
          ],
        ),
      ),
    );
  }
}

/// Comprehensive examples showcasing all Riverpod Sugar features
/// This file contains practical examples for every Sugar extension and utility.
library comprehensive_examples;

import 'package:flutter/material.dart';
import 'package:riverpod_sugar/riverpod_sugar.dart' hide FormState;

// =============================================================================
// 1. PROVIDER CREATION EXAMPLES
// =============================================================================

/// Examples of all provider creation methods using Sugar extensions
class ProviderCreationExamples {
  /// Integer provider example
  static final counter = 0.state;

  /// String provider example
  static final name = 'Guest'.state;

  /// Boolean provider example
  static final isDarkMode = false.state;

  /// Double provider example
  static final price = 19.99.state;

  /// List provider example
  static final todos = <String>[].state;

  /// Loading state example
  static final isLoading = false.state;

  /// Visibility state example
  static final isVisible = true.state;

  /// Enabled state example
  static final isEnabled = true.state;

  /// Active state example
  static final isActive = false.state;

  /// Search provider example
  static final searchQuery = ''.state;

  // Alternative using extension syntax (preferred)
  /// User age using extension
  static final userAge = 25.state;

  /// User name using extension
  static final userName = 'John Doe'.state;

  /// Online status using extension
  static final isOnline = true.state;

  /// Temperature using extension
  static final temperature = 22.5.state;

  /// Shopping list using extension
  static final shoppingList = <String>[].state;
}

// =============================================================================
// 2. WIDGET EXAMPLES - RXWIDGET FAMILY
// =============================================================================

/// Basic RxWidget example showing counter functionality
class CounterWidget extends RxWidget {
  /// Creates a counter widget
  const CounterWidget({super.key});

  @override
  Widget buildRx(BuildContext context, WidgetRef ref) {
    final count = ref.watchValue(ProviderCreationExamples.counter);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('Counter: $count',
                style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () =>
                      ProviderCreationExamples.counter.decrement(ref),
                  child: const Text('-'),
                ),
                ElevatedButton(
                  onPressed: () =>
                      ProviderCreationExamples.counter.increment(ref),
                  child: const Text('+'),
                ),
                ElevatedButton(
                  onPressed: () =>
                      ProviderCreationExamples.counter.addValue(ref, 10),
                  child: const Text('+10'),
                ),
                ElevatedButton(
                  onPressed: () =>
                      ProviderCreationExamples.counter.resetToZero(ref),
                  child: const Text('Reset'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// RxBuilder inline example showing reactive form input
class InlineBuilderExample extends StatelessWidget {
  /// Creates an inline builder example widget
  const InlineBuilderExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text('RxBuilder Example:',
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            RxBuilder(
              builder: (context, ref) {
                final name = ref.watchValue(ProviderCreationExamples.name);
                final isLoading =
                    ref.watchValue(ProviderCreationExamples.isLoading);

                return Column(
                  children: [
                    TextField(
                      decoration: const InputDecoration(labelText: 'Your Name'),
                      onChanged: (value) =>
                          ProviderCreationExamples.name.updateText(ref, value),
                    ),
                    const SizedBox(height: 8),
                    if (isLoading)
                      const CircularProgressIndicator()
                    else
                      Text('Hello, $name!'),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

/// RxShow conditional rendering example showing theme switching
class ConditionalRenderingExample extends RxWidget {
  /// Creates a conditional rendering example widget
  const ConditionalRenderingExample({super.key});

  @override
  Widget buildRx(BuildContext context, WidgetRef ref) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text('Conditional Rendering:',
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),

            // Toggle button
            ElevatedButton(
              onPressed: () => ProviderCreationExamples.isDarkMode.toggle(ref),
              child: Text(ref.watchValue(ProviderCreationExamples.isDarkMode)
                  ? 'Switch to Light'
                  : 'Switch to Dark'),
            ),

            const SizedBox(height: 16),

            // Using ref.showEither
            ref.showEither(
              ProviderCreationExamples.isDarkMode,
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[800],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text('Dark mode is enabled!',
                    style: TextStyle(color: Colors.white)),
              ),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.yellow[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text('Light mode is enabled!',
                    style: TextStyle(color: Colors.black)),
              ),
            ),

            const SizedBox(height: 8),

            // Using ref.showEither
            ref.showEither(
              ProviderCreationExamples.isDarkMode,
              const Icon(Icons.dark_mode, size: 48),
              const Icon(Icons.light_mode, size: 48, color: Colors.orange),
            ),
          ],
        ),
      ),
    );
  }
}

// =============================================================================
// 3. LIST OPERATIONS EXAMPLES
// =============================================================================

/// Todo list example demonstrating list operations and CRUD functionality
class TodoListExample extends RxWidget {
  /// Creates a todo list example widget
  const TodoListExample({super.key});

  @override
  Widget buildRx(BuildContext context, WidgetRef ref) {
    final controller = TextEditingController();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Todo List Example:',
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),

            // Add todo input
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller,
                    decoration: const InputDecoration(
                      labelText: 'Add new todo',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (value) {
                      if (value.isNotEmpty) {
                        ProviderCreationExamples.todos.add(ref, value);
                        controller.clear();
                      }
                    },
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    final text = controller.text;
                    if (text.isNotEmpty) {
                      ProviderCreationExamples.todos.add(ref, text);
                      controller.clear();
                    }
                  },
                  child: const Text('Add Todo'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ElevatedButton(
                  onPressed: () => ProviderCreationExamples.todos
                      .addAll(ref, ['Sample 1', 'Sample 2', 'Sample 3']),
                  child: const Text('Add Sample Todos'),
                ),
                ElevatedButton(
                  onPressed: ref.watch(ProviderCreationExamples.todos).isEmpty
                      ? null
                      : () => ProviderCreationExamples.todos.clear(ref),
                  child: const Text('Clear Todos'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (ref.watch(ProviderCreationExamples.todos).isEmpty)
              const Text('No todos yet!')
            else
              ...ref
                  .watch(ProviderCreationExamples.todos)
                  .asMap()
                  .entries
                  .map((entry) {
                final index = entry.key;
                final todo = entry.value;
                return ListTile(
                  title: Text(todo),
                  leading: Text('${index + 1}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () => ProviderCreationExamples.todos
                            .update(ref, index, '$todo (edited)'),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () =>
                            ProviderCreationExamples.todos.remove(ref, todo),
                      ),
                    ],
                  ),
                );
              }),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ElevatedButton(
                  onPressed: () =>
                      ProviderCreationExamples.todos.removeAt(ref, 0),
                  child: const Text('Remove First'),
                ),
                ElevatedButton(
                  onPressed: () => ProviderCreationExamples.todos
                      .removeWhere(ref, (item) => item.contains('Sample')),
                  child: const Text("Remove 'Sample'"),
                ),
                ElevatedButton(
                  onPressed: () =>
                      ProviderCreationExamples.todos.toggle(ref, 'New Item'),
                  child: const Text("Toggle 'New Item'"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// =============================================================================
// 4. BUILT-IN WIDGET HELPERS EXAMPLES
// =============================================================================

/// Built-in widget helpers example demonstrating Sugar widget extensions
class BuiltInWidgetHelpersExample extends RxWidget {
  /// Creates a built-in widget helpers example widget
  const BuiltInWidgetHelpersExample({super.key});

  @override
  Widget buildRx(BuildContext context, WidgetRef ref) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Built-in Widget Helpers:',
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),

            // Text widget helper
            ref.text(ProviderCreationExamples.counter,
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),

            const SizedBox(height: 16),

            // Switch tile helper
            ref.switchTile(
              ProviderCreationExamples.isDarkMode,
              title: 'Dark Mode',
              subtitle: 'Toggle app theme',
            ),

            // Checkbox tile helper
            ref.checkboxTile(
              ProviderCreationExamples.isEnabled,
              title: 'Enable Notifications',
              subtitle: 'Receive app notifications',
            ),

            const SizedBox(height: 16),

            // Loading helper
            Row(
              children: [
                ElevatedButton(
                  onPressed: () =>
                      ProviderCreationExamples.isLoading.toggle(ref),
                  child: Text(ref.watchValue(ProviderCreationExamples.isLoading)
                      ? 'Stop Loading'
                      : 'Start Loading'),
                ),
                const SizedBox(width: 16),
                ref.loading(ProviderCreationExamples.isLoading, size: 24),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// =============================================================================
// 5. ASYNC VALUE EXAMPLES
// =============================================================================

/// Mock API service for async examples
class MockApiService {
  /// Fetches a user name from a mock API
  static Future<String> fetchUserName() async {
    await Future.delayed(const Duration(seconds: 2));
    if (DateTime.now().millisecondsSinceEpoch % 2 == 0) {
      return 'John Doe';
    } else {
      throw Exception('Failed to load user data');
    }
  }

  /// Fetches a list of todos from a mock API
  static Future<List<String>> fetchTodos() async {
    await Future.delayed(const Duration(seconds: 1));
    return ['Buy groceries', 'Walk the dog', 'Finish project'];
  }
}

/// Async providers for examples
/// Provider for fetching user name
final userNameProvider =
    FutureProvider<String>((ref) => MockApiService.fetchUserName());

/// Provider for fetching todos list
final todosProvider =
    FutureProvider<List<String>>((ref) => MockApiService.fetchTodos());

/// AsyncValue example demonstrating easyWhen usage patterns
class AsyncValueExample extends RxWidget {
  /// Creates an async value example widget
  const AsyncValueExample({super.key});

  @override
  Widget buildRx(BuildContext context, WidgetRef ref) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('AsyncValue easyWhen Examples:',
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),

            // Basic easyWhen usage
            const Text('User Name:'),
            ref.watch(userNameProvider).easyWhen(
                  data: (name) => Text(name,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold)),
                ),

            const SizedBox(height: 16),

            // Custom loading and error
            const Text('Todos:'),
            ref.watch(todosProvider).easyWhen(
                  data: (todos) => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: todos.map((todo) => Text('• $todo')).toList(),
                  ),
                  loading: () => const Row(
                    children: [
                      SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2)),
                      SizedBox(width: 8),
                      Text('Loading todos...'),
                    ],
                  ),
                  error: (error, stack) => Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.red[100],
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text('Error: $error',
                        style: TextStyle(color: Colors.red[700])),
                  ),
                ),

            const SizedBox(height: 16),

            // Refresh button
            ElevatedButton(
              onPressed: () {
                ref.invalidate(userNameProvider);
                ref.invalidate(todosProvider);
              },
              child: const Text('Refresh'),
            ),
          ],
        ),
      ),
    );
  }
}

// =============================================================================
// 6. COMPREHENSIVE DEMO APP
// =============================================================================

/// Comprehensive Sugar demo showing all features in a single app
class ComprehensiveSugarDemo extends RxWidget {
  /// Creates the comprehensive Sugar demo widget
  const ComprehensiveSugarDemo({super.key});

  @override
  Widget buildRx(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🍯 Riverpod Sugar Demo'),
        backgroundColor: ref.watchValue(ProviderCreationExamples.isDarkMode)
            ? Colors.grey[850]
            : null,
        foregroundColor: ref.watchValue(ProviderCreationExamples.isDarkMode)
            ? Colors.white
            : null,
      ),
      backgroundColor: ref.watchValue(ProviderCreationExamples.isDarkMode)
          ? Colors.grey[900]
          : null,
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            CounterWidget(),
            SizedBox(height: 16),
            InlineBuilderExample(),
            SizedBox(height: 16),
            ConditionalRenderingExample(),
            SizedBox(height: 16),
            TodoListExample(),
            SizedBox(height: 16),
            BuiltInWidgetHelpersExample(),
            SizedBox(height: 16),
            AsyncValueExample(),
          ],
        ),
      ),
    );
  }
}

// =============================================================================
// 7. USAGE PATTERNS AND BEST PRACTICES
// =============================================================================

/// User-related state providers organized in a class
class UserStateProviders {
  /// User name provider
  static final name = ''.state;

  /// User email provider
  static final email = ''.state;

  /// Login status provider
  static final isLoggedIn = false.state;
}

/// App-level state providers
class AppStateProviders {
  /// Dark mode theme provider
  static final isDarkTheme = false.state;

  /// Selected language provider
  static final language = 'en'.state;

  /// Network status provider
  static final isOnline = true.state;

  /// Notifications enabled provider
  static final notificationsEnabled = true.state;
}

/// Form-related state providers
class FormProviders {
  /// First name field provider
  static final firstName = ''.state;

  /// Last name field provider
  static final lastName = ''.state;

  /// Email field provider
  static final email = ''.state;

  /// Form validation status provider
  static final isValid = false.state;

  /// Form submission status provider
  static final isSubmitting = false.state;
}

/// Validation utility for forms
class FormValidation {
  /// Validate the entire form and update isValid state
  static void validateForm(WidgetRef ref) {
    final firstName = ref.watchValue(FormProviders.firstName);
    final lastName = ref.watchValue(FormProviders.lastName);
    final email = ref.watchValue(FormProviders.email);

    final isValid =
        firstName.isNotEmpty && lastName.isNotEmpty && email.contains('@');

    FormProviders.isValid.setValue(ref, isValid);
  }
}

/// Example of custom widget using best practices
class UserProfileWidget extends RxWidget {
  /// Creates a user profile widget
  const UserProfileWidget({super.key});

  @override
  Widget buildRx(BuildContext context, WidgetRef ref) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // User info section
            ref.showEither(
              UserStateProviders.isLoggedIn,
              Column(
                children: [
                  ref.text(UserStateProviders.name,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold)),
                  ref.text(UserStateProviders.email),
                ],
              ),
              const Text('Please log in', style: TextStyle(color: Colors.grey)),
            ),

            // Login/logout button
            ElevatedButton(
              onPressed: () => UserStateProviders.isLoggedIn.toggle(ref),
              child: Text(ref.watchValue(UserStateProviders.isLoggedIn)
                  ? 'Logout'
                  : 'Login'),
            ),
          ],
        ),
      ),
    );
  }
}

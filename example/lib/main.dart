import 'package:flutter/material.dart';
// import removed: flutter_riverpod is re-exported by riverpod_sugar
import 'package:riverpod_sugar/riverpod_sugar.dart';
import 'ref_syntax_demo.dart';

// --- Providers using Enhanced Sugar Syntax ---

/// Ultra-concise provider creation using extension syntax
final counter = 0.state; // Creates StateProvider<int>
final userName = "Guest".text; // Creates StateProvider<String>
final isDarkMode = false.toggle; // Creates StateProvider<bool>

/// Traditional provider for comparison
final counterProvider = StateProvider((ref) => 0);

/// Async provider to demonstrate easyWhen usage
final userProvider = FutureProvider((ref) async {
  await Future.delayed(const Duration(seconds: 2));
  // To test the error state, uncomment the line below
  // throw 'Could not fetch user';
  return 'John Doe';
});

/// Provider for the search query in the debouncer example
final searchQueryProvider = StateProvider((ref) => '');

// --- Main App ---

/// Entry point for the Riverpod Sugar example app
void main() {
  runApp(const ProviderScope(child: MyApp()));
}

/// Main application widget
class MyApp extends StatelessWidget {
  /// Creates the app
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Riverpod Sugar Example',
      navigatorKey: SugarNavigation.navigatorKey, // Enable Navigation Sugar
      home: const HomeScreen(),
    );
  }
}

// --- HomeScreen ---

/// Home screen widget for the Riverpod Sugar example
class HomeScreen extends RxWidget {
  /// Creates the home screen
  const HomeScreen({super.key});

  /// Builds the reactive UI for the home screen
  @override
  Widget buildRx(BuildContext context, WidgetRef ref) {
    // Using the debouncer for the search field
    final debouncer = Debouncer(milliseconds: 500);

    return Scaffold(
      appBar: AppBar(
        title: const Text('🔥 Riverpod Sugar Demo'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Enhanced Syntax Showcase Header
              Card(
                color: Colors.deepPurple.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      const Text(
                        '✨ Enhanced Ref Syntax Demo',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 10),
                      // Showcase multiple syntax options
                      Text(
                          'Counter: ${counter.ref.text(ref)}', // Using text method
                          style: const TextStyle(fontSize: 18)),
                      Text('User: ${userName.ref(ref)}', // Using call operator
                          style: const TextStyle(fontSize: 18)),
                      counter.ref.textWidget(ref, // Direct widget method
                          style: const TextStyle(
                              color: Colors.purple,
                              fontWeight: FontWeight.bold,
                              fontSize: 16)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Enhanced Syntax Controls
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () => counter.increment(ref), // Extension method
                    child: const Text('+ Increment'),
                  ),
                  ElevatedButton(
                    onPressed: () => counter.decrement(ref), // Extension method
                    child: const Text('- Decrement'),
                  ),
                  ElevatedButton(
                    onPressed: () =>
                        counter.ref.set(ref, 0), // Enhanced ref syntax
                    child: const Text('Reset'),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Traditional comparison for education
              Card(
                color: Colors.grey.shade100,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      const Text('📱 Traditional Riverpod vs 🔥 Sugar Syntax:',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      const Text('Traditional: ref.watch(counterProvider)'),
                      Text('Sugar: counter.ref(ref) or counter.ref.text(ref)',
                          style: TextStyle(
                              color: Colors.green.shade700,
                              fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Navigation to detailed demo
              ElevatedButton.icon(
                onPressed: () => ref.pushPage(const RefSyntaxDemo()),
                icon: const Icon(Icons.rocket_launch),
                label: const Text('🚀 See Complete Ref Syntax Demo'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.all(16),
                ),
              ),
              const SizedBox(height: 12),

              // Navigation Sugar Demo
              ElevatedButton.icon(
                onPressed: () => ref.showSnackBar(
                  'Navigation Sugar Demo: Use ref.pushPage(), ref.pop(), ref.showBottomSheet() etc!',
                  backgroundColor: Colors.green,
                  textColor: Colors.white,
                ),
                icon: const Icon(Icons.navigation),
                label: const Text('🚀 Navigation Sugar Demo'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.all(16),
                ),
              ),
              const SizedBox(height: 20),

              // 1. RxBuilder Example (keep for compatibility)
              const Text('RxBuilder Example:', textAlign: TextAlign.center),
              RxBuilder(
                builder: (context, ref) {
                  final count = ref.watch(counterProvider);
                  return Text('$count',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headlineMedium);
                },
              ),
              const SizedBox(height: 20),

              // 2. easyWhen Example
              const Text('easyWhen Async Helper:', textAlign: TextAlign.center),
              ref.watch(userProvider).easyWhen(
                    data: (name) => Text('Welcome, $name!',
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 18)),
                  ),
              const SizedBox(height: 20),

              // 3. Debouncer Example with enhanced syntax
              const Text('Debouncer + Enhanced Syntax:',
                  textAlign: TextAlign.center),
              TextField(
                decoration:
                    const InputDecoration(labelText: 'Update username...'),
                onChanged: (value) {
                  debouncer.run(() {
                    userName.ref.set(ref, value); // Using enhanced syntax!
                  });
                },
              ),
              const SizedBox(height: 8),
              Text('Live Username: ${userName.ref(ref)}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => counter.increment(ref), // Using extension method
        child: const Icon(Icons.add),
      ),
    );
  }
}

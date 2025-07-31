import 'package:flutter/material.dart';
// import removed: flutter_riverpod is re-exported by riverpod_sugar
import 'package:riverpod_sugar/riverpod_sugar.dart';

// --- Providers ---

/// Simple counter provider for demonstration
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
    return const MaterialApp(
      title: 'Riverpod Sugar Example',
      home: HomeScreen(),
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
      appBar: AppBar(title: const Text('Riverpod Sugar')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 1. RxBuilder Example
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

              // 3. Debouncer Example
              const Text('Debouncer Utility:', textAlign: TextAlign.center),
              TextField(
                decoration: const InputDecoration(labelText: 'Search...'),
                onChanged: (value) {
                  debouncer.run(() {
                    ref.read(searchQueryProvider.notifier).state = value;
                  });
                },
              ),
              RxBuilder(builder: (context, ref) {
                final query = ref.watch(searchQueryProvider);
                return Text('Debounced Query: $query',
                    textAlign: TextAlign.center);
              }),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => ref.read(counterProvider.notifier).state++,
        child: const Icon(Icons.add),
      ),
    );
  }
}

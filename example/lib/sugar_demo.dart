import 'package:flutter/material.dart';
import 'package:riverpod_sugar/riverpod_sugar.dart';

/// Ultra-simple counter app using one-liner Sugar extensions
/// This demonstrates the flexibility and freedom of the new extensions

// Create providers using the flexible extension syntax
final counter = 0.state; // Integer provider
final name = "Guest".text; // String provider
final isDark = false.toggle; // Boolean provider
final todos = <String>[].items; // List provider

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Sugar Demo - Full Freedom',
      home: HomeScreen(),
    );
  }
}

/// Demonstration of flexible Sugar extensions
class HomeScreen extends RxWidget {
  const HomeScreen({super.key});

  @override
  Widget buildRx(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sugar Demo - Full Freedom')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Display counter with full flexibility - you can use it anywhere!
            Text('Counter: ${ref.watchValue(counter)}',
                style: const TextStyle(fontSize: 24)),

            const SizedBox(height: 20),

            // Custom counter controls - full freedom to design your UI
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () => counter.decrement(ref),
                  child: const Text('- Decrease'),
                ),
                ElevatedButton(
                  onPressed: () => counter.increment(ref),
                  child: const Text('+ Increase'),
                ),
                ElevatedButton(
                  onPressed: () => counter.addValue(ref, 10),
                  child: const Text('+10'),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Text input - use your own TextField design
            TextField(
              decoration: const InputDecoration(
                labelText: 'Your name',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) => name.updateText(ref, value),
            ),
            const SizedBox(height: 10),

            // Display text anywhere you want - full freedom
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text('Hello, ${ref.watchValue(name)}!',
                  style: const TextStyle(fontSize: 18)),
            ),

            const SizedBox(height: 20),

            // Toggle with your own custom switch design
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Dark Mode'),
                Switch(
                  value: ref.watchValue(isDark),
                  onChanged: (value) => isDark.setValue(ref, value),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Conditional widget - use anywhere with any widget
            ref.showWhen(
                isDark,
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade800,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text('Dark mode is ON!',
                      style: TextStyle(color: Colors.white)),
                )),

            const SizedBox(height: 20),

            // Todo functionality with full control
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
                const SizedBox(width: 10),
                IconButton(
                  onPressed: () => todos.clearAll(ref),
                  icon: const Icon(Icons.clear_all),
                  tooltip: 'Clear all todos',
                ),
              ],
            ),

            const SizedBox(height: 10),

            // Display count with your own styling
            Text('Total todos: ${todos.getLength(ref)}',
                style: const TextStyle(fontWeight: FontWeight.bold)),

            const SizedBox(height: 10),

            // List display with full control over design
            Expanded(
              child: ListView.builder(
                itemCount: ref.watchValue(todos).length,
                itemBuilder: (context, index) {
                  final todo = ref.watchValue(todos)[index];
                  return Card(
                    child: ListTile(
                      title: Text(todo),
                      trailing: IconButton(
                        onPressed: () => todos.removeItem(ref, todo),
                        icon: const Icon(Icons.delete, color: Colors.red),
                      ),
                    ),
                  );
                },
              ),
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
}

/// More examples showing the flexibility and freedom
class FlexibilityExamples extends RxWidget {
  const FlexibilityExamples({super.key});

  @override
  Widget buildRx(BuildContext context, WidgetRef ref) {
    // Create providers with meaningful names for your use case
    final loading = false.loading;
    final price = 19.99.price;
    final rating = 4.5.price; // You can use .price for any double!
    final temperature = 23.state; // You can use .state for any int!
    final isOnline = true.toggle; // You can use .toggle for any boolean!

    return Column(
      children: [
        // Use the values anywhere you need them
        if (ref.watchValue(loading))
          const CircularProgressIndicator()
        else
          Text('Price: \$${ref.watchValue(price).toStringAsFixed(2)}'),

        // Rating display - use double provider anywhere
        Row(
          children: [
            const Text('Rating: '),
            ...List.generate(
                5,
                (index) => Icon(
                      index < ref.watchValue(rating)
                          ? Icons.star
                          : Icons.star_border,
                      color: Colors.amber,
                    )),
          ],
        ),

        // Temperature display - use int provider anywhere
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: ref.watchValue(temperature) > 25
                ? Colors.red.shade100
                : Colors.blue.shade100,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text('${ref.watchValue(temperature)}°C'),
        ),

        // Control buttons - full freedom to design
        Wrap(
          spacing: 8,
          children: [
            ElevatedButton(
              onPressed: () => loading.setTrue(ref),
              child: const Text('Start Loading'),
            ),
            ElevatedButton(
              onPressed: () => loading.setFalse(ref),
              child: const Text('Stop Loading'),
            ),
            ElevatedButton(
              onPressed: () => price.addValue(ref, 5.0),
              child: const Text('Increase Price'),
            ),
            ElevatedButton(
              onPressed: () => temperature.addValue(ref, 1),
              child: const Text('Heat Up'),
            ),
            ElevatedButton(
              onPressed: () => isOnline.toggle(ref),
              child:
                  Text(ref.watchValue(isOnline) ? 'Go Offline' : 'Go Online'),
            ),
          ],
        ),

        // Status indicator - use boolean anywhere
        ref.showEither(
          isOnline,
          const Chip(
            label: Text('Online'),
            backgroundColor: Colors.green,
          ),
          const Chip(
            label: Text('Offline'),
            backgroundColor: Colors.red,
          ),
        ),
      ],
    );
  }
}

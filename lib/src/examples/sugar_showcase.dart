import 'package:flutter/material.dart';
import 'package:riverpod_sugar/riverpod_sugar.dart';

/// Comprehensive examples showcasing all Riverpod Sugar features
/// This file serves as both documentation and testing for the library

// Example providers using Sugar extensions
/// Counter provider for demonstration
final counter = 0.state;

/// User name provider for demonstration
final userName = 'Guest'.state;

/// Dark mode toggle provider
final isDarkMode = false.state;

/// Loading state provider
final isLoading = false.state;

/// Volume control provider (using .state for any double)
final volume = 50.0.state; // Using .state for any double

/// Color selection provider using extension syntax
final selectedColor = <Color>[Colors.blue, Colors.red, Colors.green].state;

/// Notifications enabled provider
final notifications = true.state;

/// Todo list provider
final todos = <String>[].state;

/// Rating provider
final rating = 4.5.state;

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
                ref.showEither(isLoading, const CircularProgressIndicator(),
                    const SizedBox.shrink()),
              ],
            ),

            // Section 2: Interactive Controls
            _buildSection(
              title: '2. Interactive Controls',
              children: [
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
                        onSubmitted: (value) {
                          if (value.isNotEmpty) {
                            todos.add(ref, value);
                          }
                        },
                        decoration: const InputDecoration(
                          hintText: 'Add a new todo...',
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () => todos.clear(ref),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ...ref.watch(todos).map((todo) => ListTile(title: Text(todo))),
              ],
            ),

            // Section 5: Advanced Usage
            _buildSection(
              title: '5. Advanced Usage',
              children: [
                Text('Volume: ${ref.watch(volume).toStringAsFixed(0)}'),
                Slider(
                  value: ref.watch(volume),
                  min: 0,
                  max: 100,
                  onChanged: (value) => volume.set(ref, value),
                ),
                Text('Rating: ${ref.watch(rating).toStringAsFixed(1)}'),
                RatingBar(
                  rating: ref.watch(rating),
                  onRatingUpdate: (value) => rating.set(ref, value),
                ),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          counter.increment(ref);
          userName.set(ref, 'User ${ref.read(counter)}');
          isLoading.toggle(ref);
          Future.delayed(const Duration(seconds: 1), () {
            isLoading.toggle(ref);
          });
        },
        child: const Icon(Icons.play_arrow),
      ),
    );
  }

  Widget _buildSection(
      {required String title, required List<Widget> children}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style:
                  const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          ...children,
          const Divider(height: 24),
        ],
      ),
    );
  }
}

/// A simple rating bar widget for demonstration
class RatingBar extends StatelessWidget {
  /// The current rating
  final double rating;

  /// Callback when the rating is updated
  final ValueChanged<double> onRatingUpdate;

  /// Creates a rating bar
  const RatingBar(
      {super.key, required this.rating, required this.onRatingUpdate});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        return IconButton(
          icon: Icon(
            index < rating ? Icons.star : Icons.star_border,
            color: Colors.amber,
          ),
          onPressed: () => onRatingUpdate(index + 1.0),
        );
      }),
    );
  }
}

/// A simple showcase of all Sugar features
void main() {
  runApp(
    const ProviderScope(
      child: MaterialApp(
        home: SugarShowcase(),
      ),
    ),
  );
}

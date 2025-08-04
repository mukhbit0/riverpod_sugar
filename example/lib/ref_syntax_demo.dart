import 'package:flutter/material.dart';
import 'package:riverpod_sugar/riverpod_sugar.dart';

/// Demonstrates the enhanced .ref syntax - ultra-concise provider access
/// This showcases the StateProviderRefAccess class with call operator

// Create providers using extension syntax
final counter = 0.state;
final userName = "Guest".text;
final message = "Hello".text;

class RefSyntaxDemo extends RxWidget {
  const RefSyntaxDemo({super.key});

  @override
  Widget buildRx(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('🔥 Enhanced Ref Syntax Demo')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            const Text(
              '✨ Multiple Syntax Options - Choose Your Style!',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            // Traditional approach
            Card(
              color: Colors.blue.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('📱 Traditional Approach:',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    Text('Count: ${ref.watchValue(counter)}'),
                    Text('User: ${ref.watchValue(userName)}'),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Enhanced ref syntax
            Card(
              color: Colors.green.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('🔥 Enhanced Ref Syntax:',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    Text('Count: ${counter.ref.text(ref)}'),     // Descriptive method
                    Text('User: ${userName.ref(ref)}'),          // Call operator - shortest!
                    counter.ref.textWidget(ref,                  // Direct widget
                        style: const TextStyle(color: Colors.purple, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Reading vs Watching
            Card(
              color: Colors.orange.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('⚡ Watch vs Read:',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    Text('Watch (rebuilds): ${counter.ref.watch(ref)}'),
                    ElevatedButton(
                      onPressed: () {
                        // Demonstrate read (one-time access)
                        final currentValue = counter.ref.read(ref);
                        message.ref.set(ref, 'Read value: $currentValue');
                      },
                      child: const Text('Read Current Value (no rebuild)'),
                    ),
                    Text('Message: ${message.ref(ref)}'),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Controls
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () => counter.increment(ref),
                  child: const Text('+ Increment'),
                ),
                ElevatedButton(
                  onPressed: () => counter.decrement(ref),
                  child: const Text('- Decrement'),
                ),
                ElevatedButton(
                  onPressed: () => counter.ref.set(ref, 0), // Using enhanced syntax!
                  child: const Text('Reset'),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // TextField using enhanced syntax
            TextField(
              decoration: const InputDecoration(
                labelText: 'Update username',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) => userName.ref.set(ref, value), // Enhanced syntax!
            ),

            const Spacer(),

            // Code examples
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('💡 Code Examples:',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Text('counter.ref.text(ref)    // Text method'),
                  Text('userName.ref(ref)       // Call operator'),
                  Text('counter.ref.watch(ref)  // Watch with rebuilds'),
                  Text('counter.ref.read(ref)   // Read once, no rebuilds'),
                  Text('counter.ref.set(ref, 5) // Set value'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

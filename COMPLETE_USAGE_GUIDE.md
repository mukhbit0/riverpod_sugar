# 📖 **Riverpod Sugar: Complete Usage Guide**

This guide shows you how to use every feature of Riverpod Sugar with full freedom and flexibility, using the latest, ultra-concise API.

## 🎯 **Philosophy: Full Freedom, Not Restrictions**

Riverpod Sugar gives you powerful extensions that work **anywhere** you need them. We don't force you into specific widgets or patterns—you have complete control over your UI design while we make state management incredibly simple.

---

## 🔥 **1. Creating Providers - One Universal Extension**

### **Instant Provider Creation with `.state`**

```dart
// Create providers in ONE WORD for any type
final counter = 0.state;           // StateProvider<int>
final userName = "John".state;     // StateProvider<String>  
final isDarkMode = false.state;    // StateProvider<bool>
final userList = <String>[].state; // StateProvider<List<String>>
final progress = 0.75.state;       // StateProvider<double>
final selectedDate = DateTime.now().state; // StateProvider<DateTime>
```

---

## ✨ **2. Concise Provider Access with `.ref`**

After creating a provider with `.state`, you can access its value with the ultra-concise `.ref` syntax. It's designed to be brief, readable, and powerful.

```dart
// Traditional Riverpod - still works!
final count = ref.watch(counter);
final name = ref.watch(userName);

// Concise `.ref` syntax - shorter and cleaner!
final count = counter.ref.watch(ref); // Explicit `watch`
final name = userName.ref(ref);       // Even shorter with call operator `()`!

// Update state
counter.ref.set(ref, 10);

// Read once without watching
final currentCount = counter.ref.read(ref);

// Get the value as a String
final countString = counter.ref.text(ref); // "10"

// Get the value directly as a Text widget
final countWidget = counter.ref.textWidget(ref, style: myStyle);
```

---

## ⚡ **3. State Operations - Full Control**

### **Integer Operations**

```dart
final points = 0.state;
points.increment(ref);              // +1
points.decrement(ref);              // -1
points.addValue(ref, 50);           // Add 50
points.subtractValue(ref, 10);      // Subtract 10
points.set(ref, 1000);              // Set specific value
points.ref.set(ref, 42);            // Also works with .ref
```

### **Double Operations**

```dart
final price = 19.99.state;
price.addValue(ref, 5.0);           // Add 5.0
price.subtractValue(ref, 2.50);     // Subtract 2.50
price.set(ref, 24.99);              // Set specific value
```

### **Boolean Operations**

```dart
final darkMode = false.state;
darkMode.toggle(ref);               // Switch true/false
darkMode.set(ref, true);            // Set to true
darkMode.set(ref, false);           // Set to false
```

### **String Operations**

```dart
final message = "Hello".state;
message.set(ref, "New message");     // Replace text
message.set(ref, "");                // Clear to ""
message.set(ref, message.ref(ref) + " World!"); // Append text
```

### **List Operations**

```dart
final todos = <String>[].state;
todos.add(ref, "New task");             // Add single item
todos.remove(ref, "Old task");          // Remove specific item
todos.clear(ref);                        // Clear all items
```

---

## 🧩 **4. Enhanced WidgetRef - Flexible Watching**

You can use the `.ref` syntax or the standard Riverpod approach anywhere:

```dart
class MyWidget extends RxWidget {
  @override
  Widget buildRx(BuildContext context, WidgetRef ref) {
    final count = counter.ref(ref); // or ref.watch(counter)
    final name = userName.ref(ref);
    return Column(
      children: [
        Text('Count: ${counter.ref.text(ref)}'),
        Text('User: ${userName.ref(ref)}'),
      ],
    );
  }
}
```

---

## 🎭 **5. RxWidget - Clean Reactive Widgets**

Replace verbose `ConsumerWidget` with the clean `RxWidget`:

```dart
class CounterWidget extends RxWidget {
  @override
  Widget buildRx(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        Text('${counter.ref(ref)}'),
        ElevatedButton(
          onPressed: () => counter.increment(ref),
          child: Text('Increment'),
        ),
      ],
    );
  }
}
```

---

## 🎭 **6. easyWhen - Simplified AsyncValue**

```dart
final userProvider = FutureProvider<User>((ref) async {
  return await apiService.fetchUser();
});

class UserWidget extends RxWidget {
  @override
  Widget buildRx(BuildContext context, WidgetRef ref) {
    return ref.watch(userProvider).easyWhen(
      data: (user) => UserProfile(user),  // Only handle data case
      // loading & error handled automatically!
    );
  }
}
```

---

## 📝 **7. Form Management**

```dart
final formManagerProvider = StateNotifierProvider<FormManager, FormState>((ref) {
  return FormManager();
});

class RegistrationForm extends RxWidget {
  @override
  Widget buildRx(BuildContext context, WidgetRef ref) {
    final formState = ref.watch(formManagerProvider);
    final formManager = ref.read(formManagerProvider.notifier);
    // ... form fields and validation ...
  }
}
```

---

## 🔗 **8. Provider Combiners**

```dart
final userProvider = FutureProvider<User>((ref) => fetchUser());
final settingsProvider = FutureProvider<Settings>((ref) => fetchSettings());

final combinedProvider = ProviderCombiners.combine2(
  userProvider,
  settingsProvider,
);

class Dashboard extends RxWidget {
  @override
  Widget buildRx(BuildContext context, WidgetRef ref) {
    final combined = ref.watch(combinedProvider);
    return combined.easyWhen(
      data: ((user, settings)) => DashboardContent(user, settings),
    );
  }
}
```

---

## ⏱️ **9. Debouncing**

```dart
class SearchWidget extends RxWidget {
  final debouncer = Debouncer(milliseconds: 300);
  @override
  Widget buildRx(BuildContext context, WidgetRef ref) {
    return TextField(
      onChanged: (query) {
        debouncer.run(() {
          searchQuery.set(ref, query);
        });
      },
    );
  }
}
```

---

## 🎨 **10. Best Practices & Patterns**

### **Organize Your Providers**

```dart
class AppState {
  static final theme = false.state;      // Dark mode
  static final language = "en".state;   // Current language
  static final isOnline = true.state;    // Network status
}
```

---

## 🚀 **11. Migration from Standard Riverpod**

**Step 1: Replace Provider Creation**
```dart
// Before
final counterProvider = StateProvider<int>((ref) => 0);
// After
final counter = 0.state;
```

**Step 2: Update State Operations**
```dart
// Before
ref.read(counterProvider.notifier).state++;
// After
counter.increment(ref);
```

**Step 3: Convert Widgets**
```dart
// Before
class MyWidget extends ConsumerWidget {
  Widget build(BuildContext context, WidgetRef ref) {
    return Text('${ref.watch(counterProvider)}');
  }
}
// After
class MyWidget extends RxWidget {
  Widget buildRx(BuildContext context, WidgetRef ref) {
    return Text('${counter.ref(ref)}');
  }
}
```

**Step 4: Simplify AsyncValue Handling**
```dart
// Before
ref.watch(userProvider).when(
  data: (user) => UserWidget(user),
  loading: () => CircularProgressIndicator(),
  error: (e, s) => Text('Error: $e'),
);
// After
ref.watch(userProvider).easyWhen(
  data: (user) => UserWidget(user),
);
```

---

## 🎯 **Summary: The Power of Freedom**

Riverpod Sugar gives you:

✅ **Instant provider creation** with `.state` extension  
✅ **Ultra-concise access** with `.ref` and helpers like `.text()` and `.textWidget()`  
✅ **Descriptive method names** that clearly show intent  
✅ **Full UI freedom**—use values anywhere, design any widget  
✅ **Type flexibility**—use `.state` for any type  
✅ **Complete compatibility** with standard Riverpod  
✅ **Enhanced developer experience** with 80% less boilerplate  

**You're not locked into specific widgets or patterns—you have complete control over your UI while we make state management incredibly simple!**

---

*Made with ❤️ for developers who value both simplicity and freedom*

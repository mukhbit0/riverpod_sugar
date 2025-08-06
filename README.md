# 🍯 Riverpod Sugar

[![pub package](https://img.shields.io/pub/v/riverpod_sugar.svg)](https://pub.dev/packages/riverpod_sugar)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

**The sweetest way to use Riverpod!** A collection of lightweight widgets, utilities, and revolutionary extensions that dramatically reduce boilerplate and improve developer ergonomics when using `flutter_riverpod`.

## 🚀 **REVOLUTIONARY: The `.state` Extension**

**Riverpod Sugar** makes state management simple with a single, unified extension: **`.state`**.

### **Before vs After**

**Traditional Riverpod** (20+ lines for a simple counter):

```dart
final counterProvider = StateProvider<int>((ref) => 0);

class CounterWidget extends ConsumerWidget {
  const CounterWidget({super.key});
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final count = ref.watch(counterProvider);
    return Column(
      children: [
        Text('$count'),
        ElevatedButton(
          onPressed: () => ref.read(counterProvider.notifier).state++,
          child: const Text('Increment'),
        ),
      ],
    );
  }
}
```

**With a single `.state` extension** (5 lines for the same result):

```dart
final counter = 0.state; // ONE WORD!

class CounterWidget extends RxWidget {
  @override
  Widget buildRx(context, ref) => Column(children: [
    Text('${ref.watch(counter)}'),
    ElevatedButton(onPressed: () => counter.increment(ref), child: const Text('+')),
  ]);
}
```

## ✨ **Complete Feature Set**

- **🔥 Unified `.state` Extension**: Create a `StateProvider` for `int`, `String`, `bool`, `List`, `Color`, `ThemeData`, `Map`, `DateTime`, `Enum`, all controllers, and more with a single, consistent extension.
- **⚡ Ultra-Simple Validation**: The shortest validation syntax in Flutter! Just 2 words: `"".emailState`, `"".passwordState`, `0.ageState`.
- **🎯 Fluent Validation Builder**: Custom validation with readable syntax: `"".validationBuilder.contains('@')(null, 'error')`.
- **⚡ RxWidget Family**: Drop-in replacements for `ConsumerWidget` with cleaner syntax.
- **🎭 easyWhen**: Simplified async state handling with default loading/error states.
- **🚀 Advanced Provider Extensions**: Powerful manipulation methods for all supported types (e.g., `myColor.brighten(ref)`, `myList.add(ref, item)`).
- **🧩 Utility Widgets**: `RxBuilder`, `RxShow`, and more for common UI patterns.

---

## 🔥 **NEW: Ultra-Simple Validation (v1.0.9)**

**The shortest validation syntax in Flutter!** Create validated state providers in just 2 words with built-in error handling.

### **Instant Validation - Just 2 Words!**

```dart
// Ultra-short validated providers (shortest possible!)
final email = "".emailState;        // Just 2 words!
final password = "".passwordState;  // Just 2 words!
final age = 0.ageState;             // Just 2 words!

// Use in your UI with one-liner error handling
TextField(
  onChanged: (value) => email.set(ref, value),
  decoration: InputDecoration(
    labelText: 'Email',
    errorText: email.errorMessage(ref), // One liner!
  ),
)

// Check validation status
if (email.isValid(ref) && password.isValid(ref)) {
  // Form is valid - submit!
}
```

### **Custom Fluent Validation**

For power users who need custom validation rules:

```dart
// Fluent builder API with readable syntax
final customEmail = "".validationBuilder
    .contains('@')(null, 'Must contain @ symbol');

final strongPassword = "".validationBuilder
    .minLength(8)(null, 'Password must be at least 8 characters');

final adultAge = 0.validationBuilder
    .min(18)(null, 'Must be 18 or older');

// Or completely custom validation
final custom = "".validState((value) => 
    value.length > 3 ? null : "Too short");
```

**📖 See [VALIDATION_GUIDE.md](VALIDATION_GUIDE.md) for comprehensive examples and advanced usage.**

---

### 🔥 **The `.state` Extension - The Game Changer**

Create providers instantly with a unified and consistent syntax. The power comes from your variable name, not a confusing set of extensions.

```dart
// Create providers in ONE WORD for any type
final counter = 0.state;           // StateProvider<int>
final userName = "John".state;     // StateProvider<String>  
final isDarkMode = false.state;    // StateProvider<bool>
final userList = <String>[].state; // StateProvider<List<String>>
final progress = 0.75.state;       // StateProvider<double>
final selectedDate = DateTime.now().state; // StateProvider<DateTime>

// Update state in ONE LINE with clear, descriptive names
counter.increment(ref);
userName.update((_) => "Jane");
isDarkMode.toggle(ref);
userList.add(ref, "New User");
```

### 🎨 **Advanced Provider Extensions**

Instantly create and manage providers for complex Flutter types with zero boilerplate.

```dart
// 🎨 Color providers with smart state management
final primaryColor = Colors.blue.state;
primaryColor.brighten(ref, 0.2);                 // Brighten color
primaryColor.darken(ref, 0.1);                   // Darken color
final hex = primaryColor.hexString(ref);         // Get hex string

// 🎭 ThemeData providers
final appTheme = ThemeData.light().state;
appTheme.switchToDark(ref);                      // Switch to dark theme
final brightness = appTheme.brightness(ref);     // Get brightness

// 🎮 Controller providers
final pageController = PageController().state;
pageController.nextPage(ref);                    // Go to next page

final textController = TextEditingController().state;
textController.setText(ref, 'New text');         // Set text

final scrollController = ScrollController().state;
scrollController.scrollToTop(ref);               // Scroll to top

// 📋 List providers with standard Dart methods
final todoItems = <String>[].state;
todoItems.add(ref, 'New task');                  // Add item
todoItems.remove(ref, 'Old task');               // Remove item
todoItems.update(ref, 0, 'Updated Task');        // Update at index
todoItems.clear(ref);                            // Clear all

// 🗺️ Map providers with type safety
final userSettings = <String, dynamic>{}.state;
userSettings.setValue(ref, 'theme', 'dark');     // Set key-value
final theme = userSettings.getValue(ref, 'theme'); // Get value by key
userSettings.removeKey(ref, 'oldSetting');       // Remove by key

// 📅 DateTime & TimeOfDay providers
final selectedDate = DateTime.now().state;
selectedDate.addDays(ref, 7);                    // Add a week
final formatted = selectedDate.formatDate(ref);  // "2025-08-06"

final selectedTime = TimeOfDay.now().state;
selectedTime.addMinutes(ref, -30);               // Go back 30 min
final formatted = selectedTime.formatTime(ref);  // "14:30"

// And many more: Set, FocusNode, Locale, Enum...
```

### 🔥 **Ultra-Simple Validation - New in v1.0.9**

**The shortest validation syntax in Flutter!** Create validated state providers with built-in error handling in just 2 words.

```dart
// 🔥 Ultra-short validated providers (shortest possible!)
final email = "".emailState;        // Just 2 words - includes email validation!
final password = "".passwordState;  // Just 2 words - includes password validation!
final age = 0.ageState;             // Just 2 words - includes age validation!

// 🎯 Custom fluent validation for power users
final customEmail = "".validationBuilder
    .contains('@')
    .minLength(5)(null, 'Email must contain @ and be 5+ chars');

final strongPassword = "".validationBuilder
    .minLength(8)
    .contains(RegExp(r'[A-Z]'))(null, 'Must be 8+ chars with uppercase');

final adultAge = 0.validationBuilder
    .min(18)
    .max(120)(null, 'Age must be between 18-120');

// 🛠️ Or completely custom validation function
final custom = "".validState((value) => 
    value.contains('@') && value.length > 5 
        ? null 
        : "Invalid email format");
```

**Using validation in your UI:**

```dart
class LoginForm extends RxWidget {
  @override
  Widget buildRx(BuildContext context, WidgetRef ref) {
    final isFormValid = email.isValid(ref) && password.isValid(ref);
    
    return Column(children: [
      // Email field with automatic error display
      TextField(
        onChanged: (value) => email.set(ref, value),
        decoration: InputDecoration(
          labelText: 'Email',
          errorText: email.errorMessage(ref), // One liner!
        ),
      ),
      
      // Password field with automatic error display
      TextField(
        onChanged: (value) => password.set(ref, value),
        obscureText: true,
        decoration: InputDecoration(
          labelText: 'Password',
          errorText: password.errorMessage(ref), // One liner!
        ),
      ),
      
      // Submit button - automatically enabled/disabled
      ElevatedButton(
        onPressed: isFormValid ? () => submitForm(ref) : null,
        child: const Text('Login'),
      ),
    ]);
  }
}
```

**📖 See [VALIDATION_GUIDE.md](VALIDATION_GUIDE.md) for complete validation documentation with advanced examples.**

### 🔥 **Concise Provider Access with `.ref`**

After creating a provider with `.state`, you can access its value with the ultra-concise `.ref` syntax. It's designed to be brief, readable, and powerful.

**Choose your style:**

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
```

**The `.ref` syntax also brings back convenient helpers:**

```dart
// Get the value as a String
final countString = counter.ref.text(ref); // "10"

// Get the value directly as a Text widget
final countWidget = counter.ref.textWidget(ref, style: myStyle);
```

## 🚀 **Quick Start**

### 1. **Installation**

Add to your `pubspec.yaml`:

```yaml
dependencies:
  riverpod_sugar: ^1.1.0
```

### 2. **Import and Use**

```dart
import 'package:riverpod_sugar/riverpod_sugar.dart';

// Create providers instantly with the .state extension
final counter = 0.state;
final name = "Anonymous".state;
final isDark = false.state;

// Use the clean RxWidget for your UI
class MyApp extends RxWidget {
  @override
  Widget buildRx(BuildContext context, WidgetRef ref) {
    return Column(children: [
      Text('Counter: ${ref.watch(counter)}'),
      ElevatedButton(onPressed: () => counter.increment(ref), child: const Text('+')),
      Text('Name: ${ref.watch(name)}'),
      Switch(
        value: ref.watch(isDark),
        onChanged: (_) => isDark.toggle(ref),
      ),
    ]);
  }
}
```

### 3. **That's it!** 🎉

You now have ultra-concise state management that's 80% less code than traditional Riverpod!

## 📚 **Complete Documentation**

### 🎯 **RxWidget Family - Clean Syntax**

Replace verbose `ConsumerWidget` with the clean `RxWidget`:

**Before (Standard Riverpod):**

```dart
class CounterWidget extends ConsumerWidget {
  const CounterWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final count = ref.watch(counterProvider);
    return Text('Count: $count');
  }
}
```

**After (With RxWidget):**

```dart
class CounterWidget extends RxWidget {
  @override
  Widget buildRx(BuildContext context, WidgetRef ref) {
    final count = ref.watch(counter); // Use the provider directly
    return Text('Count: $count');
  }
}
```

| Widget           | Use Case                                                     |
| ---------------- | ------------------------------------------------------------ |
| `RxWidget`         | Replaces `ConsumerWidget` with cleaner `buildRx` syntax.     |
| `RxStatefulWidget` | Replaces `ConsumerStatefulWidget`.                           |
| `RxBuilder`        | Inline reactive widgets without creating new classes.        |
| `RxShow`           | Conditional rendering based on a boolean provider's state. |

### 🎭 **easyWhen - Simplified AsyncValue Handling**

**Before (Standard Riverpod):**

```dart
ref.watch(userProvider).when(
  data: (user) => Text('Hello ${user.name}!'),
  loading: () => const CircularProgressIndicator(),
  error: (error, stack) => Text('Error: $error'),
)
```

**After (With easyWhen):**

```dart
ref.watch(userProvider).easyWhen(
  data: (user) => Text('Hello ${user.name}!'),
  // loading & error widgets are provided automatically!
)
```

| Extension | Purpose |
|-----------|---------|
| `easyWhen()` | Simplified async state handling with defaults |
| `mapData()` | Transform data while preserving async state |
| `hasDataWhere()` | Check conditions on async data |
| `dataOrNull` | Get data or null safely |

### 📝 **FormManager - Complete Form Validation**

```dart
final formManagerProvider = StateNotifierProvider<FormManager, FormState>((ref) {
  return FormManager();
});

class RegistrationForm extends RxWidget {
  @override
  Widget buildRx(BuildContext context, WidgetRef ref) {
    final formState = ref.watch(formManagerProvider);
    final formManager = ref.read(formManagerProvider.notifier);
    
    return Column(
      children: [
        TextFormField(
          decoration: InputDecoration(
            labelText: 'Email',
            errorText: formState.getError('email'),
          ),
          onChanged: (value) {
            formManager.validateField(
              'email',
              value,
              CommonValidators.combine([
                CommonValidators.required('Email is required'),
                CommonValidators.email('Please enter a valid email'),
              ]),
            );
          },
        ),
        ElevatedButton(
          onPressed: formState.isValid ? () => _submitForm() : null,
          child: Text('Submit'),
        ),
      ],
    );
  }
}
```

| Component | Purpose |
|-----------|---------|
| `FormManager` | Manages form validation state |
| `CommonValidators` | Pre-built validation functions (email, required, minLength, etc.) |
| `FormState` | Immutable form state with error tracking |

### 🔗 **Provider Combiners - Intelligent Combination**

```dart
final userProvider = FutureProvider<User>((ref) => fetchUser());
final settingsProvider = FutureProvider<Settings>((ref) => fetchSettings());

// Combine multiple providers with intelligent error/loading handling
final combinedProvider = ProviderCombiners.combine2(
  userProvider,
  settingsProvider,
);

// Use in widget
class UserDashboard extends RxWidget {
  @override
  Widget buildRx(BuildContext context, WidgetRef ref) {
    final combined = ref.watch(combinedProvider);
    
    return combined.easyWhen(
      data: ((user, settings)) => DashboardContent(user, settings),
    );
  }
}
```

| Combiner | Purpose |
|----------|---------|
| `combine2/3/4()` | Combine multiple providers into tuples |
| `combineList()` | Combine list of same-type providers |
| `AsyncProviderCombiners` | Smart async provider combination |
| `map()` | Transform provider values |

### ⏱️ **Advanced Debouncer - Smart Delay**

```dart
// Basic debouncing for search
final debouncer = Debouncer(milliseconds: 300);
onChanged: (query) => debouncer.run(() => search(query));

// Advanced debouncing with custom strategies
final advancedDebouncer = AdvancedDebouncer(
  milliseconds: 300,
  maxWait: 2000,     // Force execution after 2 seconds max
  leading: true,     // Execute immediately on first call
  trailing: true,    // Execute after delay
);
```

| Utility | Purpose |
|---------|---------|
| `Debouncer` | Simple delay function execution |
| `AdvancedDebouncer` | Advanced with leading/trailing/maxWait options |

## 🔥 **Revolutionary Sugar Extensions Reference**

### **Create Providers Instantly**
```dart
// Numbers
final counter = 0.state;           // StateProvider<int>
final price = 19.99.state;         // StateProvider<double>

// Strings  
final name = "John".state;          // StateProvider<String>
final query = "".state;           // StateProvider<String>

// Booleans
final isDark = false.state;       // StateProvider<bool>
final isLoading = false.state;   // StateProvider<bool>
final isVisible = true.state;    // StateProvider<bool>

// Lists
final todos = <String>[].state;    // StateProvider<List<String>>
final tasks = <Task>[].state;      // StateProvider<List<Task>>

// Colors & Themes
final primaryColor = const Color(0xFF6750A4).state;      // StateProvider<Color>
final accentColor = Colors.orange.state;                // StateProvider<Color>
final currentTheme = ThemeData.light().state;            // StateProvider<ThemeData>

// Controllers
final pageController = PageController().state;           // StateProvider<PageController>
final textController = TextEditingController().state; // StateProvider<TextEditingController>
final scrollController = ScrollController().state;       // StateProvider<ScrollController>

// Maps & Complex Types
final configMap = <String, dynamic>{}.state;             // StateProvider<Map<String, dynamic>>
final settingsMap = <String, bool>{}.state;           // StateProvider<Map<String, bool>>
final duration = Duration(seconds: 2).state;             // StateProvider<Duration>
final windowSize = Size(800, 600).state;                  // StateProvider<Size>
final position = Offset.zero.state;                   // StateProvider<Offset>
```

### **Update State in One Line**
```dart
// Counter operations with descriptive names
counter.increment(ref);           // Increment by 1
counter.decrement(ref);           // Decrement by 1
counter.addValue(ref, 5);         // Add specific value
counter.resetToZero(ref);         // Reset to 0

// Text operations with clear intent
name.updateText(ref, "Jane");     // Set new text
name.clearText(ref);              // Clear text
name.appendText(ref, " Doe");     // Append text

// Boolean operations that are self-explanatory
isDark.toggle(ref);               // Toggle state
isDark.setTrue(ref);              // Set to true
isDark.setFalse(ref);             // Set to false

// List operations with full clarity
todos.addItem(ref, "New task");   // Add item
todos.removeItem(ref, "Old task"); // Remove item
todos.clear(ref);                 // Clear all

// Generic operations (works with any StateProvider)
provider.set(ref, newValue);      // Set value
provider.get(ref);                // Get current value
provider.watch(ref);              // Watch for changes
```

### **Build Widgets in One Line**
```dart
// Display widgets
ref.text(counterProvider);               // Text widget showing count
ref.switchTile(boolProvider, title: "Dark Mode"); // Switch widget
ref.switchTile(boolProvider, title: "Dark Mode"); // Switch widget
```

## 🎨 **Best Practices**

### **Widget Organization**
```dart
// ✅ Excellent: Use Sugar extensions for instant providers
final counter = 0.state;
final name = "Guest".state;
final isDark = false.state;

// ✅ Excellent: Use RxWidget for clean reactive widgets
class UserProfile extends RxWidget {
  @override
  Widget buildRx(BuildContext context, WidgetRef ref) {
    return Column(children: [
      ref.counter(counter),
      ref.txt(name),
      ref.show(isDark, Icon(Icons.dark_mode)),
    ]);
  }
}

// ✅ Good: Use RxBuilder for inline reactive parts
Column(
  children: [
    StaticHeader(),
    RxBuilder(builder: (context, ref) {
      return ref.counter(counter);
    }),
  ],
)
```

### **Performance Tips**
```dart
// ✅ Excellent: Use Sugar extensions for instant updates
counter.increment(ref);              // Instead of ref.read(provider.notifier).state++

// ✅ Good: Combine related providers
final dashboardProvider = ProviderCombiners.combine2(userProvider, settingsProvider);

// ✅ Good: Use debouncer for expensive operations
final debouncer = Debouncer(milliseconds: 300);
onChanged: (query) => debouncer.run(() => search(query));

// ❌ Avoid: Multiple separate watches
// final user = ref.watch(userProvider);
// final settings = ref.watch(settingsProvider);
```

## 🧪 **Testing**

Riverpod Sugar works seamlessly with Riverpod's testing utilities:

```dart
void main() {
  test('Sugar extensions work in tests', () {
    final container = ProviderContainer();
    
    // Test sugar extensions
    final counter = 0.state;
    expect(counter.get(container.read), 0);
    
    counter.increment(container.read);
    expect(counter.get(container.read), 1);
    
    container.dispose();
  });
  
  test('RxWidget updates when provider changes', () async {
    final container = ProviderContainer();
    
    await tester.pumpWidget(
      ProviderScope(
        parent: container,
        child: MyRxWidget(),
      ),
    );
    
    // Verify behavior
    expect(find.text('0'), findsOneWidget);
    
    // Use sugar extension to update
    counter.increment(container.read);
    await tester.pump();
    
    expect(find.text('1'), findsOneWidget);
  });
}
```

## 🔄 **Migration Guide**

### **From Standard Riverpod to Sugar**

**1. Provider Creation**
```dart
// Before
final counterProvider = StateProvider<int>((ref) => 0);
final nameProvider = StateProvider<String>((ref) => "Guest");

// After - One word!
final counter = 0.state;
final name = "Guest".state;
```

**2. State Updates**
```dart
// Before
ref.read(counterProvider.notifier).state++;
ref.read(nameProvider.notifier).state = "New Name";

// After - One line with clear intent!
counter.increment(ref);
name.updateText(ref, "New Name");
```

**3. Widget Building**
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
    return ref.counter(counter);  // Even shorter!
  }
}
```

### **From ConsumerWidget to RxWidget**

1. **Change the parent class:**
   ```dart
   // Before
   class MyWidget extends ConsumerWidget {
   
   // After  
   class MyWidget extends RxWidget {
   ```

2. **Rename the build method:**
   ```dart
   // Before
   Widget build(BuildContext context, WidgetRef ref) {
   
   // After
   Widget buildRx(BuildContext context, WidgetRef ref) {
   ```

3. **That's it!** Your existing code works unchanged.

## 📊 **Coverage & Compatibility**

### ✅ **Perfect For (95% coverage)**
- **Social Media Apps**: Posts, likes, comments, user state
- **E-commerce Apps**: Cart, products, checkout, preferences
- **Productivity/Todo Apps**: Lists, completion, filters, settings  
- **Form-heavy Apps**: Registration, surveys, validation
- **Dashboard Apps**: Data combination, async loading
- **Settings/Config Apps**: Toggles, preferences, themes

### ⚠️ **Good For (70% coverage)**
- **Chat Apps**: Basic messaging ✅, real-time features need additional work
- **Complex Business Apps**: Forms/validation ✅, advanced business logic needs custom implementation

### ❌ **Needs Additional Work**
- **Real-time Trading**: Streaming data, high-frequency updates
- **Complex Games**: Game-specific state patterns, performance-critical updates
- **Enterprise Workflows**: Advanced business rules, complex state machines

## 🎉 **What's New in v1.0.4?**

### � **Package Optimization (v1.0.4)**

**Dramatically Reduced Package Size**:
- Package size reduced from ~13 MB to just **340 KB** (97% reduction!)
- Removed build artifacts, coverage reports, and development files
- Much faster downloads and installation for users
- Professional, clean package structure with only essential files

**Enhanced pub.dev Presence**:
- Added topics for better discoverability
- Repository and issue tracker links
- Screenshot descriptions for visual documentation
- Optimized metadata for pub.dev rankings

### 🛠️ **Foundation Improvements (v1.0.3)**

**Enhanced Widget Helpers (15+ new helpers)**:
- Build UI components directly from providers: `ref.text()`, `ref.switchTile()`, `ref.loading()`
- Smart defaults and validation for all helpers
- Zero boilerplate for common UI patterns

**Advanced Debugging System**:
- Automatic performance tracking in debug mode
- State change logging and operation monitoring
- Zero runtime overhead in release builds

**Robust Validation Framework**:
- Type-safe operations with bounds checking
- Context-aware error messages with suggestions
- Comprehensive validation utilities

**Production-Ready Quality**:
- 100% test coverage for all new features
- Complete documentation with examples
- Enhanced error handling and developer experience

> **Perfect for teams moving to production!** Optimized package size with all the reliability and debugging tools you need for real-world apps.


## 🚀 **Why Choose Riverpod Sugar?**

### **🔥 Revolutionary Simplicity**
- **80% Less Code**: Turn 50-line Riverpod apps into 10-line apps
- **Zero Learning Curve**: If you know ScreenUtil, you know this!
- **Instant Productivity**: Create providers and update state in one word

### **🎯 Production Ready**
- **Full Riverpod Compatibility**: Built on top of flutter_riverpod
- **Comprehensive Testing**: Extensive test coverage
- **Type Safe**: Full null safety and type inference
- **Performance Optimized**: No overhead, pure convenience

### **📈 Developer Experience**
- **Intuitive API**: Natural, readable code
- **Excellent Documentation**: Examples for everything
- **Active Maintenance**: Regular updates and improvements
- **Community Driven**: Built for the Flutter community

## 🤝 **Contributing**

We welcome contributions! Please see our [Contributing Guide](CONTRIBUTING.md) for details.

## 📄 **License**

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 **Acknowledgments**

- Built on top of the excellent [flutter_riverpod](https://pub.dev/packages/flutter_riverpod) package
- Inspired by [ScreenUtil](https://pub.dev/packages/flutter_screenutil)'s revolutionary approach to responsive design
- Thanks to the Flutter community for feedback and contributions
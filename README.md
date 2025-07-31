 
# 🍯 Riverpod Sugar

[![pub package](https://img.shields.io/pub/v/riverpod_sugar.svg)](https://pub.dev/packages/riverpod_sugar)
[![style: very good analysis](https://img.shields.io/badge/style-very_good_analysis-B22C89.svg)](https://pub.dev/packages/very_good_analysis)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

Sweet utilities for `flutter_riverpod` that reduce boilerplate and improve developer ergonomics **without hiding the `ref` object**.

## ✨ Features

- **🎯 RxWidget & RxBuilder**: Cleaner widget definitions with less boilerplate
- **⚡ AsyncValue.easyWhen**: Simplified async state handling with sensible defaults
- **🔄 Debouncer**: Intelligent input debouncing for search and user interactions
- **📝 FormManager**: Effortless form validation state management
- **🔗 Provider Combiners**: Combine multiple providers elegantly
- **🛠️ Common Validators**: Pre-built validation functions for forms

## 📦 Installation

Add `riverpod_sugar` to your `pubspec.yaml`:

```yaml
dependencies:
  riverpod_sugar: ^1.0.0
```

Then import it in your Dart code:

```dart
import 'package:riverpod_sugar/riverpod_sugar.dart';
```

## 🚀 Quick Start

### RxWidget - Cleaner ConsumerWidget

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
  const CounterWidget({super.key});
  
  @override
  Widget buildRx(BuildContext context, WidgetRef ref) {
    final count = ref.watch(counterProvider);
    return Text('Count: $count');
  }
}
```

### easyWhen - Simplified AsyncValue Handling

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
  // loading & error widgets provided automatically!
)
```

### Debouncer - Smart Search Input

```dart
class SearchWidget extends RxStatefulWidget {
  @override
  State<SearchWidget> createState() => _SearchWidgetState();
}

class _SearchWidgetState extends RxState<SearchWidget> {
  final _debouncer = Debouncer(milliseconds: 300);
  
  @override
  Widget buildRx(BuildContext context, WidgetRef ref) {
    return TextField(
      onChanged: (query) {
        _debouncer.run(() {
          ref.read(searchProvider.notifier).updateQuery(query);
        });
      },
    );
  }
  
  @override
  void dispose() {
    _debouncer.dispose();
    super.dispose();
  }
}
```

## 📚 Detailed Examples

### Form Validation with FormManager

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

### Provider Combination

```dart
final userProvider = FutureProvider<User>((ref) => fetchUser());
final settingsProvider = FutureProvider<Settings>((ref) => fetchSettings());

// Combine multiple providers
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

### Advanced AsyncValue Operations

```dart
final userProvider = FutureProvider<User>((ref) => fetchUser());

// Transform async data
final userNameProvider = userProvider.mapData((user) => user.name);

// Check conditions on async data
final isAdminProvider = Provider<bool>((ref) {
  final user = ref.watch(userProvider);
  return user.hasDataWhere((user) => user.role == 'admin');
});

// Combine async providers
final dashboardDataProvider = AsyncProviderCombiners.combine3(
  userProvider,
  postsProvider,
  notificationsProvider,
);
```

## 🎯 Core Components

### RxWidget Family

| Widget | Use Case |
|--------|----------|
| `RxWidget` | Replaces `ConsumerWidget` with cleaner syntax |
| `RxStatefulWidget` | Replaces `ConsumerStatefulWidget` |
| `RxBuilder` | Inline reactive widgets without creating new classes |
| `RxShow` | Conditional rendering based on provider state |

### AsyncValue Extensions

| Extension | Purpose |
|-----------|---------|
| `easyWhen()` | Simplified async state handling with defaults |
| `mapData()` | Transform data while preserving async state |
| `hasDataWhere()` | Check conditions on async data |
| `dataOrNull` | Get data or null safely |

### Form Management

| Component | Purpose |
|-----------|---------|
| `FormManager` | Manages form validation state |
| `CommonValidators` | Pre-built validation functions |
| `FormState` | Immutable form state with error tracking |

### Utilities

| Utility | Purpose |
|---------|---------|
| `Debouncer` | Delay function execution (search, API calls) |
| `AdvancedDebouncer` | Advanced debouncing with leading/trailing options |
| `ProviderCombiners` | Combine multiple providers |
| `AsyncProviderCombiners` | Combine async providers intelligently |

## 🔧 Advanced Usage

### Custom Loading and Error Widgets

```dart
userProvider.easyWhen(
  data: (user) => UserProfile(user),
  loading: () => CustomShimmer(),
  error: (error, stack) => CustomErrorWidget(error),
)
```

### Advanced Debouncing

```dart
final advancedDebouncer = AdvancedDebouncer(
  milliseconds: 300,
  maxWait: 2000,     // Force execution after 2 seconds
  leading: true,     // Execute immediately on first call
  trailing: true,    // Execute after delay
);
```

### Multiple Field Validation

```dart
formManager.validateFields({
  'email': (emailValue, CommonValidators.email()),
  'password': (passwordValue, CommonValidators.minLength(8)),
  'confirmPassword': (confirmValue, CommonValidators.matches(passwordValue)),
});
```

## 🎨 Best Practices

### ✅ Do's

- **Use RxWidget for widgets that only consume providers**
- **Dispose Debouncer in StatefulWidgets**
- **Combine related providers for better performance**
- **Use CommonValidators for standard validation**
- **Leverage easyWhen for most async operations**

### ❌ Don'ts

- **Don't override both `build` and `buildRx` methods**
- **Don't forget to dispose resources (Debouncer, controllers)**
- **Don't use RxWidget for widgets that don't need providers**
- **Don't ignore form validation errors**

### Performance Tips

```dart
// ✅ Good: Combine related providers
final dashboardProvider = ProviderCombiners.combine2(userProvider, settingsProvider);

// ❌ Avoid: Multiple separate watches
// final user = ref.watch(userProvider);
// final settings = ref.watch(settingsProvider);

// ✅ Good: Use debouncer for expensive operations
final debouncer = Debouncer(milliseconds: 300);
onChanged: (query) => debouncer.run(() => search(query));

// ❌ Avoid: Direct expensive calls
// onChanged: (query) => search(query);
```

## 🧪 Testing

Riverpod Sugar works seamlessly with Riverpod's testing utilities:

```dart
void main() {
  test('RxWidget updates when provider changes', () async {
    final container = ProviderContainer();
    
    // Test your RxWidget with the container
    await tester.pumpWidget(
      ProviderScope(
        parent: container,
        child: MyRxWidget(),
      ),
    );
    
    // Verify behavior
    expect(find.text('Initial Value'), findsOneWidget);
    
    // Update provider and test
    container.read(myProvider.notifier).state = 'Updated Value';
    await tester.pump();
    
    expect(find.text('Updated Value'), findsOneWidget);
  });
}
```

## 🔄 Migration Guide

### From ConsumerWidget to RxWidget

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

### From Manual AsyncValue Handling

1. **Replace verbose when calls:**
   ```dart
   // Before
   asyncValue.when(
     data: (data) => MyWidget(data),
     loading: () => CircularProgressIndicator(),
     error: (e, s) => Text('Error: $e'),
   )
   
   // After
   asyncValue.easyWhen(
     data: (data) => MyWidget(data),
   )
   ```

## 🤝 Contributing

We welcome contributions! Here's how you can help:

1. **🐛 Report bugs** - Open an issue with reproduction steps
2. **💡 Suggest features** - We'd love to hear your ideas
3. **📝 Improve docs** - Help make the documentation even better
4. **🧪 Add tests** - More test coverage is always appreciated
5. **💻 Submit PRs** - Bug fixes and features are welcome

### Development Setup

```bash
# Clone the repository
git clone https://github.com/mukhbit0/riverpod_sugar.git

# Install dependencies
flutter pub get

# Run tests
flutter test

# Run example app
cd example && flutter run
```

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- **[Riverpod](https://riverpod.dev/)** - The amazing state management solution this package extends
- **[Flutter Team](https://flutter.dev/)** - For the incredible framework
- **Community** - For feedback and suggestions that make this package better

## 📈 Package Stats

- ✅ **Null Safety**: Full null safety support
- ✅ **Flutter 3.10+**: Compatible with latest Flutter versions  
- ✅ **Dart 3.0+**: Uses latest Dart features
- ✅ **Well Tested**: Comprehensive test coverage
- ✅ **Well Documented**: Extensive documentation and examples
- ✅ **Zero Dependencies**: Only depends on `flutter_riverpod`

---

**Made with ❤️ for the Flutter community**

If you like this package, please give it a ⭐ on [GitHub](https://github.com/mukhbit0/riverpod_sugar) and a 👍 on [pub.dev](https://pub.dev/packages/riverpod_sugar)!
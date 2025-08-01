# 📖 **Riverpod Sugar: Complete Usage Guide**

This guide shows you exactly how to use every feature of Riverpod Sugar with full freedom and flexibility.

## 🎯 **Philosophy: Full Freedom, Not Restrictions**

Riverpod Sugar gives you powerful extensions that work **anywhere** you need them. We don't force you into specific widgets or patterns - you have complete control over your UI design while we make state management incredibly simple.

---

## 🔥 **1. Creating Providers - ScreenUtil Style**

### **Instant Provider Creation**

```dart
// Traditional Riverpod (verbose)
final counterProvider = StateProvider<int>((ref) => 0);
final nameProvider = StateProvider<String>((ref) => "Guest");
final isDarkProvider = StateProvider<bool>((ref) => false);

// With Sugar Extensions (one word!)
final counter = 0.state;           // StateProvider<int>
final name = "Guest".text;         // StateProvider<String>  
final isDark = false.toggle;       // StateProvider<bool>
final todos = <String>[].items;    // StateProvider<List<String>>
final price = 19.99.price;         // StateProvider<double>
```

### **All Available Creation Extensions**

```dart
// Numbers
final age = 25.state;              // StateProvider<int>
final temperature = 23.state;      // StateProvider<int> 
final score = 1500.state;          // StateProvider<int>

final price = 19.99.price;         // StateProvider<double>
final rating = 4.5.price;          // StateProvider<double>
final weight = 68.5.price;         // StateProvider<double>

// Strings
final username = "john".text;       // StateProvider<String>
final title = "My App".text;        // StateProvider<String>
final query = "".search;           // StateProvider<String>

// Booleans
final darkMode = false.toggle;      // StateProvider<bool>
final isLoading = false.loading;    // StateProvider<bool>
final isVisible = true.visible;     // StateProvider<bool>
final isEnabled = true.enabled;     // StateProvider<bool>
final isActive = false.active;      // StateProvider<bool>

// Lists
final usersList = <User>[].items;         // StateProvider<List<User>>
final todosList = <Todo>[].todos;         // StateProvider<List<Todo>>
final dataList = <Map>[].collection;      // StateProvider<List<Map>>
final results = <String>[].data;          // StateProvider<List<String>>
```

### **Alternative: Sugar Class Methods**

```dart
// If you prefer explicit methods
final counter = Sugar.integer(0);
final name = Sugar.text("Guest");
final isDark = Sugar.boolean(false);
final price = Sugar.decimal(19.99);
final todos = Sugar.list<String>();
```

---

## ⚡ **2. State Operations - Full Control**

### **Integer Operations**

```dart
final points = 0.state;
final level = 1.state;
final health = 100.state;

// Use anywhere integers are needed
points.increment(ref);              // +1
points.decrement(ref);              // -1
points.addValue(ref, 50);           // Add 50
points.subtractValue(ref, 10);      // Subtract 10
points.multiplyBy(ref, 2);          // Multiply by 2
points.resetToZero(ref);            // Set to 0
points.setValue(ref, 1000);         // Set specific value

// Use in your own UI designs
Text('Points: ${ref.watchValue(points)}');
ElevatedButton(
  onPressed: () => points.addValue(ref, 100),
  child: Text('Earn Points'),
);
```

### **Double Operations**

```dart
final price = 19.99.price;
final rating = 4.5.price;
final temperature = 23.5.price;

// Mathematical operations
price.addValue(ref, 5.0);           // Add 5.0
price.subtractValue(ref, 2.50);     // Subtract 2.50
price.multiplyBy(ref, 1.2);         // Apply 20% increase
price.divideBy(ref, 2.0);           // Divide by 2
price.roundTo(ref, 2);              // Round to 2 decimals
price.resetToZero(ref);             // Set to 0.0
price.setValue(ref, 24.99);         // Set specific value

// Use in any UI context
Container(
  padding: EdgeInsets.all(12),
  child: Text('\$${ref.watchValue(price).toStringAsFixed(2)}'),
);
```

### **Boolean Operations**

```dart
final darkMode = false.toggle;
final isLoading = false.loading;
final isOnline = true.active;

// Boolean manipulation
darkMode.toggle(ref);               // Switch true/false
isLoading.setTrue(ref);             // Set to true
isLoading.setFalse(ref);            // Set to false
isOnline.setValue(ref, true);       // Set specific value

// Use with any widget design
Switch(
  value: ref.watchValue(darkMode),
  onChanged: (value) => darkMode.setValue(ref, value),
);

// Conditional logic anywhere
if (ref.watchValue(isLoading)) {
  return CustomLoadingWidget();
}
```

### **String Operations**

```dart
final message = "Hello".text;
final url = "".text;
final log = "".text;

// Text manipulation
message.updateText(ref, "New message");     // Replace text
message.clearText(ref);                     // Clear to ""
message.appendText(ref, " World!");         // Add to end
message.prependText(ref, "Mr. ");           // Add to beginning
message.replaceText(ref, "old", "new");     // Replace substring
message.setValue(ref, "Final text");        // Set specific value

// Use in your UI
TextField(
  controller: TextEditingController(text: ref.watchValue(message)),
  onChanged: (value) => message.updateText(ref, value),
);
```

### **List Operations**

```dart
final todos = <String>[].items;
final users = <User>[].collection;
final cart = <Product>[].data;

// List manipulation
todos.addItem(ref, "New task");             // Add single item
todos.addItems(ref, ["Task 1", "Task 2"]); // Add multiple items
todos.removeItem(ref, "Old task");          // Remove specific item
todos.removeAt(ref, 0);                     // Remove by index
todos.insertAt(ref, 0, "First task");       // Insert at index
todos.updateAt(ref, 0, "Updated task");     // Update at index
todos.clearAll(ref);                        // Clear all items
todos.replaceWith(ref, newList);            // Replace entire list

// Get information
final count = todos.getLength(ref);         // Get length
final isEmpty = todos.isEmpty(ref);         // Check if empty
final hasItems = todos.isNotEmpty(ref);     // Check if has items

// Use in any list UI
ListView.builder(
  itemCount: ref.watchValue(todos).length,
  itemBuilder: (context, index) {
    final todo = ref.watchValue(todos)[index];
    return ListTile(
      title: Text(todo),
      trailing: IconButton(
        onPressed: () => todos.removeAt(ref, index),
        icon: Icon(Icons.delete),
      ),
    );
  },
);
```

---

## 🧩 **3. Enhanced WidgetRef - Flexible Watching**

### **Universal Value Watching**

```dart
class MyWidget extends RxWidget {
  @override
  Widget buildRx(BuildContext context, WidgetRef ref) {
    // Watch any provider and use the value anywhere
    final count = ref.watchValue(counterProvider);
    final name = ref.watchValue(nameProvider);
    final isDark = ref.watchValue(darkModeProvider);
    final items = ref.watchValue(itemsProvider);
    
    // Use these values in ANY widget you want
    return Column(
      children: [
        Text('Count: $count'),                    // Your own Text widget
        Container(
          color: isDark ? Colors.black : Colors.white,
          child: Text('Hello $name'),             // Your own styling
        ),
        ...items.map((item) => Card(             // Your own list design
          child: ListTile(title: Text(item)),
        )),
      ],
    );
  }
}
```

### **One-Time Reading**

```dart
// Read current value without watching (one-time access)
final currentCount = ref.readValue(counterProvider);
final currentName = ref.readValue(nameProvider);

// Use for one-time operations
void handleButtonPress() {
  final count = ref.readValue(counterProvider);
  if (count > 10) {
    showDialog(...);
  }
}
```

### **Direct Value Updates**

```dart
// Update any provider directly
ref.updateValue(counterProvider, 42);
ref.updateValue(nameProvider, "John Doe");
ref.updateValue(darkModeProvider, true);
```

### **Conditional Widget Display**

```dart
// Show widget when boolean is true
ref.showWhen(isLoadingProvider, 
  CustomLoadingSpinner(),  // Your own loading design
);

// Show different widgets based on boolean
ref.showEither(
  isDarkModeProvider,
  MyDarkThemeWidget(),     // When true
  MyLightThemeWidget(),    // When false
);
```

---

## 🎭 **4. RxWidget - Clean Reactive Widgets**

### **Basic Usage**

```dart
// Instead of ConsumerWidget
class CounterWidget extends RxWidget {
  @override
  Widget buildRx(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        Text('${ref.watchValue(counter)}'),
        ElevatedButton(
          onPressed: () => counter.increment(ref),
          child: Text('Increment'),
        ),
      ],
    );
  }
}
```

### **RxStatefulWidget for Complex Widgets**

```dart
class AnimatedCounter extends RxStatefulWidget {
  @override
  ConsumerState<AnimatedCounter> createState() => _AnimatedCounterState();
}

class _AnimatedCounterState extends RxState<AnimatedCounter> 
    with TickerProviderStateMixin {
  late AnimationController _controller;
  
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );
  }
  
  @override
  Widget buildRx(BuildContext context, WidgetRef ref) {
    final count = ref.watchValue(counter);
    _controller.forward(from: 0);
    
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.scale(
          scale: 1.0 + (_controller.value * 0.1),
          child: Text('$count'),
        );
      },
    );
  }
}
```

### **RxBuilder for Inline Widgets**

```dart
Column(
  children: [
    StaticHeader(),
    RxBuilder(builder: (context, ref) {
      final isLoading = ref.watchValue(loadingProvider);
      return isLoading 
        ? MyCustomSpinner() 
        : MyContentWidget();
    }),
  ],
)
```

---

## 🎭 **5. easyWhen - Simplified AsyncValue**

### **Basic Usage**

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

### **Custom Loading and Error**

```dart
ref.watch(userProvider).easyWhen(
  data: (user) => UserProfile(user),
  loading: () => MyCustomLoadingWidget(),
  error: (error, stack) => MyCustomErrorWidget(error),
);
```

### **AsyncValue Extensions**

```dart
final userProvider = FutureProvider<User>((ref) => fetchUser());

// Transform data while preserving async state
final userNameProvider = Provider((ref) {
  return ref.watch(userProvider).mapData((user) => user.name);
});

// Check conditions on async data
final isAdminProvider = Provider((ref) {
  final user = ref.watch(userProvider);
  return user.hasDataWhere((user) => user.role == 'admin');
});

// Safe data access
Widget buildUserWidget(WidgetRef ref) {
  final user = ref.watch(userProvider);
  final userData = user.dataOrNull;
  
  if (userData != null) {
    return Text('Hello ${userData.name}');
  }
  return Text('No user data');
}
```

---

## 📝 **6. Form Management**

### **Setup Form Manager**

```dart
final formManagerProvider = StateNotifierProvider<FormManager, FormState>((ref) {
  return FormManager();
});
```

### **Form Validation**

```dart
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
        
        TextFormField(
          decoration: InputDecoration(
            labelText: 'Password',
            errorText: formState.getError('password'),
          ),
          onChanged: (value) {
            formManager.validateField(
              'password',
              value,
              CommonValidators.minLength(8, 'Password must be at least 8 characters'),
            );
          },
        ),
        
        ElevatedButton(
          onPressed: formState.isValid ? () => _submitForm() : null,
          child: Text('Register'),
        ),
      ],
    );
  }
}
```

### **Available Validators**

```dart
// Built-in validators
CommonValidators.required('This field is required');
CommonValidators.email('Please enter a valid email');
CommonValidators.minLength(8, 'Must be at least 8 characters');
CommonValidators.maxLength(50, 'Must be less than 50 characters');
CommonValidators.range(1, 100, 'Must be between 1 and 100');
CommonValidators.pattern(RegExp(r'^\d+$'), 'Must contain only numbers');

// Combine multiple validators
CommonValidators.combine([
  CommonValidators.required('Email is required'),
  CommonValidators.email('Invalid email format'),
]);
```

---

## 🔗 **7. Provider Combiners**

### **Combining Multiple Providers**

```dart
final userProvider = FutureProvider<User>((ref) => fetchUser());
final settingsProvider = FutureProvider<Settings>((ref) => fetchSettings());

// Combine providers
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

### **Transform and Filter Providers**

```dart
// Transform provider values
final doubledCountProvider = ProviderCombiners.map(
  counterProvider,
  (count) => count * 2,
);

// Filter provider updates
final evenCountProvider = ProviderCombiners.where(
  counterProvider,
  (count) => count % 2 == 0,
);

// Extension methods
final combinedData = userProvider.combineWith(settingsProvider);
final userName = userProvider.mapValue((user) => user.name);
```

---

## ⏱️ **8. Debouncing**

### **Basic Debouncing**

```dart
class SearchWidget extends RxWidget {
  final debouncer = Debouncer(milliseconds: 300);
  
  @override
  Widget buildRx(BuildContext context, WidgetRef ref) {
    return TextField(
      onChanged: (query) {
        debouncer.run(() {
          // This will only execute after user stops typing for 300ms
          ref.updateValue(searchQueryProvider, query);
        });
      },
    );
  }
}
```

### **Advanced Debouncing**

```dart
final advancedDebouncer = AdvancedDebouncer(
  milliseconds: 300,
  maxWait: 2000,        // Force execution after 2 seconds max
  leading: true,        // Execute immediately on first call
  trailing: true,       // Execute after delay
);

TextField(
  onChanged: (query) {
    advancedDebouncer.run(() => performSearch(query));
  },
);
```

---

## 🎨 **9. Best Practices & Patterns**

### **Organize Your Providers**

```dart
// Group related providers
class UserState {
  static final profile = User.empty().data;
  static final isLoading = false.loading;
  static final preferences = UserPreferences.default().data;
}

class AppState {
  static final theme = false.toggle;      // Dark mode
  static final language = "en".text;      // Current language
  static final isOnline = true.active;    // Network status
}
```

### **Custom Provider Extensions**

```dart
// Create your own domain-specific extensions
extension UserProviderSugar on StateProvider<User> {
  void updateProfile(WidgetRef ref, UserProfile profile) {
    final current = ref.read(this);
    ref.read(notifier).state = current.copyWith(profile: profile);
  }
  
  void addFriend(WidgetRef ref, User friend) {
    final current = ref.read(this);
    ref.read(notifier).state = current.copyWith(
      friends: [...current.friends, friend],
    );
  }
}
```

### **Testing with Sugar Extensions**

```dart
void main() {
  test('Sugar extensions work in tests', () {
    final container = ProviderContainer();
    
    // Test integer operations
    final counter = 0.state;
    expect(ref.readValue(counter), 0);
    
    counter.increment(container.read);
    expect(ref.readValue(counter), 1);
    
    counter.addValue(container.read, 10);
    expect(ref.readValue(counter), 11);
    
    container.dispose();
  });
}
```

---

## 🚀 **10. Migration from Standard Riverpod**

### **Step-by-Step Migration**

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
    return Text('${ref.watchValue(counter)}');
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

✅ **Instant provider creation** with ScreenUtil-style extensions  
✅ **Descriptive method names** that clearly show intent  
✅ **Full UI freedom** - use values anywhere, design any widget  
✅ **Type flexibility** - use `.state` for any int, `.price` for any double  
✅ **Complete compatibility** with standard Riverpod  
✅ **Enhanced developer experience** with 80% less boilerplate  

**You're not locked into specific widgets or patterns - you have complete control over your UI while we make state management incredibly simple!**

---

*Made with ❤️ for developers who value both simplicity and freedom*

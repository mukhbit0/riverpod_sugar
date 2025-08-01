import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Ultra-concise extensions that make Riverpod state management one-liner.
/// Inspired by ScreenUtil's .r, .sp, .w, .h approach for maximum simplicity.

/// Extension on numbers to create state providers instantly
extension NumberSugar on num {
  /// Creates a StateProvider with this number as initial value
  /// Usage: `final counterProvider = 0.state;`
  StateProvider<int> get state => StateProvider((ref) => toInt());

  /// Creates a StateProvider with this number as initial double value
  /// Usage: `final priceProvider = 19.99.price;`
  StateProvider<double> get price => StateProvider((ref) => toDouble());
}

/// Extension on strings to create state providers instantly
extension StringSugar on String {
  /// Creates a StateProvider with this string as initial value
  /// Usage: `final nameProvider = "John".text;`
  StateProvider<String> get text => StateProvider((ref) => this);

  /// Creates a StateProvider for search/query functionality
  /// Usage: `final searchProvider = "".search;`
  StateProvider<String> get search => StateProvider((ref) => this);
}

/// Extension on booleans to create state providers instantly
extension BooleanSugar on bool {
  /// Creates a StateProvider with this boolean as initial value
  /// Usage: `final isDarkProvider = false.toggle;` or `final isEnabledProvider = true.enabled;`
  StateProvider<bool> get toggle => StateProvider((ref) => this);

  /// Creates a StateProvider for loading states
  /// Usage: `final loadingProvider = false.loading;`
  StateProvider<bool> get loading => StateProvider((ref) => this);

  /// Creates a StateProvider for visibility states
  /// Usage: `final visibleProvider = true.visible;`
  StateProvider<bool> get visible => StateProvider((ref) => this);

  /// Creates a StateProvider for enabled/disabled states
  /// Usage: `final enabledProvider = true.enabled;`
  StateProvider<bool> get enabled => StateProvider((ref) => this);

  /// Creates a StateProvider for active/inactive states
  /// Usage: `final activeProvider = false.active;`
  StateProvider<bool> get active => StateProvider((ref) => this);
}

/// Extension on lists to create state providers instantly
extension ListSugar<T> on List<T> {
  /// Creates a StateProvider with this list as initial value
  /// Usage: `final itemsProvider = <String>[].items;` or `final usersProvider = <User>[].collection;`
  StateProvider<List<T>> get items => StateProvider((ref) => this);

  /// Creates a StateProvider for todo lists
  /// Usage: `final todosProvider = <Todo>[].todos;`
  StateProvider<List<T>> get todos => StateProvider((ref) => this);

  /// Creates a StateProvider for any collection
  /// Usage: `final productsProvider = <Product>[].collection;`
  StateProvider<List<T>> get collection => StateProvider((ref) => this);

  /// Creates a StateProvider for a list of data
  /// Usage: `final dataProvider = <Map>[].data;`
  StateProvider<List<T>> get data => StateProvider((ref) => this);
}

/// Extension on StateProvider for ultra-simple operations
extension StateProviderSugar<T> on StateProvider<T> {
  /// Get the current value one-liner
  /// Usage: `final value = counterProvider.get(ref);`
  T get(WidgetRef ref) => ref.read(this);

  /// Update the value one-liner
  /// Usage: `counterProvider.set(ref, 5);`
  void set(WidgetRef ref, T value) => ref.read(notifier).state = value;

  /// Watch the value one-liner (for widgets)
  /// Usage: `final count = counterProvider.watch(ref);`
  T watch(WidgetRef ref) => ref.watch(this);
}

/// Extension on StateProvider<int> for integer operations
extension IntProviderSugar on StateProvider<int> {
  /// Increment the integer value by 1
  /// Usage: `countProvider.increment(ref);` or `ageProvider.increment(ref);`
  void increment(WidgetRef ref) => ref.read(notifier).state++;

  /// Decrement the integer value by 1
  /// Usage: `countProvider.decrement(ref);` or `scoreProvider.decrement(ref);`
  void decrement(WidgetRef ref) => ref.read(notifier).state--;

  /// Add a value to the current integer
  /// Usage: `pointsProvider.addValue(ref, 10);` or `balanceProvider.addValue(ref, 50);`
  void addValue(WidgetRef ref, int value) => ref.read(notifier).state += value;

  /// Subtract a value from the current integer
  /// Usage: `pointsProvider.subtractValue(ref, 5);` or `healthProvider.subtractValue(ref, 20);`
  void subtractValue(WidgetRef ref, int value) =>
      ref.read(notifier).state -= value;

  /// Multiply the current integer by a value
  /// Usage: `multiplierProvider.multiplyBy(ref, 2);`
  void multiplyBy(WidgetRef ref, int value) =>
      ref.read(notifier).state *= value;

  /// Reset the integer to 0
  /// Usage: `counterProvider.resetToZero(ref);` or `scoreProvider.resetToZero(ref);`
  void resetToZero(WidgetRef ref) => ref.read(notifier).state = 0;

  /// Set to a specific value
  /// Usage: `levelProvider.setValue(ref, 5);` or `pageProvider.setValue(ref, 1);`
  void setValue(WidgetRef ref, int value) => ref.read(notifier).state = value;
}

/// Extension on StateProvider<double> for decimal operations
extension DoubleProviderSugar on StateProvider<double> {
  /// Add a value to the current double
  /// Usage: `priceProvider.addValue(ref, 10.5);` or `ratingProvider.addValue(ref, 0.5);`
  void addValue(WidgetRef ref, double value) =>
      ref.read(notifier).state += value;

  /// Subtract a value from the current double
  /// Usage: `priceProvider.subtractValue(ref, 5.99);` or `temperatureProvider.subtractValue(ref, 2.5);`
  void subtractValue(WidgetRef ref, double value) =>
      ref.read(notifier).state -= value;

  /// Multiply the current double by a value
  /// Usage: `priceProvider.multiplyBy(ref, 1.2);`
  void multiplyBy(WidgetRef ref, double value) =>
      ref.read(notifier).state *= value;

  /// Divide the current double by a value
  /// Usage: `totalProvider.divideBy(ref, 2.0);`
  void divideBy(WidgetRef ref, double value) =>
      ref.read(notifier).state /= value;

  /// Round to a specific number of decimal places
  /// Usage: `priceProvider.roundTo(ref, 2);` // Rounds to 2 decimal places
  void roundTo(WidgetRef ref, int decimalPlaces) {
    final multiplier = 1.0 * (10 * decimalPlaces);
    ref.read(notifier).state =
        (ref.read(notifier).state * multiplier).round() / multiplier;
  }

  /// Reset the double to 0.0
  /// Usage: `priceProvider.resetToZero(ref);`
  void resetToZero(WidgetRef ref) => ref.read(notifier).state = 0.0;

  /// Set to a specific value
  /// Usage: `priceProvider.setValue(ref, 19.99);`
  void setValue(WidgetRef ref, double value) =>
      ref.read(notifier).state = value;
}

/// Extension on StateProvider<bool> for boolean operations
extension BoolProviderSugar on StateProvider<bool> {
  /// Toggle the boolean value
  /// Usage: `darkModeProvider.toggle(ref);` or `visibilityProvider.toggle(ref);`
  void toggle(WidgetRef ref) =>
      ref.read(notifier).state = !ref.read(notifier).state;

  /// Set the boolean to true
  /// Usage: `loadingProvider.setTrue(ref);` or `enabledProvider.setTrue(ref);`
  void setTrue(WidgetRef ref) => ref.read(notifier).state = true;

  /// Set the boolean to false
  /// Usage: `loadingProvider.setFalse(ref);` or `enabledProvider.setFalse(ref);`
  void setFalse(WidgetRef ref) => ref.read(notifier).state = false;

  /// Set to a specific boolean value
  /// Usage: `activeProvider.setValue(ref, true);` or `hiddenProvider.setValue(ref, false);`
  void setValue(WidgetRef ref, bool value) => ref.read(notifier).state = value;
}

/// Extension on StateProvider<String> for text operations
extension StringProviderSugar on StateProvider<String> {
  /// Update the text to a new value
  /// Usage: `nameProvider.updateText(ref, "New Name");` or `titleProvider.updateText(ref, "New Title");`
  void updateText(WidgetRef ref, String text) =>
      ref.read(notifier).state = text;

  /// Clear the text (set to empty string)
  /// Usage: `searchProvider.clearText(ref);` or `inputProvider.clearText(ref);`
  void clearText(WidgetRef ref) => ref.read(notifier).state = '';

  /// Append text to the current value
  /// Usage: `messageProvider.appendText(ref, " world!");` or `logProvider.appendText(ref, "\nNew line");`
  void appendText(WidgetRef ref, String text) =>
      ref.read(notifier).state += text;

  /// Prepend text to the current value
  /// Usage: `prefixProvider.prependText(ref, "Mr. ");` or `urlProvider.prependText(ref, "https://");`
  void prependText(WidgetRef ref, String text) =>
      ref.read(notifier).state = text + ref.read(notifier).state;

  /// Replace part of the text
  /// Usage: `contentProvider.replaceText(ref, "old", "new");`
  void replaceText(WidgetRef ref, String from, String to) =>
      ref.read(notifier).state = ref.read(notifier).state.replaceAll(from, to);

  /// Set to a specific text value
  /// Usage: `statusProvider.setValue(ref, "completed");`
  void setValue(WidgetRef ref, String value) =>
      ref.read(notifier).state = value;
}

/// Extension on StateProvider<List<T>> for list operations
extension ListProviderSugar<T> on StateProvider<List<T>> {
  /// Add an item to the list
  /// Usage: `todosProvider.addItem(ref, newTodo);` or `usersProvider.addItem(ref, newUser);`
  void addItem(WidgetRef ref, T item) {
    final current = ref.read(notifier).state;
    ref.read(notifier).state = [...current, item];
  }

  /// Add multiple items to the list
  /// Usage: `itemsProvider.addItems(ref, [item1, item2, item3]);`
  void addItems(WidgetRef ref, List<T> items) {
    final current = ref.read(notifier).state;
    ref.read(notifier).state = [...current, ...items];
  }

  /// Remove an item from the list
  /// Usage: `todosProvider.removeItem(ref, todoToRemove);`
  void removeItem(WidgetRef ref, T item) {
    final current = ref.read(notifier).state;
    ref.read(notifier).state = current.where((e) => e != item).toList();
  }

  /// Remove item at specific index
  /// Usage: `listProvider.removeAt(ref, 0);`
  void removeAt(WidgetRef ref, int index) {
    final current = ref.read(notifier).state;
    if (index >= 0 && index < current.length) {
      final newList = List<T>.from(current);
      newList.removeAt(index);
      ref.read(notifier).state = newList;
    }
  }

  /// Insert item at specific index
  /// Usage: `listProvider.insertAt(ref, 0, newItem);`
  void insertAt(WidgetRef ref, int index, T item) {
    final current = ref.read(notifier).state;
    final newList = List<T>.from(current);
    newList.insert(index, item);
    ref.read(notifier).state = newList;
  }

  /// Update item at specific index
  /// Usage: `listProvider.updateAt(ref, 0, updatedItem);`
  void updateAt(WidgetRef ref, int index, T item) {
    final current = ref.read(notifier).state;
    if (index >= 0 && index < current.length) {
      final newList = List<T>.from(current);
      newList[index] = item;
      ref.read(notifier).state = newList;
    }
  }

  /// Clear all items from the list
  /// Usage: `itemsProvider.clearAll(ref);`
  void clearAll(WidgetRef ref) => ref.read(notifier).state = [];

  /// Replace the entire list
  /// Usage: `listProvider.replaceWith(ref, newList);`
  void replaceWith(WidgetRef ref, List<T> newList) =>
      ref.read(notifier).state = newList;

  /// Get the current length of the list
  /// Usage: `final count = todosProvider.getLength(ref);`
  int getLength(WidgetRef ref) => ref.read(this).length;

  /// Check if the list is empty
  /// Usage: `final isEmpty = listProvider.isEmpty(ref);`
  bool isEmpty(WidgetRef ref) => ref.read(this).isEmpty;

  /// Check if the list is not empty
  /// Usage: `final hasItems = listProvider.isNotEmpty(ref);`
  bool isNotEmpty(WidgetRef ref) => ref.read(this).isNotEmpty;
}

/// Extension on WidgetRef for enhanced state watching and management
extension WidgetRefSugar on WidgetRef {
  /// Watch any StateProvider and get its current value
  /// Usage: `final count = ref.watchValue(counterProvider);` - Use anywhere integers are needed
  T watchValue<T>(StateProvider<T> provider) => watch(provider);

  /// Read any StateProvider and get its current value (one-time read)
  /// Usage: `final currentCount = ref.readValue(counterProvider);` - Use for one-time access
  T readValue<T>(StateProvider<T> provider) => read(provider);

  /// Update any StateProvider with a new value
  /// Usage: `ref.updateValue(counterProvider, 10);` - Works with any StateProvider
  void updateValue<T>(StateProvider<T> provider, T value) =>
      read(provider.notifier).state = value;

  /// Watch a boolean provider and conditionally show a widget
  /// Usage: `ref.showWhen(visibleProvider, MyWidget())` - Full flexibility for any widget
  Widget showWhen(StateProvider<bool> provider, Widget child) {
    return watch(provider) ? child : const SizedBox.shrink();
  }

  /// Watch a boolean provider and show different widgets based on true/false
  /// Usage: `ref.showEither(darkModeProvider, DarkWidget(), LightWidget())`
  Widget showEither(
      StateProvider<bool> provider, Widget whenTrue, Widget whenFalse) {
    return watch(provider) ? whenTrue : whenFalse;
  }
}

/// Global convenience class for instant provider creation with descriptive names
class Sugar {
  /// Create an integer provider instantly
  /// Usage: `final counter = Sugar.integer(0);` or `final age = Sugar.integer(25);`
  static StateProvider<int> integer([int initial = 0]) =>
      StateProvider((ref) => initial);

  /// Create a text provider instantly
  /// Usage: `final name = Sugar.text('John');` or `final title = Sugar.text('');`
  static StateProvider<String> text([String initial = '']) =>
      StateProvider((ref) => initial);

  /// Create a boolean provider instantly
  /// Usage: `final isDark = Sugar.boolean(false);` or `final isEnabled = Sugar.boolean(true);`
  static StateProvider<bool> boolean([bool initial = false]) =>
      StateProvider((ref) => initial);

  /// Create a double provider instantly
  /// Usage: `final price = Sugar.decimal(19.99);` or `final rating = Sugar.decimal(4.5);`
  static StateProvider<double> decimal([double initial = 0.0]) =>
      StateProvider((ref) => initial);

  /// Create a list provider instantly
  /// Usage: `final todos = Sugar.list<Todo>();` or `final numbers = Sugar.list<int>([1, 2, 3]);`
  static StateProvider<List<T>> list<T>([List<T>? initial]) =>
      StateProvider((ref) => initial ?? <T>[]);
}

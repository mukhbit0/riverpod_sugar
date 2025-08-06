import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../utils/sugar_debug.dart';

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
  /// Usage: `final nameProvider = "John".state;`
  StateProvider<String> get state => StateProvider((ref) => this);
}

/// Extension on booleans to create state providers instantly
extension BooleanSugar on bool {
  /// Creates a StateProvider with this boolean as initial value
  /// Usage: `final isDarkProvider = false.state;`
  StateProvider<bool> get state => StateProvider((ref) => this);
}

/// Extension on lists to create state providers instantly
extension ListSugar<T> on List<T> {
  /// Creates a StateProvider with this list as initial value
  /// Usage: `final itemsProvider = <String>[].state;`
  StateProvider<List<T>> get state => StateProvider((ref) => this);
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

  /// Enhanced ref-style access for more intuitive syntax
  /// Usage: `final count = counterProvider.ref.watch(ref);` or `counterProvider.ref.set(ref, value);`
  StateProviderRefAccess<T> get ref => StateProviderRefAccess<T>(this);
}

/// Helper class to provide ref-style access to StateProvider operations
/// This enables syntax like: `counterProvider.ref.watch(ref)` and `nameProvider.ref.set(ref, "value")`
class StateProviderRefAccess<T> {
  final StateProvider<T> _provider;

  /// Creates a StateProviderRefAccess for the given provider
  const StateProviderRefAccess(this._provider);

  /// Watch the provider value - rebuilds only widgets that call this
  /// Usage: `final count = counterProvider.ref.watch(ref);`
  T watch(WidgetRef ref) => ref.watch(_provider);

  /// Read the provider value once - no rebuilding
  /// Usage: `final currentCount = counterProvider.ref.read(ref);`
  T read(WidgetRef ref) => ref.read(_provider);

  /// Update the provider value
  /// Usage: `counterProvider.ref.set(ref, 42);`
  void set(WidgetRef ref, T value) =>
      ref.read(_provider.notifier).state = value;

  /// Get direct access to the notifier
  /// Usage: `counterProvider.ref.notifier(ref).state = newValue;`
  StateController<T> notifier(WidgetRef ref) => ref.read(_provider.notifier);

  /// Create a Text widget directly from the provider
  /// Usage: `Text(counterProvider.ref.text(ref))` or `counterProvider.ref.textWidget(ref)`
  String text(WidgetRef ref) => '${ref.watch(_provider)}';

  /// Create a Text widget directly - most concise option
  /// Usage: `counterProvider.ref.textWidget(ref)`
  Widget textWidget(WidgetRef ref, {TextStyle? style, TextAlign? textAlign}) {
    return Text(
      '${ref.watch(_provider)}',
      style: style,
      textAlign: textAlign,
    );
  }

  /// Call operator for ultra-concise syntax
  /// Usage: `Text('${counterProvider.ref(ref)}')` - shortest possible!
  String call(WidgetRef ref) => '${ref.watch(_provider)}';
}

/// Extension on StateProvider&lt;int&gt; for integer operations
extension IntProviderSugar on StateProvider<int> {
  /// Increment the integer value by 1
  /// Usage: `countProvider.increment(ref);` or `ageProvider.increment(ref);`
  void increment(WidgetRef ref) {
    SugarPerformance.trackOperation('increment');
    ref.read(notifier).state++;
  }

  /// Decrement the integer value by 1
  /// Usage: `countProvider.decrement(ref);` or `scoreProvider.decrement(ref);`
  void decrement(WidgetRef ref) {
    SugarPerformance.trackOperation('decrement');
    ref.read(notifier).state--;
  }

  /// Add a value to the current integer
  /// Usage: `pointsProvider.addValue(ref, 10);` or `balanceProvider.addValue(ref, 50);`
  void addValue(WidgetRef ref, int value) {
    SugarPerformance.trackOperation('addValue');
    SugarDebugger.validateOperation('addValue', value);
    ref.read(notifier).state += value;
  }

  /// Subtract a value from the current integer
  /// Usage: `pointsProvider.subtractValue(ref, 5);` or `healthProvider.subtractValue(ref, 20);`
  void subtractValue(WidgetRef ref, int value) {
    SugarPerformance.trackOperation('subtractValue');
    SugarDebugger.validateOperation('subtractValue', value);
    ref.read(notifier).state -= value;
  }

  /// Reset the integer to 0
  /// Usage: `counterProvider.resetToZero(ref);` or `scoreProvider.resetToZero(ref);`
  void resetToZero(WidgetRef ref) {
    SugarPerformance.trackOperation('resetToZero');
    ref.read(notifier).state = 0;
  }

  /// Set to a specific value
  /// Usage: `levelProvider.setValue(ref, 5);` or `pageProvider.setValue(ref, 1);`
  void setValue(WidgetRef ref, int value) {
    SugarPerformance.trackOperation('setValue');
    SugarDebugger.validateOperation('setValue', value);
    ref.read(notifier).state = value;
  }
}

/// Extension on StateProvider&lt;double&gt; for decimal operations
extension DoubleProviderSugar on StateProvider<double> {
  /// Add a value to the current double
  /// Usage: `priceProvider.addValue(ref, 10.5);` or `ratingProvider.addValue(ref, 0.5);`
  void addValue(WidgetRef ref, double value) =>
      ref.read(notifier).state += value;

  /// Subtract a value from the current double
  /// Usage: `priceProvider.subtractValue(ref, 5.99);` or `temperatureProvider.subtractValue(ref, 2.5);`
  void subtractValue(WidgetRef ref, double value) =>
      ref.read(notifier).state -= value;

  /// Reset the double to 0.0
  /// Usage: `priceProvider.resetToZero(ref);`
  void resetToZero(WidgetRef ref) => ref.read(notifier).state = 0.0;

  /// Set to a specific value
  /// Usage: `priceProvider.setValue(ref, 19.99);`
  void setValue(WidgetRef ref, double value) =>
      ref.read(notifier).state = value;
}

/// Extension on StateProvider&lt;bool&gt; for boolean operations
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

/// Extension on StateProvider&lt;String&gt; for text operations
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

  /// Set to a specific text value
  /// Usage: `statusProvider.setValue(ref, "completed");`
  void setValue(WidgetRef ref, String value) =>
      ref.read(notifier).state = value;
}

/// Extension on StateProvider&lt;List&lt;T&gt;&gt; for list operations
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
}

/// Extension on WidgetRef for enhanced state watching and management
extension WidgetRefSugar on WidgetRef {
  /// Watch any StateProvider and get its current value
  /// Usage: `final count = ref.watchValue(counterProvider);` - Use anywhere integers are needed
  T watchValue<T>(StateProvider<T> provider) => watch(provider);

  /// Read any StateProvider and get its current value (one-time read)
  /// Usage: `final currentCount = ref.readValue(counterProvider);` - Use for one-time access
  T readValue<T>(StateProvider<T> provider) => read(provider);

  /// Watch a boolean provider and show different widgets based on true/false
  /// Usage: `ref.showEither(darkModeProvider, DarkWidget(), LightWidget())`
  Widget showEither(
      StateProvider<bool> provider, Widget whenTrue, Widget whenFalse) {
    return watch(provider) ? whenTrue : whenFalse;
  }

  /// Create a Text widget displaying any provider value
  /// Usage: `ref.text(counterProvider)` or `ref.text(nameProvider, style: myStyle)`
  Widget text<T>(StateProvider<T> provider,
      {TextStyle? style, TextAlign? textAlign}) {
    return Text(
      '${watch(provider)}',
      style: style,
      textAlign: textAlign,
    );
  }

  /// Create a switch tile for boolean providers
  /// Usage: `ref.switchTile(darkModeProvider, title: "Dark Mode")`
  Widget switchTile(
    StateProvider<bool> provider, {
    required String title,
    String? subtitle,
    Widget? leading,
    Widget? secondary,
  }) {
    return SwitchListTile(
      title: Text(title),
      subtitle: subtitle != null ? Text(subtitle) : null,
      secondary: leading,
      value: watch(provider),
      onChanged: (value) => read(provider.notifier).state = value,
    );
  }

  /// Create a checkbox tile for boolean providers
  /// Usage: `ref.checkboxTile(agreeProvider, title: "I agree to terms")`
  Widget checkboxTile(
    StateProvider<bool> provider, {
    required String title,
    String? subtitle,
    Widget? leading,
  }) {
    return CheckboxListTile(
      title: Text(title),
      subtitle: subtitle != null ? Text(subtitle) : null,
      secondary: leading,
      value: watch(provider),
      onChanged: (value) => read(provider.notifier).state = value ?? false,
    );
  }

  /// Create a circular progress indicator based on a loading provider
  /// Usage: `ref.loading(isLoadingProvider)` or `ref.loading(isLoadingProvider, size: 24)`
  Widget loading(
    StateProvider<bool> provider, {
    double? size,
    Color? color,
    double? strokeWidth,
  }) {
    return watch(provider)
        ? SizedBox(
            width: size,
            height: size,
            child: CircularProgressIndicator(
              color: color,
              strokeWidth: strokeWidth ?? 4.0,
            ),
          )
        : const SizedBox.shrink();
  }
}

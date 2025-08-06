import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Additional Sugar Extensions for Complex Types
/// Adds support for Colors, ThemeData, Controllers, and Maps

/// Extension on Color to create instant providers
extension ColorSugar on Color {
  /// Creates a StateProvider with this color as initial value
  /// Usage: `final primaryColor = const Color(0xFF6750A4).state;`
  StateProvider<Color> get state => StateProvider((ref) => this);
}

/// Extension on ThemeData to create instant providers
extension ThemeDataSugar on ThemeData {
  /// Creates a StateProvider with this theme as initial value
  /// Usage: `final currentTheme = AppTheme.lightTheme.state;`
  StateProvider<ThemeData> get state => StateProvider((ref) => this);
}

/// Extension on PageController to create instant providers
extension PageControllerSugar on PageController {
  /// Creates a StateProvider with this controller as initial value
  /// Usage: `final pageController = PageController().state;`
  StateProvider<PageController> get state => StateProvider((ref) => this);
}

/// Extension on Map to create instant providers
extension MapSugar<K, V> on Map<K, V> {
  /// Creates a StateProvider with this map as initial value
  /// Usage: `final configMap = <String, dynamic>{}.state;`
  StateProvider<Map<K, V>> get state => StateProvider((ref) => this);
}

/// Extension on TextEditingController to create instant providers
extension TextControllerSugar on TextEditingController {
  /// Creates a StateProvider with this controller as initial value
  /// Usage: `final textController = TextEditingController().state;`
  StateProvider<TextEditingController> get state =>
      StateProvider((ref) => this);
}

/// Extension on ScrollController to create instant providers
extension ScrollControllerSugar on ScrollController {
  /// Creates a StateProvider with this controller as initial value
  /// Usage: `final scrollController = ScrollController().state;`
  StateProvider<ScrollController> get state => StateProvider((ref) => this);
}

/// Extension on TabController to create instant providers
extension TabControllerSugar on TabController {
  /// Creates a StateProvider with this controller as initial value
  /// Usage: `final tabController = TabController(length: 3, vsync: this).state;`
  StateProvider<TabController> get state => StateProvider((ref) => this);
}

/// Extension on List to create instant providers
extension ListSugar<T> on List<T> {
  /// Creates a StateProvider with this list as initial value
  /// Usage: `final items = <String>[].state;`
  StateProvider<List<T>> get state => StateProvider((ref) => this);
}

/// Extension on double to create instant providers
extension DoubleSugar on double {
  /// Creates a StateProvider with this double as initial value
  /// Usage: `final progress = 0.0.state;`
  StateProvider<double> get state => StateProvider((ref) => this);
}

/// Extension on DateTime to create instant providers
extension DateTimeSugar on DateTime {
  /// Creates a StateProvider with this DateTime as initial value
  /// Usage: `final selectedDate = DateTime.now().state;`
  StateProvider<DateTime> get state => StateProvider((ref) => this);
}

/// Extension on TimeOfDay to create instant providers
extension TimeOfDaySugar on TimeOfDay {
  /// Creates a StateProvider with this TimeOfDay as initial value
  /// Usage: `final selectedTime = TimeOfDay.now().state;`
  StateProvider<TimeOfDay> get state => StateProvider((ref) => this);
}

/// Extension on Set to create instant providers
extension SetSugar<T> on Set<T> {
  /// Creates a StateProvider with this set as initial value
  /// Usage: `final selectedItems = <String>{}.state;`
  StateProvider<Set<T>> get state => StateProvider((ref) => this);
}

/// Extension on Locale to create instant providers
extension LocaleSugar on Locale {
  /// Creates a StateProvider with this locale as initial value
  /// Usage: `final currentLocale = Locale('en').state;`
  StateProvider<Locale> get state => StateProvider((ref) => this);
}

/// Extension on FocusNode to create instant providers
extension FocusNodeSugar on FocusNode {
  /// Creates a StateProvider with this FocusNode as initial value
  /// Usage: `final textFocus = FocusNode().state;`
  StateProvider<FocusNode> get state => StateProvider((ref) => this);
}

/// Extension on Enum to create instant providers
extension EnumSugar<T extends Enum> on T {
  /// Creates a StateProvider with this enum as initial value
  /// Usage: `final status = MyEnum.idle.state;`
  StateProvider<T> get state => StateProvider((ref) => this);
}

/// Enhanced StateProvider operations with proper ref type handling
extension StateProviderRefFix<T> on StateProvider<T> {
  /// Set value with proper ref type handling
  /// Works with both WidgetRef and other ref types
  /// Usage: `provider.setValue(ref, newValue);`
  void setValue(Ref ref, T value) {
    ref.read(notifier).state = value;
  }

  /// Set value for WidgetRef specifically
  /// Usage: `provider.setWidgetValue(ref, newValue);`
  void setWidgetValue(WidgetRef ref, T value) {
    ref.read(notifier).state = value;
  }

  /// Get value with proper ref type handling
  /// Usage: `final value = provider.getValue(ref);`
  T getValue(Ref ref) {
    return ref.read(this);
  }

  /// Get value for WidgetRef specifically
  /// Usage: `final value = provider.getWidgetValue(ref);`
  T getWidgetValue(WidgetRef ref) {
    return ref.read(this);
  }
}

/// Color provider manipulation extensions
extension ColorProviderSugar on StateProvider<Color> {
  /// Get the current color value
  Color colorValue(WidgetRef ref) => ref.read(this);

  /// Get the hex string representation
  String hexString(WidgetRef ref) {
    final color = ref.read(this);
    return '#${color.toARGB32().toRadixString(16).padLeft(8, '0').substring(2)}';
  }

  /// Get the opacity of the color
  double opacity(WidgetRef ref) => ref.read(this).a;

  /// Set color with specific opacity
  void withOpacity(WidgetRef ref, double opacity) {
    final current = ref.read(this);
    ref.read(notifier).state = current.withValues(alpha: opacity);
  }

  /// Brighten the color
  void brighten(WidgetRef ref, double factor) {
    final current = ref.read(this);
    final hsl = HSLColor.fromColor(current);
    ref.read(notifier).state =
        hsl.withLightness((hsl.lightness + factor).clamp(0.0, 1.0)).toColor();
  }

  /// Darken the color
  void darken(WidgetRef ref, double factor) {
    final current = ref.read(this);
    final hsl = HSLColor.fromColor(current);
    ref.read(notifier).state =
        hsl.withLightness((hsl.lightness - factor).clamp(0.0, 1.0)).toColor();
  }
}

/// ThemeData provider manipulation extensions
extension ThemeDataProviderSugar on StateProvider<ThemeData> {
  /// Get the current brightness
  Brightness brightness(WidgetRef ref) => ref.read(this).brightness;

  /// Get the primary color
  Color primaryColor(WidgetRef ref) => ref.read(this).primaryColor;

  /// Switch to dark theme
  void switchToDark(WidgetRef ref) {
    ref.read(notifier).state = ThemeData.dark();
  }

  /// Switch to light theme
  void switchToLight(WidgetRef ref) {
    ref.read(notifier).state = ThemeData.light();
  }

  /// Copy with new properties
  void copyWith(
    WidgetRef ref, {
    ColorScheme? colorScheme,
    Color? primaryColor,
    Brightness? brightness,
  }) {
    final current = ref.read(this);
    ref.read(notifier).state = current.copyWith(
      colorScheme: colorScheme,
      primaryColor: primaryColor,
      brightness: brightness,
    );
  }
}

/// PageController provider manipulation extensions
extension PageControllerProviderSugar on StateProvider<PageController> {
  /// Get current page
  double? currentPage(WidgetRef ref) =>
      ref.read(this).hasClients ? ref.read(this).page : null;

  /// Animate to specific page
  void animateToPage(WidgetRef ref, int page) {
    ref.read(this).animateToPage(
          page,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
  }

  /// Jump to specific page
  void jumpToPage(WidgetRef ref, int page) {
    ref.read(this).jumpToPage(page);
  }

  /// Go to next page
  void nextPage(WidgetRef ref) {
    ref.read(this).nextPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
  }

  /// Go to previous page
  void previousPage(WidgetRef ref) {
    ref.read(this).previousPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
  }
}

/// Map provider manipulation extensions
extension MapProviderSugar<K, V> on StateProvider<Map<K, V>> {
  /// Set a key-value pair
  void setValue(WidgetRef ref, K key, V value) {
    final current = Map<K, V>.from(ref.read(this));
    current[key] = value;
    ref.read(notifier).state = current;
  }

  /// Get value by key
  V? getValue(WidgetRef ref, K key) => ref.read(this)[key];

  /// Check if key exists
  bool hasKey(WidgetRef ref, K key) => ref.read(this).containsKey(key);

  /// Remove a key
  void removeKey(WidgetRef ref, K key) {
    final current = Map<K, V>.from(ref.read(this));
    current.remove(key);
    ref.read(notifier).state = current;
  }

  /// Clear all entries
  void clear(WidgetRef ref) {
    ref.read(notifier).state = <K, V>{};
  }
}

/// List provider manipulation extensions
extension ListProviderSugar<T> on StateProvider<List<T>> {
  /// Add item to list
  void add(WidgetRef ref, T item) {
    final current = List<T>.from(ref.read(this));
    current.add(item);
    ref.read(notifier).state = current;
  }

  /// Remove item from list
  void remove(WidgetRef ref, T item) {
    final current = List<T>.from(ref.read(this));
    current.remove(item);
    ref.read(notifier).state = current;
  }

  /// Remove item at index
  void removeAt(WidgetRef ref, int index) {
    final current = List<T>.from(ref.read(this));
    current.removeAt(index);
    ref.read(notifier).state = current;
  }

  /// Insert item at index
  void insert(WidgetRef ref, int index, T item) {
    final current = List<T>.from(ref.read(this));
    current.insert(index, item);
    ref.read(notifier).state = current;
  }

  /// Clear all items
  void clear(WidgetRef ref) {
    ref.read(notifier).state = <T>[];
  }

  /// Update item at a specific index
  void update(WidgetRef ref, int index, T newItem) {
    final current = List<T>.from(ref.read(this));
    if (index >= 0 && index < current.length) {
      current[index] = newItem;
      ref.read(notifier).state = current;
    }
  }

  /// Add multiple items to the list
  void addAll(WidgetRef ref, Iterable<T> items) {
    final current = List<T>.from(ref.read(this));
    current.addAll(items);
    ref.read(notifier).state = current;
  }

  /// Remove items that satisfy a condition
  void removeWhere(WidgetRef ref, bool Function(T) test) {
    final current = List<T>.from(ref.read(this));
    current.removeWhere(test);
    ref.read(notifier).state = current;
  }

  /// Get length
  int length(WidgetRef ref) => ref.read(this).length;

  /// Check if empty
  bool isEmpty(WidgetRef ref) => ref.read(this).isEmpty;

  /// Check if not empty
  bool isNotEmpty(WidgetRef ref) => ref.read(this).isNotEmpty;

  /// Toggle item (add if not present, remove if present)
  void toggle(WidgetRef ref, T item) {
    final current = List<T>.from(ref.read(this));
    if (current.contains(item)) {
      current.remove(item);
    } else {
      current.add(item);
    }
    ref.read(notifier).state = current;
  }
}

/// TabController provider manipulation extensions
extension TabControllerProviderSugar on StateProvider<TabController> {
  /// Get current index
  int currentIndex(WidgetRef ref) => ref.read(this).index;

  /// Animate to tab
  void animateTo(WidgetRef ref, int index) {
    ref.read(this).animateTo(index);
  }

  /// Get tab length
  int tabLength(WidgetRef ref) => ref.read(this).length;
}

/// TextEditingController provider manipulation extensions
extension TextControllerProviderSugar on StateProvider<TextEditingController> {
  /// Get current text
  String text(WidgetRef ref) => ref.read(this).text;

  /// Set text
  void setText(WidgetRef ref, String text) {
    ref.read(this).text = text;
  }

  /// Clear text
  void clearText(WidgetRef ref) {
    ref.read(this).clear();
  }

  /// Check if empty
  bool isEmpty(WidgetRef ref) => ref.read(this).text.isEmpty;

  /// Check if not empty
  bool isNotEmpty(WidgetRef ref) => ref.read(this).text.isNotEmpty;
}

/// ScrollController provider manipulation extensions
extension ScrollControllerProviderSugar on StateProvider<ScrollController> {
  /// Get current scroll position
  double position(WidgetRef ref) =>
      ref.read(this).hasClients ? ref.read(this).position.pixels : 0.0;

  /// Scroll to top
  void scrollToTop(WidgetRef ref) {
    if (ref.read(this).hasClients) {
      ref.read(this).animateTo(
            0.0,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
    }
  }

  /// Scroll to bottom
  void scrollToBottom(WidgetRef ref) {
    if (ref.read(this).hasClients) {
      ref.read(this).animateTo(
            ref.read(this).position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
    }
  }

  /// Check if at top
  bool isAtTop(WidgetRef ref) =>
      ref.read(this).hasClients && ref.read(this).position.pixels == 0.0;

  /// Check if at bottom
  bool isAtBottom(WidgetRef ref) =>
      ref.read(this).hasClients &&
      ref.read(this).position.pixels >= ref.read(this).position.maxScrollExtent;
}

/// DateTime provider manipulation extensions
extension DateTimeProviderSugar on StateProvider<DateTime> {
  /// Get formatted date string
  String formatDate(WidgetRef ref, [String pattern = 'yyyy-MM-dd']) {
    final date = ref.read(this);
    // Basic formatting - you can enhance with intl package
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  /// Get formatted time string
  String formatTime(WidgetRef ref) {
    final date = ref.read(this);
    return '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }

  /// Check if today
  bool isToday(WidgetRef ref) {
    final date = ref.read(this);
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  /// Add days
  void addDays(WidgetRef ref, int days) {
    final current = ref.read(this);
    ref.read(notifier).state = current.add(Duration(days: days));
  }

  /// Subtract days
  void subtractDays(WidgetRef ref, int days) {
    final current = ref.read(this);
    ref.read(notifier).state = current.subtract(Duration(days: days));
  }

  /// Set to today
  void setToday(WidgetRef ref) {
    ref.read(notifier).state = DateTime.now();
  }
}

/// TimeOfDay provider manipulation extensions
extension TimeOfDayProviderSugar on StateProvider<TimeOfDay> {
  /// Get formatted time string
  String formatTime(WidgetRef ref, [bool use24Hour = true]) {
    final time = ref.read(this);
    if (use24Hour) {
      return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
    } else {
      final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
      final period = time.period == DayPeriod.am ? 'AM' : 'PM';
      return '${hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')} $period';
    }
  }

  /// Set to current time
  void setNow(WidgetRef ref) {
    final now = DateTime.now();
    ref.read(notifier).state = TimeOfDay(hour: now.hour, minute: now.minute);
  }

  /// Add minutes
  void addMinutes(WidgetRef ref, int minutes) {
    final current = ref.read(this);
    final totalMinutes = current.hour * 60 + current.minute + minutes;
    final newHour = (totalMinutes ~/ 60) % 24;
    final newMinute = totalMinutes % 60;
    ref.read(notifier).state = TimeOfDay(hour: newHour, minute: newMinute);
  }
}

/// Set provider manipulation extensions
extension SetProviderSugar<T> on StateProvider<Set<T>> {
  /// Add item to set
  void add(WidgetRef ref, T item) {
    final current = Set<T>.from(ref.read(this));
    current.add(item);
    ref.read(notifier).state = current;
  }

  /// Remove item from set
  void remove(WidgetRef ref, T item) {
    final current = Set<T>.from(ref.read(this));
    current.remove(item);
    ref.read(notifier).state = current;
  }

  /// Toggle item (add if not present, remove if present)
  void toggle(WidgetRef ref, T item) {
    final current = Set<T>.from(ref.read(this));
    if (current.contains(item)) {
      current.remove(item);
    } else {
      current.add(item);
    }
    ref.read(notifier).state = current;
  }

  /// Check if contains item
  bool contains(WidgetRef ref, T item) => ref.read(this).contains(item);

  /// Clear all items
  void clear(WidgetRef ref) {
    ref.read(notifier).state = <T>{};
  }

  /// Get length
  int length(WidgetRef ref) => ref.read(this).length;

  /// Check if empty
  bool isEmpty(WidgetRef ref) => ref.read(this).isEmpty;

  /// Check if not empty
  bool isNotEmpty(WidgetRef ref) => ref.read(this).isNotEmpty;

  /// Add multiple items
  void addAll(WidgetRef ref, Iterable<T> items) {
    final current = Set<T>.from(ref.read(this));
    current.addAll(items);
    ref.read(notifier).state = current;
  }
}

/// FocusNode provider manipulation extensions
extension FocusNodeProviderSugar on StateProvider<FocusNode> {
  /// Request focus
  void requestFocus(WidgetRef ref) {
    ref.read(this).requestFocus();
  }

  /// Unfocus
  void unfocus(WidgetRef ref) {
    ref.read(this).unfocus();
  }

  /// Check if has focus
  bool hasFocus(WidgetRef ref) => ref.read(this).hasFocus;

  /// Check if has primary focus
  bool hasPrimaryFocus(WidgetRef ref) => ref.read(this).hasPrimaryFocus;

  /// Next focus
  void nextFocus(WidgetRef ref) {
    ref.read(this).nextFocus();
  }

  /// Previous focus
  void previousFocus(WidgetRef ref) {
    ref.read(this).previousFocus();
  }
}

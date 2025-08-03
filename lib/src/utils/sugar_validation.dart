import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Enhanced Sugar extensions with better error handling and validation
extension SafeStateProviderSugar<T> on StateProvider<T> {
  /// Safely read the value with error handling
  T? safeRead(WidgetRef ref, {T? fallback}) {
    try {
      return ref.read(this);
    } catch (e) {
      if (kDebugMode) {
        debugPrint('🍯 Sugar Safe Read Error: ${e.toString()}');
      }
      return fallback;
    }
  }

  /// Safely update the value with validation
  bool safeUpdate(WidgetRef ref, T value, {bool Function(T)? validator}) {
    try {
      // Validate if validator is provided
      if (validator != null && !validator(value)) {
        if (kDebugMode) {
          debugPrint(
              '🍯 Sugar Validation Failed: $value did not pass validation');
        }
        return false;
      }

      ref.read(notifier).state = value;
      return true;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('🍯 Sugar Safe Update Error: ${e.toString()}');
      }
      return false;
    }
  }

  /// Check if the provider is in a valid state
  bool isValid(WidgetRef ref) {
    try {
      ref.read(this);
      return true;
    } catch (e) {
      return false;
    }
  }
}

/// Enhanced integer provider extensions with bounds checking
extension SafeIntProviderSugar on StateProvider<int> {
  /// Increment with bounds checking
  bool safeIncrement(WidgetRef ref, {int? max}) {
    try {
      final current = ref.read(this);
      if (max != null && current >= max) {
        if (kDebugMode) {
          debugPrint(
              '🍯 Sugar Increment Warning: Cannot exceed max value $max');
        }
        return false;
      }
      ref.read(notifier).state = current + 1;
      return true;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('🍯 Sugar Increment Error: ${e.toString()}');
      }
      return false;
    }
  }

  /// Decrement with bounds checking
  bool safeDecrement(WidgetRef ref, {int? min}) {
    try {
      final current = ref.read(this);
      if (min != null && current <= min) {
        if (kDebugMode) {
          debugPrint(
              '🍯 Sugar Decrement Warning: Cannot go below min value $min');
        }
        return false;
      }
      ref.read(notifier).state = current - 1;
      return true;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('🍯 Sugar Decrement Error: ${e.toString()}');
      }
      return false;
    }
  }

  /// Add value with bounds checking
  bool safeAddValue(WidgetRef ref, int value, {int? min, int? max}) {
    try {
      final current = ref.read(this);
      final newValue = current + value;

      if (min != null && newValue < min) {
        if (kDebugMode) {
          debugPrint(
              '🍯 Sugar Add Warning: Result $newValue would be below min $min');
        }
        return false;
      }

      if (max != null && newValue > max) {
        if (kDebugMode) {
          debugPrint(
              '🍯 Sugar Add Warning: Result $newValue would exceed max $max');
        }
        return false;
      }

      ref.read(notifier).state = newValue;
      return true;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('🍯 Sugar Add Error: ${e.toString()}');
      }
      return false;
    }
  }
}

/// Enhanced string provider extensions with validation
extension SafeStringProviderSugar on StateProvider<String> {
  /// Update text with length validation
  bool safeUpdateText(WidgetRef ref, String text,
      {int? minLength, int? maxLength}) {
    try {
      if (minLength != null && text.length < minLength) {
        if (kDebugMode) {
          debugPrint(
              '🍯 Sugar Text Warning: Text too short (${text.length} < $minLength)');
        }
        return false;
      }

      if (maxLength != null && text.length > maxLength) {
        if (kDebugMode) {
          debugPrint(
              '🍯 Sugar Text Warning: Text too long (${text.length} > $maxLength)');
        }
        return false;
      }

      ref.read(notifier).state = text;
      return true;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('🍯 Sugar Text Update Error: ${e.toString()}');
      }
      return false;
    }
  }

  /// Append text with length validation
  bool safeAppendText(WidgetRef ref, String text, {int? maxLength}) {
    try {
      final current = ref.read(this);
      final newText = current + text;

      if (maxLength != null && newText.length > maxLength) {
        if (kDebugMode) {
          debugPrint(
              '🍯 Sugar Append Warning: Result too long (${newText.length} > $maxLength)');
        }
        return false;
      }

      ref.read(notifier).state = newText;
      return true;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('🍯 Sugar Append Error: ${e.toString()}');
      }
      return false;
    }
  }
}

/// Enhanced list provider extensions with validation
extension SafeListProviderSugar<T> on StateProvider<List<T>> {
  /// Add item with capacity checking
  bool safeAddItem(WidgetRef ref, T item, {int? maxCapacity}) {
    try {
      final current = ref.read(this);

      if (maxCapacity != null && current.length >= maxCapacity) {
        if (kDebugMode) {
          debugPrint(
              '🍯 Sugar List Warning: Cannot exceed max capacity $maxCapacity');
        }
        return false;
      }

      ref.read(notifier).state = [...current, item];
      return true;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('🍯 Sugar List Add Error: ${e.toString()}');
      }
      return false;
    }
  }

  /// Remove item safely
  bool safeRemoveItem(WidgetRef ref, T item) {
    try {
      final current = ref.read(this);
      if (!current.contains(item)) {
        if (kDebugMode) {
          debugPrint('🍯 Sugar List Warning: Item not found in list');
        }
        return false;
      }

      ref.read(notifier).state = current.where((e) => e != item).toList();
      return true;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('🍯 Sugar List Remove Error: ${e.toString()}');
      }
      return false;
    }
  }

  /// Remove at index safely
  bool safeRemoveAt(WidgetRef ref, int index) {
    try {
      final current = ref.read(this);
      if (index < 0 || index >= current.length) {
        if (kDebugMode) {
          debugPrint(
              '🍯 Sugar List Warning: Index $index out of bounds (0-${current.length - 1})');
        }
        return false;
      }

      final newList = List<T>.from(current);
      newList.removeAt(index);
      ref.read(notifier).state = newList;
      return true;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('🍯 Sugar List Remove At Error: ${e.toString()}');
      }
      return false;
    }
  }
}

/// Common validators for Sugar extensions
class SugarValidators {
  /// Validate integer range
  static bool intRange(int value, {int? min, int? max}) {
    if (min != null && value < min) return false;
    if (max != null && value > max) return false;
    return true;
  }

  /// Validate string length
  static bool stringLength(String value, {int? minLength, int? maxLength}) {
    if (minLength != null && value.length < minLength) return false;
    if (maxLength != null && value.length > maxLength) return false;
    return true;
  }

  /// Validate email format
  static bool email(String value) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(value);
  }

  /// Validate non-empty string
  static bool notEmpty(String value) {
    return value.trim().isNotEmpty;
  }

  /// Validate list capacity
  static bool listCapacity<T>(List<T> value, {int? maxCapacity}) {
    if (maxCapacity != null && value.length > maxCapacity) return false;
    return true;
  }
}

/// Error reporter for Sugar operations
class SugarErrorReporter {
  static final List<String> _errors = [];

  /// Add an error to the log
  static void logError(String operation, String error) {
    final timestamp = DateTime.now().toIso8601String();
    final errorMsg = '[$timestamp] $operation: $error';
    _errors.add(errorMsg);

    if (kDebugMode) {
      debugPrint('🍯 Sugar Error: $errorMsg');
    }
  }

  /// Get all logged errors
  static List<String> getErrors() => List.from(_errors);

  /// Clear error log
  static void clearErrors() => _errors.clear();

  /// Get error count
  static int getErrorCount() => _errors.length;
}

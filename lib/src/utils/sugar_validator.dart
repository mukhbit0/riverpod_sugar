import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Comprehensive validation utilities for Riverpod Sugar operations
/// to provide better error messages and prevent common mistakes.
class SugarValidator {
  /// Validate that a provider is properly initialized
  static void validateProvider<T>(
      StateProvider<T>? provider, String operation) {
    if (provider == null) {
      throw ArgumentError(
        '🍯 Sugar Error: Cannot perform $operation on null provider.\n'
        '💡 Make sure your provider is properly created using Sugar extensions:\n'
        '   Example: final myProvider = 0.state; // ✅ Correct\n'
        '   Example: StateProvider<int>? myProvider; // ❌ Null provider',
      );
    }
  }

  /// Validate numeric operations
  static void validateNumericOperation(dynamic value, String operation) {
    if (value == null) {
      throw ArgumentError(
        '🍯 Sugar Error: Cannot perform $operation with null value.\n'
        '💡 Provide a valid number:\n'
        '   Example: counter.addValue(ref, 5); // ✅ Correct\n'
        '   Example: counter.addValue(ref, null); // ❌ Null value',
      );
    }

    if (value is! num) {
      throw ArgumentError(
        '🍯 Sugar Error: $operation requires a numeric value, got ${value.runtimeType}.\n'
        '💡 Use numeric values for mathematical operations:\n'
        '   Example: counter.addValue(ref, 10); // ✅ Correct\n'
        '   Example: counter.addValue(ref, "10"); // ❌ String instead of number',
      );
    }

    if (value.isNaN) {
      throw ArgumentError(
        '🍯 Sugar Error: Cannot perform $operation with NaN value.\n'
        '💡 Check your calculations to avoid NaN results.',
      );
    }

    if (value.isInfinite) {
      throw ArgumentError(
        '🍯 Sugar Error: Cannot perform $operation with infinite value.\n'
        '💡 Check for division by zero or overflow conditions.',
      );
    }
  }

  /// Validate list operations
  static void validateListOperation<T>(List<T>? list, String operation,
      [dynamic item]) {
    if (list == null) {
      throw ArgumentError(
        '🍯 Sugar Error: Cannot perform $operation on null list.\n'
        '💡 Initialize your list provider properly:\n'
        '   Example: final todos = <String>[].items; // ✅ Correct',
      );
    }

    if (operation == 'removeAt' && item is int) {
      if (item < 0 || item >= list.length) {
        throw RangeError(
          '🍯 Sugar Error: Index $item is out of range for list of length ${list.length}.\n'
          '💡 Valid range: 0 to ${list.length - 1}\n'
          '   Use ref.watchValue(listProvider).length to check list bounds.',
        );
      }
    }

    if (operation == 'insertAt' && item is int) {
      if (item < 0 || item > list.length) {
        throw RangeError(
          '🍯 Sugar Error: Insert index $item is out of range for list of length ${list.length}.\n'
          '💡 Valid range: 0 to ${list.length}\n'
          '   Use ref.watchValue(listProvider).length to check current list size.',
        );
      }
    }
  }

  /// Validate text operations
  static void validateTextOperation(String? text, String operation) {
    if (operation == 'appendText') {
      if (text == null) {
        throw ArgumentError(
          '🍯 Sugar Error: Cannot $operation with null text.\n'
          '💡 Provide a valid string:\n'
          '   Example: name.appendText(ref, " Doe"); // ✅ Correct\n'
          '   Example: name.appendText(ref, null); // ❌ Null text',
        );
      }
    }
  }

  /// Validate boolean operations
  static void validateBooleanOperation(dynamic value, String operation) {
    if (operation == 'setValue' && value is! bool) {
      throw ArgumentError(
        '🍯 Sugar Error: Boolean provider setValue requires bool value, got ${value?.runtimeType}.\n'
        '💡 Use boolean values:\n'
        '   Example: isDark.setValue(ref, true); // ✅ Correct\n'
        '   Example: isDark.setValue(ref, "true"); // ❌ String instead of bool',
      );
    }
  }

  /// Validate WidgetRef is not null
  static void validateWidgetRef(WidgetRef? ref, String operation) {
    if (ref == null) {
      throw ArgumentError(
        '🍯 Sugar Error: WidgetRef is null in $operation.\n'
        '💡 Make sure you\'re calling this from within a widget that has access to ref:\n'
        '   - RxWidget.buildRx(context, ref)\n'
        '   - ConsumerWidget.build(context, ref)\n'
        '   - Consumer((context, ref, child) => ...)',
      );
    }
  }

  /// Generate helpful error message with suggestions
  static String generateHelpfulError(String operation, String error,
      [List<String>? suggestions]) {
    final buffer = StringBuffer()
      ..writeln('🍯 Riverpod Sugar Error in $operation:')
      ..writeln('❌ $error')
      ..writeln();

    if (suggestions != null && suggestions.isNotEmpty) {
      buffer.writeln('🔧 Suggestions:');
      for (final suggestion in suggestions) {
        buffer.writeln('   💡 $suggestion');
      }
      buffer.writeln();
    }

    buffer
      ..writeln(
          '📚 Documentation: https://github.com/yourusername/riverpod_sugar#readme')
      ..writeln(
          '🐛 Report issues: https://github.com/yourusername/riverpod_sugar/issues');

    return buffer.toString();
  }

  /// Validate provider type matches operation
  static void validateProviderType<T>(String operation) {
    final type = T.toString();

    final intOperations = ['increment', 'decrement', 'addValue', 'subtractValue'];
    final boolOperations = ['toggle', 'setTrue', 'setFalse'];
    final listOperations = ['addItem', 'removeItem', 'addItems', 'clearAll'];

    if (intOperations.contains(operation) && !type.contains('int')) {
      throw ArgumentError(
        generateHelpfulError(
          operation,
          'Operation $operation can only be used with int providers, got $type',
          [
            'Use $operation only with integer providers: final counter = 0.state;',
            'For double values, use addValue, subtractValue with double providers',
            'For string values, use updateText, appendText, etc.',
          ],
        ),
      );
    }

    if (boolOperations.contains(operation) && !type.contains('bool')) {
      throw ArgumentError(
        generateHelpfulError(
          operation,
          'Operation $operation can only be used with bool providers, got $type',
          [
            'Use $operation only with boolean providers: final isDark = false.toggle;',
            'For other types, use setValue method instead',
          ],
        ),
      );
    }

    if (listOperations.contains(operation) && !type.contains('List')) {
      throw ArgumentError(
        generateHelpfulError(
          operation,
          'Operation $operation can only be used with List providers, got $type',
          [
            'Use $operation only with list providers: final todos = <String>[].items;',
            'For single values, use setValue or specific type operations',
          ],
        ),
      );
    }
  }
}

/// Safe operations wrapper that handles errors gracefully
class SugarSafeOps {
  /// Safely read from a provider with fallback
  static T safeRead<T>(
    WidgetRef ref,
    StateProvider<T> provider, {
    T? fallback,
    bool logErrors = true,
  }) {
    try {
      SugarValidator.validateProvider(provider, 'read');
      SugarValidator.validateWidgetRef(ref, 'read');
      return ref.read(provider);
    } catch (e) {
      if (logErrors && kDebugMode) {
        debugPrint('🍯 Sugar Safe Read Error: $e');
      }

      if (fallback != null) {
        return fallback;
      }

      rethrow;
    }
  }

  /// Safely update a provider value
  static bool safeUpdate<T>(
    WidgetRef ref,
    StateProvider<T> provider,
    T value, {
    bool logErrors = true,
  }) {
    try {
      SugarValidator.validateProvider(provider, 'update');
      SugarValidator.validateWidgetRef(ref, 'update');
      ref.read(provider.notifier).state = value;
      return true;
    } catch (e) {
      if (logErrors && kDebugMode) {
        debugPrint('🍯 Sugar Safe Update Error: $e');
      }
      return false;
    }
  }

  /// Safely perform list operations
  static bool safeListOperation<T>(
    WidgetRef ref,
    StateProvider<List<T>> provider,
    String operation,
    VoidCallback action, {
    bool logErrors = true,
  }) {
    try {
      SugarValidator.validateProvider(provider, operation);
      SugarValidator.validateWidgetRef(ref, operation);
      action();
      return true;
    } catch (e) {
      if (logErrors && kDebugMode) {
        debugPrint('🍯 Sugar Safe List Operation Error: $e');
      }
      return false;
    }
  }
}

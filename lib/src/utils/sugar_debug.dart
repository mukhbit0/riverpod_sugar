import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Enhanced debugging and error handling utilities for Riverpod Sugar
class SugarDebugger {
  static bool _debugMode = kDebugMode;

  /// Enable or disable debug mode
  static void setDebugMode(bool enabled) {
    _debugMode = enabled;
  }

  /// Log provider state changes
  static void logStateChange<T>(
      StateProvider<T> provider, T oldValue, T newValue) {
    if (_debugMode) {
      debugPrint('🍯 Sugar State Change: ${provider.runtimeType}');
      debugPrint('   Old: $oldValue');
      debugPrint('   New: $newValue');
    }
  }

  /// Log provider creation
  static void logProviderCreation<T>(
      StateProvider<T> provider, T initialValue) {
    if (_debugMode) {
      debugPrint(
          '🍯 Sugar Provider Created: ${provider.runtimeType} = $initialValue');
    }
  }

  /// Validate provider operations
  static void validateOperation(String operation, dynamic value) {
    if (_debugMode && value == null) {
      debugPrint('⚠️  Sugar Warning: $operation called with null value');
    }
  }

  /// Get a human-readable provider name
  static String getProviderName<T>(StateProvider<T> provider) {
    final type = provider.runtimeType.toString();
    return type.replaceAll('StateProvider<', '').replaceAll('>', '');
  }
}

/// Enhanced StateProvider extensions with debugging support
extension StateProviderDebugging<T> on StateProvider<T> {
  /// Get a debug-friendly name for this provider
  String get debugName => SugarDebugger.getProviderName(this);

  /// Set value with debug logging
  void setValueWithLogging(WidgetRef ref, T value) {
    final oldValue = ref.read(this);
    ref.read(notifier).state = value;
    SugarDebugger.logStateChange(this, oldValue, value);
  }
}

/// Error handling utilities
class SugarErrorHandler {
  /// Handle common provider errors gracefully
  static T? safeRead<T>(WidgetRef ref, StateProvider<T> provider,
      {T? fallback}) {
    try {
      return ref.read(provider);
    } catch (e) {
      if (kDebugMode) {
        debugPrint(
            '🍯 Sugar Error: Failed to read ${SugarDebugger.getProviderName(provider)} - $e');
      }
      return fallback;
    }
  }

  /// Handle safe state updates
  static bool safeUpdate<T>(WidgetRef ref, StateProvider<T> provider, T value) {
    try {
      ref.read(provider.notifier).state = value;
      return true;
    } catch (e) {
      if (kDebugMode) {
        debugPrint(
            '🍯 Sugar Error: Failed to update ${SugarDebugger.getProviderName(provider)} - $e');
      }
      return false;
    }
  }
}

/// Performance monitoring for Sugar operations
class SugarPerformance {
  static final Map<String, int> _operationCounts = {};
  static final Map<String, DateTime> _lastOperationTimes = {};

  /// Track operation frequency
  static void trackOperation(String operation) {
    if (!kDebugMode) return;

    _operationCounts[operation] = (_operationCounts[operation] ?? 0) + 1;
    _lastOperationTimes[operation] = DateTime.now();
  }

  /// Get operation statistics
  static Map<String, dynamic> getStats() {
    return {
      'operationCounts': Map.from(_operationCounts),
      'lastOperationTimes': Map.from(_lastOperationTimes),
    };
  }

  /// Clear performance tracking data
  static void clearStats() {
    _operationCounts.clear();
    _lastOperationTimes.clear();
  }

  /// Print performance summary
  static void printStats() {
    if (!kDebugMode) return;

    debugPrint('🍯 Sugar Performance Stats:');
    _operationCounts.forEach((operation, count) {
      debugPrint('   $operation: $count times');
    });
  }
}

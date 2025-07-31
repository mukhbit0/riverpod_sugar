import 'dart:async';
import 'package:flutter/foundation.dart';

/// A simple debouncer to delay the execution of a function.
///
/// Useful for scenarios like search input fields where you want to wait for
/// the user to stop typing before performing an expensive operation like API calls.
///
/// ## Basic Usage:
/// ```dart
/// final debouncer = Debouncer(milliseconds: 300);
///
/// TextField(
///   onChanged: (value) {
///     debouncer.run(() {
///       ref.read(searchProvider.notifier).search(value);
///     });
///   },
/// )
/// ```
///
/// ## How it works:
/// - Each call to [run] cancels any pending execution
/// - A new timer is started with the specified delay
/// - Only the last action within the delay period gets executed
/// - Perfect for preventing API spam from user input
class Debouncer {
  /// The delay in milliseconds before executing the action.
  final int milliseconds;

  Timer? _timer;

  /// Creates a debouncer with the specified [milliseconds] delay.
  ///
  /// ## Common delay values:
  /// - **100-200ms**: For UI updates, very responsive
  /// - **300-500ms**: For search queries, good balance
  /// - **500-1000ms**: For expensive operations, less responsive but efficient
  Debouncer({required this.milliseconds});

  /// Runs the [action] after the specified delay.
  ///
  /// If [run] is called again before the timer completes, the previous
  /// timer is cancelled and a new one is started. This ensures only the
  /// last action gets executed.
  ///
  /// ## Example:
  /// ```dart
  /// final debouncer = Debouncer(milliseconds: 500);
  ///
  /// // User types quickly: "h", "he", "hel", "hell", "hello"
  /// // Only the search for "hello" will execute after 500ms
  /// onChanged: (value) {
  ///   debouncer.run(() => performSearch(value));
  /// }
  /// ```
  void run(VoidCallback action) {
    // Cancel any existing timer
    _timer?.cancel();

    // Start a new timer
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }

  /// Cancels any pending execution without running the action.
  ///
  /// Useful when you want to prevent the debounced action from executing,
  /// for example when disposing a widget or navigating away.
  ///
  /// ## Example:
  /// ```dart
  /// @override
  /// void dispose() {
  ///   debouncer.cancel(); // Prevent search after widget disposal
  ///   super.dispose();
  /// }
  /// ```
  void cancel() {
    _timer?.cancel();
    _timer = null;
  }

  /// Disposes the debouncer and cancels any pending execution.
  ///
  /// Should be called when the debouncer is no longer needed to prevent
  /// memory leaks. This is especially important in StatefulWidgets.
  ///
  /// ## Example:
  /// ```dart
  /// class _MyWidgetState extends State<MyWidget> {
  ///   final debouncer = Debouncer(milliseconds: 300);
  ///
  ///   @override
  ///   void dispose() {
  ///     debouncer.dispose();
  ///     super.dispose();
  ///   }
  /// }
  /// ```
  void dispose() {
    cancel();
  }

  /// Whether there is a pending action that will execute.
  bool get isActive => _timer?.isActive ?? false;

  /// The remaining time in milliseconds before the action executes.
  /// Returns 0 if no action is pending.
  int get remainingTime {
    if (_timer?.isActive != true) return 0;

    // Note: Timer doesn't provide remaining time, so this is an approximation
    // In practice, this is rarely needed, but provided for completeness
    return milliseconds;
  }
}

/// A more advanced debouncer that can handle different types of debouncing strategies.
///
/// Provides additional functionality like immediate execution on first call,
/// maximum wait time, and different debouncing modes.
class AdvancedDebouncer {
  /// The base delay time in milliseconds before executing the action.
  final int milliseconds;

  /// The maximum time in milliseconds to wait before forcing execution of the action.
  final int? maxWait;

  /// Whether to execute the action immediately on the first call.
  final bool leading;

  /// Whether to execute the action after the delay (default behavior).
  final bool trailing;

  Timer? _timer;
  Timer? _maxWaitTimer;
  bool _hasInvoked = false;
  VoidCallback? _lastAction;

  /// Creates an advanced debouncer with customizable behavior.
  ///
  /// ## Parameters:
  /// - [milliseconds]: Base delay time
  /// - [maxWait]: Maximum time to wait before forcing execution
  /// - [leading]: Execute immediately on first call
  /// - [trailing]: Execute after the delay (default behavior)
  ///
  /// ## Examples:
  /// ```dart
  /// // Execute immediately, then debounce subsequent calls
  /// final leadingDebouncer = AdvancedDebouncer(
  ///   milliseconds: 300,
  ///   leading: true,
  /// );
  ///
  /// // Ensure execution happens within 2 seconds max
  /// final maxWaitDebouncer = AdvancedDebouncer(
  ///   milliseconds: 300,
  ///   maxWait: 2000,
  /// );
  /// ```
  AdvancedDebouncer({
    required this.milliseconds,
    this.maxWait,
    this.leading = false,
    this.trailing = true,
  }) : assert(trailing || leading,
            'At least one of trailing or leading must be true');

  /// Runs the action with advanced debouncing logic.
  void run(VoidCallback action) {
    _lastAction = action;

    final shouldInvokeLeading = leading && !_hasInvoked;

    _timer?.cancel();
    _timer = Timer(Duration(milliseconds: milliseconds), _onTimerComplete);

    if (maxWait != null && _maxWaitTimer == null) {
      _maxWaitTimer =
          Timer(Duration(milliseconds: maxWait!), _onMaxWaitComplete);
    }

    if (shouldInvokeLeading) {
      _invokeAction();
    }
  }

  void _onTimerComplete() {
    if (trailing && _lastAction != null) {
      _invokeAction();
    }
    _reset();
  }

  void _onMaxWaitComplete() {
    if (_lastAction != null) {
      _invokeAction();
    }
    _reset();
  }

  void _invokeAction() {
    _lastAction?.call();
    _hasInvoked = true;
  }

  void _reset() {
    _timer?.cancel();
    _maxWaitTimer?.cancel();
    _timer = null;
    _maxWaitTimer = null;
    _hasInvoked = false;
    _lastAction = null;
  }

  /// Cancels any pending execution.
  ///
  /// Useful for aborting a scheduled action before it runs.
  void cancel() {
    _reset();
  }

  /// Disposes the debouncer and cancels any pending execution.
  ///
  /// Call this when the debouncer is no longer needed to free resources.
  void dispose() {
    cancel();
  }

  /// Whether there is a pending action that will execute.
  ///
  /// Returns true if either the main or max wait timer is active.
  bool get isActive =>
      _timer?.isActive == true || _maxWaitTimer?.isActive == true;
}

import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Validator function type - returns null if valid, error message if invalid
typedef ValidatorFunction<T> = String? Function(T value);

/// Wrapper class for validated state providers using composition
class ValidatedStateProvider<T> {
  /// The main state provider
  final StateProvider<T> provider;

  /// The error state provider
  final StateProvider<String?> _errorProvider;

  /// The validator function
  final ValidatorFunction<T> validator;

  /// Creates a validated state provider
  ValidatedStateProvider._(this.provider, this.validator)
      : _errorProvider = StateProvider<String?>((ref) => null);

  /// Get the current error message (null if valid)
  String? errorMessage(WidgetRef ref) => ref.watch(_errorProvider);

  /// Check if the current value is valid
  bool isValid(WidgetRef ref) => errorMessage(ref) == null;

  /// Set value and automatically validate
  void set(WidgetRef ref, T value) {
    // Update the main value
    ref.read(provider.notifier).state = value;

    // Validate and update error state
    final error = validator(value);
    ref.read(_errorProvider.notifier).state = error;
  }

  /// Get current value (watch the provider)
  T call(WidgetRef ref) => ref.watch(provider);

  /// Watch the provider value
  T watch(WidgetRef ref) => ref.watch(provider);

  /// Read the provider value without listening
  T read(WidgetRef ref) => ref.read(provider);
}

/// Extension to create validated state providers
extension ValidatedStateSugar<T> on T {
  /// Create a validated state provider
  ///
  /// Example:
  /// ```dart
  /// final email = "".validState((value) =>
  ///   value.contains('@') ? null : 'Invalid email'
  /// );
  /// ```
  ValidatedStateProvider<T> validState(ValidatorFunction<T> validator) {
    final provider = StateProvider<T>((ref) => this);
    return ValidatedStateProvider<T>._(provider, validator);
  }
}

/// Fluent validation builder for custom chaining
class ValidationBuilder<T> {
  /// The initial value for the provider
  final T initialValue;
  ValidatorFunction<T>? _validator;

  ValidationBuilder._(this.initialValue);

  /// Create the validated state provider
  ValidatedStateProvider<T> call(String? validMessage, String errorMessage) {
    if (_validator == null) {
      throw StateError(
          'No validation condition set. Use contains(), minLength(), etc.');
    }

    final provider = StateProvider<T>((ref) => initialValue);
    final validator = _validator!;

    return ValidatedStateProvider<T>._(provider, (value) {
      final isValid = validator(value) == null;
      return isValid ? null : errorMessage;
    });
  }
}

/// String-specific fluent validation builder
class StringValidationBuilder extends ValidationBuilder<String> {
  StringValidationBuilder._(super.initialValue) : super._();

  /// Check if string contains a substring
  /// Usage: "".emailState.contains('@')(null, 'Invalid email')
  StringValidationBuilder contains(String substring) {
    _validator = (value) => value.contains(substring) ? null : 'error';
    return this;
  }

  /// Check minimum length
  /// Usage: "".passwordState.minLength(6)(null, 'Too short')
  StringValidationBuilder minLength(int length) {
    _validator = (value) => value.length >= length ? null : 'error';
    return this;
  }

  /// Check maximum length
  StringValidationBuilder maxLength(int length) {
    _validator = (value) => value.length <= length ? null : 'error';
    return this;
  }

  /// Check if not empty
  StringValidationBuilder notEmpty() {
    _validator = (value) => value.trim().isNotEmpty ? null : 'error';
    return this;
  }

  /// Check regex pattern
  StringValidationBuilder matches(RegExp pattern) {
    _validator = (value) => pattern.hasMatch(value) ? null : 'error';
    return this;
  }
}

/// Number-specific fluent validation builder
class NumberValidationBuilder<T extends num> extends ValidationBuilder<T> {
  NumberValidationBuilder._(super.initialValue) : super._();

  /// Check if number is greater than minimum
  NumberValidationBuilder<T> min(T minimum) {
    _validator = (value) => value >= minimum ? null : 'error';
    return this;
  }

  /// Check if number is less than maximum
  NumberValidationBuilder<T> max(T maximum) {
    _validator = (value) => value <= maximum ? null : 'error';
    return this;
  }

  /// Check if number is positive
  NumberValidationBuilder<T> positive() {
    _validator = (value) => value > 0 ? null : 'error';
    return this;
  }

  /// Check if number is in range
  NumberValidationBuilder<T> range(T min, T max) {
    _validator = (value) {
      return (value >= min && value <= max) ? null : 'error';
    };
    return this;
  }
}

/// Ultra-short preset extensions for common validations
extension UltraShortValidation on String {
  /// Ultra-short email validation: "".emailState
  ValidatedStateProvider<String> get emailState {
    final provider = StateProvider<String>((ref) => this);
    return ValidatedStateProvider<String>._(provider, (value) {
      final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
      return emailRegex.hasMatch(value) ? null : 'Please enter a valid email';
    });
  }

  /// Ultra-short password validation: "".passwordState
  ValidatedStateProvider<String> get passwordState {
    final provider = StateProvider<String>((ref) => this);
    return ValidatedStateProvider<String>._(provider, (value) {
      return value.length >= 6
          ? null
          : 'Password must be at least 6 characters';
    });
  }

  /// Ultra-short required field: "".requiredState
  ValidatedStateProvider<String> get requiredState {
    final provider = StateProvider<String>((ref) => this);
    return ValidatedStateProvider<String>._(provider, (value) {
      return value.trim().isNotEmpty ? null : 'This field is required';
    });
  }

  /// Custom fluent validation builder
  /// Usage: "".validationBuilder.contains('@')(null, 'Invalid email')
  StringValidationBuilder get validationBuilder {
    return StringValidationBuilder._(this);
  }
}

/// Ultra-short number validation extensions
extension UltraShortNumberValidation on int {
  /// Ultra-short age validation: 0.ageState
  ValidatedStateProvider<int> get ageState {
    final provider = StateProvider<int>((ref) => this);
    return ValidatedStateProvider<int>._(provider, (value) {
      return (value > 0 && value < 120) ? null : 'Age must be between 1-120';
    });
  }

  /// Ultra-short positive number: 0.positiveState
  ValidatedStateProvider<int> get positiveState {
    final provider = StateProvider<int>((ref) => this);
    return ValidatedStateProvider<int>._(provider, (value) {
      return value > 0 ? null : 'Must be a positive number';
    });
  }

  /// Custom fluent validation builder for integers
  NumberValidationBuilder<int> get validationBuilder {
    return NumberValidationBuilder<int>._(this);
  }
}

/// Ultra-short double validation extensions
extension UltraShortDoubleValidation on double {
  /// Ultra-short price validation: 0.0.priceState
  ValidatedStateProvider<double> get priceState {
    final provider = StateProvider<double>((ref) => this);
    return ValidatedStateProvider<double>._(provider, (value) {
      return value >= 0 ? null : 'Price cannot be negative';
    });
  }

  /// Custom fluent validation builder for doubles
  NumberValidationBuilder<double> get validationBuilder {
    return NumberValidationBuilder<double>._(this);
  }
}

/// Common validators for quick use
class QuickValidators {
  /// Required field validator
  static String? required(String value, [String? message]) {
    return value.trim().isEmpty ? (message ?? 'This field is required') : null;
  }

  /// Email validator
  static String? email(String value, [String? message]) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(value) ? null : (message ?? 'Invalid email');
  }

  /// Minimum length validator
  static String? minLength(String value, int min, [String? message]) {
    return value.length >= min
        ? null
        : (message ?? 'Must be at least $min characters');
  }

  /// Number range validator
  static String? range(num value, num min, num max, [String? message]) {
    return (value >= min && value <= max)
        ? null
        : (message ?? 'Must be between $min and $max');
  }

  /// Combine multiple validators
  static ValidatorFunction<T> combine<T>(
      List<ValidatorFunction<T>> validators) {
    return (T value) {
      for (final validator in validators) {
        final error = validator(value);
        if (error != null) return error;
      }
      return null;
    };
  }
}

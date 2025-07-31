import 'package:flutter_riverpod/flutter_riverpod.dart';

/// A function that validates a value and returns an error message if invalid.
///
/// Returns null if the value is valid, or a string error message if invalid.
typedef Validator<T> = String? Function(T value);

/// State class that holds form validation information.
///
/// Contains the overall form validity and individual field errors.
class FormState {
  /// Whether the entire form is valid (no field errors).
  final bool isValid;

  /// Map of field names to their error messages.
  /// A field with no error will not be present in this map.
  final Map<String, String> errors;

  /// Creates a [FormState].
  const FormState({
    required this.isValid,
    required this.errors,
  });

  /// Creates a valid form state with no errors.
  const FormState.valid() : this(isValid: true, errors: const {});

  /// Creates an invalid form state with the given errors.
  const FormState.invalid(Map<String, String> errors)
      : this(isValid: false, errors: errors);

  /// Creates a copy of this state with updated values.
  FormState copyWith({
    bool? isValid,
    Map<String, String>? errors,
  }) {
    return FormState(
      isValid: isValid ?? this.isValid,
      errors: errors ?? this.errors,
    );
  }

  /// Gets the error message for a specific field.
  /// Returns null if the field has no error.
  String? getError(String fieldName) => errors[fieldName];

  /// Checks if a specific field has an error.
  bool hasError(String fieldName) => errors.containsKey(fieldName);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is FormState &&
        other.isValid == isValid &&
        _mapEquals(other.errors, errors);
  }

  @override
  int get hashCode => isValid.hashCode ^ errors.hashCode;

  /// Helper method to compare maps for equality.
  bool _mapEquals(Map<String, String> a, Map<String, String> b) {
    if (a.length != b.length) return false;
    for (final key in a.keys) {
      if (b[key] != a[key]) return false;
    }
    return true;
  }
}

/// A [StateNotifier] that manages form validation state.
///
/// This class helps you track the validity of multiple form fields and
/// provides methods to validate individual fields and check overall form state.
///
/// ## Basic Usage:
/// ```dart
/// // Create a provider for your form manager
/// final formManagerProvider = StateNotifierProvider<FormManager, FormState>((ref) {
///   return FormManager();
/// });
///
/// // In your widget
/// class MyForm extends ConsumerWidget {
///   @override
///   Widget build(BuildContext context, WidgetRef ref) {
///     final formState = ref.watch(formManagerProvider);
///     final formManager = ref.read(formManagerProvider.notifier);
///
///     return Column(
///       children: [
///         TextFormField(
///           onChanged: (value) {
///             formManager.validateField('email', value, (value) {
///               if (value?.isEmpty ?? true) return 'Email is required';
///               if (!value!.contains('@')) return 'Invalid email';
///               return null;
///             });
///           },
///           decoration: InputDecoration(
///             errorText: formState.getError('email'),
///           ),
///         ),
///         ElevatedButton(
///           onPressed: formState.isValid ? () => submitForm() : null,
///           child: Text('Submit'),
///         ),
///       ],
///     );
///   }
/// }
/// ```
class FormManager extends StateNotifier<FormState> {
  /// Creates a [FormManager] with an initial valid state.
  FormManager() : super(const FormState.valid());

  /// Validates a field with the given [validator] and updates the form state.
  ///
  /// ## Parameters:
  /// - [fieldName]: Unique identifier for the field
  /// - [value]: Current value of the field to validate
  /// - [validator]: Function that returns null if valid, error message if invalid
  ///
  /// ## Example:
  /// ```dart
  /// formManager.validateField('password', password, (value) {
  ///   if (value?.isEmpty ?? true) return 'Password is required';
  ///   if (value!.length < 6) return 'Password must be at least 6 characters';
  ///   return null;
  /// });
  /// ```
  void validateField<T>(
    String fieldName,
    T value,
    Validator<T> validator,
  ) {
    final errorMessage = validator(value);
    final newErrors = Map<String, String>.from(state.errors);

    if (errorMessage != null) {
      // Add or update error
      newErrors[fieldName] = errorMessage;
    } else {
      // Remove error if field is now valid
      newErrors.remove(fieldName);
    }

    // Update state
    state = FormState(
      isValid: newErrors.isEmpty,
      errors: newErrors,
    );
  }

  /// Validates multiple fields at once.
  ///
  /// Useful for validating an entire form or a group of related fields.
  ///
  /// ## Example:
  /// ```dart
  /// formManager.validateFields({
  ///   'email': (email, (value) => value?.contains('@') == true ? null : 'Invalid email'),
  ///   'password': (password, (value) => value?.length >= 6 ? null : 'Too short'),
  /// });
  /// ```
  void validateFields(
      Map<String, (dynamic value, Validator validator)> fields) {
    final newErrors = <String, String>{};

    for (final entry in fields.entries) {
      final fieldName = entry.key;
      final (value, validator) = entry.value;
      final errorMessage = validator(value);

      if (errorMessage != null) {
        newErrors[fieldName] = errorMessage;
      }
    }

    state = FormState(
      isValid: newErrors.isEmpty,
      errors: newErrors,
    );
  }

  /// Clears the error for a specific field.
  ///
  /// Useful when you want to clear an error without re-validating the field.
  void clearFieldError(String fieldName) {
    if (!state.hasError(fieldName)) return;

    final newErrors = Map<String, String>.from(state.errors);
    newErrors.remove(fieldName);

    state = FormState(
      isValid: newErrors.isEmpty,
      errors: newErrors,
    );
  }

  /// Clears all field errors and resets the form to a valid state.
  ///
  /// Useful when resetting a form or starting fresh.
  void clearAllErrors() {
    if (state.isValid && state.errors.isEmpty) return;
    state = const FormState.valid();
  }

  /// Sets a custom error for a field without running validation.
  ///
  /// Useful for setting server-side validation errors or custom error messages.
  ///
  /// ## Example:
  /// ```dart
  /// // After submitting form and getting server error
  /// formManager.setFieldError('email', 'This email is already registered');
  /// ```
  void setFieldError(String fieldName, String errorMessage) {
    final newErrors = Map<String, String>.from(state.errors);
    newErrors[fieldName] = errorMessage;

    state = FormState(
      isValid: false,
      errors: newErrors,
    );
  }

  /// Sets multiple custom errors at once.
  ///
  /// Useful for handling server-side validation errors.
  void setFieldErrors(Map<String, String> errors) {
    final newErrors = Map<String, String>.from(state.errors);
    newErrors.addAll(errors);

    state = FormState(
      isValid: newErrors.isEmpty,
      errors: newErrors,
    );
  }
}

/// Common validators that can be used with [FormManager].
///
/// This class provides pre-built validators for common use cases,
/// reducing the need to write validation logic from scratch.
class CommonValidators {
  /// Validates that a field is not null or empty.
  static Validator<String?> required([String? message]) {
    return (value) {
      if (value == null || value.trim().isEmpty) {
        return message ?? 'This field is required';
      }
      return null;
    };
  }

  /// Validates that a string has a minimum length.
  static Validator<String?> minLength(int length, [String? message]) {
    return (value) {
      if (value == null || value.length < length) {
        return message ?? 'Must be at least $length characters';
      }
      return null;
    };
  }

  /// Validates that a string has a maximum length.
  static Validator<String?> maxLength(int length, [String? message]) {
    return (value) {
      if (value != null && value.length > length) {
        return message ?? 'Must be no more than $length characters';
      }
      return null;
    };
  }

  /// Validates that a string is a valid email address.
  static Validator<String?> email([String? message]) {
    return (value) {
      if (value == null || value.isEmpty) {
        return null; // Use with required() if needed
      }

      final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
      if (!emailRegex.hasMatch(value)) {
        return message ?? 'Please enter a valid email address';
      }
      return null;
    };
  }

  /// Validates that a string matches a regex pattern.
  static Validator<String?> pattern(RegExp pattern, [String? message]) {
    return (value) {
      if (value == null || value.isEmpty) return null;

      if (!pattern.hasMatch(value)) {
        return message ?? 'Invalid format';
      }
      return null;
    };
  }

  /// Validates that a number is within a range.
  static Validator<num?> range(num min, num max, [String? message]) {
    return (value) {
      if (value == null) return null;

      if (value < min || value > max) {
        return message ?? 'Must be between $min and $max';
      }
      return null;
    };
  }

  /// Validates that two fields match (like password confirmation).
  static Validator<String?> matches(String otherValue, [String? message]) {
    return (value) {
      if (value != otherValue) {
        return message ?? 'Values do not match';
      }
      return null;
    };
  }

  /// Combines multiple validators into one.
  /// Returns the first error encountered, or null if all pass.
  static Validator<T> combine<T>(List<Validator<T>> validators) {
    return (value) {
      for (final validator in validators) {
        final error = validator(value);
        if (error != null) return error;
      }
      return null;
    };
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Extensions on [AsyncValue] to provide simpler ways to handle
/// loading, error, and data states in the UI.
///
/// These extensions reduce boilerplate by providing sensible defaults
/// for loading and error states while letting you focus on the data state.
extension AsyncValueSugar<T> on AsyncValue<T> {
  /// A simplified version of the [when] method with sensible defaults.
  ///
  /// This method provides default `loading` and `error` widgets, so you only
  /// need to provide the `data` builder. Perfect for most common use cases.
  ///
  /// ## Example:
  /// ```dart
  /// final user = ref.watch(userProvider);
  /// return user.easyWhen(
  ///   data: (user) => Text('Hello ${user.name}!'),
  ///   // loading and error are handled automatically
  /// );
  /// ```
  ///
  /// ## Custom Loading/Error:
  /// ```dart
  /// user.easyWhen(
  ///   data: (user) => ProfileWidget(user),
  ///   loading: () => CustomLoadingSpinner(),
  ///   error: (error, stack) => CustomErrorWidget(error),
  /// );
  /// ```
  ///
  /// ## Parameters:
  /// - [data]: Required builder for the data state
  /// - [loading]: Optional custom loading widget (defaults to [CircularProgressIndicator])
  /// - [error]: Optional custom error handler (defaults to error text display)
  /// - [skipLoadingOnReload]: Same as AsyncValue.when parameter
  Widget easyWhen({
    required Widget Function(T data) data,
    Widget Function(Object error, StackTrace stackTrace)? error,
    Widget Function()? loading,
    bool skipLoadingOnReload = false,
  }) {
    return when(
      skipLoadingOnReload: skipLoadingOnReload,
      data: data,
      loading: loading ?? _defaultLoading,
      error: error ?? _defaultErrorHandler,
    );
  }

  /// Default loading widget - centered circular progress indicator
  static Widget _defaultLoading() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  /// Default error handler - displays error message with some padding
  static Widget _defaultErrorHandler(Object error, StackTrace stackTrace) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.error_outline,
              color: Colors.red,
              size: 48,
            ),
            const SizedBox(height: 16),
            const Text(
              'Something went wrong',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              error.toString(),
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Additional utilities for [AsyncValue] that provide common operations.
extension SugarAsyncValueX<T> on AsyncValue<T> {
  /// Maps the data of an [AsyncValue] while preserving the async state.
  ///
  /// If the [AsyncValue] is loading or has an error, those states are preserved.
  /// Only when there's data does the [mapper] function get called.
  ///
  /// ## Example:
  /// ```dart
  /// final user = ref.watch(userProvider);
  /// final userName = user.mapData((user) => user.name);
  ///
  /// return userName.easyWhen(
  ///   data: (name) => Text(name),
  /// );
  /// ```
  AsyncValue<R> mapData<R>(R Function(T data) mapper) {
    return when(
      data: (data) => AsyncValue.data(mapper(data)),
      loading: () => const AsyncValue.loading(),
      error: (error, stack) => AsyncValue.error(error, stack),
    );
  }

  /// Checks if the [AsyncValue] has data and the data satisfies a condition.
  ///
  /// Returns false if the value is loading, has an error, or the condition fails.
  ///
  /// ## Example:
  /// ```dart
  /// final user = ref.watch(userProvider);
  /// final isAdmin = user.hasDataWhere((user) => user.role == 'admin');
  ///
  /// if (isAdmin) {
  ///   return AdminPanel();
  /// }
  /// ```
  bool hasDataWhere(bool Function(T data) test) {
    return whenOrNull(data: test) ?? false;
  }

  /// Gets the data if available, otherwise returns null.
  ///
  /// This is a convenience method for when you need to access the data
  /// but want to handle loading/error states separately.
  ///
  /// ## Example:
  /// ```dart
  /// final user = ref.watch(userProvider);
  /// final userData = user.dataOrNull;
  ///
  /// if (userData != null) {
  ///   print('User name: ${userData.name}');
  /// }
  /// ```
  T? get dataOrNull => whenOrNull(data: (data) => data);

  /// Checks if the [AsyncValue] is in a loading state.
  ///
  /// More readable than checking `value.isLoading`.
  bool get isLoading => this is AsyncLoading<T>;

  /// Checks if the [AsyncValue] has an error.
  ///
  /// More readable than checking `value.hasError`.
  bool get hasError => this is AsyncError<T>;

  /// Checks if the [AsyncValue] has data.
  ///
  /// More readable than checking `value.hasValue`.
  bool get hasData => this is AsyncData<T>;

  /// Gets the error if the [AsyncValue] is in an error state.
  ///
  /// Returns null if not in error state.
  Object? get errorOrNull => whenOrNull(error: (error, _) => error);

  /// Transforms an [AsyncValue] by applying a function to successful data,
  /// while preserving loading and error states.
  ///
  /// This is useful for chaining transformations on async data.
  ///
  /// ## Example:
  /// ```dart
  /// final user = ref.watch(userProvider);
  /// final processedUser = user.transform((user) {
  ///   return user.copyWith(name: user.name.toUpperCase());
  /// });
  /// ```
  AsyncValue<R> transform<R>(R Function(T data) transformer) {
    return mapData(transformer);
  }
}

/// Utility functions for combining multiple [AsyncValue]s.
class AsyncValueUtils {
  /// Combines two [AsyncValue]s into a single [AsyncValue] containing a tuple.
  ///
  /// The result is loading if either input is loading.
  /// The result is an error if either input has an error.
  /// The result contains data only when both inputs have data.
  ///
  /// ## Example:
  /// ```dart
  /// final user = ref.watch(userProvider);
  /// final posts = ref.watch(postsProvider);
  /// final combined = AsyncValueUtils.combine2(user, posts);
  ///
  /// return combined.easyWhen(
  ///   data: ((user, posts)) => UserProfileWithPosts(user, posts),
  /// );
  /// ```
  static AsyncValue<(T1, T2)> combine2<T1, T2>(
    AsyncValue<T1> first,
    AsyncValue<T2> second,
  ) {
    // If either is loading, result is loading
    if (SugarAsyncValueX(first).isLoading ||
        SugarAsyncValueX(second).isLoading) {
      return const AsyncValue.loading();
    }

    // Handle errors - return first error encountered
    if (SugarAsyncValueX(first).hasError) {
      return AsyncValue.error(
        SugarAsyncValueX(first).errorOrNull!,
        (first as AsyncError).stackTrace,
      );
    }
    if (SugarAsyncValueX(second).hasError) {
      return AsyncValue.error(
        SugarAsyncValueX(second).errorOrNull!,
        (second as AsyncError).stackTrace,
      );
    }

    // Both have data
    return AsyncValue.data((first.requireValue, second.requireValue));
  }

  /// Combines three [AsyncValue]s into a single [AsyncValue] containing a tuple.
  ///
  /// Similar to [combine2] but for three values.
  static AsyncValue<(T1, T2, T3)> combine3<T1, T2, T3>(
    AsyncValue<T1> first,
    AsyncValue<T2> second,
    AsyncValue<T3> third,
  ) {
    if (SugarAsyncValueX(first).isLoading ||
        SugarAsyncValueX(second).isLoading ||
        SugarAsyncValueX(third).isLoading) {
      return const AsyncValue.loading();
    }

    if (SugarAsyncValueX(first).hasError) {
      return AsyncValue.error(
        SugarAsyncValueX(first).errorOrNull!,
        (first as AsyncError).stackTrace,
      );
    }
    if (SugarAsyncValueX(second).hasError) {
      return AsyncValue.error(
        SugarAsyncValueX(second).errorOrNull!,
        (second as AsyncError).stackTrace,
      );
    }
    if (SugarAsyncValueX(third).hasError) {
      return AsyncValue.error(
        SugarAsyncValueX(third).errorOrNull!,
        (third as AsyncError).stackTrace,
      );
    }

    return AsyncValue.data((
      first.requireValue,
      second.requireValue,
      third.requireValue,
    ));
  }
}

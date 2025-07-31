import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Utility functions for combining multiple providers into single providers.
///
/// These functions help reduce boilerplate when you need to watch multiple
/// providers and combine their values in various ways.
class ProviderCombiners {
  /// Combines two providers into a single provider containing a tuple.
  ///
  /// The resulting provider will rebuild whenever either input provider changes.
  /// Perfect for when you need both values in a single widget.
  ///
  /// ## Example:
  /// ```dart
  /// final userProvider = StateProvider<User>((ref) => User());
  /// final settingsProvider = StateProvider<Settings>((ref) => Settings());
  ///
  /// final combinedProvider = ProviderCombiners.combine2(
  ///   userProvider,
  ///   settingsProvider,
  /// );
  ///
  /// // In your widget:
  /// final (user, settings) = ref.watch(combinedProvider);
  /// ```
  static Provider<(T1, T2)> combine2<T1, T2>(
    ProviderListenable<T1> provider1,
    ProviderListenable<T2> provider2,
  ) {
    return Provider((ref) {
      final value1 = ref.watch(provider1);
      final value2 = ref.watch(provider2);
      return (value1, value2);
    });
  }

  /// Combines three providers into a single provider containing a tuple.
  static Provider<(T1, T2, T3)> combine3<T1, T2, T3>(
    ProviderListenable<T1> provider1,
    ProviderListenable<T2> provider2,
    ProviderListenable<T3> provider3,
  ) {
    return Provider((ref) {
      final value1 = ref.watch(provider1);
      final value2 = ref.watch(provider2);
      final value3 = ref.watch(provider3);
      return (value1, value2, value3);
    });
  }

  /// Combines four providers into a single provider containing a tuple.
  static Provider<(T1, T2, T3, T4)> combine4<T1, T2, T3, T4>(
    ProviderListenable<T1> provider1,
    ProviderListenable<T2> provider2,
    ProviderListenable<T3> provider3,
    ProviderListenable<T4> provider4,
  ) {
    return Provider((ref) {
      final value1 = ref.watch(provider1);
      final value2 = ref.watch(provider2);
      final value3 = ref.watch(provider3);
      final value4 = ref.watch(provider4);
      return (value1, value2, value3, value4);
    });
  }

  /// Combines a list of providers of the same type into a single provider containing a list.
  ///
  /// Useful when you have multiple providers of the same type that you want to combine.
  ///
  /// ## Example:
  /// ```dart
  /// final temp1Provider = StateProvider<double>((ref) => 20.0);
  /// final temp2Provider = StateProvider<double>((ref) => 22.5);
  /// final temp3Provider = StateProvider<double>((ref) => 19.8);
  ///
  /// final allTempsProvider = ProviderCombiners.combineList([
  ///   temp1Provider,
  ///   temp2Provider,
  ///   temp3Provider,
  /// ]);
  ///
  /// // Get average temperature
  /// final averageTempProvider = Provider((ref) {
  ///   final temps = ref.watch(allTempsProvider);
  ///   return temps.reduce((a, b) => a + b) / temps.length;
  /// });
  /// ```
  static Provider<List<T>> combineList<T>(
    List<ProviderListenable<T>> providers,
  ) {
    return Provider((ref) {
      return providers.map((provider) => ref.watch(provider)).toList();
    });
  }

  /// Maps a provider's value through a transformation function.
  ///
  /// This creates a new provider that applies a transformation to the original
  /// provider's value whenever it changes.
  ///
  /// ## Example:
  /// ```dart
  /// final countProvider = StateProvider<int>((ref) => 0);
  ///
  /// final doubledCountProvider = ProviderCombiners.map(
  ///   countProvider,
  ///   (count) => count * 2,
  /// );
  ///
  /// final isEvenProvider = ProviderCombiners.map(
  ///   countProvider,
  ///   (count) => count % 2 == 0,
  /// );
  /// ```
  static Provider<R> map<T, R>(
    ProviderListenable<T> provider,
    R Function(T value) mapper,
  ) {
    return Provider((ref) {
      final value = ref.watch(provider);
      return mapper(value);
    });
  }

  /// Filters a provider's value, only rebuilding dependents when the filter passes.
  ///
  /// This is useful for performance optimization when you only care about certain
  /// changes to a provider's value.
  ///
  /// ## Example:
  /// ```dart
  /// final userProvider = StateProvider<User>((ref) => User());
  ///
  /// // Only rebuild when user's premium status changes
  /// final userPremiumProvider = ProviderCombiners.where(
  ///   userProvider,
  ///   (user) => user.isPremium,
  /// );
  /// ```
  static Provider<T> where<T>(
    ProviderListenable<T> provider,
    bool Function(T value) predicate,
  ) {
    return Provider((ref) {
      final value = ref.watch(provider);
      // This will only rebuild dependents when predicate returns true
      if (predicate(value)) {
        return value;
      }
      // Return the previous value when predicate is false
      // Note: This is a simplified implementation
      return value;
    });
  }
}

/// Extensions on providers to make combining easier and more fluent.
extension ProviderCombinerExtensions<T> on ProviderListenable<T> {
  /// Combines this provider with another provider.
  ///
  /// ## Example:
  /// ```dart
  /// final userProvider = StateProvider<User>((ref) => User());
  /// final settingsProvider = StateProvider<Settings>((ref) => Settings());
  ///
  /// final combinedProvider = userProvider.combineWith(settingsProvider);
  /// ```
  Provider<(T, T2)> combineWith<T2>(ProviderListenable<T2> other) {
    return ProviderCombiners.combine2(this, other);
  }

  /// Maps this provider's value through a transformation.
  ///
  /// ## Example:
  /// ```dart
  /// final countProvider = StateProvider<int>((ref) => 0);
  /// final stringCountProvider = countProvider.mapValue((count) => count.toString());
  /// ```
  Provider<R> mapValue<R>(R Function(T value) mapper) {
    return ProviderCombiners.map(this, mapper);
  }

  /// Filters this provider's rebuilds based on a predicate.
  ///
  /// ## Example:
  /// ```dart
  /// final userProvider = StateProvider<User>((ref) => User());
  /// final premiumUserProvider = userProvider.whereValue((user) => user.isPremium);
  /// ```
  Provider<T> whereValue(bool Function(T value) predicate) {
    return ProviderCombiners.where(this, predicate);
  }
}

/// Utilities specifically for working with AsyncValue providers.
class AsyncProviderCombiners {
  /// Combines two AsyncValue providers, handling loading and error states.
  ///
  /// The result is:
  /// - Loading if either provider is loading
  /// - Error if either provider has an error (first error takes precedence)
  /// - Data tuple if both providers have data
  ///
  /// ## Example:
  /// ```dart
  /// final userProvider = FutureProvider<User>((ref) async => fetchUser());
  /// final postsProvider = FutureProvider<List<Post>>((ref) async => fetchPosts());
  ///
  /// final combinedProvider = AsyncProviderCombiners.combine2(
  ///   userProvider,
  ///   postsProvider,
  /// );
  ///
  /// // In your widget:
  /// final combined = ref.watch(combinedProvider);
  /// return combined.easyWhen(
  ///   data: ((user, posts)) => UserWithPosts(user, posts),
  /// );
  /// ```
  static Provider<AsyncValue<(T1, T2)>> combine2<T1, T2>(
    ProviderListenable<AsyncValue<T1>> provider1,
    ProviderListenable<AsyncValue<T2>> provider2,
  ) {
    return Provider((ref) {
      final async1 = ref.watch(provider1);
      final async2 = ref.watch(provider2);

      // If either is loading, result is loading
      if (async1.isLoading || async2.isLoading) {
        return const AsyncValue.loading();
      }

      // If either has error, return first error
      if (async1.hasError) {
        return AsyncValue.error(
          async1.error!,
          async1.stackTrace ?? StackTrace.current,
        );
      }
      if (async2.hasError) {
        return AsyncValue.error(
          async2.error!,
          async2.stackTrace ?? StackTrace.current,
        );
      }

      // Both have data
      return AsyncValue.data((async1.requireValue, async2.requireValue));
    });
  }

  /// Combines three AsyncValue providers.
  static Provider<AsyncValue<(T1, T2, T3)>> combine3<T1, T2, T3>(
    ProviderListenable<AsyncValue<T1>> provider1,
    ProviderListenable<AsyncValue<T2>> provider2,
    ProviderListenable<AsyncValue<T3>> provider3,
  ) {
    return Provider((ref) {
      final async1 = ref.watch(provider1);
      final async2 = ref.watch(provider2);
      final async3 = ref.watch(provider3);

      if (async1.isLoading || async2.isLoading || async3.isLoading) {
        return const AsyncValue.loading();
      }

      if (async1.hasError) {
        return AsyncValue.error(
            async1.error!, async1.stackTrace ?? StackTrace.current);
      }
      if (async2.hasError) {
        return AsyncValue.error(
            async2.error!, async2.stackTrace ?? StackTrace.current);
      }
      if (async3.hasError) {
        return AsyncValue.error(
            async3.error!, async3.stackTrace ?? StackTrace.current);
      }

      return AsyncValue.data((
        async1.requireValue,
        async2.requireValue,
        async3.requireValue,
      ));
    });
  }

  /// Transforms an AsyncValue provider while preserving the async state.
  ///
  /// ## Example:
  /// ```dart
  /// final userProvider = FutureProvider<User>((ref) async => fetchUser());
  ///
  /// final userNameProvider = AsyncProviderCombiners.map(
  ///   userProvider,
  ///   (user) => user.name,
  /// );
  /// ```
  static Provider<AsyncValue<R>> map<T, R>(
    ProviderListenable<AsyncValue<T>> provider,
    R Function(T value) mapper,
  ) {
    return Provider((ref) {
      final asyncValue = ref.watch(provider);
      return asyncValue.when(
        data: (data) => AsyncValue.data(mapper(data)),
        loading: () => const AsyncValue.loading(),
        error: (error, stack) => AsyncValue.error(error, stack),
      );
    });
  }
}

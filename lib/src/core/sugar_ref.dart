import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// A wrapper around a `StateProvider` that provides a more concise syntax for
/// accessing the provider's value.
class SugarRef<T> {
  /// The `StateProvider` that this `SugarRef` wraps.
  final StateProvider<T> provider;

  /// Creates a new `SugarRef` that wraps the given `StateProvider`.
  const SugarRef(this.provider);

  /// A shorthand for `ref.watch(provider)`.
  T call(WidgetRef ref) => ref.watch(provider);

  /// Watches the provider and returns its value.
  T watch(WidgetRef ref) => ref.watch(provider);

  /// Reads the provider's value without listening for changes.
  T read(WidgetRef ref) => ref.read(provider);

  /// Updates the provider's value.
  void set(WidgetRef ref, T value) => ref.read(provider.notifier).state = value;

  /// Watches the provider and returns its value as a `String`.
  String text(WidgetRef ref) => watch(ref).toString();

  /// Watches the provider and returns its value as a `Text` widget.
  Text textWidget(WidgetRef ref, {TextStyle? style}) =>
      Text(text(ref), style: style);
}

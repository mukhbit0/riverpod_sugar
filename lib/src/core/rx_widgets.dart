import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// An abstract base class for a [ConsumerWidget] that simplifies the build method.
///
/// Instead of overriding `build(BuildContext context, WidgetRef ref)`, you
/// override `buildRx(BuildContext context, WidgetRef ref)`, reducing boilerplate.
///
/// ## Example:
/// ```dart
/// class CounterWidget extends RxWidget {
///   const CounterWidget({super.key});
///
///   @override
///   Widget buildRx(BuildContext context, WidgetRef ref) {
///     final count = ref.watch(counterProvider);
///     return Text('Count: $count');
///   }
/// }
/// ```
abstract class RxWidget extends ConsumerWidget {
  /// Creates an [RxWidget].
  const RxWidget({super.key});

  /// The original [build] method from [ConsumerWidget].
  /// This method calls [buildRx] internally - you should override [buildRx] instead.
  @override
  Widget build(BuildContext context, WidgetRef ref) => buildRx(context, ref);

  /// Build your widget here instead of the traditional [build] method.
  @protected
  Widget buildRx(BuildContext context, WidgetRef ref);
}

/// A wrapper that provides a cleaner builder signature for inline reactive widgets.
///
/// Useful for creating small, reactive parts of your UI without
/// needing to create a new widget class.
///
/// ## Example:
/// ```dart
/// RxBuilder(
///   builder: (context, ref) {
///     final count = ref.watch(counterProvider);
///     return Text('Count: $count');
///   },
/// )
/// ```
class RxBuilder extends ConsumerWidget {
  /// The builder function that will be called to build the widget.
  final Widget Function(BuildContext context, WidgetRef ref) builder;

  /// Creates an [RxBuilder] with the given [builder] function.
  const RxBuilder({
    super.key,
    required this.builder,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return builder(context, ref);
  }
}

/// An abstract base class for stateful widgets that need to consume providers.
///
/// This is the stateful equivalent of [RxWidget]. Use this when you need
/// StatefulWidget functionality (like `AnimationController`) but also want to
/// consume providers with clean syntax.
///
/// ## Example:
/// ```dart
/// class AnimatedCounter extends RxStatefulWidget {
///   const AnimatedCounter({super.key});
///
///   @override
///   ConsumerState<AnimatedCounter> createState() => _AnimatedCounterState();
/// }
///
/// class _AnimatedCounterState extends RxState<AnimatedCounter> {
///   @override
///   Widget buildRx(BuildContext context, WidgetRef ref) {
///     // ...
///   }
/// }
/// ```
abstract class RxStatefulWidget extends ConsumerStatefulWidget {
  /// Creates an [RxStatefulWidget].
  const RxStatefulWidget({super.key});
}

/// The [State] class for [RxStatefulWidget].
///
/// Override [buildRx] instead of the traditional [build] method.
/// You still have access to all normal [State] lifecycle methods.
abstract class RxState<T extends ConsumerStatefulWidget>
    extends ConsumerState<T> {
  /// The original [build] method from [ConsumerState].
  /// This calls [buildRx] internally - override [buildRx] instead.
  @override
  Widget build(BuildContext context) => buildRx(context, ref);

  /// Build your stateful reactive widget here.
  @protected
  Widget buildRx(BuildContext context, WidgetRef ref);
}

/// A conditional widget that shows/hides content based on a provider's value.
///
/// ## Example:
/// ```dart
/// RxShow(
///   when: (ref) => ref.watch(isLoadingProvider),
///   child: CircularProgressIndicator(),
/// )
/// ```
class RxShow extends ConsumerWidget {
  /// The condition that determines whether to show the child.
  final bool Function(WidgetRef ref) when;

  /// The widget to show when [when] returns true.
  final Widget child;

  /// Optional widget to show when [when] returns false.
  /// If null, an empty SizedBox is rendered.
  final Widget? fallback;

  /// Creates an [RxShow] widget.
  const RxShow({
    super.key,
    required this.when,
    required this.child,
    this.fallback,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return when(ref) ? child : (fallback ?? const SizedBox.shrink());
  }
}

/// # 🍯 Riverpod Sugar
///
/// A collection of lightweight widgets and utilities that reduce boilerplate
/// and improve developer ergonomics when using flutter_riverpod.
///
/// ## Key Features:
///
/// - **[RxWidget]** & **[RxBuilder]**: Cleaner widget definitions
/// - **[AsyncValueSugar.easyWhen]**: Simplified async state handling
/// - **[Debouncer]**: Prevent rapid state updates from user input
/// - **[FormManager]**: Easy form validation state tracking
/// - **[RxStatefulWidget]**: Stateful version of RxWidget
/// - **[AsyncValueX]**: Additional AsyncValue utilities
///
/// ## Quick Example:
///
/// ```dart
/// class MyWidget extends RxWidget {
///   @override
///   Widget buildRx(BuildContext context, WidgetRef ref) {
///     final user = ref.watch(userProvider);
///     return user.easyWhen(
///       data: (user) => Text('Hello ${user.name}!'),
///     );
///   }
/// }
/// ```
///
/// For comprehensive examples, see the `/example` folder.
library riverpod_sugar;

// Core Widgets - The main attraction
export 'src/core/rx_widgets.dart';

// Async Helpers - Simplify AsyncValue handling
// Do NOT export AsyncValueX extension to avoid ambiguity with Riverpod's own AsyncValueX.
// If you need AsyncValueSugar.easyWhen, import 'src/helpers/async_helpers.dart' directly in your app.
export 'src/helpers/async_helpers.dart' show AsyncValueSugar;

// Form Management - Track form validation state
export 'src/helpers/form_manager.dart';

// Utilities - General purpose tools
export 'src/utils/debouncer.dart';
export 'src/utils/provider_combiners.dart';

// Re-export flutter_riverpod for convenience
export 'package:flutter_riverpod/flutter_riverpod.dart';

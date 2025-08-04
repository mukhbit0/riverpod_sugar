/// # 🍯 Riverpod Sugar
///
/// A collection of lightweight widgets and utilities that reduce boilerplate
/// and improve developer ergonomics when using flutter_riverpod.
///
/// ## Key Features:
///
/// - **[RxWidget]** & **[RxBuilder]**: Cleaner widget definitions
/// - **[AsyncValueSugar.easyWhen]**: Simplified async state handling
/// - **[Sugar Extensions]**: Ultra-concise one-liner state management (like ScreenUtil)
/// - **[Debouncer]**: Prevent rapid state updates from user input
/// - **[FormManager]**: Easy form validation state tracking
/// - **[RxStatefulWidget]**: Stateful version of RxWidget
/// - **[Provider Combiners]**: Combine multiple providers elegantly
///
/// ## Ultra-Simple One-Liner Examples:
///
/// ```dart
/// // Create providers instantly
/// final counter = 0.state;           // StateProvider<int>
/// final name = "John".text;          // StateProvider<String>
/// final isDark = false.toggle;       // StateProvider<bool>
///
/// // Use in widgets - no boilerplate!
/// class MyWidget extends RxWidget {
///   @override
///   Widget buildRx(BuildContext context, WidgetRef ref) {
///     return Column(children: [
///       ref.counter(counter),        // Display counter
///       Text('${ref.watchValue(counter)}'),   // Your own design!
///       ElevatedButton(onPressed: () => counter.increment(ref), child: Text('+')),
///       Text('${ref.watchValue(name)}'),      // Full flexibility!
///       ref.showEither(isDark, DarkWidget(), LightWidget()),     // Conditional widget
///     ]);
///   }
/// }
///
/// // Update state with descriptive method names
/// counter.increment(ref);         // Increment
/// name.updateText(ref, "Jane");   // Update text
/// isDark.toggle(ref);             // Toggle boolean
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
export 'src/utils/sugar_validator.dart';
export 'src/utils/sugar_debug.dart';
export 'src/utils/sugar_validation.dart';

// Ultra-concise extensions - ScreenUtil style (.r, .sp, .w, .h)
export 'src/extensions/sugar_extensions.dart';

// Navigation helpers - Make routing with state management simple
export 'src/navigation/navigation_sugar.dart';

// Examples and showcase (for documentation and testing)
export 'src/examples/sugar_showcase.dart';

// Re-export flutter_riverpod for convenience
export 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter/material.dart';
import 'package:riverpod_sugar/riverpod_sugar.dart';

/// This file shows you exactly how to create instant providers for:
/// - Colors, ThemeData, PageController, Maps, and other complex types
/// - How to fix the ref issue you encountered

// =============================================================================
// ✅ INSTANT PROVIDER CREATION - Your requested examples
// =============================================================================

/// Color providers - exactly what you asked for
final currentThemeData = ThemeData.light().state; // StateProvider<ThemeData>
final primaryColor = const Color(0xFF6750A4).state; // StateProvider<Color>
final accentColor = Colors.orange.state; // StateProvider<Color>
final backgroundColor = Colors.white.state; // StateProvider<Color>

/// Map providers - exactly what you asked for
final customColorScheme =
    <String, dynamic>{}.state; // StateProvider<Map<String, dynamic>>
final appConfig =
    <String, String>{}.state; // StateProvider<Map<String, String>>
final userSettings = <String, bool>{}.state; // StateProvider<Map<String, bool>>

/// Controller providers - exactly what you asked for
final pageController = PageController().state; // StateProvider<PageController>
final textController =
    TextEditingController().state; // StateProvider<TextEditingController>
final scrollController =
    ScrollController().state; // StateProvider<ScrollController>

/// DateTime providers - much more useful than Duration/Size/Offset
final selectedDate = DateTime.now().state; // StateProvider<DateTime>
final selectedTime = TimeOfDay.now().state; // StateProvider<TimeOfDay>
final currentLocale = const Locale('en').state; // StateProvider<Locale>

// =============================================================================
// ✅ USAGE EXAMPLES - How to use these providers
// =============================================================================

class InstantProviderUsageExample extends RxWidget {
  const InstantProviderUsageExample({super.key});

  @override
  Widget buildRx(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🚀 Instant Provider Usage'),
        backgroundColor: ref.watch(primaryColor), // ✅ Use the color provider
      ),
      backgroundColor: ref.watch(backgroundColor), // ✅ Use background color
      body: PageView(
        controller: ref.watch(pageController), // ✅ Use controller provider
        children: [
          _ColorPage(),
          _ConfigPage(),
          _ControllerPage(),
        ],
      ),
    );
  }
}

// =============================================================================
// ✅ SOLUTION TO YOUR REF ISSUE
// =============================================================================

class _ColorPage extends RxWidget {
  @override
  Widget buildRx(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          const Text(
            '🎨 Color Provider Usage',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),

          // ✅ CORRECT WAY - Fixed your ref issue
          Container(
            height: 100,
            width: double.infinity,
            color: ref.watch(primaryColor),
            child: const Center(
              child: Text('Primary Color Container',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ),
          const SizedBox(height: 20),

          ElevatedButton(
            onPressed: () {
              // ✅ FIXED - Use setWidgetValue instead of ref.set
              final newColor = Colors.primaries[(Colors.primaries.length *
                      (DateTime.now().millisecond / 1000))
                  .floor()];
              primaryColor.setWidgetValue(ref, newColor);
            },
            child: const Text('Change Primary Color'),
          ),

          const SizedBox(height: 20),

          // Show the old problematic way vs the new working way
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '❌ OLD WAY (caused your error):',
                  style:
                      TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                ),
                Text('primaryColor.ref.set(ref, newColor);'),
                Text(
                    '// Error: FutureProviderRef<bool> can\'t be assigned to WidgetRef'),
                SizedBox(height: 12),
                Text(
                  '✅ NEW WAY (works perfectly):',
                  style: TextStyle(
                      color: Colors.green, fontWeight: FontWeight.bold),
                ),
                Text('primaryColor.setWidgetValue(ref, newColor);'),
                Text('final color = primaryColor.getWidgetValue(ref);'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ConfigPage extends RxWidget {
  @override
  Widget buildRx(BuildContext context, WidgetRef ref) {
    final config = ref.watch(appConfig);
    final settings = ref.watch(userSettings);
    final colorScheme = ref.watch(customColorScheme);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          const Text(
            '📋 Map Provider Usage',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),

          // Show config entries
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('App Config (${config.length} entries):'),
                  ...config.entries.map((e) => Text('  ${e.key}: ${e.value}')),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Show settings
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('User Settings (${settings.length} entries):'),
                  ...settings.entries
                      .map((e) => Text('  ${e.key}: ${e.value}')),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          ElevatedButton(
            onPressed: () {
              // ✅ Update map providers correctly
              final newConfig = Map<String, String>.from(config);
              newConfig['timestamp'] = DateTime.now().toString();
              newConfig['user'] = 'Flutter Developer';
              appConfig.setWidgetValue(ref, newConfig);

              final newSettings = Map<String, bool>.from(settings);
              newSettings['darkMode'] = !newSettings['darkMode']!;
              newSettings['notifications'] = true;
              userSettings.setWidgetValue(ref, newSettings);

              final newColorScheme = Map<String, dynamic>.from(colorScheme);
              newColorScheme['primary'] = ref.read(primaryColor).toARGB32();
              newColorScheme['timestamp'] =
                  DateTime.now().millisecondsSinceEpoch;
              customColorScheme.setWidgetValue(ref, newColorScheme);
            },
            child: const Text('Update All Maps'),
          ),
        ],
      ),
    );
  }
}

class _ControllerPage extends RxWidget {
  @override
  Widget buildRx(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          const Text(
            '🎮 Controller & DateTime Provider Usage',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),

          // DateTime example
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Text('Selected Date: ${selectedDate.formatDate(ref)}'),
                  Text('Is Today: ${selectedDate.isToday(ref)}'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () => selectedDate.addDays(ref, 1),
                        child: const Text('Next Day'),
                      ),
                      ElevatedButton(
                        onPressed: () => selectedDate.setToday(ref),
                        child: const Text('Today'),
                      ),
                      ElevatedButton(
                        onPressed: () => selectedDate.subtractDays(ref, 1),
                        child: const Text('Previous Day'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // TimeOfDay example
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Text('Selected Time: ${selectedTime.formatTime(ref)}'),
                  Text('24H Format: ${selectedTime.formatTime(ref, true)}'),
                  Text('12H Format: ${selectedTime.formatTime(ref, false)}'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () => selectedTime.addMinutes(ref, 15),
                        child: const Text('+15 min'),
                      ),
                      ElevatedButton(
                        onPressed: () => selectedTime.setNow(ref),
                        child: const Text('Now'),
                      ),
                      ElevatedButton(
                        onPressed: () => selectedTime.addMinutes(ref, -15),
                        child: const Text('-15 min'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// =============================================================================
// ✅ SUMMARY OF WHAT YOU CAN NOW DO
// =============================================================================

/*
🎯 INSTANT PROVIDER CREATION:

// Colors
final primaryColor = const Color(0xFF6750A4).state;
final accentColor = Colors.orange.state;
final bgColor = Colors.white.state;

// ThemeData
final currentTheme = ThemeData.light().state;
final darkTheme = ThemeData.dark().state;

// Controllers
final pageController = PageController().state;
final textController = TextEditingController().state;
final scrollController = ScrollController().state;

// Maps
final configMap = <String, dynamic>{}.state;
final settingsMap = <String, bool>{}.state;
final dataMap = <String, String>{}.state;

// Other types
final selectedDate = DateTime.now().state;
final selectedTime = TimeOfDay.now().state;
final appMode = AppMode.light.state;

✅ FIXED REF USAGE:

// OLD (caused error):
isFirstTime.ref.set(ref, isFirst); // ❌ Wrong ref type

// NEW (works perfectly):
isFirstTime.setWidgetValue(ref, isFirst); // ✅ Correct!
final value = isFirstTime.getWidgetValue(ref); // ✅ Correct!

🚀 ALL PROVIDER TYPES NOW SUPPORTED:
- Basic: int, String, bool, List, Set, double
- Advanced: Color, ThemeData, Controllers, Maps, Locale, Enum
- DateTime: DateTime, TimeOfDay
*/

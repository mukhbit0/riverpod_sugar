import 'package:flutter/material.dart';
import 'package:riverpod_sugar/riverpod_sugar.dart';
import 'dart:math' as math;

/// Example demonstrating advanced provider creation for Colors, ThemeData, Controllers, and Maps
class AdvancedProviderExample extends RxWidget {
  const AdvancedProviderExample({super.key});

  @override
  Widget buildRx(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🎨 Advanced Provider Examples'),
        backgroundColor: ref.watch(primaryColor),
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _ColorSection(),
              SizedBox(height: 24),
              _ThemeSection(),
              SizedBox(height: 24),
              _ControllerSection(),
              SizedBox(height: 24),
              _MapSection(),
              SizedBox(height: 24),
              _FixedRefSection(),
            ],
          ),
        ),
      ),
    );
  }
}

// =============================================================================
// PROVIDER CREATION EXAMPLES - Using the new extensions
// =============================================================================

/// 1. Color providers - instant creation
final primaryColor = const Color(0xFF6750A4).state;
final accentColor = Colors.orange.state;
final backgroundColor = Colors.white.state;

/// 2. ThemeData providers - instant creation
final currentThemeData = ThemeData.light().state;
final darkTheme = ThemeData.dark().state;

/// 3. Controller providers - instant creation
final pageController = PageController().state;
final textController = TextEditingController().state;
final scrollController = ScrollController().state;

/// 4. Map providers - instant creation
final customColorScheme = <String, dynamic>{}.state;
final appConfig = <String, String>{}.state;
final userSettings = <String, bool>{}.state;

/// 5. Other useful types
enum AppMode { light, dark, system }

final appMode = AppMode.system.state;
final selectedDate = DateTime.now().state;

// =============================================================================
// WIDGET SECTIONS
// =============================================================================

class _ColorSection extends RxWidget {
  const _ColorSection();

  @override
  Widget buildRx(BuildContext context, WidgetRef ref) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '🎨 Color Providers',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Text(
              'Primary Color: #${ref.watch(primaryColor).toARGB32().toRadixString(16).substring(2).toUpperCase()}',
              style: TextStyle(color: ref.watch(primaryColor)),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () {
                // Update color with new random color
                final newColor = Color(
                    (math.Random().nextDouble() * 0xFFFFFF).toInt() |
                        0xFF000000);
                primaryColor.setWidgetValue(ref, newColor);
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: ref.watch(primaryColor)),
              child: const Text('Change Primary Color'),
            ),
            const SizedBox(height: 8),
            Container(
              height: 50,
              width: double.infinity,
              decoration: BoxDecoration(
                color: ref.watch(backgroundColor),
                border: Border.all(color: ref.watch(accentColor), width: 2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  'Background with accent border',
                  style: TextStyle(color: ref.watch(accentColor)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ThemeSection extends RxWidget {
  const _ThemeSection();

  @override
  Widget buildRx(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(currentThemeData);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '🎭 Theme Providers',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Text('Current brightness: ${theme.brightness}'),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () {
                // Toggle between light and dark theme
                final newTheme = theme.brightness == Brightness.light
                    ? ThemeData.dark()
                    : ThemeData.light();
                currentThemeData.setWidgetValue(ref, newTheme);
              },
              child: const Text('Toggle Theme'),
            ),
          ],
        ),
      ),
    );
  }
}

class _ControllerSection extends RxWidget {
  const _ControllerSection();

  @override
  Widget buildRx(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(pageController);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '🎮 Controller Providers',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Text('Page Controller created: ${controller.hasClients}'),
            const SizedBox(height: 8),
            SizedBox(
              height: 100,
              child: PageView(
                controller: controller,
                children: [
                  Container(
                    color: Colors.red.shade100,
                    child: const Center(child: Text('Page 1')),
                  ),
                  Container(
                    color: Colors.green.shade100,
                    child: const Center(child: Text('Page 2')),
                  ),
                  Container(
                    color: Colors.blue.shade100,
                    child: const Center(child: Text('Page 3')),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MapSection extends RxWidget {
  const _MapSection();

  @override
  Widget buildRx(BuildContext context, WidgetRef ref) {
    final config = ref.watch(appConfig);
    final settings = ref.watch(userSettings);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '📋 Map Providers',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Text('Config entries: ${config.length}'),
            Text('Settings entries: ${settings.length}'),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () {
                // Add new config entry
                final newConfig = Map<String, String>.from(config);
                newConfig['timestamp'] =
                    DateTime.now().millisecondsSinceEpoch.toString();
                appConfig.setWidgetValue(ref, newConfig);

                // Add new setting
                final newSettings = Map<String, bool>.from(settings);
                newSettings['feature_${settings.length}'] =
                    math.Random().nextBool();
                userSettings.setWidgetValue(ref, newSettings);
              },
              child: const Text('Add Config & Setting'),
            ),
            if (config.isNotEmpty)
              ...config.entries.map((e) => Text('${e.key}: ${e.value}')),
            if (settings.isNotEmpty)
              ...settings.entries.map((e) => Text('${e.key}: ${e.value}')),
          ],
        ),
      ),
    );
  }
}

class _FixedRefSection extends RxWidget {
  const _FixedRefSection();

  @override
  Widget buildRx(BuildContext context, WidgetRef ref) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '🔧 Fixed Ref Issue Examples',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            const Text(
              'The ref issue is fixed with new methods:',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '// ✅ CORRECT - Use these methods:',
                    style: TextStyle(
                        color: Colors.green, fontWeight: FontWeight.bold),
                  ),
                  Text('primaryColor.setWidgetValue(ref, newColor);'),
                  Text('final color = primaryColor.getWidgetValue(ref);'),
                  SizedBox(height: 8),
                  Text(
                    '// ❌ OLD - This caused the error:',
                    style: TextStyle(
                        color: Colors.red, fontWeight: FontWeight.bold),
                  ),
                  Text(
                      'primaryColor.ref.set(ref, newColor); // Wrong ref type'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

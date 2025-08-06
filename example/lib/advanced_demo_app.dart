import 'package:flutter/material.dart';
import 'package:riverpod_sugar/riverpod_sugar.dart';

// 🎨 Advanced Provider Examples
final primaryColor = Colors.blue.state;
final appTheme = ThemeData.light().state;
final pageController = PageController().state;
final userSettings = <String, dynamic>{
  'theme': 'light',
  'notifications': true,
  'fontSize': 16.0,
}.state;

class AdvancedDemoApp extends ConsumerWidget {
  const AdvancedDemoApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'Riverpod Sugar Advanced Demo',
      theme: appTheme.watch(ref),
      home: const AdvancedDemoHome(),
    );
  }
}

class AdvancedDemoHome extends ConsumerWidget {
  const AdvancedDemoHome({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🎨 Advanced Sugar Demo'),
        backgroundColor: primaryColor.watch(ref),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(appTheme.brightness(ref) == Brightness.light
                ? Icons.dark_mode
                : Icons.light_mode),
            onPressed: () {
              if (appTheme.brightness(ref) == Brightness.light) {
                appTheme.switchToDark(ref);
                userSettings.setValue(ref, 'theme', 'dark');
              } else {
                appTheme.switchToLight(ref);
                userSettings.setValue(ref, 'theme', 'light');
              }
            },
          ),
        ],
      ),
      body: PageView(
        controller: pageController.watch(ref),
        children: [
          _buildColorDemo(ref),
          _buildThemeDemo(ref),
          _buildNavigationDemo(ref),
          _buildSettingsDemo(ref),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: pageController.currentPage(ref)?.round() ?? 0,
        onTap: (index) => pageController.animateToPage(ref, index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.palette), label: 'Colors'),
          BottomNavigationBarItem(
              icon: Icon(Icons.format_paint), label: 'Theme'),
          BottomNavigationBarItem(
              icon: Icon(Icons.navigation), label: 'Navigation'),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings), label: 'Settings'),
        ],
      ),
    );
  }

  Widget _buildColorDemo(WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('🎨 Color Sugar Demo',
              style: Theme.of(ref.context).textTheme.headlineMedium),
          const SizedBox(height: 20),

          // Color display
          Container(
            height: 100,
            width: double.infinity,
            decoration: BoxDecoration(
              color: primaryColor.watch(ref),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Primary Color',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    primaryColor.hexString(ref),
                    style: const TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Color controls
          Text('Color Controls:',
              style: Theme.of(ref.context).textTheme.titleMedium),
          const SizedBox(height: 10),

          Wrap(
            spacing: 8,
            children: [
              ElevatedButton(
                onPressed: () =>
                    ref.read(primaryColor.notifier).state = Colors.red,
                child: const Text('Red'),
              ),
              ElevatedButton(
                onPressed: () =>
                    ref.read(primaryColor.notifier).state = Colors.green,
                child: const Text('Green'),
              ),
              ElevatedButton(
                onPressed: () =>
                    ref.read(primaryColor.notifier).state = Colors.purple,
                child: const Text('Purple'),
              ),
              ElevatedButton(
                onPressed: () => primaryColor.brighten(ref, 0.2),
                child: const Text('Brighten'),
              ),
              ElevatedButton(
                onPressed: () => primaryColor.darken(ref, 0.2),
                child: const Text('Darken'),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Opacity controls
          Text('Opacity: ${primaryColor.opacity(ref).toStringAsFixed(2)}'),
          Slider(
            value: primaryColor.opacity(ref),
            onChanged: (value) => primaryColor.withOpacity(ref, value),
          ),
        ],
      ),
    );
  }

  Widget _buildThemeDemo(WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('🎭 Theme Sugar Demo',
              style: Theme.of(ref.context).textTheme.headlineMedium),
          const SizedBox(height: 20),

          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Current Theme Info:',
                      style: Theme.of(ref.context).textTheme.titleMedium),
                  const SizedBox(height: 10),
                  Text('Brightness: ${appTheme.brightness(ref).name}'),
                  Container(
                    height: 40,
                    width: 100,
                    decoration: BoxDecoration(
                      color: appTheme.primaryColor(ref),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Center(
                      child: Text('Primary',
                          style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Theme controls
          Text('Theme Controls:',
              style: Theme.of(ref.context).textTheme.titleMedium),
          const SizedBox(height: 10),

          Column(
            children: [
              SwitchListTile(
                title: const Text('Dark Mode'),
                value: appTheme.brightness(ref) == Brightness.dark,
                onChanged: (isDark) {
                  if (isDark) {
                    appTheme.switchToDark(ref);
                  } else {
                    appTheme.switchToLight(ref);
                  }
                },
              ),
              ListTile(
                title: const Text('Update Primary Color'),
                trailing: ElevatedButton(
                  onPressed: () {
                    appTheme.copyWith(
                      ref,
                      colorScheme: ColorScheme.fromSeed(
                        seedColor: primaryColor.watch(ref),
                        brightness: appTheme.brightness(ref),
                      ),
                    );
                  },
                  child: const Text('Apply'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationDemo(WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('🎮 Navigation Sugar Demo',
              style: Theme.of(ref.context).textTheme.headlineMedium),
          const SizedBox(height: 20),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                      'Current Page: ${(pageController.currentPage(ref) ?? 0).round() + 1}'),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () => pageController.previousPage(ref),
                        icon: const Icon(Icons.arrow_back),
                        label: const Text('Previous'),
                      ),
                      ElevatedButton.icon(
                        onPressed: () => pageController.nextPage(ref),
                        icon: const Icon(Icons.arrow_forward),
                        label: const Text('Next'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text('Quick Navigation:',
              style: Theme.of(ref.context).textTheme.titleMedium),
          const SizedBox(height: 10),
          GridView.count(
            shrinkWrap: true,
            crossAxisCount: 2,
            childAspectRatio: 3,
            children: [
              _buildPageButton(ref, 0, 'Colors', Icons.palette),
              _buildPageButton(ref, 1, 'Theme', Icons.format_paint),
              _buildPageButton(ref, 2, 'Navigation', Icons.navigation),
              _buildPageButton(ref, 3, 'Settings', Icons.settings),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPageButton(
      WidgetRef ref, int index, String title, IconData icon) {
    final isActive = (pageController.currentPage(ref) ?? 0).round() == index;

    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: ElevatedButton.icon(
        onPressed: () => pageController.animateToPage(ref, index),
        icon: Icon(icon),
        label: Text(title),
        style: ElevatedButton.styleFrom(
          backgroundColor: isActive ? primaryColor.watch(ref) : null,
          foregroundColor: isActive ? Colors.white : null,
        ),
      ),
    );
  }

  Widget _buildSettingsDemo(WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('🗺️ Map Sugar Demo',
              style: Theme.of(ref.context).textTheme.headlineMedium),
          const SizedBox(height: 20),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Settings:',
                      style: Theme.of(ref.context).textTheme.titleMedium),
                  const SizedBox(height: 10),
                  ListTile(
                    title: const Text('Theme'),
                    subtitle:
                        Text(userSettings.getValue(ref, 'theme') ?? 'unknown'),
                    trailing: Switch(
                      value: userSettings.getValue(ref, 'theme') == 'dark',
                      onChanged: (isDark) {
                        userSettings.setValue(
                            ref, 'theme', isDark ? 'dark' : 'light');
                        if (isDark) {
                          appTheme.switchToDark(ref);
                        } else {
                          appTheme.switchToLight(ref);
                        }
                      },
                    ),
                  ),
                  ListTile(
                    title: const Text('Notifications'),
                    subtitle: Text(userSettings.hasKey(ref, 'notifications')
                        ? 'Enabled'
                        : 'Disabled'),
                    trailing: Switch(
                      value:
                          userSettings.getValue(ref, 'notifications') ?? false,
                      onChanged: (value) =>
                          userSettings.setValue(ref, 'notifications', value),
                    ),
                  ),
                  ListTile(
                    title: const Text('Font Size'),
                    subtitle: Text(
                        '${userSettings.getValue(ref, 'fontSize') ?? 16.0}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () {
                            final current =
                                userSettings.getValue(ref, 'fontSize') ?? 16.0;
                            userSettings.setValue(ref, 'fontSize',
                                (current - 2.0).clamp(12.0, 24.0));
                          },
                          icon: const Icon(Icons.remove),
                        ),
                        IconButton(
                          onPressed: () {
                            final current =
                                userSettings.getValue(ref, 'fontSize') ?? 16.0;
                            userSettings.setValue(ref, 'fontSize',
                                (current + 2.0).clamp(12.0, 24.0));
                          },
                          icon: const Icon(Icons.add),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Settings Debug Info:',
                      style: Theme.of(ref.context).textTheme.titleMedium),
                  const SizedBox(height: 10),
                  Text('Total Keys: ${userSettings.watch(ref).length}'),
                  Text('Has Theme: ${userSettings.hasKey(ref, 'theme')}'),
                  Text(
                      'Has Notifications: ${userSettings.hasKey(ref, 'notifications')}'),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      ElevatedButton(
                        onPressed: () => userSettings.setValue(
                            ref,
                            'newKey_${DateTime.now().millisecondsSinceEpoch}',
                            'test'),
                        child: const Text('Add Random Key'),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: () => userSettings.clear(ref),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red),
                        child: const Text('Clear All'),
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

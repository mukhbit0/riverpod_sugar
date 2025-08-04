import 'package:flutter/material.dart';
import 'package:riverpod_sugar/riverpod_sugar.dart';

/// Demo showcasing Navigation Sugar features
class NavigationDemo extends RxWidget {
  /// Creates a navigation demo widget
  const NavigationDemo({super.key});

  @override
  Widget buildRx(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🚀 Navigation Sugar Demo'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              '🧭 WidgetRef Extensions:',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
            ),
            const SizedBox(height: 12),

            ElevatedButton.icon(
              onPressed: () => ref.pushPage(const _SecondPage()),
              icon: const Icon(Icons.arrow_forward),
              label: const Text('Push Simple Page'),
            ),
            const SizedBox(height: 12),

            ElevatedButton.icon(
              onPressed: () async {
                final result =
                    await ref.pushPageWithResult<String>(const _ResultPage());
                if (result != null && context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Result: $result')),
                  );
                }
              },
              icon: const Icon(Icons.keyboard_return),
              label: const Text('Push with Result'),
            ),
            const SizedBox(height: 12),

            ElevatedButton.icon(
              onPressed: () => ref.pushPage(const _TransitionPage()),
              icon: const Icon(Icons.animation),
              label: const Text('Custom Transitions'),
            ),
            const SizedBox(height: 12),

            ElevatedButton.icon(
              onPressed: () => ref.showBottomSheet(const _BottomSheetDemo()),
              icon: const Icon(Icons.expand_less),
              label: const Text('Bottom Sheet'),
            ),
            const SizedBox(height: 12),

            ElevatedButton.icon(
              onPressed: () => ref.showCustomDialog(const _DialogDemo()),
              icon: const Icon(Icons.chat_bubble_outline),
              label: const Text('Show Dialog'),
            ),
            const SizedBox(height: 24),

            // Widget Extension Examples
            const Text(
              '📱 Widget Extensions:',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
            ),
            const SizedBox(height: 12),

            ElevatedButton(
              onPressed: () => const _SecondPage().push(ref),
              child: const Text('Widget.push(ref)'),
            ),
            const SizedBox(height: 12),

            ElevatedButton(
              onPressed: () => const _SecondPage().pushReplacement(ref),
              child: const Text('Widget.pushReplacement(ref)'),
            ),
            const SizedBox(height: 12),

            ElevatedButton(
              onPressed: () => const _SecondPage().pushAndClearAll(ref),
              child: const Text('Widget.pushAndClearAll(ref)'),
            ),
            const SizedBox(height: 12),

            ElevatedButton(
              onPressed: () => const _BottomSheetDemo().showAsBottomSheet(ref),
              child: const Text('Widget.showAsBottomSheet(ref)'),
            ),
          ],
        ),
      ),
    );
  }
}

class _SecondPage extends RxWidget {
  const _SecondPage();

  @override
  Widget buildRx(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Second Page'),
        backgroundColor: Colors.orange,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              '🎉 Welcome to the Second Page!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => ref.pushPage(const _ThirdPage()),
              icon: const Icon(Icons.arrow_forward),
              label: const Text('Go to Third Page'),
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: () => ref.pop(),
              icon: const Icon(Icons.arrow_back),
              label: const Text('Go Back'),
            ),
          ],
        ),
      ),
    );
  }
}

class _ResultPage extends RxWidget {
  const _ResultPage();

  @override
  Widget buildRx(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Return Result'),
        backgroundColor: Colors.green,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              '💫 Choose a result to return:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => ref.popWithData('Success! 🎉'),
              icon: const Icon(Icons.check_circle),
              label: const Text('Return Success'),
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: () => ref.popWithData('Cancelled 😔'),
              icon: const Icon(Icons.cancel),
              label: const Text('Return Cancelled'),
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: () => ref.pop(),
              icon: const Icon(Icons.arrow_back),
              label: const Text('Return Nothing'),
            ),
          ],
        ),
      ),
    );
  }
}

class _TransitionPage extends RxWidget {
  const _TransitionPage();

  @override
  Widget buildRx(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Custom Transitions'),
        backgroundColor: Colors.purple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              '✨ Try different transition effects:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () => ref.pushPageWithTransition(
                const _FadePage(),
                (context, animation, secondaryAnimation, child) {
                  return FadeTransition(opacity: animation, child: child);
                },
              ),
              icon: const Icon(Icons.blur_on),
              label: const Text('Fade Transition'),
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: () => ref.pushPageWithTransition(
                const _ScalePage(),
                (context, animation, secondaryAnimation, child) {
                  return ScaleTransition(scale: animation, child: child);
                },
              ),
              icon: const Icon(Icons.zoom_in),
              label: const Text('Scale Transition'),
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: () => ref.pushPageWithTransition(
                const _SecondPage(),
                (context, animation, secondaryAnimation, child) {
                  return SlideTransition(
                    position: animation.drive(
                      Tween(begin: const Offset(0.0, 1.0), end: Offset.zero),
                    ),
                    child: child,
                  );
                },
              ),
              icon: const Icon(Icons.arrow_upward),
              label: const Text('Slide from Bottom'),
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: () => ref.pushPageWithTransition(
                const _SecondPage(),
                (context, animation, secondaryAnimation, child) {
                  return SlideTransition(
                    position: animation.drive(
                      Tween(begin: const Offset(1.0, 0.0), end: Offset.zero),
                    ),
                    child: child,
                  );
                },
              ),
              icon: const Icon(Icons.arrow_forward),
              label: const Text('Slide from Right'),
            ),
          ],
        ),
      ),
    );
  }
}

class _ThirdPage extends RxWidget {
  const _ThirdPage();

  @override
  Widget buildRx(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Third Page'),
        backgroundColor: Colors.teal,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              '🎯 You made it to the third page!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => ref.popToRoot(),
              icon: const Icon(Icons.home),
              label: const Text('Pop to Root'),
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: () => ref.pop(),
              icon: const Icon(Icons.arrow_back),
              label: const Text('Go Back One'),
            ),
          ],
        ),
      ),
    );
  }
}

class _FadePage extends RxWidget {
  const _FadePage();

  @override
  Widget buildRx(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fade Transition'),
        backgroundColor: Colors.indigo,
      ),
      body: const Center(
        child: Text(
          '✨ This page appeared with a fade transition!',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

class _ScalePage extends RxWidget {
  const _ScalePage();

  @override
  Widget buildRx(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scale Transition'),
        backgroundColor: Colors.deepOrange,
      ),
      body: const Center(
        child: Text(
          '🔍 This page appeared with a scale transition!',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

class _BottomSheetDemo extends RxWidget {
  const _BottomSheetDemo();

  @override
  Widget buildRx(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            '📋 Bottom Sheet Demo',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          const Text(
            'This is a bottom sheet created with Navigation Sugar!',
            style: TextStyle(fontSize: 16),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: () => ref.pop(),
            icon: const Icon(Icons.close),
            label: const Text('Close Bottom Sheet'),
          ),
        ],
      ),
    );
  }
}

class _DialogDemo extends RxWidget {
  const _DialogDemo();

  @override
  Widget buildRx(BuildContext context, WidgetRef ref) {
    return AlertDialog(
      title: const Text('🎪 Dialog Demo'),
      content: const Text(
        'This dialog was created using Navigation Sugar!\n\n'
        'You can easily show dialogs with ref.showDialog().',
      ),
      actions: [
        TextButton(
          onPressed: () => ref.pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () => ref.popWithData('Dialog confirmed!'),
          child: const Text('OK'),
        ),
      ],
    );
  }
}

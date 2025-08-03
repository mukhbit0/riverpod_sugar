import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:riverpod_sugar/riverpod_sugar.dart';

void main() {
  group('Enhanced Sugar Extensions Tests', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    group('Enhanced Widget Helpers', () {
      testWidgets('text helper creates proper Text widget', (tester) async {
        final nameProvider = 'John'.text;

        await tester.pumpWidget(
          ProviderScope(
            child: MaterialApp(
              home: Scaffold(
                body: Consumer(
                  builder: (context, ref, _) {
                    return ref.text(nameProvider,
                        style: const TextStyle(fontSize: 20));
                  },
                ),
              ),
            ),
          ),
        );

        expect(find.text('John'), findsOneWidget);
        final textWidget = tester.widget<Text>(find.text('John'));
        expect(textWidget.style?.fontSize, 20);
      });

      testWidgets('switchTile helper creates functional switch',
          (tester) async {
        final darkModeProvider = false.toggle;
        bool currentValue = false;

        await tester.pumpWidget(
          ProviderScope(
            child: MaterialApp(
              home: Scaffold(
                body: Consumer(
                  builder: (context, ref, _) {
                    currentValue = ref.watch(darkModeProvider);
                    return ref.switchTile(darkModeProvider, title: 'Dark Mode');
                  },
                ),
              ),
            ),
          ),
        );

        expect(find.text('Dark Mode'), findsOneWidget);
        expect(find.byType(Switch), findsOneWidget);
        expect(currentValue, false);

        // Test switch functionality
        await tester.tap(find.byType(Switch));
        await tester.pumpAndSettle();

        expect(currentValue, true);
      });

      // testWidgets('stepper helper creates increment/decrement buttons',
      //     (tester) async {
      //   // final counterProvider = 5.state; // Removed - stepper helper removed

      //   await tester.pumpWidget(
      //     ProviderScope(
      //       child: MaterialApp(
      //         home: Scaffold(
      //           body: Consumer(
      //             builder: (context, ref, _) {
      //               return const Text('Stepper test removed');
      //               // return ref.stepper(counterProvider, min: 0, max: 10);
      //             },
      //           ),
      //         ),
      //       ),
      //     ),
      //   );

      //   expect(find.text('5'), findsOneWidget);
      //   expect(find.byIcon(Icons.add), findsOneWidget);
      //   expect(find.byIcon(Icons.remove), findsOneWidget);

      //   // Test increment
      //   await tester.tap(find.byIcon(Icons.add));
      //   await tester.pumpAndSettle();
      //   expect(find.text('6'), findsOneWidget);

      //   // Test decrement
      //   await tester.tap(find.byIcon(Icons.remove));
      //   await tester.pumpAndSettle();
      //   expect(find.text('5'), findsOneWidget);
      // });

      testWidgets('loading helper shows/hides loading indicator',
          (tester) async {
        final loadingProvider = false.loading;

        await tester.pumpWidget(
          ProviderScope(
            child: MaterialApp(
              home: Scaffold(
                body: Consumer(
                  builder: (context, ref, _) {
                    return Column(
                      children: [
                        ref.loading(loadingProvider),
                        ElevatedButton(
                          onPressed: () => loadingProvider.toggle(ref),
                          child: const Text('Toggle Loading'),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        );

        // Initially no loading indicator
        expect(find.byType(CircularProgressIndicator), findsNothing);

        // Toggle loading
        await tester.tap(find.text('Toggle Loading'));
        await tester.pump();

        // Now loading indicator should be visible
        expect(find.byType(CircularProgressIndicator), findsOneWidget);
      });

      // testWidgets('chip helper creates chip with provider value',
      //     (tester) async {
      //   // final statusProvider = 'Active'.text; // Removed - chip helper removed

      //   await tester.pumpWidget(
      //     ProviderScope(
      //       child: MaterialApp(
      //         home: Scaffold(
      //           body: Consumer(
      //             builder: (context, ref, _) {
      //               return const Text('Chip test removed');
      //               // return ref.chip(statusProvider, backgroundColor: Colors.green);
      //             },
      //           ),
      //         ),
      //       ),
      //     ),
      //   );

      //   expect(find.byType(Chip), findsOneWidget);
      //   expect(find.text('Active'), findsOneWidget);

      //   final chip = tester.widget<Chip>(find.byType(Chip));
      //   expect(chip.backgroundColor, Colors.green);
      // });

      // testWidgets('card helper creates card with conditional visibility',
      //     (tester) async {
      //   final visibleProvider = true.visible;

      //   await tester.pumpWidget(
      //     ProviderScope(
      //       child: MaterialApp(
      //         home: Scaffold(
      //           body: Consumer(
      //             builder: (context, ref, _) {
      //               return Column(
      //                 children: [
      //                   const Text('Card test removed'),
      //                   // ref.card(
      //                   //   const Text('Card Content'),
      //                   //   visible: visibleProvider,
      //                   //   padding: const EdgeInsets.all(16),
      //                   // ),
      //                   ElevatedButton(
      //                     onPressed: () => visibleProvider.toggle(ref),
      //                     child: const Text('Toggle Card'),
      //                   ),
      //                 ],
      //               );
      //             },
      //           ),
      //         ),
      //       ),
      //     ),
      //   );

      //   expect(find.byType(Card), findsOneWidget);
      //   expect(find.text('Card Content'), findsOneWidget);

      //   // Hide the card
      //   await tester.tap(find.text('Toggle Card'));
      //   await tester.pumpAndSettle();

      //   expect(find.byType(Card), findsNothing);
      //   expect(find.text('Card Content'), findsNothing);
      // });
    });

    group('Safe Operations', () {
      testWidgets('safeIncrement respects max bounds', (tester) async {
        final counterProvider = 9.state;

        await tester.pumpWidget(
          ProviderScope(
            child: MaterialApp(
              home: Consumer(
                builder: (context, ref, _) {
                  return Column(
                    children: [
                      Text('${ref.watch(counterProvider)}'),
                      ElevatedButton(
                        onPressed: () =>
                            counterProvider.safeIncrement(ref, max: 10),
                        child: const Text('Increment'),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        );

        // Should succeed
        await tester.tap(find.text('Increment'));
        await tester.pumpAndSettle();
        expect(find.text('10'), findsOneWidget);

        // Should fail due to max limit
        await tester.tap(find.text('Increment'));
        await tester.pumpAndSettle();
        expect(find.text('10'), findsOneWidget); // Should remain unchanged
      });

      testWidgets('safeDecrement respects min bounds', (tester) async {
        final counterProvider = 1.state;

        await tester.pumpWidget(
          ProviderScope(
            child: MaterialApp(
              home: Consumer(
                builder: (context, ref, _) {
                  return Column(
                    children: [
                      Text('${ref.watch(counterProvider)}'),
                      ElevatedButton(
                        onPressed: () =>
                            counterProvider.safeDecrement(ref, min: 0),
                        child: const Text('Decrement'),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        );

        // Should succeed
        await tester.tap(find.text('Decrement'));
        await tester.pumpAndSettle();
        expect(find.text('0'), findsOneWidget);

        // Should fail due to min limit
        await tester.tap(find.text('Decrement'));
        await tester.pumpAndSettle();
        expect(find.text('0'), findsOneWidget); // Should remain unchanged
      });

      testWidgets('safeUpdateText validates length', (tester) async {
        final textProvider = ''.text;

        await tester.pumpWidget(
          ProviderScope(
            child: MaterialApp(
              home: Consumer(
                builder: (context, ref, _) {
                  return Column(
                    children: [
                      Text(ref.watch(textProvider)),
                      ElevatedButton(
                        onPressed: () => textProvider
                            .safeUpdateText(ref, 'Hello', minLength: 3),
                        child: const Text('Set Hello'),
                      ),
                      ElevatedButton(
                        onPressed: () => textProvider.safeUpdateText(ref, 'Hi',
                            minLength: 3),
                        child: const Text('Set Hi'),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        );

        // Should succeed
        await tester.tap(find.text('Set Hello'));
        await tester.pumpAndSettle();
        expect(find.text('Hello'), findsOneWidget);

        // Should fail due to min length
        await tester.tap(find.text('Set Hi'));
        await tester.pumpAndSettle();
        expect(find.text('Hello'), findsOneWidget); // Should remain unchanged
      });
    });

    group('Validators', () {
      test('intRange validator works correctly', () {
        expect(SugarValidators.intRange(5, min: 1, max: 10), true);
        expect(SugarValidators.intRange(0, min: 1, max: 10), false);
        expect(SugarValidators.intRange(11, min: 1, max: 10), false);
        expect(SugarValidators.intRange(5), true); // No bounds
      });

      test('stringLength validator works correctly', () {
        expect(
            SugarValidators.stringLength('Hello', minLength: 3, maxLength: 10),
            true);
        expect(SugarValidators.stringLength('Hi', minLength: 3, maxLength: 10),
            false);
        expect(
            SugarValidators.stringLength('This is too long',
                minLength: 3, maxLength: 10),
            false);
        expect(SugarValidators.stringLength('Hello'), true); // No bounds
      });

      test('email validator works correctly', () {
        expect(SugarValidators.email('test@example.com'), true);
        expect(SugarValidators.email('user.name@domain.co.uk'), true);
        expect(SugarValidators.email('invalid-email'), false);
        expect(SugarValidators.email('@domain.com'), false);
        expect(SugarValidators.email('user@'), false);
      });

      test('notEmpty validator works correctly', () {
        expect(SugarValidators.notEmpty('Hello'), true);
        expect(SugarValidators.notEmpty('   Hello   '), true); // Trimmed
        expect(SugarValidators.notEmpty(''), false);
        expect(SugarValidators.notEmpty('   '), false); // Only whitespace
      });

      test('listCapacity validator works correctly', () {
        expect(SugarValidators.listCapacity([1, 2, 3], maxCapacity: 5), true);
        expect(SugarValidators.listCapacity([1, 2, 3, 4, 5, 6], maxCapacity: 5),
            false);
        expect(
            SugarValidators.listCapacity([1, 2, 3]), true); // No capacity limit
      });
    });

    group('Error Reporting', () {
      test('error reporter logs errors correctly', () {
        SugarErrorReporter.clearErrors();

        SugarErrorReporter.logError('test_operation', 'test error message');

        expect(SugarErrorReporter.getErrorCount(), 1);
        expect(
            SugarErrorReporter.getErrors().first, contains('test_operation'));
        expect(SugarErrorReporter.getErrors().first,
            contains('test error message'));

        SugarErrorReporter.clearErrors();
        expect(SugarErrorReporter.getErrorCount(), 0);
      });
    });
  });
}

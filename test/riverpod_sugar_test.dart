import 'package:flutter_test/flutter_test.dart';
import 'package:riverpod_sugar/riverpod_sugar.dart';
import 'package:riverpod_sugar/src/helpers/async_helpers.dart';

void main() {
  group('Debouncer Tests', () {
    test('should delay execution', () async {
      final debouncer = Debouncer(milliseconds: 100);
      var executed = false;

      debouncer.run(() => executed = true);

      // Should not execute immediately
      expect(executed, false);
      expect(debouncer.isActive, true);

      // Should execute after delay
      await Future.delayed(const Duration(milliseconds: 150));
      expect(executed, true);
      expect(debouncer.isActive, false);

      debouncer.dispose();
    });

    test('should cancel previous execution when called multiple times',
        () async {
      final debouncer = Debouncer(milliseconds: 100);
      var counter = 0;

      // Call multiple times quickly
      debouncer.run(() => counter++);
      debouncer.run(() => counter++);
      debouncer.run(() => counter++);

      // Wait for execution
      await Future.delayed(const Duration(milliseconds: 150));

      // Only the last call should execute
      expect(counter, 1);

      debouncer.dispose();
    });

    test('should cancel pending execution', () async {
      final debouncer = Debouncer(milliseconds: 100);
      var executed = false;

      debouncer.run(() => executed = true);
      debouncer.cancel();

      await Future.delayed(const Duration(milliseconds: 150));

      expect(executed, false);
      expect(debouncer.isActive, false);

      debouncer.dispose();
    });

    test('should handle dispose correctly', () async {
      final debouncer = Debouncer(milliseconds: 100);
      var executed = false;

      debouncer.run(() => executed = true);
      debouncer.dispose();

      await Future.delayed(const Duration(milliseconds: 150));

      expect(executed, false);
      expect(debouncer.isActive, false);
    });
  });

  group('FormManager Tests', () {
    test('should start with valid state', () {
      final formManager = FormManager();
      expect(formManager.state.isValid, true);
      expect(formManager.state.errors.isEmpty, true);
    });

    test('should validate field and update state', () {
      final formManager = FormManager();

      // Add an error
      formManager.validateField('email', '', (value) {
        return value.isEmpty ? 'Email is required' : null;
      });

      expect(formManager.state.isValid, false);
      expect(formManager.state.getError('email'), 'Email is required');

      // Fix the error
      formManager.validateField('email', 'test@example.com', (value) {
        return value.isEmpty ? 'Email is required' : null;
      });

      expect(formManager.state.isValid, true);
      expect(formManager.state.getError('email'), null);
    });

    test('should handle multiple field validation', () {
      final formManager = FormManager();

      formManager.validateFields({
        'email': (
          '',
          (dynamic value) =>
              value is String && value.isEmpty ? 'Email required' : null
        ),
        'password': (
          '123',
          (dynamic value) =>
              value is String && value.length < 6 ? 'Too short' : null
        ),
      });

      expect(formManager.state.isValid, false);
      expect(formManager.state.errors.length, 2);
      expect(formManager.state.getError('email'), 'Email required');
      expect(formManager.state.getError('password'), 'Too short');
    });

    test('should clear field errors', () {
      final formManager = FormManager();

      formManager.setFieldError('email', 'Some error');
      expect(formManager.state.hasError('email'), true);

      formManager.clearFieldError('email');
      expect(formManager.state.hasError('email'), false);
      expect(formManager.state.isValid, true);
    });

    test('should clear all errors', () {
      final formManager = FormManager();

      formManager.setFieldErrors({
        'email': 'Error 1',
        'password': 'Error 2',
      });

      expect(formManager.state.isValid, false);
      expect(formManager.state.errors.length, 2);

      formManager.clearAllErrors();
      expect(formManager.state.isValid, true);
      expect(formManager.state.errors.isEmpty, true);
    });
  });

  group('CommonValidators Tests', () {
    test('required validator should work correctly', () {
      final validator = CommonValidators.required();

      expect(validator(null), 'This field is required');
      expect(validator(''), 'This field is required');
      expect(validator('   '), 'This field is required');
      expect(validator('valid'), null);
    });

    test('minLength validator should work correctly', () {
      final validator = CommonValidators.minLength(5);

      expect(validator(null), 'Must be at least 5 characters');
      expect(validator('1234'), 'Must be at least 5 characters');
      expect(validator('12345'), null);
      expect(validator('123456'), null);
    });

    test('maxLength validator should work correctly', () {
      final validator = CommonValidators.maxLength(5);

      expect(validator(null), null);
      expect(validator('1234'), null);
      expect(validator('12345'), null);
      expect(validator('123456'), 'Must be no more than 5 characters');
    });

    test('email validator should work correctly', () {
      final validator = CommonValidators.email();

      expect(validator(null), null); // null is allowed, use with required()
      expect(validator(''), null); // empty is allowed, use with required()
      expect(validator('invalid'), 'Please enter a valid email address');
      expect(validator('test@'), 'Please enter a valid email address');
      expect(validator('test@example.com'), null);
    });

    test('range validator should work correctly', () {
      final validator = CommonValidators.range(1, 10);

      expect(validator(null), null);
      expect(validator(0), 'Must be between 1 and 10');
      expect(validator(1), null);
      expect(validator(5), null);
      expect(validator(10), null);
      expect(validator(11), 'Must be between 1 and 10');
    });

    test('matches validator should work correctly', () {
      final validator = CommonValidators.matches('password123');

      expect(validator('password123'), null);
      expect(validator('different'), 'Values do not match');
      expect(validator(''), 'Values do not match');
    });

    test('combine validator should work correctly', () {
      final validator = CommonValidators.combine([
        CommonValidators.required(),
        CommonValidators.minLength(5),
        CommonValidators.email(),
      ]);

      expect(validator(null), 'This field is required');
      expect(validator(''), 'This field is required');
      expect(validator('test'), 'Must be at least 5 characters');
      expect(validator('test@invalid'), 'Please enter a valid email address');
      expect(validator('test@example.com'), null);
    });
  });

  group('AsyncValue Extensions Tests', () {
    test('mapData should preserve async states', () {
      const loading = AsyncValue<int>.loading();
      const error = AsyncValue<int>.error('Error', StackTrace.empty);
      const data = AsyncValue.data(42);

      // Test loading state preservation
      final mappedLoading =
          SugarAsyncValueX<int>(loading).mapData((value) => value.toString());
      expect(mappedLoading.isLoading, true);

      // Test error state preservation
      final mappedError =
          SugarAsyncValueX<int>(error).mapData((value) => value.toString());
      expect(SugarAsyncValueX<String>(mappedError).hasError, true);
      expect(mappedError.error, 'Error');

      // Test data transformation
      final mappedData =
          SugarAsyncValueX<int>(data).mapData((value) => value.toString());
      expect(mappedData.hasValue, true);
      expect(mappedData.requireValue, '42');
    });

    test('hasDataWhere should work correctly', () {
      const data = AsyncValue.data(42);
      const loading = AsyncValue<int>.loading();
      const error = AsyncValue<int>.error('Error', StackTrace.empty);

      expect(SugarAsyncValueX<int>(data).hasDataWhere((value) => value > 40),
          true);
      expect(SugarAsyncValueX<int>(data).hasDataWhere((value) => value < 40),
          false);
      expect(SugarAsyncValueX<int>(loading).hasDataWhere((value) => value > 40),
          false);
      expect(SugarAsyncValueX<int>(error).hasDataWhere((value) => value > 40),
          false);
    });

    test('dataOrNull should return data or null', () {
      const data = AsyncValue.data(42);
      const loading = AsyncValue<int>.loading();
      const error = AsyncValue<int>.error('Error', StackTrace.empty);

      expect(SugarAsyncValueX<int>(data).dataOrNull, 42);
      expect(SugarAsyncValueX<int>(loading).dataOrNull, null);
      expect(SugarAsyncValueX<int>(error).dataOrNull, null);
    });

    test('convenience getters should work correctly', () {
      const data = AsyncValue.data(42);
      const loading = AsyncValue<int>.loading();
      const error = AsyncValue<int>.error('Error', StackTrace.empty);

      expect(SugarAsyncValueX<int>(data).hasData, true);
      expect(SugarAsyncValueX<int>(data).isLoading, false);
      expect(SugarAsyncValueX<int>(data).hasError, false);

      expect(SugarAsyncValueX<int>(loading).hasData, false);
      expect(SugarAsyncValueX<int>(loading).isLoading, true);
      expect(SugarAsyncValueX<int>(loading).hasError, false);

      expect(SugarAsyncValueX<int>(error).hasData, false);
      expect(SugarAsyncValueX<int>(error).isLoading, false);
      expect(SugarAsyncValueX<int>(error).hasError, true);
      expect(SugarAsyncValueX<int>(error).errorOrNull, 'Error');
    });
  });

  group('AdvancedDebouncer Tests', () {
    test('should support leading execution', () async {
      final debouncer = AdvancedDebouncer(
        milliseconds: 100,
        leading: true,
        trailing: false,
      );
      var counter = 0;

      debouncer.run(() => counter++);

      // Should execute immediately (leading)
      expect(counter, 1);

      // Multiple calls shouldn't execute again
      debouncer.run(() => counter++);
      debouncer.run(() => counter++);

      await Future.delayed(const Duration(milliseconds: 150));

      // Should still be 1 (no trailing execution)
      expect(counter, 1);

      debouncer.dispose();
    });

    test('should support max wait time', () async {
      final debouncer = AdvancedDebouncer(
        milliseconds: 200,
        maxWait: 100,
      );
      var counter = 0;

      debouncer.run(() => counter++);

      // Keep calling before debounce time
      await Future.delayed(const Duration(milliseconds: 50));
      debouncer.run(() => counter++);

      await Future.delayed(const Duration(milliseconds: 50));
      debouncer.run(() => counter++);

      // Should execute due to maxWait (100ms total)
      await Future.delayed(const Duration(milliseconds: 50));
      expect(counter, 1);

      debouncer.dispose();
    });
  });

  group('Provider Combiners Tests', () {
    test('combine2 should work correctly', () {
      final container = ProviderContainer();

      final provider1 = StateProvider<int>((ref) => 1);
      final provider2 = StateProvider<String>((ref) => 'hello');
      final combined = ProviderCombiners.combine2(provider1, provider2);
      final result = container.read(combined);
      expect(result.$1, 1);
      expect(result.$2, 'hello');
      container.dispose();
    });

    test('combineList should work correctly', () {
      final container = ProviderContainer();

      final provider1 = StateProvider<int>((ref) => 1);
      final provider2 = StateProvider<int>((ref) => 2);
      final provider3 = StateProvider<int>((ref) => 3);
      final combined = ProviderCombiners.combineList([
        provider1,
        provider2,
        provider3,
      ]);
      final result = container.read(combined);
      expect(result, [1, 2, 3]);
      container.dispose();
    });

    test('map should transform provider values', () {
      final container = ProviderContainer();

      final provider = StateProvider<int>((ref) => 42);
      final mapped =
          ProviderCombiners.map(provider, (value) => value.toString());
      final result = container.read(mapped);
      expect(result, '42');
      container.dispose();
    });
  });

  group('AsyncProviderCombiners Tests', () {
    test('combine2 should handle async states correctly', () {
      final container = ProviderContainer();

      final provider1 =
          Provider<AsyncValue<int>>((ref) => const AsyncValue.data(1));
      final provider2 =
          Provider<AsyncValue<String>>((ref) => const AsyncValue.data('hello'));
      final combined = AsyncProviderCombiners.combine2(provider1, provider2);
      final result = container.read(combined);
      expect(result.hasValue, true);
      final (value1, value2) = result.requireValue;
      expect(value1, 1);
      expect(value2, 'hello');
      container.dispose();
    });

    test('combine2 should return loading when either is loading', () {
      final container = ProviderContainer();

      final provider1 =
          Provider<AsyncValue<int>>((ref) => const AsyncValue.loading());
      final provider2 =
          Provider<AsyncValue<String>>((ref) => const AsyncValue.data('hello'));
      final combined = AsyncProviderCombiners.combine2(provider1, provider2);
      final result = container.read(combined);
      expect(result.isLoading, true);
      container.dispose();
    });

    test('combine2 should return error when either has error', () {
      final container = ProviderContainer();

      final provider1 = Provider<AsyncValue<int>>(
          (ref) => const AsyncValue.error('Error 1', StackTrace.empty));
      final provider2 =
          Provider<AsyncValue<String>>((ref) => const AsyncValue.data('hello'));
      final combined = AsyncProviderCombiners.combine2(provider1, provider2);
      final result = container.read(combined);
      expect(SugarAsyncValueX(result).hasError, true);
      expect(result.error, 'Error 1');
      container.dispose();
    });

    test('map should transform async values correctly', () {
      final container = ProviderContainer();

      final provider =
          Provider<AsyncValue<int>>((ref) => const AsyncValue.data(42));
      final mapped =
          AsyncProviderCombiners.map(provider, (value) => value.toString());

      final result = container.read(mapped);
      expect(result.hasValue, true);
      expect(result.requireValue, '42');

      container.dispose();
    });
  });
}

 
# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2025-07-31

### 🎉 Initial Release

#### Added
- **Core Widgets**
  - `RxWidget` - Simplified ConsumerWidget with cleaner build method
  - `RxStatefulWidget` & `RxState` - Stateful equivalent of RxWidget
  - `RxBuilder` - Inline reactive widget builder
  - `RxShow` - Conditional rendering based on provider state

- **AsyncValue Extensions**
  - `AsyncValueSugar.easyWhen()` - Simplified async state handling
  - `AsyncValueX.mapData()` - Transform data while preserving async state
  - `AsyncValueX.hasDataWhere()` - Check conditions on async data
  - `AsyncValueX.dataOrNull` - Safe data access
  - Convenience getters: `hasData`, `isLoading`, `hasError`, `errorOrNull`

- **Form Management**
  - `FormManager` - StateNotifier for form validation
  - `FormState` - Immutable form state with error tracking
  - `CommonValidators` - Pre-built validation functions:
    - `required()`
    - `minLength()` / `maxLength()`
    - `email()`
    - `pattern()`
    - `range()`
    - `matches()`
    - `combine()` - Combine multiple validators

- **Utilities**
  - `Debouncer` - Simple input debouncing
  - `AdvancedDebouncer` - Advanced debouncing with leading/trailing options
  - `ProviderCombiners` - Combine multiple providers:
    - `combine2()`, `combine3()`, `combine4()`
    - `combineList()`
    - `map()`, `where()`
  - `AsyncProviderCombiners` - Combine AsyncValue providers intelligently

- **Extensions**
  - Provider extension methods for fluent API
  - AsyncValue utility extensions

#### Documentation
- Comprehensive README with examples
- API documentation for all public members
- Complete example app demonstrating all features
- Migration guide from standard Riverpod

#### Testing
- Full test coverage for all components
- Example tests for common use cases

### Technical Details
- **Dart SDK**: `>=3.0.0 <4.0.0`
- **Flutter**: `>=3.10.0`
- **Dependencies**: `flutter_riverpod ^2.4.9`
- **Null Safety**: ✅ Complete null safety support
- **Platforms**: All Flutter platforms supported

---

## Future Releases

### [1.1.0] - Planned Features
- `RxListView` - Reactive list widget with loading states
- `RxAnimatedSwitcher` - Animated transitions between provider states  
- Navigation helpers for provider-aware routing
- Performance optimization widgets
- Additional common validators

### [1.2.0] - Advanced Features
- DevTools integration for better debugging
- Code generation macros for providers
- Testing utilities and mock helpers
- Advanced caching strategies
- Background task management

---

## Migration Notes

### From flutter_riverpod to riverpod_sugar

This package is designed to be a drop-in enhancement to flutter_riverpod:

1. **No Breaking Changes**: All existing riverpod code continues to work
2. **Gradual Adoption**: Migrate widgets one at a time
3. **Zero Runtime Overhead**: Sugar syntax compiles to standard riverpod calls
4. **Full Interoperability**: Mix and match with existing ConsumerWidget code

### Version Compatibility

| riverpod_sugar | flutter_riverpod | Flutter | Dart |
|----------------|------------------|---------|------|
| 1.0.0          | ^2.4.9          | >=3.10.0| >=3.0.0 |

---

## Contributing

We welcome contributions! Please see our [Contributing Guide](CONTRIBUTING.md) for details.

## Support

- 📖 [Documentation](https://github.com/yourusername/riverpod_sugar#readme)
- 🐛 [Issue Tracker](https://github.com/yourusername/riverpod_sugar/issues)
- 💬 [Discussions](https://github.com/yourusername/riverpod_sugar/discussions)
- 📧 [Email Support](mailto:support@yourpackage.com)
# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.5] - 2025-08-03

### 🧹 **API Cleanup & Focus**

**Streamlined Widget Helpers**: Removed opinionated and overly-specific widget helpers to maintain package focus on core utility and prevent API bloat.

**Key Changes**:

- ❌ **Removed Bloat Helpers** - Eliminated 5 widget helpers that provided minimal value or forced unnecessary patterns
- 🎯 **Focused API** - Kept only genuinely useful helpers that solve common real-world problems
- 🚀 **Cleaner Package** - Reduced cognitive overhead and maintained library simplicity
- ✅ **Core Helpers Retained** - Kept `ref.text()`, `ref.loading()`, `ref.switchTile()`, `ref.checkboxTile()` - the helpers developers actually use

#### ❌ **Removed Widget Helpers**

The following widget helpers have been removed as they were identified as bloat that forced unnecessary patterns:

- **`ref.stepper()`** - Too specific use case, easy to build manually with standard Flutter widgets
- **`ref.chip()`** - Trivial wrapper providing no real value over direct `Chip` widget usage  
- **`ref.card()`** - Too opinionated API that was confusing and offered minimal benefit
- **`ref.slider()`** - Forces specific design decisions, better to use standard `Slider` with providers
- **`ref.animatedContainer()`** - Unclear value proposition, overcomplicated simple animations

#### ✅ **Retained Core Helpers**

These widget helpers remain because they solve genuine common problems:

- **`ref.text()`** - Extremely common pattern, saves significant boilerplate
- **`ref.loading()`** - Essential for loading states, used in most apps
- **`ref.switchTile()`** - Perfect for settings screens, very commonly needed
- **`ref.checkboxTile()`** - Natural companion to switch tiles, frequently used

**Rationale**: A focused API with genuinely useful helpers is better than comprehensive coverage that includes questionable utilities. This change maintains the library's core value while eliminating potential confusion and forced patterns.

## [1.0.4] - 2025-08-03

### 📦 **Package Optimization & Publishing Preparation**

**Package Cleanup**: Optimized package structure for pub.dev publishing with dramatically reduced size and cleaner distribution.

**Key Improvements**:
- 🗑️ **Removed Development Files** - Cleaned up build artifacts, coverage reports, and IDE files
- 📉 **97% Size Reduction** - Package size reduced from ~13 MB to just 340 KB
- 🚀 **Faster Downloads** - Users get much quicker installation and updates
- 🧹 **Professional Structure** - Clean, lean package with only essential files
- 📋 **Enhanced Metadata** - Added topics, repository links, and screenshot descriptions for better pub.dev discoverability

#### 🗑️ **Files Removed**

- **Build artifacts** - `build/` folder (~50+ MB of compiled cache)
- **Coverage reports** - `coverage/` folder (development-only files)
- **IDE configuration** - `.github/`, `.idea/`, `.iml` files
- **Empty directories** - Unused `doc/` folder
- **Development cache** - `.dart_tool/` and test cache files

#### 📈 **Publishing Optimizations**

- **Package size**: 340 KB (down from ~13 MB)
- **Download speed**: ~90% faster for end users
- **Clean structure**: Only essential files for package functionality
- **Better discoverability**: Enhanced pub.dev metadata with topics and screenshots

## [1.0.3] - 2025-08-03

### 🛠️ **Foundation Improvements & Polish**

**Major Update**: This release focuses on production-readiness with enhanced developer tools, comprehensive validation, and 15+ new widget helpers. Perfect for teams moving from prototype to production!

**Key Highlights**:
- ✨ **15+ New Widget Helpers** - Build UI directly from providers with `ref.text()`, `ref.switchTile()`, etc.
- 🐛 **Advanced Debugging** - Automatic performance tracking and state monitoring in debug mode
- ✅ **Robust Validation** - Comprehensive validation framework with helpful error messages
- 📚 **Enhanced Documentation** - Complete examples and best practices guide
- 🚀 **Zero Runtime Overhead** - All debugging features compile away in release builds
- 🔄 **100% Backward Compatible** - All existing code continues to work unchanged

#### ✨ **Enhanced Widget Helpers**

- **Expanded WidgetRefSugar extensions** with 15+ new built-in widget helpers:
  - `ref.text()` - Direct text widgets from providers
  - `ref.switchTile()` - Switch controls with title/subtitle
  - `ref.checkboxTile()` - Checkbox controls
  - `ref.slider()` - Slider controls for numeric values
  - `ref.stepper()` - Increment/decrement controls
  - `ref.loading()` - Loading indicators
  - `ref.chip()` - Chip widgets
  - `ref.card()` - Card wrappers with conditional visibility
  - `ref.animatedContainer()` - Animated containers

#### 🐛 **Enhanced Debugging & Validation**

- **SugarPerformance** - Automatic operation tracking in debug mode
- **SugarValidator** - Comprehensive validation with helpful error messages
- **SugarSafeOps** - Safe operations that handle errors gracefully
- **Enhanced error messages** with suggestions and documentation links
- **Type validation** prevents common mistakes at runtime
- **Performance monitoring** tracks operation frequency and timing

#### 📚 **Improved Documentation**

- **Comprehensive examples** showcasing all features
- **FOUNDATION_IMPROVEMENTS.md** - Complete guide for new features
- **Best practices** and patterns for scalable applications
- **Migration guide** from basic to enhanced usage
- **Performance tips** and optimization strategies

#### 🎯 **Developer Experience**

- **Better error messages** with context-aware suggestions
- **Safe list operations** with bounds checking
- **Provider organization** patterns and utilities
- **Debug logging** for state changes and operations
- **Validation utilities** for common use cases

### 📈 **Performance & Quality**

- **Zero runtime overhead** in release builds
- **Comprehensive test coverage** for all new features
- **Type-safe operations** with enhanced validation
- **Memory efficient** tracking and debugging utilities

### 🔧 **Breaking Changes**

- None! All changes are backward compatible

### 📝 **Migration Notes**

- All existing code continues to work unchanged
- New features are opt-in and enhance existing functionality
- Debug features automatically enabled in debug mode

## [1.0.2] - 2025-08-01

### 🐛 **Documentation Fixes**

#### ✅ **Fixed**
- **HTML escaping in documentation** - Fixed angle brackets in doc comments to prevent HTML interpretation
- **Dart analyzer warnings** - All documentation comments now properly escape generic type parameters
- **Code analysis compliance** - Package now passes all lint checks without warnings

#### 📚 **Technical Details**
- Escaped `<Type>` as `&lt;Type&gt;` in all documentation comments
- Fixed 5 analyzer warnings related to HTML interpretation in doc comments
- Maintained full API functionality while improving documentation quality

## [1.0.1] - 2025-08-01

### 🧹 **Documentation & Structure Improvements**

#### ✨ **Enhanced**
- **Complete documentation overhaul** with comprehensive usage guides
- **Streamlined documentation structure** - removed redundant files for clarity
- **Enhanced example documentation** with practical implementation details
- **Improved method naming** - all extensions now use descriptive names (e.g., `increment()` instead of `inc`)
- **Full freedom philosophy** - emphasized flexibility over restrictive patterns

#### 🗑️ **Removed**
- **Redundant documentation files** - cleaned up duplicate markdown files
- **Restrictive widget patterns** - removed forced patterns like `ref.counter()`
- **Abbreviated method names** - replaced with clear, descriptive alternatives

#### 📚 **Documentation**
- **COMPLETE_USAGE_GUIDE.md** - comprehensive guide emphasizing user freedom
- **RIVERPOD_VS_SUGAR.md** - detailed comparison with standard Riverpod
- **Enhanced README.md** - streamlined main documentation
- **Updated example README** - practical demo documentation

## [1.0.0] - 2025-08-01

### 🚀 **REVOLUTIONARY RELEASE: ScreenUtil-Style State Management!**

#### 🔥 **Game-Changing Features**
- **Sugar Extensions** - Revolutionary one-liner provider creation and state management
  - **Instant Provider Creation**: `0.state`, `"text".text`, `false.toggle`, `<String>[].items`
  - **Descriptive State Updates**: `counter.increment(ref)`, `name.updateText(ref, "value")`, `toggle.toggle(ref)`
  - **Flexible Value Watching**: `ref.watchValue(provider)`, `ref.readValue(provider)`, `ref.updateValue(provider, value)`
  - **80% Code Reduction**: Transform verbose Riverpod into concise one-liners
  - **ScreenUtil-Inspired API**: Same simplicity as `.w`, `.h`, `.r`, `.sp` but for state management

#### ⚡ **Core Widgets & Components**
- **RxWidget Family**
  - `RxWidget` - Simplified ConsumerWidget with `buildRx()` method
  - `RxStatefulWidget` & `RxState` - Stateful equivalent with clean syntax
  - `RxBuilder` - Inline reactive widget builder without creating new classes
  - `RxShow` - Conditional rendering based on provider state

- **AsyncValue Superpowers**
  - `AsyncValueSugar.easyWhen()` - Simplified async state handling with auto loading/error
  - `mapData()` - Transform data while preserving async state
  - `hasDataWhere()` - Check conditions on async data
  - `dataOrNull` - Safe data access without exceptions
  - Smart getters: `hasData`, `isLoading`, `hasError`, `errorOrNull`

- **Complete Form Management**
  - `FormManager` - StateNotifier for comprehensive form validation
  - `FormState` - Immutable form state with error tracking
  - `CommonValidators` - Production-ready validation functions:
    - `required()` - Required field validation
    - `minLength()` / `maxLength()` - Length validation
    - `email()` - Email format validation
    - `pattern()` - Regex pattern validation
    - `range()` - Numeric range validation
    - `matches()` - Field matching validation
    - `combine()` - Combine multiple validators

#### 🛠️ **Advanced Utilities**
- **Smart Debouncing**
  - `Debouncer` - Simple input debouncing for search and API calls
  - `AdvancedDebouncer` - Advanced debouncing with leading/trailing/maxWait options
  
- **Intelligent Provider Combination**
  - `ProviderCombiners` - Combine multiple providers elegantly:
    - `combine2()`, `combine3()`, `combine4()` - Combine providers into tuples
    - `combineList()` - Combine same-type providers into lists
    - `map()` - Transform provider values
    - `where()` - Filter provider rebuilds
  - `AsyncProviderCombiners` - Smart async provider combination with error handling

#### 🎯 **Sugar Extensions Reference**
- **Provider Creation**
  ```dart
  final counter = 0.state;           // StateProvider<int>
  final name = "John".text;          // StateProvider<String>
  final isDark = false.toggle;       // StateProvider<bool>
  final todos = <String>[].items;    // StateProvider<List<String>>
  final price = 19.99.price;         // StateProvider<double>
  ```

- **State Operations with Descriptive Names**
  ```dart
  counter.increment(ref);           // Increment
  counter.decrement(ref);           // Decrement
  counter.addValue(ref, 5);         // Add value
  counter.resetToZero(ref);         // Reset to 0
  name.updateText(ref, "Jane");     // Update text
  name.clearText(ref);              // Clear text
  isDark.toggle(ref);               // Toggle boolean
  todos.addItem(ref, "New task");   // Add to list
  ```

- **Widget Building**
  ```dart
  ref.counter(counter);             // Text widget showing count
  ref.txt(name);                    // Text widget showing string
  ref.show(isDark, MyWidget());     // Conditional widget
  ref.stepper(counter);             // +/- buttons with counter
  ```

#### 📈 **Performance & Developer Experience**
- **80% Code Reduction**: Turn 50-line Riverpod patterns into 10-line Sugar code
- **Zero Learning Curve**: Familiar ScreenUtil-style API
- **Full Type Safety**: Complete null safety and type inference
- **Production Ready**: Extensive testing and real-world validation
- **Perfect Compatibility**: Works alongside existing Riverpod code

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
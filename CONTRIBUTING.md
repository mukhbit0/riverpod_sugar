 
# Contributing to Riverpod Sugar 🍯

First off, thank you for considering contributing to Riverpod Sugar! It's people like you that make this package better for the entire Flutter community.

## 🎯 How Can You Contribute?

### 🐛 Reporting Bugs
- Use the [GitHub issue tracker](https://github.com/mukhbit0/riverpod_sugar/issues)
- Check if the issue already exists before creating a new one
- Include reproduction steps, expected behavior, and actual behavior
- Provide Flutter/Dart version information

### 💡 Suggesting Features
- Open a [GitHub discussion](https://github.com/mukhbit0/riverpod_sugar/discussions) first
- Describe the use case and why it would be valuable
- Consider backward compatibility and API consistency

### 📝 Improving Documentation
- Fix typos, clarify explanations, add examples
- Documentation is in the README.md and code comments
- Examples in the `/example` folder are also documentation

### 🧪 Writing Tests
- All new features should have corresponding tests
- Run `flutter test` to ensure all tests pass
- Aim for high test coverage

### 💻 Code Contributions
- Follow the guidelines below for code style and structure
- Ensure all tests pass and add new tests for new features
- Update documentation as needed

## 🚀 Getting Started

### Development Setup

1. **Fork and Clone**
   ```bash
   git clone https://github.com/mukhbit0/riverpod_sugar.git
   cd riverpod_sugar
   ```

2. **Install Dependencies**
   ```bash
   flutter pub get
   cd example && flutter pub get
   ```

3. **Run Tests**
   ```bash
   flutter test
   ```

4. **Run Example App**
   ```bash
   cd example && flutter run
   ```

### Project Structure

```
riverpod_sugar/
├── lib/
│   ├── src/
│   │   ├── core/          # Core widgets (RxWidget, RxBuilder)
│   │   ├── helpers/       # Helper classes (AsyncValue extensions, FormManager)
│   │   └── utils/         # Utilities (Debouncer, ProviderCombiners)
│   └── riverpod_sugar.dart # Main export file
├── test/                  # Test files
├── example/               # Example application
├── README.md             # Main documentation
├── CHANGELOG.md          # Version history
└── pubspec.yaml          # Package configuration
```

## 📋 Coding Standards

### Dart Style Guide
- Follow the [official Dart style guide](https://dart.dev/guides/language/effective-dart/style)
- Use `flutter analyze` to check for style issues
- All code should pass the linter rules in `analysis_options.yaml`

### Documentation Requirements
- **All public APIs must have documentation comments**
- Use `///` for documentation comments
- Include examples in documentation where helpful
- Document parameters, return values, and exceptions

```dart
/// A simple debouncer to delay the execution of a function.
///
/// Useful for scenarios like search input fields where you want to wait for
/// the user to stop typing before performing an expensive operation.
///
/// ## Example:
/// ```dart
/// final debouncer = Debouncer(milliseconds: 300);
/// onChanged: (value) => debouncer.run(() => search(value));
/// ```
class Debouncer {
  /// Creates a debouncer with the specified [milliseconds] delay.
  Debouncer({required this.milliseconds});
}
```

### Code Organization
- Keep files focused on a single concern
- Use meaningful names for classes, methods, and variables
- Group related functionality together
- Export public APIs through the main library file

### Testing Requirements
- **All new features must include tests**
- Test both success and error cases
- Use descriptive test names
- Group related tests using `group()`

```dart
group('Debouncer Tests', () {
  test('should delay execution', () async {
    // Test implementation
  });
  
  test('should cancel previous execution', () async {
    // Test implementation
  });
});
```

## 🔄 Pull Request Process

### Before Submitting
1. **Create a feature branch** from `main`
2. **Write/update tests** for your changes
3. **Update documentation** if needed
4. **Run the full test suite**: `flutter test`
5. **Check code formatting**: `dart format .`
6. **Run static analysis**: `flutter analyze`

### PR Guidelines
- **Clear title and description** explaining what and why
- **Reference related issues** using `Fixes #123` or `Closes #123`
- **Keep PRs focused** - one feature/fix per PR
- **Include tests** for new functionality
- **Update CHANGELOG.md** for user-facing changes

### PR Template
```markdown
## Description
Brief description of changes and motivation.

## Type of Change
- [ ] Bug fix (non-breaking change which fixes an issue)
- [ ] New feature (non-breaking change which adds functionality)
- [ ] Breaking change (fix or feature that would cause existing functionality to not work as expected)
- [ ] Documentation update

## Testing
- [ ] I have added tests that prove my fix is effective or that my feature works
- [ ] New and existing unit tests pass locally with my changes

## Checklist
- [ ] My code follows the style guidelines of this project
- [ ] I have performed a self-review of my own code
- [ ] I have commented my code, particularly in hard-to-understand areas
- [ ] I have made corresponding changes to the documentation
- [ ] My changes generate no new warnings
```

## 🏗️ Architecture Guidelines

### Design Principles
1. **Simplicity**: Keep APIs simple and intuitive
2. **Consistency**: Follow existing patterns and naming conventions
3. **Performance**: Don't introduce unnecessary overhead
4. **Compatibility**: Maintain backward compatibility
5. **Interoperability**: Work seamlessly with existing Riverpod code

### API Design
- Use clear, descriptive names
- Provide sensible defaults
- Make common use cases easy
- Allow customization for advanced use cases
- Follow Flutter/Dart naming conventions

### Adding New Features

When adding new features, consider:

1. **Does it solve a real problem?** - Features should address common pain points
2. **Is it consistent with existing APIs?** - Follow established patterns
3. **Does it maintain backward compatibility?** - Don't break existing code
4. **Is it well-tested?** - Include comprehensive tests
5. **Is it documented?** - Provide clear documentation and examples

## 🤝 Community Guidelines

### Code of Conduct
- Be respectful and inclusive
- Welcome newcomers and help them learn
- Focus on constructive feedback
- Celebrate diverse perspectives and experiences

### Communication
- Use clear, professional language
- Be patient with questions and discussions
- Provide helpful, actionable feedback
- Acknowledge contributions from others

## 🏷️ Versioning

We use [Semantic Versioning](https://semver.org/):
- **MAJOR**: Breaking changes
- **MINOR**: New features (backward compatible)
- **PATCH**: Bug fixes (backward compatible)

## 📋 Issue Labels

We use these labels to organize issues:
- `bug` - Something isn't working
- `enhancement` - New feature or request
- `documentation` - Improvements or additions to docs
- `good first issue` - Good for newcomers
- `help wanted` - Extra attention is needed
- `question` - Further information is requested

## 🎉 Recognition

Contributors will be:
- Listed in the README.md contributors section
- Mentioned in release notes for significant contributions
- Invited to join the maintainer team for consistent contributors

## 📞 Getting Help

If you need help:
- 📖 Check the [documentation](README.md)
- 💬 Start a [discussion](https://github.com/mukhbit0/riverpod_sugar/discussions)
- 🐛 [Open an issue](https://github.com/mukhbit0/riverpod_sugar/issues)
- 📧 Email us at [mukhbit000@gmail.com](mailto:mukhbit000@gmail.com)

Thank you for contributing to Riverpod Sugar! 🙏

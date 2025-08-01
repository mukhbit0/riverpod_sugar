# 🍯 Riverpod Sugar Example

A comprehensive example app demonstrating the power and simplicity of Riverpod Sugar extensions.

## 🚀 What's Demonstrated

This example showcases:

- **ScreenUtil-style provider creation** - `0.state`, `"text".text`, `false.toggle`
- **One-line state operations** - `increment()`, `updateText()`, `addValue()`
- **Flexible reactive widgets** - `RxWidget`, `RxBuilder`
- **Enhanced value watching** - `ref.watchValue()`, `ref.readValue()`
- **Simplified async handling** - `easyWhen()` for AsyncValue
- **Form management** - Built-in validation
- **Real-world patterns** - Complete app examples

## 🏃‍♂️ Quick Start

```bash
cd example
flutter pub get
flutter run
```

## 📱 Features in the Demo

### 1. **Sugar Counter** - Basic state management
- Provider creation: `final counter = 0.state;`
- Operations: `counter.increment(ref)`, `counter.addValue(ref, 10)`
- Flexible UI: Use values anywhere in your custom widgets

### 2. **Text Manager** - String state operations  
- Creation: `final message = "Hello".text;`
- Operations: `updateText()`, `appendText()`, `clearText()`

### 3. **Todo List** - List state management
- Creation: `final todos = <String>[].items;`
- Operations: `addItem()`, `removeAt()`, `clearAll()`

### 4. **Theme Toggle** - Boolean state
- Creation: `final isDark = false.toggle;`
- Operations: `toggle()`, `setTrue()`, `setFalse()`

### 5. **Async Data** - AsyncValue handling
- Simplified with `easyWhen()`
- Custom loading and error states

## 🎯 Key Takeaway

Notice how **you have complete freedom** to design your UI however you want while Riverpod Sugar handles the state management complexity. No forced widget patterns - just pure flexibility!

## 📚 Learn More

- [Complete Usage Guide](../COMPLETE_USAGE_GUIDE.md)
- [Riverpod vs Sugar Comparison](../RIVERPOD_VS_SUGAR.md)
- [Main Package Documentation](../README.md)

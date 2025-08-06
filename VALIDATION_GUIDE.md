## 🔥 **Ultra-Simple Validation - Three Ways!**

Riverpod Sugar now offers **3 levels** of validation complexity, so you can choose based on your needs:

### **1. 📱 Ultra-Short (2 words only!)**
```dart
// Predefined validations - shortest possible!
final email = "".emailState;        // Just 2 words!
final password = "".passwordState;  // Just 2 words!
final age = 0.ageState;             // Just 2 words!

// Usage
email.set(ref, "user@example.com");
final error = email.errorMessage(ref); // null = valid, string = error
final isValid = email.isValid(ref);     // true/false
```

### **2. 🎯 Custom Fluent (Chainable)**
```dart
// Custom validation with fluent API
final customEmail = "".validationBuilder
    .contains('@')(null, 'Must contain @ symbol');

final strongPassword = "".validationBuilder
    .minLength(8)(null, 'Password must be at least 8 characters');

final adultAge = 0.validationBuilder
    .min(18)(null, 'Must be 18 or older');

// Multiple conditions
final complexPassword = "".validationBuilder
    .minLength(8)
    .contains('!')
    .matches(RegExp(r'[A-Z]'))(null, 'Need 8+ chars, !, and uppercase');
```

### **3. 🔧 Full Custom (Maximum flexibility)**
```dart
// Write your own validation logic
final customField = "".validState((value) {
  if (value.isEmpty) return 'Required';
  if (value.length < 3) return 'Too short';
  if (!value.contains('@')) return 'Must have @';
  return null; // Valid!
});
```

## **Why This Is Perfect:**

### **✅ No Bloat:**
- Uses existing StateProvider pattern
- Zero additional dependencies
- Minimal code footprint

### **✅ No Ambiguity:**
- Clear method names: `.emailState`, `.isValid(ref)`, `.errorMessage(ref)`
- Predictable behavior: Set → Auto-validate → Get result
- Three distinct approaches for different needs

### **✅ Developer Choice:**
- **Beginners**: Use ultra-short `.emailState`
- **Power users**: Use fluent `.validationBuilder.contains('@')`
- **Custom needs**: Use `.validState((value) => ...)`

### **✅ Perfect Integration:**
- Works seamlessly with your existing `.state` pattern
- Same API: `.set(ref, value)`, `.read(ref)`, `.watch(ref)`
- Automatic validation on every state change

## **Usage in UI:**
```dart
TextField(
  onChanged: (value) => email.set(ref, value), // Auto-validates!
  decoration: InputDecoration(
    errorText: email.errorMessage(ref),         // One liner!
  ),
)

ElevatedButton(
  onPressed: email.isValid(ref) ? submit : null, // Auto-disable!
  child: Text('Submit'),
)
```

**Result**: From complex FormManager setup → to **2-word validation**! 🔥

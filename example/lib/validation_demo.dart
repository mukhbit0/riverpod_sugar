import 'package:flutter/material.dart';
import 'package:riverpod_sugar/riverpod_sugar.dart';

/// Demonstrates the ultra-simple validation syntax
class ValidationDemo extends RxWidget {
  // 🔥 ULTRA-SHORT validated providers (shortest possible!)
  static final email = "".emailState; // Just 2 words!
  static final password = "".passwordState; // Just 2 words!
  static final age = 0.ageState; // Just 2 words!

  // 🎯 CUSTOM fluent validation (for power users!)
  static final customEmail =
      "".validationBuilder.contains('@')(null, 'Must contain @ symbol');

  static final strongPassword = "".validationBuilder.minLength(8)(
      null, 'Password must be at least 8 characters');

  static final adultAge =
      0.validationBuilder.min(18)(null, 'Must be 18 or older');

  const ValidationDemo({super.key});

  @override
  Widget buildRx(BuildContext context, WidgetRef ref) {
    // Check if all fields are valid
    final isFormValid =
        email.isValid(ref) && password.isValid(ref) && age.isValid(ref);

    // Check custom validation example
    final isCustomValid = customEmail.isValid(ref) &&
        strongPassword.isValid(ref) &&
        adultAge.isValid(ref);

    return Scaffold(
      appBar: AppBar(title: const Text('🔥 Ultra-Simple Validation')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('📱 ULTRA-SHORT Syntax',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),

            // Email field
            TextField(
              onChanged: (value) => email.set(ref, value),
              decoration: InputDecoration(
                labelText: 'Email',
                errorText: email.errorMessage(ref), // One liner!
                border: const OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 16),

            // Password field
            TextField(
              onChanged: (value) => password.set(ref, value),
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
                errorText: password.errorMessage(ref), // One liner!
                border: const OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 16),

            // Age field
            TextField(
              onChanged: (value) => age.set(ref, int.tryParse(value) ?? 0),
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Age',
                errorText: age.errorMessage(ref), // One liner!
                border: const OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 24),

            const Text('🎯 CUSTOM Fluent Syntax',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),

            // Custom email field
            TextField(
              onChanged: (value) => customEmail.set(ref, value),
              decoration: InputDecoration(
                labelText: 'Custom Email (requires @)',
                errorText: customEmail.errorMessage(ref),
                border: const OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 16),

            // Strong password field
            TextField(
              onChanged: (value) => strongPassword.set(ref, value),
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Strong Password (8+ chars)',
                errorText: strongPassword.errorMessage(ref),
                border: const OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 16),

            // Adult age field
            TextField(
              onChanged: (value) => adultAge.set(ref, int.tryParse(value) ?? 0),
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Adult Age (18+)',
                errorText: adultAge.errorMessage(ref),
                border: const OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 24),

            // Status display for both validation types
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isFormValid
                          ? Colors.green.shade50
                          : Colors.red.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isFormValid ? Colors.green : Colors.red,
                      ),
                    ),
                    child: Column(
                      children: [
                        Icon(
                          isFormValid ? Icons.check_circle : Icons.error,
                          color: isFormValid ? Colors.green : Colors.red,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Ultra-Short\n${isFormValid ? 'Valid' : 'Invalid'}',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: isFormValid ? Colors.green : Colors.red,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isCustomValid
                          ? Colors.purple.shade50
                          : Colors.orange.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isCustomValid ? Colors.purple : Colors.orange,
                      ),
                    ),
                    child: Column(
                      children: [
                        Icon(
                          isCustomValid ? Icons.check_circle : Icons.error,
                          color: isCustomValid ? Colors.purple : Colors.orange,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Custom Fluent\n${isCustomValid ? 'Valid' : 'Invalid'}',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color:
                                isCustomValid ? Colors.purple : Colors.orange,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Submit buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: isFormValid
                        ? () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Ultra-Short Form submitted!\n'
                                  'Email: ${email.read(ref)}\n'
                                  'Age: ${age.read(ref)}',
                                ),
                              ),
                            );
                          }
                        : null,
                    child: const Text('Submit Ultra-Short'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: isCustomValid
                        ? () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Custom Form submitted!\n'
                                  'Email: ${customEmail.read(ref)}\n'
                                  'Age: ${adultAge.read(ref)}',
                                ),
                              ),
                            );
                          }
                        : null,
                    child: const Text('Submit Custom'),
                  ),
                ),
              ],
            ),

            const Spacer(),

            // Code example
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('💡 Ultra-Short Code Examples:',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Text('final email = "".emailState;        // Just 2 words!'),
                  Text('final password = "".passwordState;  // Just 2 words!'),
                  Text('final age = 0.ageState;             // Just 2 words!'),
                  SizedBox(height: 8),
                  Text('🎯 Custom Fluent Examples:',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.purple)),
                  Text(
                      '"".validationBuilder.contains("@")(null, "Must have @");'),
                  Text('"".validationBuilder.minLength(8)(null, "Too short");'),
                  Text('0.validationBuilder.min(18)(null, "Must be 18+");'),
                  SizedBox(height: 8),
                  Text('🔥 Or custom validation:',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.orange)),
                  Text(
                      'final custom = "".validState((v) => v.length > 3 ? null : "Too short");'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

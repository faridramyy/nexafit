import 'package:flutter/material.dart';
import 'package:nexafit/services/gemini_service.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class MealsScreen extends StatefulWidget {
  const MealsScreen({super.key});

  @override
  State<MealsScreen> createState() => _MealsScreenState();
}

class _MealsScreenState extends State<MealsScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedMealType;
  final _caloriesController = TextEditingController();
  String? _selectedCountry;
  String? _selectedPriority;
  final _additionalNotesController = TextEditingController();
  String? _generatedMeal;
  bool _isLoading = false;

  final List<String> _mealTypes = ['Breakfast', 'Lunch', 'Dinner'];
  final List<String> _priorities = [
    'Filling Meal',
    'High Protein',
    'No Carb',
    'Balanced',
  ];
  final List<String> _countries = [
    'United States',
    'United Kingdom',
    'Italy',
    'Japan',
    'India',
    'Mexico',
    'France',
    'China',
    'Thailand',
    'Greece',
    'Other',
  ];

  @override
  void dispose() {
    _caloriesController.dispose();
    _additionalNotesController.dispose();
    super.dispose();
  }

  void _clearForm() {
    setState(() {
      _selectedMealType = null;
      _caloriesController.clear();
      _selectedCountry = null;
      _selectedPriority = null;
      _additionalNotesController.clear();
      _generatedMeal = null;
    });
    _formKey.currentState?.reset();
  }

  Future<void> _generateMeal() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final prompt = '''
You are a fitness expert. Generate a meal plan with the following specifications:
- Meal Type: $_selectedMealType
- Target Calories: ${_caloriesController.text}
- Country Preference: $_selectedCountry
- Dietary Priority: $_selectedPriority
- Additional Notes: ${_additionalNotesController.text}

Format your response using markdown for better readability. Use:
- Headers (# for main headers, ## for subheaders)
- Lists (both ordered and unordered)
- Bold and italic text for emphasis
- Code blocks for specific instructions or measurements
- Blockquotes for important tips or warnings

Structure your response as follows:

# Meal Plan

## Main Dish
[Name of the main dish with a brief description]

## Ingredients
- [List of ingredients with quantities]
- [Use bullet points for ingredients]

## Instructions
1. [Step by step instructions]
2. [Use numbered list for steps]

## Nutritional Information
- **Calories**: [Total calories]
- **Protein**: [g]
- **Carbs**: [g]
- **Fat**: [g]

## Tips
> [Important cooking tips or notes]
> [Use blockquotes for tips]

Make sure to:
1. Use ingredients commonly available in $_selectedCountry
2. Focus on $_selectedPriority requirements
3. Keep the total calories close to ${_caloriesController.text}
4. Consider any dietary restrictions mentioned in the notes
''';

      final response = await GeminiService.getResponse(prompt);
      setState(() {
        _generatedMeal = response;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error generating meal: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meal Generator'),
        actions: [
          IconButton(
            icon: const Icon(Icons.clear_all),
            onPressed: _clearForm,
            tooltip: 'Clear Form',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Meal Type Dropdown
              DropdownButtonFormField<String>(
                value: _selectedMealType,
                decoration: const InputDecoration(
                  labelText: 'Meal Type',
                  border: OutlineInputBorder(),
                ),
                items:
                    _mealTypes.map((type) {
                      return DropdownMenuItem(value: type, child: Text(type));
                    }).toList(),
                onChanged: (value) {
                  setState(() => _selectedMealType = value);
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a meal type';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Calories Input
              TextFormField(
                controller: _caloriesController,
                decoration: const InputDecoration(
                  labelText: 'Target Calories',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter target calories';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Country Dropdown
              DropdownButtonFormField<String>(
                value: _selectedCountry,
                decoration: const InputDecoration(
                  labelText: 'Country Preference',
                  border: OutlineInputBorder(),
                ),
                items:
                    _countries.map((country) {
                      return DropdownMenuItem(
                        value: country,
                        child: Text(country),
                      );
                    }).toList(),
                onChanged: (value) {
                  setState(() => _selectedCountry = value);
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a country';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Priority Dropdown
              DropdownButtonFormField<String>(
                value: _selectedPriority,
                decoration: const InputDecoration(
                  labelText: 'Dietary Priority',
                  border: OutlineInputBorder(),
                ),
                items:
                    _priorities.map((priority) {
                      return DropdownMenuItem(
                        value: priority,
                        child: Text(priority),
                      );
                    }).toList(),
                onChanged: (value) {
                  setState(() => _selectedPriority = value);
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a priority';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Additional Notes
              TextFormField(
                controller: _additionalNotesController,
                decoration: const InputDecoration(
                  labelText: 'Additional Notes (Optional)',
                  border: OutlineInputBorder(),
                  hintText: 'e.g., No meat, allergic to nuts, etc.',
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 24),

              // Generate Button
              ElevatedButton(
                onPressed: _isLoading ? null : _generateMeal,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child:
                    _isLoading
                        ? const CircularProgressIndicator()
                        : const Text('Generate Meal Plan'),
              ),
              const SizedBox(height: 24),

              // Generated Meal Display
              if (_generatedMeal != null) ...[
                const Divider(),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: Theme.of(context).colorScheme.outline,
                    ),
                  ),
                  child: MarkdownBody(
                    data: _generatedMeal!,
                    styleSheet: MarkdownStyleSheet(
                      h1: Theme.of(context).textTheme.headlineMedium,
                      h2: Theme.of(context).textTheme.titleLarge,
                      p: Theme.of(context).textTheme.bodyLarge,
                      listBullet: Theme.of(context).textTheme.bodyLarge,
                      blockquote: Theme.of(
                        context,
                      ).textTheme.bodyLarge?.copyWith(
                        fontStyle: FontStyle.italic,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      code: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        backgroundColor:
                            Theme.of(context).colorScheme.surfaceVariant,
                        fontFamily: 'monospace',
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

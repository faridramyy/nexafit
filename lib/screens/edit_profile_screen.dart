import 'package:flutter/material.dart';
import 'package:nexafit/services/profile_service.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _profileService = ProfileService();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = true;
  bool _isSaving = false;

  // Controllers for text fields
  final _usernameController = TextEditingController();
  final _fullNameController = TextEditingController();
  final _ageController = TextEditingController();
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();
  final _bioController = TextEditingController();
  final _linkController = TextEditingController();

  // Dropdown values
  String? _selectedGender;
  String? _selectedFitnessLevel;
  String? _selectedGoal;
  int? _selectedTrainingDays;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _fullNameController.dispose();
    _ageController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    _bioController.dispose();
    _linkController.dispose();
    super.dispose();
  }

  Future<void> _loadProfile() async {
    setState(() => _isLoading = true);
    try {
      final profile = await _profileService.getProfile();
      if (profile != null) {
        _usernameController.text = profile['username'] ?? '';
        _fullNameController.text = profile['full_name'] ?? '';
        _ageController.text = profile['age']?.toString() ?? '';
        _heightController.text = profile['height_cm']?.toString() ?? '';
        _weightController.text = profile['weight_kg']?.toString() ?? '';
        _bioController.text = profile['bio'] ?? '';
        _linkController.text = profile['link'] ?? '';

        setState(() {
          _selectedGender = profile['gender'];
          _selectedFitnessLevel = profile['fitness_level'];
          _selectedGoal = profile['goal'];
          _selectedTrainingDays = profile['training_days_per_week'];
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Failed to load profile')));
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);
    try {
      await _profileService.updateProfile(
        username:
            _usernameController.text.trim().isNotEmpty
                ? _usernameController.text.trim()
                : null,
        fullName:
            _fullNameController.text.trim().isNotEmpty
                ? _fullNameController.text.trim()
                : null,
        age:
            _ageController.text.trim().isNotEmpty
                ? int.tryParse(_ageController.text.trim())
                : null,
        gender: _selectedGender,
        heightCm:
            _heightController.text.trim().isNotEmpty
                ? int.tryParse(_heightController.text.trim())
                : null,
        weightKg:
            _weightController.text.trim().isNotEmpty
                ? int.tryParse(_weightController.text.trim())
                : null,
        fitnessLevel: _selectedFitnessLevel,
        goal: _selectedGoal,
        trainingDaysPerWeek: _selectedTrainingDays,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated successfully')),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update profile: ${e.toString()}')),
        );
      }
    } finally {
      setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        centerTitle: true,
        actions: [
          if (_isSaving)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
              ),
            )
          else
            TextButton(
              onPressed: _saveProfile,
              child: const Text('Save', style: TextStyle(color: Colors.white)),
            ),
        ],
      ),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      const SizedBox(height: 16),
                      const CircleAvatar(
                        radius: 50,
                        // backgroundImage: AssetImage('assets/images/avatar_placeholder.png'),
                      ),
                      const SizedBox(height: 8),
                      TextButton(
                        onPressed: () {},
                        child: const Text('Change Picture'),
                      ),
                      const SizedBox(height: 24),
                      const SectionTitle('Public profile data'),
                      _buildTextField(
                        controller: _usernameController,
                        label: 'Username',
                        validator: (value) {
                          if (value?.isEmpty ?? true) {
                            return 'Username is required';
                          }
                          return null;
                        },
                      ),
                      _buildTextField(
                        controller: _fullNameController,
                        label: 'Full Name',
                        validator: (value) {
                          if (value?.isEmpty ?? true) {
                            return 'Full name is required';
                          }
                          return null;
                        },
                      ),
                      _buildTextField(
                        controller: _ageController,
                        label: 'Age',
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value?.isNotEmpty ?? false) {
                            final age = int.tryParse(value!);
                            if (age == null || age < 0 || age > 120) {
                              return 'Please enter a valid age';
                            }
                          }
                          return null;
                        },
                      ),
                      _buildTextField(
                        controller: _heightController,
                        label: 'Height (cm)',
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value?.isNotEmpty ?? false) {
                            final height = int.tryParse(value!);
                            if (height == null || height < 50 || height > 250) {
                              return 'Please enter a valid height';
                            }
                          }
                          return null;
                        },
                      ),
                      _buildTextField(
                        controller: _weightController,
                        label: 'Weight (kg)',
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value?.isNotEmpty ?? false) {
                            final weight = int.tryParse(value!);
                            if (weight == null || weight < 20 || weight > 300) {
                              return 'Please enter a valid weight';
                            }
                          }
                          return null;
                        },
                      ),
                      _buildTextField(
                        controller: _bioController,
                        label: 'Bio',
                        maxLines: 3,
                      ),
                      _buildTextField(
                        controller: _linkController,
                        label: 'Link',
                      ),
                      const SizedBox(height: 24),
                      const SectionTitle('Private data', withInfo: true),
                      _buildDropdown(
                        label: 'Gender',
                        value: _selectedGender,
                        items: const [
                          DropdownMenuItem(value: 'male', child: Text('Male')),
                          DropdownMenuItem(
                            value: 'female',
                            child: Text('Female'),
                          ),
                          DropdownMenuItem(
                            value: 'other',
                            child: Text('Other'),
                          ),
                        ],
                        onChanged: (value) {
                          setState(() => _selectedGender = value);
                        },
                      ),
                      _buildDropdown(
                        label: 'Fitness Level',
                        value: _selectedFitnessLevel,
                        items: const [
                          DropdownMenuItem(
                            value: 'beginner',
                            child: Text('Beginner'),
                          ),
                          DropdownMenuItem(
                            value: 'intermediate',
                            child: Text('Intermediate'),
                          ),
                          DropdownMenuItem(
                            value: 'advanced',
                            child: Text('Advanced'),
                          ),
                        ],
                        onChanged: (value) {
                          setState(() => _selectedFitnessLevel = value);
                        },
                      ),
                      _buildDropdown(
                        label: 'Goal',
                        value: _selectedGoal,
                        items: const [
                          DropdownMenuItem(
                            value: 'muscle_gain',
                            child: Text('Muscle Gain'),
                          ),
                          DropdownMenuItem(
                            value: 'fat_loss',
                            child: Text('Fat Loss'),
                          ),
                          DropdownMenuItem(
                            value: 'strength',
                            child: Text('Strength'),
                          ),
                          DropdownMenuItem(
                            value: 'endurance',
                            child: Text('Endurance'),
                          ),
                        ],
                        onChanged: (value) {
                          setState(() => _selectedGoal = value);
                        },
                      ),
                      _buildDropdown(
                        label: 'Training Days per Week',
                        value: _selectedTrainingDays?.toString(),
                        items: List.generate(
                          7,
                          (index) => DropdownMenuItem(
                            value: (index + 1).toString(),
                            child: Text('${index + 1}'),
                          ),
                        ),
                        onChanged: (value) {
                          setState(() {
                            _selectedTrainingDays = int.tryParse(value ?? '');
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    TextInputType? keyboardType,
    int? maxLines,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        keyboardType: keyboardType,
        maxLines: maxLines ?? 1,
        validator: validator,
      ),
    );
  }

  Widget _buildDropdown({
    required String label,
    required String? value,
    required List<DropdownMenuItem<String>> items,
    required void Function(String?)? onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: DropdownButtonFormField<String>(
        value: value,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        items: items,
        onChanged: onChanged,
      ),
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String title;
  final bool withInfo;

  const SectionTitle(this.title, {this.withInfo = false, super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(title, style: const TextStyle(color: Colors.grey, fontSize: 14)),
        if (withInfo)
          const Padding(
            padding: EdgeInsets.only(left: 4),
            child: Icon(Icons.info_outline, color: Colors.grey, size: 16),
          ),
      ],
    );
  }
}

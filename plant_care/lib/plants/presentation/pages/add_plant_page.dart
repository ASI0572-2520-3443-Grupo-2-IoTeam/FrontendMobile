import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plant_care/plants/presentation/components/plants_cubit.dart';

class AddPlantPage extends StatefulWidget {
  const AddPlantPage({super.key});

  @override
  State<AddPlantPage> createState() => _AddPlantPageState();
}

class _AddPlantPageState extends State<AddPlantPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _typeController = TextEditingController();
  final _imgUrlController = TextEditingController();
  final _bioController = TextEditingController();
  final _locationController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _typeController.dispose();
    _imgUrlController.dispose();
    _bioController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final plantData = {
        'userId': context.read<PlantsCubit>().userId,
        'name': _nameController.text,
        'type': _typeController.text,
        'imgUrl': _imgUrlController.text,
        'bio': _bioController.text,
        'location': _locationController.text,
      };

      context.read<PlantsCubit>().createPlant(plantData);
      Navigator.of(context).pop();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('🌱 ${_nameController.text} added successfully!'),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: _GlassBackButton(),
        title: Text(
          'Add New Plant',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w700,
            letterSpacing: -0.3,
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDark
                ? [theme.colorScheme.background, theme.colorScheme.surface]
                : [
                    theme.colorScheme.primaryContainer.withOpacity(0.1),
                    theme.colorScheme.background,
                  ],
          ),
        ),
        child: SafeArea(
          child: Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(24),
              physics: const BouncingScrollPhysics(),
              children: [
                // Header Icon
                Center(
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          theme.colorScheme.primary.withOpacity(0.2),
                          theme.colorScheme.primary.withOpacity(0.1),
                        ],
                      ),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: theme.colorScheme.primary.withOpacity(0.2),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.energy_savings_leaf_rounded,
                      size: 64,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ),
                const SizedBox(height: 32),

                // Section: Basic Info
                _SectionHeader(
                  icon: Icons.info_outline_rounded,
                  title: 'Basic Information',
                ),
                const SizedBox(height: 16),

                _GlassFormField(
                  controller: _nameController,
                  label: 'Plant Name',
                  hint: 'e.g., Monstera Deliciosa',
                  icon: Icons.local_florist_rounded,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a plant name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                _GlassFormField(
                  controller: _typeController,
                  label: 'Plant Type',
                  hint: 'e.g., Tropical, Succulent',
                  icon: Icons.category_rounded,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a plant type';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                _GlassFormField(
                  controller: _locationController,
                  label: 'Location',
                  hint: 'e.g., Living Room, Balcony',
                  icon: Icons.location_on_rounded,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a location';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 32),

                // Section: Details
                _SectionHeader(
                  icon: Icons.description_outlined,
                  title: 'Plant Details',
                ),
                const SizedBox(height: 16),

                _GlassFormField(
                  controller: _bioController,
                  label: 'Biography',
                  hint: 'Tell us about this plant...',
                  icon: Icons.auto_stories_rounded,
                  maxLines: 4,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a biography';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                _GlassFormField(
                  controller: _imgUrlController,
                  label: 'Image URL',
                  hint: 'https://example.com/plant.jpg',
                  icon: Icons.image_rounded,
                  keyboardType: TextInputType.url,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an image URL';
                    }
                    if (!value.startsWith('http')) {
                      return 'Please enter a valid URL';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 40),

                // Submit Button with Glass Effect
                _GlassSubmitButton(onPressed: _submitForm, label: 'Add Plant'),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// GLASS COMPONENTS
// ============================================================================

class _GlassBackButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(50),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface.withOpacity(0.7),
              shape: BoxShape.circle,
              border: Border.all(
                color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
                width: 1.5,
              ),
            ),
            child: IconButton(
              icon: Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 20,
                color: Theme.of(context).colorScheme.onSurface,
              ),
              onPressed: () {
                HapticFeedback.lightImpact();
                Navigator.of(context).pop();
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final IconData icon;
  final String title;

  const _SectionHeader({required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                theme.colorScheme.primary.withOpacity(0.15),
                theme.colorScheme.primary.withOpacity(0.08),
              ],
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, size: 20, color: theme.colorScheme.primary),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
            fontSize: 18,
            letterSpacing: -0.3,
          ),
        ),
      ],
    );
  }
}

class _GlassFormField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final IconData icon;
  final String? Function(String?)? validator;
  final int maxLines;
  final TextInputType? keyboardType;

  const _GlassFormField({
    required this.controller,
    required this.label,
    required this.hint,
    required this.icon,
    this.validator,
    this.maxLines = 1,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          decoration: BoxDecoration(
            color: isDark
                ? theme.colorScheme.surface.withOpacity(0.5)
                : Colors.white.withOpacity(0.7),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: theme.colorScheme.outline.withOpacity(0.2),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: theme.colorScheme.shadow.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: TextFormField(
            controller: controller,
            validator: validator,
            maxLines: maxLines,
            keyboardType: keyboardType,
            style: theme.textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w500,
            ),
            decoration: InputDecoration(
              labelText: label,
              hintText: hint,
              prefixIcon: Container(
                margin: const EdgeInsets.all(12),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, size: 20, color: theme.colorScheme.primary),
              ),
              labelStyle: theme.textTheme.labelLarge?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
              hintStyle: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant.withOpacity(0.5),
              ),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 20,
                vertical: maxLines > 1 ? 20 : 16,
              ),
              errorStyle: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.error,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _GlassSubmitButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String label;

  const _GlassSubmitButton({required this.onPressed, required this.label});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            theme.colorScheme.primary,
            theme.colorScheme.primary.withOpacity(0.8),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.primary.withOpacity(0.4),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: ElevatedButton(
            onPressed: () {
              HapticFeedback.mediumImpact();
              onPressed();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              foregroundColor: Colors.white,
              shadowColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              padding: const EdgeInsets.symmetric(vertical: 18),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.add_circle_outline_rounded, size: 24),
                const SizedBox(width: 12),
                Text(
                  label,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 17,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

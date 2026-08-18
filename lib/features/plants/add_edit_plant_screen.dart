import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../theme/theme_data.dart';
import 'plant.dart';
import 'plant_form_model.dart';
import 'plants_provider.dart';

/// Add or edit a plant. Pass [plant] to edit an existing one; omit it to
/// create a new one. Saving sends the plant to the backend via
/// [PlantsProvider]; the photo picker is still a UI stub.
class AddEditPlantScreen extends StatelessWidget {
  const AddEditPlantScreen({super.key, this.plant});

  final Plant? plant;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => PlantFormModel(initial: plant),
      child: _AddEditForm(plant: plant),
    );
  }
}

class _AddEditForm extends StatefulWidget {
  const _AddEditForm({required this.plant});

  final Plant? plant;

  @override
  State<_AddEditForm> createState() => _AddEditFormState();
}

class _AddEditFormState extends State<_AddEditForm> {
  final _formKey = GlobalKey<FormState>();
  bool _isSaving = false;

  bool get _isEditing => widget.plant != null;

  @override
  Widget build(BuildContext context) {
    final formModel = context.watch<PlantFormModel>();

    return Scaffold(
      appBar: AppBar(title: Text(_isEditing ? 'Edit Plant' : 'Add Plant')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _PhotoPicker(
                  hasPhoto: formModel.hasPhoto,
                  onTap: () {
                    formModel.pickPhoto();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Photo picker not implemented yet'),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 24),
                TextFormField(
                  controller: formModel.nameController,
                  decoration: const InputDecoration(
                    labelText: 'Plant name',
                    prefixIcon: Icon(Icons.eco_outlined),
                  ),
                  validator: (value) => (value == null || value.trim().isEmpty)
                      ? 'Enter a name for this plant'
                      : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: formModel.speciesController,
                  decoration: const InputDecoration(
                    labelText: 'Species',
                    prefixIcon: Icon(Icons.local_florist_outlined),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: formModel.wateringFrequencyDaysController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Watering frequency (days)',
                    prefixIcon: Icon(Icons.water_drop_outlined),
                  ),
                  validator: (value) {
                    final parsed = int.tryParse(value?.trim() ?? '');
                    return (parsed == null || parsed <= 0)
                        ? 'Enter a whole number of days greater than 0'
                        : null;
                  },
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: _isSaving ? null : () => _save(context, formModel),
                  child: _isSaving
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(_isEditing ? 'Save Changes' : 'Add Plant'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _save(BuildContext context, PlantFormModel formModel) async {
    if (!_formKey.currentState!.validate()) return;

    final plantsProvider = context.read<PlantsProvider>();
    final existing = widget.plant;
    final name = formModel.nameController.text.trim();
    final species = formModel.speciesController.text.trim();
    final wateringFrequencyDays = int.parse(
      formModel.wateringFrequencyDaysController.text.trim(),
    );

    final plant = Plant(
      id: existing?.id ?? '',
      name: name,
      species: species.isEmpty ? null : species,
      wateringFrequencyDays: wateringFrequencyDays,
      imagePath: existing?.imagePath,
      lastWateredDate: existing?.lastWateredDate,
      createdAt: existing?.createdAt,
    );

    setState(() => _isSaving = true);
    try {
      if (existing == null) {
        await plantsProvider.addPlant(plant);
      } else {
        await plantsProvider.updatePlant(plant);
      }
      if (context.mounted) Navigator.of(context).pop();
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not save this plant: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }
}

class _PhotoPicker extends StatelessWidget {
  const _PhotoPicker({required this.hasPhoto, required this.onTap});

  final bool hasPhoto;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Container(
        height: 140,
        decoration: BoxDecoration(
          color: AppColors.placeholderFill,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.earthBrown, width: 1.5),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              hasPhoto ? Icons.check_circle : Icons.add_a_photo_outlined,
              size: 32,
              color: AppColors.primaryGreen,
            ),
            const SizedBox(height: 8),
            Text(
              hasPhoto ? 'Photo selected' : 'Add a photo',
              style: const TextStyle(color: AppColors.soilBrown),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:plant_care/iam/presentation/providers/auth_provider.dart';
import 'package:plant_care/plants/data/models/plant_model.dart';
import 'package:provider/provider.dart';
import 'package:plant_care/plants/domain/entities/plant_status.dart';
import 'package:plant_care/plants/presentation/providers/plant_provider.dart';

class AddPlantDialog extends StatefulWidget {
  const AddPlantDialog({super.key});

  @override
  State<AddPlantDialog> createState() => _AddPlantDialogState();
}

class _AddPlantDialogState extends State<AddPlantDialog> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedName;
  String? _selectedType;
  String? _location;
  String? _bio;

  final List<Map<String, String>> plantOptions = [
    {
      "name": "Aloe Vera",
      "type": "Succulent",
      "img": "https://i.imgur.com/W2pQqMx.png"
    },
    {
      "name": "Ficus",
      "type": "Tree",
      "img": "https://i.imgur.com/Dk8x7lr.png"
    },
    {
      "name": "Basil",
      "type": "Herb",
      "img": "https://i.imgur.com/cUZzT7D.png"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: CurvedAnimation(
        parent: ModalRoute.of(context)!.animation!,
        curve: Curves.easeOutBack,
      ),
      child: AlertDialog(
        backgroundColor: Theme.of(context).cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text("Add New Plant"),
        content: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(labelText: "Select Plant"),
                  items: plantOptions.map((plant) {
                    return DropdownMenuItem<String>(
                      value: plant["name"],
                      child: Text(plant["name"]!),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() => _selectedName = value);
                    _selectedType = plantOptions
                        .firstWhere((p) => p["name"] == value)["type"];
                  },
                  validator: (value) => value == null ? "Required" : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  decoration: const InputDecoration(labelText: "Location"),
                  onSaved: (val) => _location = val,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  decoration: const InputDecoration(labelText: "Bio"),
                  onSaved: (val) => _bio = val,
                ),
                const SizedBox(height: 16),
                if (_selectedName != null)
                  Image.network(
                    plantOptions
                        .firstWhere((p) => p["name"] == _selectedName)["img"]!,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () async {
  if (_formKey.currentState!.validate()) {
    _formKey.currentState!.save();

    //  Obtener el usuario actual
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final userId = authProvider.userId ?? "0";
    final token = authProvider.token ?? "";

    final selected = plantOptions.firstWhere((p) => p["name"] == _selectedName);

    //  Crear la planta con el userId dinámico
    final plant = PlantModel(
      id: 0,
      userId: userId,
      name: _selectedName!,
      type: _selectedType!,
      imgUrl: selected["img"]!,
      bio: _bio ?? '',
      location: _location ?? '',
      humidity: 50,
      status: PlantStatus.healthy,
      lastWatered: "",
      nextWatering: "",
    );

    //  Llamar al provider para agregar la planta
    await context.read<PlantProvider>().addPlant(plant);

    // (Opcional) Forzar recarga de plantas del usuario actual
    await context.read<PlantProvider>().fetchPlantsByUserId(
      userId: userId,
      token: token,
      force: true,
    );

    Navigator.pop(context);
  }
}, child:   const Text("Add"),

          ),
        ],
      ),
    );
  }
}

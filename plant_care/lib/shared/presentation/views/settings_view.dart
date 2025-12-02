import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:plant_care/shared/presentation/theme/theme.dart';
import 'package:plant_care/shared/presentation/viewmodel/theme_viewmodel.dart';
import 'package:provider/provider.dart';
import '../widgets/custom_bottom_navbar.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  bool notificationsEnabled = true;
  bool darkModeEnabled = false;
  String selectedLanguage = "English";

  final List<String> languages = ["English", "Español", "Français"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: ListView(
            children: [
              // Header
              Card(
                margin: const EdgeInsets.only(bottom: 16),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Settings",
                          style: Theme.of(context).textTheme.headlineLarge),
                      const SizedBox(height: 4),
                      Text("Manage your preferences and account",
                          style: Theme.of(context).textTheme.bodyMedium),
                    ],
                  ),
                ),
              ),

              // Perfil de usuario
              Card(
                margin: const EdgeInsets.only(bottom: 16),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: AppTheme.primaryGreen.withOpacity(0.2),
                    child: const Icon(Icons.person,
                        color: AppTheme.primaryGreen),
                  ),
                  title: Text("Sarah Johnson",
                      style: Theme.of(context).textTheme.bodyLarge),
                  subtitle: Text("sarah@example.com",
                      style: Theme.of(context).textTheme.bodyMedium),
                  trailing: IconButton(
                    icon: const Icon(Icons.edit, color: AppTheme.primaryGreen),
                    onPressed: () {
                      // TODO: editar perfil
                    },
                  ),
                ),
              ),
              Card(
                margin: const EdgeInsets.only(bottom: 16),
                child: ListTile(
                  leading: const Icon(Icons.credit_card, color: AppTheme.primaryGreen),
                  title: const Text("My Subscription"),
                  subtitle: const Text("Manage or change your plan"),
                  onTap: () => context.go('/subscription'),
                ),
              ),

              // Idioma
              Card(
                margin: const EdgeInsets.only(bottom: 16),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: DropdownButtonFormField<String>(
                    initialValue: selectedLanguage,
                    items: languages
                        .map((lang) =>
                            DropdownMenuItem(value: lang, child: Text(lang)))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedLanguage = value!;
                      });
                    },
                    decoration: const InputDecoration(
                      labelText: "Language",
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),

              // Notificaciones
              Card(
                margin: const EdgeInsets.only(bottom: 16),
                child: SwitchListTile(
                  title: const Text("Enable Notifications"),
                  value: notificationsEnabled,
                  onChanged: (value) {
                    setState(() {
                      notificationsEnabled = value;
                    });
                  },
                  activeThumbColor: AppTheme.primaryGreen,
                ),
              ),

              // Modo oscuro
              Card(
  margin: const EdgeInsets.only(bottom: 16),
  child: SwitchListTile(
    title: const Text("Dark Mode"),
    value: context.watch<ThemeViewModel>().isDarkMode,
    onChanged: (value) {
      context.read<ThemeViewModel>().toggleTheme(value);
    },
    secondary: AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      transitionBuilder: (child, animation) {
        return RotationTransition(
          turns: Tween(begin: 0.75, end: 1.0).animate(animation),
          child: FadeTransition(opacity: animation, child: child),
        );
      },
      child: Icon(
        context.watch<ThemeViewModel>().isDarkMode
            ? Icons.dark_mode
            : Icons.light_mode,
        key: ValueKey<bool>(context.watch<ThemeViewModel>().isDarkMode),
        color: AppTheme.primaryGreen,
      ),
    ),
  ),
),


              // Logout
              Card(
              
                child: ListTile(
                  leading: const Icon(Icons.logout, color: AppTheme.criticalColor),
                  title: const Text(
                    "Log Out",
                    style: TextStyle(
                      color: AppTheme.criticalColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onTap: () {
                    context.go('/login'); 
                },
                ),
              ),
            ],
          ),
        ),
      ),

      // Barra inferior
      bottomNavigationBar: const CustomBottomNavBar(currentIndex: 3),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:plant_care/presentation/theme/theme.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bottomBarTheme = theme.bottomNavigationBarTheme;

    return BottomNavigationBar(
      currentIndex: currentIndex,
      backgroundColor:
          bottomBarTheme.backgroundColor ?? theme.colorScheme.surface,
      selectedItemColor:
          bottomBarTheme.selectedItemColor ?? AppTheme.primaryGreen,
      unselectedItemColor:
          bottomBarTheme.unselectedItemColor ?? AppTheme.textLight,
      showUnselectedLabels:
          bottomBarTheme.showUnselectedLabels ?? true,
      type: BottomNavigationBarType.fixed,
      onTap: (index) {
        switch (index) {
          case 0:
            context.go("/dashboard");
            break;
          case 1:
            context.go("/myplants");
            break;
          case 2:
            context.go("/history");
            break;
          case 3:
            context.go("/settings");
            break;
        }
      },
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.dashboard),
          label: "Dashboard",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.local_florist),
          label: "My Plants",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.history),
          label: "History",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: "Settings",
        ),
      ],
    );
  }
}

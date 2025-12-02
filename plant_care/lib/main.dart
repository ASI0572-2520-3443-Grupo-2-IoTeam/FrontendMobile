import 'package:flutter/material.dart';
import 'package:plant_care/community/infrastructure/repositories/http_community_repository.dart';
import 'package:plant_care/community/presentation/providers/community_provider.dart';
import 'package:plant_care/iam/application/usecases/google_signin_usecase.dart';
import 'package:plant_care/shared/presentation/navigation/app_router.dart';
import 'package:provider/provider.dart';
import 'iam/infrastructure/datasources/auth_api_service.dart';
import 'iam/infrastructure/repositories/auth_repository_impl.dart';
import 'iam/application/usecases/login_usecase.dart';
import 'iam/application/usecases/register_usecase.dart';
import 'iam/presentation/providers/auth_provider.dart';
import 'plants/presentation/providers/plant_provider.dart';
import 'shared/presentation/theme/theme.dart';
import 'shared/presentation/viewmodel/theme_viewmodel.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    debugPrint("✅ Firebase inicializado correctamente");
  } else {
    debugPrint("⚠️ Firebase ya estaba inicializado, se omitió la reinicialización.");
  }
} catch (e) {
  debugPrint("❌ Error al inicializar Firebase: $e");
}

  // ==== Inyección manual de dependencias ====
  final authApiService = AuthApiService();
  final authRepository = AuthRepositoryImpl(authApiService);

  final loginUseCase = LoginUseCase(authRepository);
  final registerUseCase = RegisterUseCase(authRepository);
  final googleSignInUseCase = GoogleSignInUseCase(); 

  // ==== Inicializa la app ====
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeViewModel()),
        ChangeNotifierProvider(
          create: (_) => AuthProvider(
            loginUseCase: loginUseCase,
            registerUseCase: registerUseCase,
            googleSignInUseCase: googleSignInUseCase, 
          ),
        ),
        ChangeNotifierProvider(create: (_) => PlantProvider()),
        ChangeNotifierProvider(
          create: (context) => CommunityProvider(
            repository: HttpCommunityRepository(),
            authProvider: Provider.of<AuthProvider>(context, listen: false),
          ),
        ),
      ],
      child: const PlantCareApp(),
    ),
  );
}

class PlantCareApp extends StatelessWidget {
  const PlantCareApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeViewModel>(
      builder: (context, themeViewModel, child) {
        final isDark = themeViewModel.isDarkMode;
        final theme = isDark ? AppTheme.darkTheme : AppTheme.lightTheme;

        return AnimatedTheme(
          data: theme,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
          child: MaterialApp.router(
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
            routerConfig: appRouter,
          ),
        );
      },
    );
  }
}
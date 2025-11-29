import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart'; // Importación necesaria para DI

// --- Importaciones de la Capa de Infraestructura (Asegúrate de que estas rutas son correctas) ---
// La base de datos es necesaria para inicializar Drift
import 'features/habits/infrastructure/app_database.dart'; 
// El gestor de archivos es necesario para la lógica de import/export
import 'features/habits/infrastructure/db_file_manager.dart'; 
// Puedes necesitar importar contratos de repositorio si los vas a registrar aquí
// import 'features/habits/domain/habit_repository.dart'; 
// import 'features/habits/infrastructure/habit_local_repository_impl.dart'; 
// ------------------------------------------------------------------------------------------------

import './app.dart';

// Inicializa la instancia global de GetIt
final getIt = GetIt.instance;

// -------------------------------------------------------------------
// FUNCIÓN DE CONFIGURACIÓN DE DEPENDENCIAS
// -------------------------------------------------------------------

void setupDependencies() {
  // 1. REGISTRO DE LA BASE DE DATOS (Drift)
  // Drift AppDatabase debe ser un Singleton (una única conexión)
  getIt.registerLazySingleton<AppDatabase>(() => AppDatabase()); 

  // 2. REGISTRO DEL GESTOR DE ARCHIVOS DE LA DB
  getIt.registerLazySingleton<DbFileManager>(() => DbFileManager());

  // 3. REGISTRO DE REPOSITORIOS (EJEMPLO)
  // Debes registrar aquí tu repositorio, inyectando AppDatabase:
  // getIt.registerLazySingleton<HabitRepositoryContract>(
  //   () => HabitLocalRepositoryImpl(database: getIt<AppDatabase>()),
  // );

  // AÑADE AQUÍ EL RESTO DE REPOSITORIOS Y SERVICIOS
}
// -------------------------------------------------------------------


void main() {
  // Inicializa los bindings de Flutter antes de usar plugins (como path_provider)
  WidgetsFlutterBinding.ensureInitialized(); 
  
  // Llama a la función de setup para registrar todas las dependencias
  setupDependencies(); 

  runApp(
    const ProviderScope(
      child: App(),
    ),
  );
}
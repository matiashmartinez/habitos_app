import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart' as p;

import 'tables.dart'; // Importa las definiciones de tabla

part 'app_database.g.dart'; // Drift generará el código aquí

// Define la base de datos principal
@DriftDatabase(tables: [Users, Habits, Completions])
class AppDatabase extends _$AppDatabase {
  // Inicializa la conexión de la DB
  AppDatabase() : super(_openConnection());

  // Debes incrementar la versión si modificas el esquema de la DB
  @override
  int get schemaVersion => 1;

  // Si actualizas la versión del esquema, debes implementar una migración aquí.
  // @override
  // MigrationStrategy get migration => MigrationStrategy(...);
}

// Función para abrir la conexión de la base de datos (requiere path_provider)
LazyDatabase _openConnection() {
  // La base de datos estará en 'app_database.sqlite' dentro del directorio de documentos de la aplicación.
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'app_database.sqlite'));
    return NativeDatabase(file);
  });
}
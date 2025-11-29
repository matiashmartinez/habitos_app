import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

// Esta clase maneja la copia y manipulación del archivo SQLite
class DbFileManager {
  static const String databaseFileName = 'app_database.sqlite';

  // 1. Obtiene la ruta completa donde Drift almacena el archivo SQLite internamente.
  Future<String> getDatabasePath() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, databaseFileName));
    return file.path;
  }

  // 2. Exporta el archivo de la DB a una ruta de destino proporcionada por FilePicker.
  Future<void> exportDatabase({required String destinationPath}) async {
    final sourcePath = await getDatabasePath();
    final sourceFile = File(sourcePath);
    
    if (!await sourceFile.exists()) {
      // Este error es crítico, significa que la DB no existe donde debería.
      throw Exception('El archivo de la base de datos no existe en el origen.');
    }

    try {
      // Copia el archivo
      await sourceFile.copy(destinationPath);
    } catch (e) {
      throw Exception('Error al copiar el archivo para exportar: $e');
    }
  }

  // 3. Importa el archivo de la DB desde una ruta de origen seleccionada por FilePicker.
  Future<void> importDatabase({required String sourcePath}) async {
    final destinationPath = await getDatabasePath();
    final sourceFile = File(sourcePath);
    
    if (!await sourceFile.exists()) {
      throw Exception('El archivo de origen no fue encontrado. Intenta seleccionar otro.');
    }
    
    try {
      // Importante: Copia el archivo importado al directorio de Drift, sobrescribiendo el actual.
      await sourceFile.copy(destinationPath);
      
      // Nota: La aplicación DEBE reiniciarse para que Drift recargue el nuevo archivo.
    } catch (e) {
      throw Exception('Error al importar y reemplazar el archivo de la base de datos: $e');
    }
  }
}
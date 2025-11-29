import 'package:drift/drift.dart';

// Tabla de Usuarios
class Users extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  
  @override
  Set<Column>? get primaryKey => {id};
}

// Tabla de Hábitos
class Habits extends Table {
  TextColumn get id => text()();
  
  // Clave Foránea: Un hábito pertenece a un usuario (references Users.id)
  TextColumn get userId => text().references(Users, #id)();
  
  TextColumn get title => text()();
  TextColumn get description => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  
  // Este campo se puede usar para el estado diario, pero su valor real debe 
  // ser determinado consultando la tabla Completions para el día actual.
  BoolColumn get completed => boolean().withDefault(const Constant(false))();
  
  @override
  Set<Column>? get primaryKey => {id};
}

// Tabla de Registros de Cumplimiento
class Completions extends Table {
  TextColumn get id => text()();
  
  // Clave Foránea: Un registro pertenece a un hábito (references Habits.id)
  TextColumn get habitId => text().references(Habits, #id)();
  
  DateTimeColumn get completedAt => dateTime()();
  
  @override
  Set<Column>? get primaryKey => {id};
}
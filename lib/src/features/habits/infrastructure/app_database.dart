import 'package:drift/drift.dart';

class Users extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  @override
  Set<Column>? get primaryKey => {id};
}

class Habits extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text()();
  TextColumn get title => text()();
  TextColumn get description => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  BoolColumn get completed => boolean().withDefault(Constant(false))();
  @override
  Set<Column>? get primaryKey => {id};
}

class Completions extends Table {
  TextColumn get id => text()();
  TextColumn get habitId => text()();
  DateTimeColumn get completedAt => dateTime()();
  @override
  Set<Column>? get primaryKey => {id};
}

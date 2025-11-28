import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../application/habit_notifier.dart';
import '../../domain/habit.dart';

class HabitEditScreen extends ConsumerStatefulWidget {
  final Habit habit;

  const HabitEditScreen({super.key, required this.habit});

  @override
  ConsumerState<HabitEditScreen> createState() => _HabitEditScreenState();
}

class _HabitEditScreenState extends ConsumerState<HabitEditScreen> {
  final formKey = GlobalKey<FormState>();
  late final TextEditingController nameCtrl;
  late final TextEditingController descCtrl;

  @override
  void initState() {
    super.initState();
    nameCtrl = TextEditingController(text: widget.habit.title);
    descCtrl = TextEditingController(text: widget.habit.description);
  }

  void _save() {
    if (formKey.currentState!.validate()) {
      ref.read(habitNotifierProvider.notifier).updateHabit(
            widget.habit.id,
            nameCtrl.text.trim(),
            descCtrl.text.trim(),
          );
      if (mounted) Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Editar Hábito")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              TextFormField(
                controller: nameCtrl,
                decoration: const InputDecoration(labelText: "Nombre"),
                validator: (v) => v!.isEmpty ? "Debe ingresar un nombre" : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: descCtrl,
                decoration: const InputDecoration(labelText: "Descripción"),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _save,
                child: const Text("Actualizar"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

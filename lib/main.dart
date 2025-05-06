import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:minitaskmanagementapps/presentation/bloc/theme/theme_bloc.dart';
import 'data/datasources/task_local_datasource.dart';
import 'data/repositories/task_repository_impl.dart';
import 'domain/repositories/task_repository.dart';
import 'presentation/bloc/task/task_bloc.dart';
import 'presentation/pages/task_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() {
  // WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();
  final TaskRepository repository = TaskRepositoryImpl(TaskLocalDataSource());

  runApp(MyApp(repository: repository));
}

class MyApp extends StatelessWidget {
  final TaskRepository repository;

  const MyApp({super.key, required this.repository});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Task Manager',
      home: BlocProvider(
        create: (_) => TaskBloc(repository)..add(LoadTasks()),
        child: TaskPage(),
      ),
    );
  }
}

import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:minitaskmanagementapps/core/utils/color.dart';
import 'package:minitaskmanagementapps/core/utils/custome_pop_up_item.dart';
import 'package:minitaskmanagementapps/core/utils/custome_text_form_field.dart';
import 'package:minitaskmanagementapps/presentation/bloc/task/task_bloc.dart';
import '../../domain/entities/task.dart';

class TaskPage extends StatefulWidget {
  TaskPage({super.key});

  @override
  State<TaskPage> createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  final TextEditingController _titleController = TextEditingController();

  final TextEditingController _descController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // backgroundColor: Colors.green,
        title: const Text('Mini Task Management App'),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {
              // Handle click action here
              showMenu(
                context: context,
                position: const RelativeRect.fromLTRB(1000, 80, 0, 0),
                items: [
                  PopupMenuItem(
                    child: CustomePopUpItem(
                      title: "All",
                      onPressed: () {
                        context.read<TaskBloc>().add(LoadTasks());
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  CustomePopUpItem(
                    title: "Completed",
                    onPressed: () {
                      context
                          .read<TaskBloc>()
                          .add(LoadTasks(filterCompleted: true));
                      Navigator.pop(context);
                    },
                  ),
                  CustomePopUpItem(
                    title: "Pending",
                    onPressed: () {
                      context
                          .read<TaskBloc>()
                          .add(LoadTasks(filterCompleted: false));
                      Navigator.pop(context);
                    },
                  ),
                ],
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<TaskBloc, TaskState>(
        builder: (context, state) {
          if (state is TaskLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is TaskLoaded) {
            return ListView.builder(
              itemCount: state.tasks.length,
              itemBuilder: (context, index) {
                final task = state.tasks[index];
                return Card(
                  margin: const EdgeInsets.all(8.0),
                  elevation: 2,
                  child: ListTile(
                    leading: Checkbox(
                      value: task.isCompleted,
                      onChanged: (_) {
                        context.read<TaskBloc>().add(UpdateTask(
                            task.copyWith(isCompleted: !task.isCompleted)));
                      },
                    ),
                    title: Text(
                      task.title,
                      style: TextStyle(
                        decoration: task.isCompleted
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                      ),
                    ),
                    subtitle: Text(task.description),
                    onTap: () => _showEditTaskDialog(context, task),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      color: ColorPalette.redColor,
                      onPressed: () {
                        context.read<TaskBloc>().add(DeleteTask(task.id));
                      },
                    ),
                  ),
                );
              },
            );
          }
          return const Center(child: Text('No tasks'));
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddTaskDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddTaskDialog(BuildContext context) {
    DateTime selectedDate = DateTime.now();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Add Task'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomeTexFormField(controller: _titleController, title: "Title"),
            const SizedBox(height: 20),
            CustomeTexFormField(
                controller: _descController, title: "Description"),
            const SizedBox(height: 20),
            TextButton.icon(
              icon: const Icon(Icons.calendar_today),
              label: Text(
                  'Select Date: ${selectedDate.toLocal().toString().split(' ')[0]}'),
              onPressed: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: selectedDate,
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                );
                if (picked != null) {
                  setState(() {
                    selectedDate = picked;
                  });
                  // ignore: use_build_context_synchronously
                  // context.read<TaskBloc>().add(changeDate(selectedDate));
                } else {
                  // Handle the case when the user cancels the date picker
                  // ignore: use_build_context_synchronously
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Date selection cancelled'),
                    ),
                  );
                }
              },
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: ColorPalette.greenColor,
              onPrimary: ColorPalette.whiteColor,
              textStyle: const TextStyle(fontSize: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            onPressed: () {
              final title = _titleController.text;
              final description = _descController.text;
              if (title.isNotEmpty && description.isNotEmpty) {
                context.read<TaskBloc>().add(AddTask(
                      Task(
                        id: 0,
                        title: title,
                        description: description,
                        isCompleted: false,
                        createdAt: selectedDate,
                      ),
                    ));
                _titleController.clear();
                _descController.clear();
                Navigator.pop(context);
              }
            },
            child: const Text('Add'),
          )
        ],
      ),
    );
  }

  void _showEditTaskDialog(BuildContext context, Task task) {
    final titleController = TextEditingController(text: task.title);
    final descController = TextEditingController(text: task.description);
    DateTime selectedDate = task.createdAt;
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Edit Task'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomeTexFormField(controller: titleController, title: "Title"),
            const SizedBox(height: 20),
            CustomeTexFormField(
                controller: descController, title: "Description"),
            TextButton.icon(
              icon: const Icon(Icons.calendar_today),
              label: Text(
                  'Select Date: ${selectedDate.toLocal().toString().split(' ')[0]}'),
              onPressed: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: selectedDate,
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                );
                if (picked != null) {
                  setState(() {
                    selectedDate = picked;
                  });
                }
              },
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: ColorPalette.greenColor,
              onPrimary: ColorPalette.whiteColor,
              textStyle: const TextStyle(fontSize: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            onPressed: () {
              context.read<TaskBloc>().add(UpdateTask(task.copyWith(
                    title: titleController.text,
                    description: descController.text,
                    createdAt: selectedDate,
                  )));

              Navigator.pop(context);
            },
            child: const Text('Update'),
          )
        ],
      ),
    );
  }
}

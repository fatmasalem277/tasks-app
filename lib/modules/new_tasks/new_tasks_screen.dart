import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_application/shared/cubit/states.dart';
import '../../components/constents.dart';
import '../../components/reusable_components.dart';
import 'package:notes_application/shared/cubit/cubit.dart';

class NewTasks extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {} ,
      builder: (context, state) {
        var tasks = AppCubit
            .get(context)
            .newTasks;
        return tasksBuilder(tasks: tasks);
      }

    );
  }
}

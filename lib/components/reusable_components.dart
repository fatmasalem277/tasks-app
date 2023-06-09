import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:notes_application/shared/cubit/cubit.dart';

Widget buildTaskItem(Map model, context) =>
    Dismissible(
      key: Key(model['id'].toString()),
      child: Padding(

        padding: const EdgeInsets.all(20.0),

        child: Row(

          children: [

            CircleAvatar(

              radius: 40,

              child: Text('${model['time']}'),

            ),

            SizedBox(

              width: 20,

            ),

            Expanded(

              child: Column(

                mainAxisSize: MainAxisSize.min,

                crossAxisAlignment: CrossAxisAlignment.start,

                children: [

                  Text('${model['title']}',

                      style: TextStyle(

                        fontSize: 18,

                        fontWeight: FontWeight.bold,

                      )),

                  Text('${model['date']}',

                      style: TextStyle(

                        color: Colors.grey,

                      )),

                  // Text

                ],

              ),

            ),

            SizedBox(

              width: 20,

            ),

            IconButton(onPressed: () {
              AppCubit.get(context).updateData(status: 'done', id: model['id']);
            }, icon: Icon(Icons.check_box, color: Colors.green,)),

            IconButton(onPressed: () {
              AppCubit.get(context).updateData(
                  status: 'archived', id: model['id']);
            }, icon: Icon(Icons.archive, color: Colors.grey,)),


          ],

        ),

      ),
      onDismissed: (direction) {
        AppCubit.get(context).deleteData(id: model['id'],);
      },
    );

Widget tasksBuilder({
  required List<Map> tasks,
}) => ConditionalBuilder (
condition: tasks.length > 0,
builder: (
context) =>
ListView.separated(itemBuilder: (
context, index) =>
buildTaskItem
(
tasks[index],
context),
separatorBuilder: (
context, index) =>
Container
(
width: double.infinity,height: 1
,
color: Colors.grey[300
]
,
)
,
itemCount: tasks.length),
fallback: (
context) =>
Center
(
child: Column
(
mainAxisAlignment: MainAxisAlignment.center,children: [
Icon
(
Icons.menu, size: 100
,
color: Colors.grey,)
,
Text
('No Tasks Yet, Please Add Some Task'
,
style: TextStyle
(
fontSize: 15
,
fontWeight: FontWeight.bold,color: Colors.grey),),
],
),
),
);
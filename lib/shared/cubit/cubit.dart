import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:notes_application/shared/cubit/states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';

import '../../components/constents.dart';
import '../../modules/archived_tasks/archived_tasks_screen.dart';
import '../../modules/done_tasks/done_tasks_screen.dart';
import '../../modules/new_tasks/new_tasks_screen.dart';

class AppCubit extends Cubit<AppStates>
{
  late Database database;
  List<Map> newTasks = [];
  List<Map> doneTasks = [];
  List<Map> archivedTasks = [];
  AppCubit() : super(AppInitialState());

  static AppCubit get(context) => BlocProvider.of(context) ;
  int currentIndex = 0;
  List<Widget> screens = [
    NewTasks(),
    DoneTasks(),
    ArchivedTasks(),
  ];
  List<String> titles = [
    'New Tasks',
    'Done Tasks',
    'Archived Tasks',
  ];
  void changeIndex(int index)
  {
    currentIndex = index;
    emit(AppChangeBottomNavBarState());
  }
  void createDataBase()  {
     openDatabase(
      'todo.db',
      version: 1,
      onCreate: (database, version) {
        print('database created');
        database
            .execute(
            'CREATE TABLE tasks(id INTEGER PRIMARY KEY,title TEXT,date TEXT,time TEXT,status TEXT)')
            .then((value) {
          print('table creaated');
        }).catchError((error) {
          print('Error when creating table ${error.toString()}');
        });
      },
      onOpen: (database) {

      },
    ).then((value) {
      database = value;
      emit(AppCreateDataBaseState());
     });
  }

   insertToDB(
      {required String title,
        required String time,
        required String date}) async {
    await database.transaction((txn) {
      txn
          .rawInsert(
          'INSERT INTO tasks(title, date, time, status) VALUES("$title","$date","$time","new")')
          .then((value) {
        print(' $value inserted successfully');
        emit(AppInsertDataBaseState());
        getDataFromDB(database);
      }).catchError((error) {
        print('Error When inserting new record ${error.toString()}');
      });
      return Future(() => null);
    });
  }

  void getDataFromDB(database)  {
    newTasks = [];
    doneTasks = [];
    archivedTasks = [];
    emit(AppGetDataBaseLoadingState());
     database.rawQuery('SELECT * FROM tasks').then((value) {

       value.forEach((element) {
         if(element ['status'] == 'new')
           newTasks.add(element);
         else if(element ['status'] == 'done')
           doneTasks.add(element);
         else archivedTasks.add(element);


       });
       emit(AppGetDataBaseState());
     });
  }
  void updateData({
  required String status,
    required int id,
}) async
  {
    database.rawUpdate(
      'UPDATE tasks SET status = ? WHERE id = ?',
    ['$status', id]).then((value) {
      getDataFromDB(database);
      emit(AppUpdateDataBaseLoadingState());
    });
  }

  void deleteData({
    required int id,
  }) async
  {
    database.rawDelete(
        'DELETE FROM tasks WHERE id = ?', [id]).then((value)
         {
      getDataFromDB(database);
      emit(AppDeleteDataBaseLoadingState());
    });
  }


  bool isBottomSheetShown = false;
  IconData fabIcon = Icons.edit;

  void changeBottomSheetState({required bool isShow, required IconData icon})
  {
    isBottomSheetShown = isShow;
    fabIcon= icon;
    emit(AppChangeBottomSheetState());

  }


}

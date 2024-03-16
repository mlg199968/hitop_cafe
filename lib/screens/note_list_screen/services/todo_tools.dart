

//with help of extension method we add the method to DateTime to check the two date are they same or not
import 'package:flutter/material.dart';
import 'package:hitop_cafe/models/note.dart';
import 'package:hitop_cafe/screens/note_list_screen/panels/note_info_panel.dart';
import 'package:hitop_cafe/screens/note_list_screen/widgets/note_tile.dart';
import 'package:hitop_cafe/services/hive_boxes.dart';

extension DateOnlyCompare on DateTime {
  bool isSameDate(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }
}

class ToDoTools {

/// generate
 static List<Widget> generateNoteList(
      {required BuildContext context, required onChange, required  List all}) {
    return List.generate(all.length, (int index) {
      ///notes part
      if (all[index].runtimeType == Note) {
        Note note = all[index];
        return ToDoTile(
            onTap: () {
              showDialog(
                  context: context,
                  builder: (context) =>
                      noteInfoPanel(context: context, note: note)).then((value) {
                onChange();
              });
            },
            title: note.title,
            subTitle: note.subTitle,
            checkValue: note.isDone,
            onChanged: (val) {
              note.isDone = val!;
              HiveBoxes.getNotes().put(note.noteId, note);
              onChange();
            });
      }

      return const SizedBox();
    });
  }

  /// get check list of the chosen date
  static List getCurrentDayToDoList(DateTime checkDate) {

    List<Note> noteList = [];
    List all = [];
//get cheque list from bills



    noteList = HiveBoxes.getNotes().values.toList();
    //check the node deadline to add to the list
    for (var note in noteList) {
      if (note.deadline.isSameDate(checkDate)) {
        all.add(note);
      }
    }
    return all;
  }
///get all past days check list
  static List getPastDaysToDoList(DateTime checkDate){

    List<Note> noteList = [];
    List all = [];

    noteList = HiveBoxes.getNotes().values.toList();
    //check the node deadline to add to the list
    for (var note in noteList) {
      if (note.deadline.isBefore(checkDate)) {
        all.add(note);
      }
    }
    return all;
  }

}

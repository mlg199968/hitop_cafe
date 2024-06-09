import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hitop_cafe/common/time/day_slider.dart';
import 'package:hitop_cafe/common/widgets/custom_divider.dart';
import 'package:hitop_cafe/common/widgets/custom_float_action_button.dart';
import 'package:hitop_cafe/common/widgets/empty_holder.dart';
import 'package:hitop_cafe/constants/constants.dart';
import 'package:hitop_cafe/models/note.dart';
import 'package:hitop_cafe/models/raw_ware.dart';
import 'package:hitop_cafe/screens/note_list_screen/panels/add_task_panel.dart';
import 'package:hitop_cafe/screens/note_list_screen/services/todo_tools.dart';
import 'package:hitop_cafe/services/hive_boxes.dart';
import 'package:hive_flutter/hive_flutter.dart';

class NoteListScreen extends StatefulWidget {
  static const String id = "/NoteListScreen";
  const NoteListScreen({
    super.key,
  });

  @override
  State<NoteListScreen> createState() => _NoteListScreenState();
}

class _NoteListScreenState extends State<NoteListScreen> {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  DateTime checkDate = (DateTime.now());

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      floatingActionButton: CustomFloatActionButton(onPressed: () {
        showDialog(context: context, builder: (context) => const AddTaskPanel())
            .then((value) {
          setState(() {});
        });
      }),
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back)),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(gradient: kMainGradiant),
        ),
        title: Container(
          padding: const EdgeInsets.only(right: 5),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("لیست یاد آوری"),
            ],
          ),
        ),
        elevation: 5.0,
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Align(
          alignment: Alignment.topCenter,
          child: Container(
            width: 500,
            padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
            child: ValueListenableBuilder(
                valueListenable: HiveBoxes.getRawWare().listenable(),
                builder: (context, valWare, child) {
                  List<RawWare> wares = valWare.values.toList();
                  return ValueListenableBuilder(
                      valueListenable: HiveBoxes.getNotes().listenable(),
                      builder: (context, valNote, child) {
                        List<Note> notes = valNote.values.toList();
                        return Column(
                          children: <Widget>[
                            ///Top part for backward or forward the date
                            DaySlider(date: checkDate,
                                onChange: (current,begin,end){
                              checkDate=current;
                              setState(() {});
                                }),

                            Expanded(
                              child: ListView(
                                children: [
                                  ///present day check list
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    width: double.maxFinite,
                                    child: ToDoTools.getCurrentDayToDoList(
                                                checkDate, notes, wares)
                                            .isEmpty
                                        ? const EmptyHolder(
                                            text: "چیزی برای یاد آوری نیست",
                                            icon: Icons.note_outlined,
                                          )
                                        : Column(
                                            children:
                                                ToDoTools.generateNoteList(
                                              onChange: () {
                                                setState(() {});
                                              },
                                              all: ToDoTools
                                                  .getCurrentDayToDoList(
                                                      checkDate, notes, wares),
                                              context: context,
                                            ),
                                          ),
                                  ),
                                  const CustomDivider(
                                    title: "همه یادآور های گذشته",
                                  ),

                                  ///past days check list
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    width: double.maxFinite,
                                    child: ToDoTools.getPastDaysToDoList(
                                                checkDate.add(
                                                    const Duration(hours: 7)))
                                            .isEmpty
                                        ? const SizedBox(
                                            height: 70,
                                            child: Center(
                                                child: Text(
                                                    "چیزی برای یاد آوری نیست")))
                                        : Column(
                                            children:
                                                ToDoTools.generateNoteList(
                                              onChange: () {
                                                setState(() {});
                                              },
                                              all:
                                                  ToDoTools.getPastDaysToDoList(
                                                      checkDate.add(
                                                          const Duration(
                                                              hours: 7))),
                                              context: context,
                                            ),
                                          ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      });
                }),
          ),
        ),
      ),
    );
  }
}



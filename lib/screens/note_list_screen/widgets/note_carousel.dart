import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:hitop_cafe/constants/constants.dart';
import 'package:hitop_cafe/constants/enums.dart';
import 'package:hitop_cafe/constants/utils.dart';
import 'package:hitop_cafe/models/note.dart';
import 'package:hitop_cafe/models/raw_ware.dart';
import 'package:hitop_cafe/screens/note_list_screen/note_list_screen.dart';
import 'package:hitop_cafe/screens/note_list_screen/services/todo_tools.dart';
import 'package:hitop_cafe/services/hive_boxes.dart';
import 'package:hive_flutter/adapters.dart';

/// check list reminder part
class NoteCarouselSlider extends StatelessWidget {
  const NoteCarouselSlider(
      {super.key, required this.onChange, this.width = 600});
  final VoidCallback onChange;
  final double width;
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: LayoutBuilder(builder: (context, constraint) {
        double maxWidth = constraint.maxWidth;
        return Directionality(
          textDirection: TextDirection.rtl,
          child: ValueListenableBuilder(
              valueListenable: HiveBoxes.getRawWare().listenable(),
              builder: (context, valWare, child) {
                return ValueListenableBuilder(
                    valueListenable: HiveBoxes.getNotes().listenable(),
                    builder: (context, valNote, child) {
                      List<Note> notes = valNote.values.toList();
                      List<RawWare> wares = valWare.values.toList();
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: width,
                            alignment: Alignment.centerRight,
                            margin: const EdgeInsets.only(top: 20),
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            decoration: BoxDecoration(
                              gradient: kMainGradiant,
                              borderRadius: (maxWidth < width &&
                                      screenType(context) == ScreenType.mobile)
                                  ? null
                                  : const BorderRadius.horizontal(
                                      left: Radius.circular(18)),
                            ),
                            child: Center(
                              child: ToDoTools.getCurrentDayToDoList(
                                          DateTime.now(), notes, wares)
                                      .isEmpty
                                  ? const Text(
                                      "چیزی برای یادآوری نیست",
                                      style: TextStyle(color: Colors.white),
                                    )
                                  : CarouselSlider(
                                      options: CarouselOptions(
                                          reverse: true,
                                          enlargeStrategy:
                                              CenterPageEnlargeStrategy.height,
                                          enlargeFactor: .5,
                                          enlargeCenterPage: true,
                                          autoPlayInterval:
                                              const Duration(seconds: 3),
                                          autoPlay: true,
                                          height: 100.0),
                                      items: ToDoTools.generateNoteList(
                                        context: context,
                                        onChange: onChange,
                                        all: ToDoTools.getCurrentDayToDoList(
                                            DateTime.now(), notes, wares),
                                      ),
                                    ),
                            ),
                          ),

                          ///go to all notes screen
                          TextButton.icon(
                              onPressed: () {
                                Navigator.pushNamed(context, NoteListScreen.id)
                                    .then((value) {
                                  onChange();
                                });
                              },
                              icon: const Icon(
                                Icons.notes,
                                size: 20,
                              ),
                              label: const Text("مشاهده همه یادآوری ها")),
                        ],
                      );
                    });
              }),
        );
      }),
    );
  }
}

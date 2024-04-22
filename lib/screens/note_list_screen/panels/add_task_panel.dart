import 'package:flutter/material.dart';
import 'package:hitop_cafe/common/time/time.dart';
import 'package:hitop_cafe/common/widgets/custom_button.dart';
import 'package:hitop_cafe/models/note.dart';
import 'package:hitop_cafe/services/hive_boxes.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import 'package:persian_number_utility/persian_number_utility.dart';
import 'package:uuid/uuid.dart';

import '../../../common/widgets/custom_dialog.dart';
import '../../../common/widgets/custom_textfield.dart';

class AddTaskPanel extends StatefulWidget {
  const AddTaskPanel({super.key});

  @override
  State<AddTaskPanel> createState() => _AddTaskPanelState();
}

class _AddTaskPanelState extends State<AddTaskPanel> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController titleController = TextEditingController();
  TextEditingController subTitleController = TextEditingController();
  DateTime deadline = DateTime.now().add(const Duration(days: 1));
  DateTime registrationDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return CustomDialog(
        height: 350,
        title: "افزودن یادداشت",
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Form(
                key:_formKey ,
                child: ListView(
                  children: [
                    CustomTextField(
                      validate: true,
                      label: "عنوان",
                      controller: titleController,
                      maxLength: 100,
                      maxLine: 1,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    CustomTextField(
                      label: "زیرنویس",
                      controller: subTitleController,
                      maxLength: 400,
                      maxLine: 5,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Text(
                          "تاریخ یادآوری:",
                          style: TextStyle(color: Colors.black54, fontSize: 13),
                        ),
                        TextButton(
                          onPressed: () async {
                            Jalali? picked = await TimeTools.chooseDate(context);
                            if (picked != null) {
                              deadline = picked.toDateTime();
                               setState(() {});
                            }
                          },
                          child: Text(
                            deadline.toPersianDate(),
                            style:
                                const TextStyle(color: Colors.blue, fontSize: 18),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            CustomButton(
                width: double.maxFinite,
                text: "افزودن یادداشت",
                onPressed: () {
                  if(_formKey.currentState!.validate()) {
                    Note note = Note()
                      ..title = titleController.text
                      ..subTitle = subTitleController.text
                      ..registrationDate = registrationDate
                      ..deadline = deadline
                      ..noteId = const Uuid().v1();
                    HiveBoxes.getNotes().put(note.noteId, note);
                    Navigator.pop(context, "");
                  }
                })
          ],
        ));
  }
}

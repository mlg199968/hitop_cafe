import 'package:flutter/material.dart';
import 'package:hitop_cafe/common/widgets/custom_text.dart';
import 'package:hitop_cafe/constants/constants.dart';
import 'package:hitop_cafe/models/notice.dart';

class NoticeTile extends StatelessWidget {
  const NoticeTile({
    super.key,
    required this.notice,
    required this.onTap,
    this.height = 80,
  });
  final Notice notice;
  final VoidCallback onTap;
  final double height;
  bool get seen => notice.seen;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Opacity(
        opacity: seen ? .7 : 0.99,
        child: Container(
          alignment: Alignment.centerRight,
          margin: const EdgeInsets.all(5),
          decoration: BoxDecoration(
              color: Colors.white,
              gradient: kMainGradiant,
              borderRadius: BorderRadius.circular(7),
              boxShadow: seen?null:const [
                BoxShadow(
                    blurRadius: 2,
                    offset: Offset(0.1, .7),
                    color: Colors.black54)
              ]),
          height: height,
          child: Opacity(
            opacity: 0.99,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(7),
              child: Stack(
                children: [
                  ///image holder part with faded bottom,
                  Container(
                    width: 200,
                    height: height,
                    decoration: BoxDecoration(
                      image: (notice.image == null || notice.image == "null" || notice.image == "")
                          ? const DecorationImage(
                        image: AssetImage(
                            "assets/icons/notification.png"),
                        alignment: Alignment.centerRight,
                        fit: BoxFit.cover,
                      )
                          : DecorationImage(
                        image: NetworkImage(notice.image!),
                        alignment: Alignment.centerRight,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Container(
                    width: 200,
                    height: height,
                    decoration: const BoxDecoration(
                        backgroundBlendMode: BlendMode.dstIn,
                        gradient: LinearGradient(
                            begin: Alignment.centerRight,
                            end: Alignment.centerLeft,
                            colors: [Colors.white, Colors.transparent],
                            stops: [.5, .9])),
                  ),

                  Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(5),
                    margin: const EdgeInsets.only(right: 150),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Flexible(
                            child: CText(
                              notice.title,
                              color: Colors.white,
                              shadow: kShadow,
                            )),
                        Flexible(
                          child: CText(
                            notice.content ?? "",
                            color: Colors.white70,
                            maxLine: 2,
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
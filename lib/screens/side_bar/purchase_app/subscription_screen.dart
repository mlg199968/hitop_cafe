import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gap/gap.dart';
import 'package:hitop_cafe/common/widgets/action_button.dart';
import 'package:hitop_cafe/common/widgets/custom_alert.dart';
import 'package:hitop_cafe/constants/constants.dart';
import 'package:hitop_cafe/constants/utils.dart';
import 'package:hitop_cafe/models/plan.dart';
import 'package:hitop_cafe/screens/home_screen/home_screen.dart';
import 'package:hitop_cafe/screens/side_bar/purchase_app/plan_screen.dart';
import 'package:hitop_cafe/screens/side_bar/purchase_app/widgets/subscription_timer.dart';
import 'package:hitop_cafe/services/backend_services.dart';
import 'package:persian_number_utility/persian_number_utility.dart';
import 'package:provider/provider.dart';

import '../../../common/widgets/custom_text.dart';
import '../../../common/widgets/dynamic_button.dart';
import '../../../common/widgets/empty_holder.dart';
import '../../../models/subscription.dart';
import '../../../providers/user_provider.dart';

class SubscriptionScreen extends StatefulWidget {
  static const String id = '/subscription-screen';
  const SubscriptionScreen({super.key});

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(builder: (context, userProvider, child) {
      Subscription? subs = userProvider.subscription;
      return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: const Text("وضعیت اشتراک"),
          actions: [
            DynamicButton(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              label: "تازه سازی",
              icon: Icons.refresh_rounded,
              bgColor: Colors.black12,
              iconColor: Colors.teal,
              onPress: () async {
                Map map = await BackendServices.readSubscription(
                    context, subs!.phone,
                    subsId: subs.id.toString());
                if (map["success"] == true) {
                  userProvider.setSubscription(map["subs"]);
                  setState(() {});
                }
              },
            ),
          ],
        ),
        body: Directionality(
          textDirection: TextDirection.rtl,
          child: Container(
            padding: const EdgeInsets.only(top: 80),
            alignment: Alignment.center,
            decoration: const BoxDecoration(gradient: kMainGradiant),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  ///subs user detail
                  Container(
                      margin: const EdgeInsets.all(10),
                      width: 500,
                      height: 150,
                      decoration: BoxDecoration(
                        gradient: kBlackWhiteGradiant,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          const Flexible(
                            child: Align(
                                alignment: Alignment.bottomRight,
                                child: Icon(
                                  Icons.person,
                                  size: 180,
                                )),
                          ),
                          Flexible(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CText(subs?.name,
                                    fontSize: 17, color: Colors.black87),
                                CText(subs?.phone),
                                CText(subs?.email, color: Colors.black87),
                                CText(
                                  "تاریخ ثبت: ${subs?.startDate?.toPersianDateStr()}",
                                  color: Colors.black54,
                                  fontSize: 10,
                                ),
                                const Gap(10),
                                SubscriptionDeadLine(
                                  endDate: subs!.endDate,
                                ),
                              ],
                            ),
                          ),
                        ],
                      )),
                  Wrap(
                    children: [
                      ActionButton(
                        label: "خروج از حساب اشتراکی",
                        icon: Icons.logout,
                        borderRadius: 5,
                        bgColor: Colors.redAccent,
                        onPress: (){
                          showDialog(context: context, builder: (_)=>CustomAlert(
                            title: "آیا از خروج از حساب اشتراکی مطمئن هستید؟",
                            onYes: (){
                              userProvider.setSubscription(null);
                              Navigator.pushNamedAndRemoveUntil(context, HomeScreen.id, (route) => false);
                              setState(() {});
                            },
                          ),
                          );
                        },
                      ),
                      ActionButton(
                        label: "خرید اشتراک جدید",
                        icon: Icons.stars,
                        borderRadius: 5,
                        bgColor: Colors.deepPurple.withOpacity(.8),
                        iconColor: Colors.amberAccent,
                        onPress: (){
                          Navigator.pushNamed(context, PlanScreen.id,arguments: {"phone": subs.phone,"subsId":subs.id});
                        },
                      ),
                    ],
                  ),
                  ///plans list
                  PlanListPart(planList: subs.planList),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}

class PlanListPart extends StatefulWidget {
  const PlanListPart({
    super.key,
    required this.planList,
  });
  final List<Plan>? planList;
  @override
  State<PlanListPart> createState() => _PlanListPartState();
}

class _PlanListPartState extends State<PlanListPart> {
  bool isCollapse = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 450,
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        gradient: kBlackWhiteGradiant,
        color: Colors.white70,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: () {
              isCollapse = !isCollapse;
              setState(() {});
            },
            child: Container(
              padding: const EdgeInsets.all(8.0),
              decoration:
                  const BoxDecoration(border: Border(bottom: BorderSide())),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const CText(
                    "اشتراک های خریداری شده",
                    fontSize: 14,
                  ),
                  const Expanded(child: SizedBox()),
                  Icon(
                    isCollapse
                        ? Icons.keyboard_arrow_down_rounded
                        : Icons.keyboard_arrow_up_rounded,
                  ),
                ],
              ),
            ),
          ),
          AnimatedSize(
            duration: const Duration(milliseconds: 500),
            child: SizedBox(
              height: isCollapse ? 150 : null,
              child: (widget.planList == null || widget.planList!.isEmpty)
                  ? const EmptyHolder(
                      height: 150,
                      text: "اشتراکی یافت نشد",
                      icon: Icons.timelapse_rounded,
                    )
                  : SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children:
                            List.generate(widget.planList!.length, (index) {
                          Plan plan = widget.planList![index];
                          return Container(
                            margin: const EdgeInsets.all(3),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: Colors.white),
                            child: ListTile(
                              leading: const Icon(
                                Icons.star_rounded,
                                color: Colors.amber,
                              ),
                              title: CText("اشتراک ${plan.title}"),
                              subtitle: CText(
                                  "${plan.refId ?? ""} - ${plan.description ?? ""}"),
                              trailing: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  CText(
                                    plan.startDate?.toPersianDate(),
                                    color: Colors.black54,
                                    fontSize: 11,
                                  ),
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      ///discount red holder
                                      if (plan.hasDiscount)
                                        Container(
                                            margin: const EdgeInsets.symmetric(
                                                horizontal: 8),
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 5),
                                            decoration: BoxDecoration(
                                                color: Colors.red,
                                                borderRadius:
                                                    BorderRadius.circular(20)),
                                            child: CText(
                                              "${plan.discount}%"
                                                  .toPersianDigit(),
                                              fontSize: 10,
                                              color: Colors.white,
                                            )),

                                      ///price text
                                      CText(
                                        addSeparator(plan.price),
                                        fontSize: 14,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).reversed.toList(),
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

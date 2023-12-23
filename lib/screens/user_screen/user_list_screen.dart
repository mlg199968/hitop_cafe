import 'package:flutter/material.dart';
import 'package:hitop_cafe/common/widgets/custom_float_action_button.dart';
import 'package:hitop_cafe/common/widgets/custom_search_bar.dart';
import 'package:hitop_cafe/common/widgets/hide_keyboard.dart';
import 'package:hitop_cafe/constants/constants.dart';
import 'package:hitop_cafe/constants/enums.dart';
import 'package:hitop_cafe/models/order.dart';
import 'package:hitop_cafe/models/user.dart';
import 'package:hitop_cafe/screens/orders_screen/add_order_screen.dart';
import 'package:hitop_cafe/screens/user_screen/add_user_screen.dart';
import 'package:hitop_cafe/screens/user_screen/services/user_tools.dart';
import 'package:hitop_cafe/screens/user_screen/widgets/user_tile.dart';
import 'package:hitop_cafe/services/hive_boxes.dart';
import 'package:hive_flutter/adapters.dart';

class UserListScreen extends StatefulWidget {
  static const String id = "/user-list-screen";
  const UserListScreen({Key? key}) : super(key: key);
  @override
  State<UserListScreen> createState() => _UserListScreenState();
}
class _UserListScreenState extends State<UserListScreen> {
  FocusNode focusNode = FocusNode();
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  GlobalKey filterScreenKey = GlobalKey();
  TextEditingController searchCustomerController = TextEditingController();
  final List<String> sortList = [
    SortItem.modifiedDate.value,
    SortItem.createdDate.value,
    SortItem.name.value,
  ];
  String sortItem = SortItem.modifiedDate.value;
  String? keyWord;

  @override
  void didChangeDependencies() {

    super.didChangeDependencies();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return HideKeyboard(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        key: scaffoldKey,
        floatingActionButton: CustomFloatActionButton(
            onPressed: () {
              Navigator.pushNamed(context, AddUserScreen.id);
            }),
        appBar: AppBar(
          backgroundColor: Colors.transparent,

          actions: [
            IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.more_vert,
                size: 30,
              ),
            ),
          ],
          leading: const BackButton(),
          flexibleSpace: Container(
          ),
          title: Container(
            padding: const EdgeInsets.only(right: 5),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("کاربران"),
              ],
            ),
          ),
          elevation: 0,
          automaticallyImplyLeading: false,
        ),
        body:Container(
          padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                ///Search bar
                Container(
                  height: 200,
                  padding: const EdgeInsets.symmetric(horizontal: 30,vertical: 40),
                  decoration: const BoxDecoration(
                      gradient: kMainGradiant,
                      borderRadius: BorderRadius.vertical(bottom: Radius.elliptical(100, 20))
                  ),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: CustomSearchBar(
                        focusNode: focusNode,
                        controller: searchCustomerController,
                        hint: "جست و جو کاربر",
                        onChange: (val) {
                          keyWord = val;
                          setState(() {});
                        },
                        selectedSort: sortItem,
                        sortList: sortList,
                        onSort: (val){
                          sortItem = val;
                          setState(() {});
                        }),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(top: 10),
                  child: ValueListenableBuilder<Box<User>>(
                      valueListenable: HiveBoxes.getUsers().listenable(),
                      builder: (context, box, _) {
                        List<User> userList =
                        box.values.toList().cast<User>();
                        //filter the list in order to the search results
                        List<User> filteredList =userList;
                        UserTools.filterList(userList, keyWord, sortItem);
                        if (filteredList.isNotEmpty) {
                          return UserListPart(
                            userList: filteredList,
                            key: widget.key,
                          );
                          ///empty screen show
                        } else {
                          return Container(
                            height: 400,
                            alignment: Alignment.center,
                            child: const Text(
                              "کاربری یافت نشد!",
                              textDirection: TextDirection.rtl,
                            ),
                          );
                        }
                      }),
                ),
              ],
            ),
          ),
        ),),
    );
  }
}

class UserListPart extends StatefulWidget {
  const UserListPart({Key? key, required this.userList}) : super(key: key);
  final List<User> userList;

  @override
  State<UserListPart> createState() => _CreditListPartState();
}

class _CreditListPartState extends State<UserListPart> {
  User? selectedUser;
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraint) {

      return Wrap(
        runSpacing: 10,
        spacing: 10,
        alignment: WrapAlignment.center,
        children:
        List.generate(
            widget.userList.length,
                (index) {

              if (true) {
                return UserTile(
                  userDetail: widget.userList[index],
                  onSee: () {
                    if (widget.key != null) {
                      Navigator.pop(context, widget.userList[index]);
                    } else {
                      Navigator.pushNamed(context, AddUserScreen.id,
                          arguments: widget.userList[index]);
                    }
                  }, color: Colors.red,
                );
              } else {
                return const SizedBox();
              }
            }),

      );
    });
  }
}

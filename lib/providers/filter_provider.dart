import 'package:flutter/cupertino.dart';
import 'package:hitop_cafe/common/widgets/custom_radio_button.dart';
import 'package:hitop_cafe/models/order.dart';

class FilterProvider extends ChangeNotifier {
  num? minPayable;
  num? maxPayable;
  num? interval;
  DateTime? startCreateDate;
  DateTime? endCreateDate;
   DateTime? startDueDate;
  DateTime? endDueDate;
  List<Order> orderList=[];
  List<num> payableList=[];
  List<DateTime> createDateList=[];
  bool isDueDate=false;
  bool isCreateDate=false;
  ButtonLogic radioButtonValue=ButtonLogic.setVal(false, false, false,true);



  bool compareData(DateTime? dueDate,num payable,DateTime createDate) {
   bool isRight=dataFilter1(dueDate, payable, createDate);

   if(radioButtonValue.notSettle && payable>0 && isRight){
     isRight=true;
   }
   else if(radioButtonValue.settle && payable==0 && isRight){
     isRight=true;
   }
   else if(radioButtonValue.creditor && payable<0 && isRight){

     isRight=true;
   }

   else if(!radioButtonValue.all){
     isRight=false;
   }
   return isRight;
  }

  bool dataFilter1(DateTime? dueDate,num payable,DateTime createDate) {
    bool isRight = false;
    bool dueDateCondition=true;
    bool createDateCondition=true;
    bool payableCondition=true;

    if (startCreateDate != null) {
      // define conditions
      createDateCondition = createDate.isAfter(startCreateDate!) &&
          createDate.isBefore(endCreateDate!);
    }
    if(startDueDate != null && dueDate != null) {
      dueDateCondition=dueDate.isAfter(startDueDate!) && dueDate.isBefore(endDueDate!);
    }else if(dueDate == null){
      if(isDueDate) {
        dueDateCondition=false;
      }
    }
    if(minPayable !=null) {
      payableCondition=(payable/10)>=minPayable! && (payable/10)<=maxPayable!;
    }

    if (createDateCondition && payableCondition && dueDateCondition) {

      return true;
    }
    return isRight;
  }

  void cleanFilterProvider(){
    minPayable  =null;
    maxPayable  =null;
    startDueDate=null;
    endDueDate=null;
    interval    =null;
    startCreateDate=null;
    endCreateDate=null;
    isDueDate=false;
    isCreateDate=false;
    radioButtonValue=ButtonLogic.setVal(false, false, false,true);
  }
}

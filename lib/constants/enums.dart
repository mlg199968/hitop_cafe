

  enum SortItem{
  createdDate("تاریخ ثبت"),
  modifiedDate("تاریخ ویرایش"),
  dueDate("تاریخ تسویه"),
  name("حروف الفبا"),
  amount("موجودی"),
  billNumber("شماره فاکتور"),
  tableNumber("شماره میز");
  const SortItem(this.value);
  final String value;
}

///message type for snackbar
  enum SnackType{
    normal,
    success,
    warning,
    error,
  }
  enum ScreenType{
    mobile,
    tablet,
    desktop
  }

  enum AppType{
  waiter("waiter"),
    main("main");
    const AppType(this.value);
   final String value;
  }

 enum PackType{
  order("order"),
    itemList("itemList"),
    wareList("wareList"),
    respond("respond");
    const PackType(this.value);
   final String value;
  }

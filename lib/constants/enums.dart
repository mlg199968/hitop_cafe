

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

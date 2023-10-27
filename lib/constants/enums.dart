

 enum SortItem{
  createdDate("تاریخ ثبت"),
  modifiedDate("تاریخ ویرایش"),
  dueDate("تاریخ تسویه"),
  name("حروف الفبا"),
  amount("موجودی");
  const SortItem(this.value);
  final String value;
}

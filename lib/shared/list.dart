import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class iconData{

  String title;
  Icon data;

  iconData({this.data, this.title});

}

List<iconData> iconList = [
  iconData(title: 'History', data: Icon(FontAwesomeIcons.history)),
  iconData(title: 'Graph', data: Icon(FontAwesomeIcons.chartPie)),
];

List <String> onboardImageString = [
  'assets/images/onboard1.png',
  'assets/images/pie-chart.png',
  'assets/images/onboard-3.png'
];

List <String> onboardTitle = [
  'Manage Expenses',
  'Visualise your spending habits',
  'Take smarter decisions',
];

List <String> onboardSubTitle = [
  'Now no need to worry where your Pocket money or Income went at month-ends',
  'A visual is always better than some accounting gibberish!',
  'With recurring cycle and past expense records, make even smarter decisions',
];

List<String> expenseCategories = [
  'Food',
  'Fuel',
  'Travel',
  'Misc',
  'Grooming',
  'Home',
  'College Canteen',
];

List<String> addExpenseMode = [
  'Lene Hai',
  'Kharch Diye',
];

List<String> addIncomeMode = [
  'Pocket Money',
  'Others',
];

List<String> viewTransactionsMode = [
  'All',
  'Income',
  'Expense',
];

Map<String, IconData> icons = {
  'Food': Icons.fastfood,
  'Fuel': FontAwesomeIcons.gasPump,
  'Travel': FontAwesomeIcons.car,
  'Misc' : Icons.category,
  'Grooming': Icons.content_cut,
  'Home': Icons.home,
  'College Canteen': FontAwesomeIcons.solidBuilding,
};

List<String> budgetCycleList = [];
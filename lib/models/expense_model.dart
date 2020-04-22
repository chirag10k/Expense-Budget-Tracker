import 'package:cloud_firestore/cloud_firestore.dart';

class Expense {
  final int amount;
  final String textLabel;
  final String category;
  final String expenseMode;
  final Timestamp timestamp;

  Expense({this.amount, this.textLabel, this.category, this.expenseMode, this.timestamp});

}

List<Expense> expList = [];
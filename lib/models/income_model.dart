import 'package:cloud_firestore/cloud_firestore.dart';

class Income {
  final int amount;
  final String source;
  final Timestamp timestamp;

  Income({this.amount, this.source, this.timestamp});

}

List<Income> incomeList = [];

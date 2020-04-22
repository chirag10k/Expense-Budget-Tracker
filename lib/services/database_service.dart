import 'package:budgetingapp/models/expense_model.dart';
import 'package:budgetingapp/models/graph_models.dart';
import 'package:budgetingapp/models/income_model.dart';
import 'package:budgetingapp/models/reminder_model.dart';
import 'package:budgetingapp/models/user_model.dart';
import 'package:budgetingapp/shared/list.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';


class DatabaseService{

  User user;
  DatabaseService({this.user});

  static final Firestore _firestore = Firestore.instance;
  SharedPreferences prefs;

  //Users Collection reference
  final CollectionReference userCollection = _firestore.collection('users');
  //Expense Categories Collection Reference
  final CollectionReference expCategoriesCollection = _firestore.collection('expenseCategories');

  //Map Expense Document Snapshot to List of Expense Objects
  mapExpensesToList(Map map) {
    for(int i = 0; i < map.length; i++){
      Expense expense = Expense(
        amount: map[i]['amount'],
        textLabel: map[i]['textLabel'],
        category: map[i]['category'],
        expenseMode: map[i]['expenseMode'],
        timestamp: map[i]['timestamp'],
      );
      expList.add(expense);
    }
  }

  //Map Income Document Snapshot to List of Income Objects
  mapIncomesToList(Map map) {
    for(int i = 0; i < map.length; i++){
      Income income = Income(
        amount: map[i]['amount'],
        source: map[i]['source'],
        timestamp: map[i]['timestamp'],
      );
      incomeList.add(income);
    }
  }

  //Map Reminders Document Snapshot to List of Reminder Objects
  mapRemindersToList(Map map){
    for(int i = 0; i < map.length; i++){
      Reminder reminder = Reminder(
        time: map[i]['time'],
      );
      reminderList.add(reminder);
    }
  }

  //map user snapshot to user data
  User userDataFromSnapshot(DocumentSnapshot snapshot){
    return User(
      uid: snapshot.data['uid'],
      nickname: snapshot.data['nickname'],
      photoUrl: snapshot.data['photoUrl'],
      email: snapshot.data['email'],
      budgetCycle: snapshot.data['budgetCycle'],
      tExpenseAmount: snapshot.data['totalExpenseAmount'],
      tIncomeAmount: snapshot.data['totalIncomeAmount'],
      balance: snapshot.data['balance'],
    );
  }

  //get user data stream from firebase
  Stream<User> get userData {
    return _firestore.collection('users').document(user.uid).snapshots()
        .map(userDataFromSnapshot);
  }

  //Write data to firestore server for new user
  Future setUserData() async{
    return await userCollection.document(user.uid).setData({
      'uid': user.uid,
      'nickname': user.nickname,
      'email': user.email,
      'photoUrl': user.photoUrl,
      'budgetCycle': 1,
      'balance': 0,
      'totalExpenseAmount': 0,
      'totalIncomeAmount': 0,
    });
  }

  //Update Profile data to server
  Future updateBudgetData() async{
    user.tExpenseAmount = 0;
    user.tIncomeAmount = 0;
    user.balance = 0;
    expList.removeRange(0, expList.length);
    incomeList.removeRange(0, incomeList.length);
    return await userCollection.document(user.uid).updateData({
      'budgetCycle': user.budgetCycle,
      'totalIncomeAmount': user.tIncomeAmount,
      'totalExpenseAmount': user.tExpenseAmount,
      'balance': user.balance,
    });
  }

  //Add Expense
  Future addExpense(int amount, String expMode, String textLabel, String category) async{
    user.tExpenseAmount = user.tExpenseAmount + amount;
    user.balance = user.balance - amount;
  //Expense Collection Reference
    final CollectionReference expenseCollection = _firestore.collection('income-expenses').document(user.uid).collection('budget').document('${user.budgetCycle}').collection('expenses');
    final DocumentReference balanceDocument = _firestore.collection('income-expenses').document(user.uid).collection('budget').document('${user.budgetCycle}');
    final DocumentReference userDocument = userCollection.document('${user.uid}');
    await expenseCollection.add({
      'amount': amount,
      'expenseMode': expMode,
      'textLabel': textLabel ?? '',
      'category': category ?? '',
      'timestamp': FieldValue.serverTimestamp(),
    });
    await balanceDocument.setData({
      'totalExpenseAmount': user.tExpenseAmount,
      'balance': user.balance,
    },
      merge: true,
    );
    await userDocument.setData({
      'totalExpenseAmount': user.tExpenseAmount,
      'balance': user.balance,
    },
    merge: true
    );
  }

  //Add Income
  Future addIncome(int amount, String source) async{
    user.tIncomeAmount = user.tIncomeAmount + amount;
    user.balance = user.balance + amount;
    //Income Collection Reference
    final CollectionReference incomeCollection = _firestore.collection('income-expenses').document(user.uid).collection('budget').document('${user.budgetCycle}').collection('income');
    final DocumentReference balanceDocument = _firestore.collection('income-expenses').document(user.uid).collection('budget').document('${user.budgetCycle}');
    final DocumentReference userDocument = userCollection.document('${user.uid}');
    await incomeCollection.add({
        'amount': amount,
        'source': source ?? '',
        'timestamp': FieldValue.serverTimestamp(),
    });
    await balanceDocument.setData({
      'totalIncomeAmount': user.tIncomeAmount,
      'balance': user.balance,
    },
      merge: true,
    );
    await userDocument.setData({
      'totalIncomeAmount': user.tIncomeAmount,
      'balance': user.balance,
    },
        merge: true
    );
  }

  //Delete Expense
  Future deleteExpense(Timestamp timestamp, int cycle, int amount) async{
    user.balance += amount;
    user.tExpenseAmount -= amount;
    String docID;
    final QuerySnapshot snapshot =
    await _firestore.collection('income-expenses').document(user.uid).collection('budget')
        .document(cycle.toString()).collection('expenses').getDocuments();
    final List<DocumentSnapshot> documents = snapshot.documents;
    if(documents != null){
      for(int i =0; i < documents.length ; i++){
        if(documents[i].data['timestamp'] == timestamp) {
          docID = documents[i].documentID;
        }
      }
    }
    final CollectionReference expenseCollection = _firestore.collection('income-expenses').document(user.uid).collection('budget').document(cycle.toString()).collection('expenses');
    final DocumentReference balanceDocument = _firestore.collection('income-expenses').document(user.uid).collection('budget').document(cycle.toString());
    final DocumentReference userDocument = userCollection.document('${user.uid}');
    await expenseCollection.document(docID).delete();
    await balanceDocument.setData({
      'totalExpenseAmount': user.tExpenseAmount,
      'balance': user.balance,
    },
      merge: true,
    );
    await userDocument.setData({
      'totalExpenseAmount': user.tExpenseAmount,
      'balance': user.balance,
    },
        merge: true
    );
  }

  //Delete Income
  Future deleteIncome(Timestamp timestamp, int cycle, int amount) async{
    user.balance -= amount;
    user.tIncomeAmount -= amount;
    String docID;
    final QuerySnapshot snapshot =
    await _firestore.collection('income-expenses').document(user.uid).collection('budget')
        .document(cycle.toString()).collection('income').getDocuments();
    final List<DocumentSnapshot> documents = snapshot.documents;
    if(documents != null){
      for(int i =0; i < documents.length ; i++){
        if(documents[i].data['timestamp'] == timestamp) {
          docID = documents[i].documentID;
        }
      }
    }
    final CollectionReference incomeCollection = _firestore.collection('income-expenses').document(user.uid).collection('budget').document(cycle.toString()).collection('income');
    final DocumentReference balanceDocument = _firestore.collection('income-expenses').document(user.uid).collection('budget').document(cycle.toString());
    final DocumentReference userDocument = userCollection.document('${user.uid}');
    await incomeCollection.document(docID).delete();
    await balanceDocument.setData({
      'totalIncomeAmount': user.tIncomeAmount,
      'balance': user.balance,
    },
      merge: true,
    );
    await userDocument.setData({
      'totalIncomeAmount': user.tIncomeAmount,
      'balance': user.balance,
    },
        merge: true
    );
  }

  //Get All Budget Cycles
  Future getBudgetCycles() async {
    //Budget Cycle Collection Reference
    final CollectionReference budgetCollectionReference = _firestore.collection('income-expenses').document(user.uid).collection('budget');
    final QuerySnapshot snapshot =
    await budgetCollectionReference.getDocuments();
    final List<DocumentSnapshot> documents = snapshot.documents;
    if(documents.length != 0 && budgetCycleList.length != documents.length){
      budgetCycleList.removeRange(0, budgetCycleList.length);
      for(int i =0; i<documents.length; i++){
        budgetCycleList.add(documents[i].documentID);
      }
    }
  }

  //View all Expense of Users
  Future getExpenses(int cycle) async {
    final QuerySnapshot snapshot =
    await _firestore.collection('income-expenses').document(user.uid)
        .collection('budget').document('$cycle').collection(
        'expenses')
        .orderBy('timestamp', descending: true)
        .getDocuments();
    final List<DocumentSnapshot> documents = snapshot.documents;
//    if (documents.length != expList.length) {
      expList.removeRange(0, expList.length);
      if (documents.length != 0) {
        Map expensesMap = documents.asMap();
        mapExpensesToList(expensesMap);
      }
//    }
    if(documents.length == 0) {
      print('No Expense Data');
    }
  }

  //View all Income of the user
  Future getIncomes(int cycle) async {
    final QuerySnapshot snapshot =
    await _firestore.collection('income-expenses').document(user.uid)
        .collection('budget').document('$cycle').collection(
        'income')
        .orderBy('timestamp', descending: true)
        .getDocuments();
    final List<DocumentSnapshot> documents = snapshot.documents;
//    if (documents.length != incomeList.length) {
      incomeList.removeRange(0, incomeList.length);
      if (documents.length != 0) {
        Map incomeMap = documents.asMap();
        mapIncomesToList(incomeMap);
      }
//    }
    if(documents.length == 0) {
      print('No Income Data');
    }
  }

  //Copying Expenses from expense list for graph plotting
  List<ExpenseItem> getExpenseGraphDetails(){
    List<ExpenseItem> eList = List<ExpenseItem>();
    int flag;

    for(int i = 0; i < expList.length; i++) {
      if (i == 0) {
        ExpenseItem item = ExpenseItem(
          category: '${expList[i].category}',
          amount: expList[i].amount,
        );
        eList.add(item);
      }
      else {
        flag = 1;
        for (int j = 0; j < eList.length; j++) {
          if (eList[j].category == expList[i].category) {
            eList[j].amount += expList[i].amount;
            flag = 0;
          }
        }
        if (flag == 1) {
          ExpenseItem item = ExpenseItem(
            category: '${expList[i].category}',
            amount: expList[i].amount,
          );
          eList.add(item);
        }
      }
    }
    return eList;
  }

  //Copying Income from expense list for graph plotting
  List<IncomeItem> getIncomeGraphDetails(){
    List<IncomeItem> iList = List<IncomeItem>();
    int flag;

    for(int i = 0; i < incomeList.length; i++) {
      if (i == 0) {
        IncomeItem item = IncomeItem(
          source: '${incomeList[i].source}',
          amount: incomeList[i].amount,
        );
        iList.add(item);
      }
      else {
        flag = 1;
        for (int j = 0; j < iList.length; j++) {
          if (iList[j].source == incomeList[i].source) {
            iList[j].amount += incomeList[i].amount;
            flag = 0;
          }
        }
        if (flag == 1) {
          IncomeItem item = IncomeItem(
            source: '${incomeList[i].source}',
            amount: incomeList[i].amount,
          );
          iList.add(item);
        }
      }
    }
    return iList;
  }
  
  //Set Smart Reminders
  Future setReminders(String _picked) async{
    final CollectionReference reminderCollection = _firestore.collection('smart-reminders');
    await reminderCollection.add({
      'time': _picked,
      'timestamp': DateTime.now(),
    });
  }

  //Get Reminder List from Collection
  Future getReminders() async{
    final QuerySnapshot snapshot =
    await _firestore.collection('smart-reminders').orderBy('timestamp', descending: true).getDocuments();
    final List<DocumentSnapshot> documents = snapshot.documents;
    if (documents.length != reminderList.length) {
      reminderList.removeRange(0, reminderList.length);
      if (documents.length != 0) {
        Map remindersMap = documents.asMap();
        mapRemindersToList(remindersMap);
      }
    }
    if(documents.length == 0) {
      print('No Reminder Data');
    }
  }

  //Delete a Reminder
  Future deleteReminder(String time) async{
    String docID;
    final QuerySnapshot snapshot =
    await _firestore.collection('smart-reminders').orderBy('timestamp', descending: true).getDocuments();
    final List<DocumentSnapshot> documents = snapshot.documents;
    if(documents != null){
      for(int i =0; i < documents.length ; i++){
        if(documents[i].data['time'] == time)
          docID = documents[i].documentID;
      }
    }

    final CollectionReference reminderCollection = _firestore.collection('smart-reminders');
    await reminderCollection.document(docID).delete();
  }


}
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'main.dart';
import 'dart:math';

class LoanCalculator extends StatefulWidget {
  @override
  _LoanCalculatorState createState() => _LoanCalculatorState();
}

class _LoanCalculatorState extends State<LoanCalculator> {
  DateTime selectedDate = DateTime.now();

  Color kTextColor = const Color(0xfff28c3e);

  LoanModal modal = LoanModal();

  List<ModalBal> modalList = [];


  int calculateDifference(DateTime start, DateTime end) {
    return (start.year - end.year) * 12 + start.month - end.month;
  }

  List<DateTime> getDaysInBeteween(DateTime startDate, DateTime endDate) {
    List<DateTime> days = [];
    for (int i = startDate.day > 1 ? 1 : 0;
    i <= calculateDifference(endDate, startDate);
    i++) {
      days.add(DateTime(
          startDate.year,
          startDate.month + i,
// In Dart you can set more than. 30 days, DateTime will do the trick
          startDate.day));
    }
    return days;
  }

  double calculateMonthlyPayment(int months, double balance, double r) {
    var loan = (r / 12) + (r / 12) / (pow((1 + (r / 12)), months) - 1);
    var payment = loan * balance;
    return payment;
  }

  int calculateMonths(int year, int month) {
    int totalMonthInYear = 12;
    int totalMonths = year * totalMonthInYear;
    return totalMonths + month;
  }

  int calculateEndDate(int year, int month, DateTime startDate) {
    DateTime endDate;
    //print("Start Date : $startDate");
    /* if(updateDate.day > 1){
      updateDate = DateTime(startDate.year, startDate.month+1, startDate.day);
       endDate = DateTime(updateDate.year+year, updateDate.month+month-1, updateDate.day);
    }else{*/
    endDate =
        DateTime(startDate.year + year, startDate.month + month, startDate.day);
    // }

    print(
        "Dates : ${DateFormat("yyyy-MMMM-dd").format(endDate)} ${DateFormat("yyyy-MMMM-dd").format(startDate)}");

    //print("Months : ${}");
    return calculateDifference(endDate, startDate);
  }

  _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedDate, // Refer step 1
      firstDate: selectedDate,
      lastDate: DateTime(2025),
    );
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        _initialDate.text = DateFormat("dd-MMMM-yyyy").format(selectedDate);
      });
  }

  TextEditingController _initialDate = TextEditingController();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 5,
        title: Text(
          "Loan Calculator",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 5,
                ),
                TextFormField(
                    keyboardType: TextInputType.phone,
                    textInputAction: TextInputAction.next,
                    textAlign: TextAlign.start,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Loan Needed',
                      hintStyle: TextStyle(fontSize: 15.5, color: Colors.white),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                          borderSide: BorderSide(color: kTextColor)),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                          borderSide: BorderSide(color: Colors.grey)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                          borderSide: BorderSide(color: kTextColor)),
                    ),
                    onSaved: (value) {
                      modal.loanNeeded = double.parse(value);
                    }),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                    keyboardType: TextInputType.phone,
                    textAlign: TextAlign.start,
                    style: TextStyle(color: Colors.white),
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      hintText: 'Annual Interest Rate',
                      hintStyle: TextStyle(fontSize: 15.5, color: Colors.white),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                          borderSide: BorderSide(color: kTextColor)),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                          borderSide: BorderSide(color: Colors.grey)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                          borderSide: BorderSide(color: kTextColor)),
                    ),
                    onSaved: (value) {
                      modal.annualInterestRate = double.parse(value);
                    }),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                    keyboardType: TextInputType.phone,
                    textAlign: TextAlign.start,
                    style: TextStyle(color: Colors.white),
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      hintText: 'Initial Deposit',
                      hintStyle: TextStyle(fontSize: 15.5, color: Colors.white),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                          borderSide: BorderSide(color: kTextColor)),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                          borderSide: BorderSide(color: Colors.grey)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                          borderSide: BorderSide(color: kTextColor)),
                    ),
                    onSaved: (value) {
                      modal.initialDeposit = double.parse(value);
                    }),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                    keyboardType: TextInputType.phone,
                    textAlign: TextAlign.start,
                    style: TextStyle(color: Colors.white),
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      hintText: 'Extra Fees',
                      hintStyle: TextStyle(fontSize: 15.5, color: Colors.white),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                          borderSide: BorderSide(color: kTextColor)),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                          borderSide: BorderSide(color: Colors.grey)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                          borderSide: BorderSide(color: kTextColor)),
                    ),
                    onSaved: (value) {
                      modal.extraFees = double.parse(value);
                    }),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width / 2.2,
                      child: TextFormField(
                          keyboardType: TextInputType.phone,
                          style: TextStyle(color: Colors.white),
                          textInputAction: TextInputAction.next,
                          textAlign: TextAlign.start,
                          decoration: InputDecoration(
                            hintText: 'Years',
                            hintStyle:
                            TextStyle(fontSize: 15.5, color: Colors.white),
                            border: OutlineInputBorder(
                                borderRadius:
                                BorderRadius.all(Radius.circular(5.0)),
                                borderSide: BorderSide(color: kTextColor)),
                            enabledBorder: OutlineInputBorder(
                                borderRadius:
                                BorderRadius.all(Radius.circular(5.0)),
                                borderSide: BorderSide(color: Colors.grey)),
                            focusedBorder: OutlineInputBorder(
                                borderRadius:
                                BorderRadius.all(Radius.circular(5.0)),
                                borderSide: BorderSide(color: kTextColor)),
                          ),
                          onSaved: (value) {
                            modal.years = int.parse(value);
                          }),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width / 2.2,
                      child: TextFormField(
                          keyboardType: TextInputType.phone,
                          style: TextStyle(color: Colors.white),
                          textInputAction: TextInputAction.next,
                          textAlign: TextAlign.start,
                          decoration: InputDecoration(
                            hintText: 'Months',
                            hintStyle:
                            TextStyle(fontSize: 15.5, color: Colors.white),
                            border: OutlineInputBorder(
                                borderRadius:
                                BorderRadius.all(Radius.circular(5.0)),
                                borderSide: BorderSide(color: kTextColor)),
                            enabledBorder: OutlineInputBorder(
                                borderRadius:
                                BorderRadius.all(Radius.circular(5.0)),
                                borderSide: BorderSide(color: Colors.grey)),
                            focusedBorder: OutlineInputBorder(
                                borderRadius:
                                BorderRadius.all(Radius.circular(5.0)),
                                borderSide: BorderSide(color: kTextColor)),
                          ),
                          onSaved: (value) {
                            modal.months = int.parse(value);
                          }),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width / 1.2,
                      child: TextFormField(
                        style: TextStyle(color: Colors.white),
                        readOnly: true,
                        controller: _initialDate,
                        keyboardType: TextInputType.phone,
                        textAlign: TextAlign.start,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          hintText: 'Loan Start Date',
                          hintStyle: TextStyle(fontSize: 15.5, color: Colors.white),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(5.0)),
                              borderSide: BorderSide(color: kTextColor)),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(5.0)),
                              borderSide: BorderSide(color: Colors.grey)),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(5.0)),
                              borderSide: BorderSide(color: kTextColor)),
                        ),
                        onSaved: (value) {
                          modal.startDate = selectedDate;
                        },
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.date_range,
                        color: Colors.white,
                        size: 30,
                      ),
                      onPressed: () {
                        _selectDate(context);
                      },
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                MaterialButton(
                  onPressed: () {
                    double payment = calculateMonthlyPayment(360, 240000.00, (3.32 / 100));
                    print(payment.toString());
                /*    if(_formKey.currentState.validate()){
                      _formKey.currentState.save();
                      print("Loan Model : ${modal.toString()}");
                      double loanNeeded = modal.loanNeeded;
                      double extraFees = modal.extraFees;
                      double initialDeposit = modal.initialDeposit;
                      DateTime startDate = modal.startDate;
                      double annualInterest = modal.annualInterestRate;
                      int year = modal.years;
                      int months = modal.months;

                      loanNeeded += extraFees -= initialDeposit;
                      DateTime endDate = DateTime(startDate.year + year, startDate.month + months, startDate.day);
                      int totalMonths = calculateDifference(endDate, startDate);
                      double payment = calculateMonthlyPayment(totalMonths, loanNeeded, (annualInterest / 100));
                      double remainingBalance = loanNeeded;
                      double principle = 0.0;
                      for (int i = startDate.day > 1 ? 1 : 0; startDate.day > 1 ?(i <= totalMonths):(i < totalMonths); i++) {
                        double interest = (((annualInterest / 100) / 12) * remainingBalance);
                        principle = payment - interest;
                        remainingBalance -= principle;
                         modalList.add(ModalBal(date: DateFormat("MMM-yyyy").format(DateTime(startDate.year, startDate.month + i, startDate.day)), payment: payment.toStringAsFixed(2), principle: principle.toStringAsFixed(2), interest: interest.toStringAsFixed(2), balance: remainingBalance.toStringAsFixed(2)));
                        print(
                            "PRINCIPLE : $principle BALANCE : ${remainingBalance > 0 ? remainingBalance : 0.0} INTEREST : $interest Date : ${DateFormat("MMM-yyyy").format(DateTime(startDate.year, startDate.month + i, startDate.day))}");
                      }
                    }*/
                  },
                  height: 50,
                  minWidth: 200,
                  color: Colors.lightGreen,
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    "Calculate",
                    style: TextStyle(color: Colors.black, fontSize: 17),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ModalBal {
  String date;
  String payment;
  String principle;
  String interest;
  String balance;

  ModalBal({this.date, this.payment, this.principle, this.interest, this.balance});
}

class LoanModal {
  double loanNeeded;
  double annualInterestRate;
  double initialDeposit;
  double extraFees;
  int years;
  int months;
  DateTime startDate;

  LoanModal({
    this.loanNeeded,
    this.annualInterestRate,
    this.initialDeposit,
    this.extraFees,
    this.years,
    this.months,
    this.startDate,
  });

  @override
  String toString() {
    return 'LoanModal{loanNeeded: $loanNeeded, annualInterestRate: $annualInterestRate, initialDeposit: $initialDeposit, extraFees: $extraFees, years: $years, months: $months, startDate: $startDate}';
  }
}
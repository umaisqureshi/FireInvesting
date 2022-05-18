import 'package:MOT/shared/colors.dart';
import 'package:MOT/widgets/portfolio/widgets/heading/portfolio_heading.dart';
import 'package:MOT/widgets/widgets/standard/DrawerWidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:MOT/models/compound_cal/compound_calculator_model.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AddCompoundCalculator extends StatefulWidget {
  @override
  _AddCompoundCalculatorState createState() => _AddCompoundCalculatorState();
}

class _AddCompoundCalculatorState extends State<AddCompoundCalculator> {
  String valueChoose;

  String compoundInterval;
  int compoundIntervalValue;

  String interestInterval;

  String depositInterval;

  String withdrawalInterval;
  int years;
  int months = 0;
  bool isSelect = true;

  CompoundCalculatorModel calModel = CompoundCalculatorModel.name();

  List listItem = [
    CompoundInterval.name(name: "Daily", value: 365),
    CompoundInterval.name(name: "Weekly", value: 52),
    CompoundInterval.name(name: "Half-Monthly", value: 24),
    CompoundInterval.name(name: "Monthly", value: 12),
    CompoundInterval.name(name: "Quarterly", value: 4),
    CompoundInterval.name(name: "Half-Yearly", value: 2),
    CompoundInterval.name(name: "Yearly", value: 1),
  ];

  GlobalKey<ScaffoldState> globalKey = GlobalKey<ScaffoldState>();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: globalKey,
      backgroundColor: kScaffoldBackground,
      drawer: DrawerWidget(),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: const AssetImage('assets/images/background.png'),
            fit: BoxFit.fill,
          ),
        ),
        child: SafeArea(
          child: ListView(
            physics: BouncingScrollPhysics(),
            children: [
              PortfolioHeadingSection(
                globalKey: null,
                showAction: false,
                title: "Compound Interest",
                subtitle: "Calculator",
                widget: Container(),
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Form(
                  key: formKey,
                  child: Column(children: [
                    TextFormField(
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                      textAlign: TextAlign.start,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: 'Unique Name',
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
                      validator: (value) {
                        return value.isEmpty ? "Required Field" : null;
                      },
                      onSaved: (value) {
                        calModel.name = value;
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      keyboardType: TextInputType.phone,
                      textInputAction: TextInputAction.next,
                      textAlign: TextAlign.start,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: 'Initial Investment',
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
                      validator: (value) {
                        return value.isEmpty ? "Required Field" : null;
                      },
                      onSaved: (value) {
                        calModel.initialInvestment =
                            double.parse(value ?? "0.0");
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                        keyboardType: TextInputType.phone,
                        textAlign: TextAlign.start,
                        style: TextStyle(color: Colors.white),
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          suffixIcon: Container(
                            width: 30,
                            child: Center(
                              child: Text(
                                "%",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w900,
                                  color: kTextColor,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          hintText: 'Interest Rate',
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
                        validator: (value) {
                          return value.isEmpty ? "Required Field" : null;
                        },
                        onSaved: (value) {
                          calModel.interestRate = double.parse(value ?? "0.0");
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
                              suffixIcon: Container(
                                width: 30,
                                child: Center(
                                  child: Text(
                                    ":",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w900,
                                      color: kTextColor,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                              hintStyle: TextStyle(
                                  fontSize: 15.5, color: Colors.white),
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
                            validator: (value) {
                              return value.isEmpty ? "Required Field" : null;
                            },
                            onSaved: (value) {
                              calModel.yearToMonths =
                                  int.parse(value ?? "0") * 12;
                            },
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width / 2.2,
                          child: TextFormField(
                              keyboardType: TextInputType.phone,
                              style: TextStyle(color: Colors.white),
                              textInputAction: TextInputAction.next,
                              textAlign: TextAlign.start,
                              decoration: InputDecoration(
                                suffixIcon: Container(
                                  width: 30,
                                  child: Center(
                                    child: Text(
                                      ":",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w900,
                                        color: kTextColor,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                                hintText: 'Months',
                                hintStyle: TextStyle(
                                    fontSize: 15.5, color: Colors.white),
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
                                if (value.length > 0) {
                                  calModel.months = int.parse(value ?? "0");
                                } else {
                                  calModel.months = 0;
                                }
                              }),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    DropdownButtonFormField(
                      isExpanded: false,
                      dropdownColor: Colors.black.withOpacity(0.6),
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w400,
                          fontSize: 17),
                      icon: Icon(
                        Icons.arrow_drop_down,
                        color: kTextColor,
                      ),
                      decoration: InputDecoration(
                        hintText: "Compound Interval",
                        contentPadding: EdgeInsets.all(8.0),
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
                      value: compoundInterval,
                      items: listItem
                          .map<DropdownMenuItem<String>>(
                              (value) => DropdownMenuItem(
                            child: Text(value.name),
                            value: value.name,
                            key: ValueKey(value.value),
                          ))
                          .toList(),
                      onSaved: (value) {
                        calModel.interval = listItem
                            .firstWhere((element) => element.name == value)
                            .value;
                      },
                      validator: (value) {
                        return value == null ? "Required Field" : null;
                      },
                      onChanged: (value) {
                        setState(() {
                          compoundInterval = value;
                        });
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      width: double.infinity,
                      child: Text(
                        "Optional",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            color: kTextColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 17),
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: kBlueGrayWithOpacity(300),
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      child: Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius:
                              BorderRadius.all(Radius.circular(11)),
                              border: Border.all(color: Colors.white),
                            ),
                            width: (MediaQuery.of(context).size.width),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      isSelect = !isSelect;
                                    });
                                  },
                                  child: Container(
                                    width: (MediaQuery.of(context).size.width /
                                        2) -
                                        19,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      color: isSelect
                                          ? kTextColor
                                          : Colors.transparent,
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(10),
                                          bottomLeft: Radius.circular(10)),
                                    ),
                                    child: Center(
                                        child: Text(
                                          "Withdrawals",
                                          style: TextStyle(
                                              color: isSelect
                                                  ? Colors.white
                                                  : kTextColor,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 17),
                                        )),
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      isSelect = !isSelect;
                                    });
                                  },
                                  child: Container(
                                    width: (MediaQuery.of(context).size.width /
                                        2) -
                                        19,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      color: !isSelect
                                          ? kTextColor
                                          : Colors.transparent,
                                      borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(10),
                                          bottomRight: Radius.circular(10)),
                                    ),
                                    child: Center(
                                        child: Text(
                                          "Deposits",
                                          style: TextStyle(
                                              color: !isSelect
                                                  ? Colors.white
                                                  : kTextColor,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 17),
                                        )),
                                  ),
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                            keyboardType: TextInputType.phone,
                            textAlign: TextAlign.start,
                            style: TextStyle(color: Colors.white),
                            textInputAction: TextInputAction.next,
                            decoration: InputDecoration(
                              hintText: isSelect ? 'Withdrawals' : 'Deposits',
                              hintStyle: TextStyle(
                                  fontSize: 15.5, color: Colors.white),
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
                              if (value.length > 0) {
                                calModel.initialAmount = double.parse(value);
                              } else {
                                calModel.initialAmount = 0.0;
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      width: double.infinity,
                      child: RaisedButton(
                        color: Theme.of(context).accentColor,
                        onPressed: () {
                          if (formKey.currentState.validate()) {
                            formKey.currentState.save();
                            print(calModel.toString());
                            print(calModel.getTotalMonths);

                          }
                        },
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0)),
                        child: Text(
                          'Calculate',
                          style: Theme.of(context).textTheme.subtitle1,
                        ),
                      ),
                    ),
                  ]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AddCompoundModal extends ModalRoute<CompoundInterval> {
  @override
  Duration get transitionDuration => Duration(milliseconds: 400);

  @override
  bool get opaque => false;

  @override
  bool get barrierDismissible => false;

  @override
  Color get barrierColor {
    return Colors.white.withOpacity(0);
  }

  @override
  String get barrierLabel => null;

  @override
  bool get maintainState => true;

  @override
  Widget buildPage(
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      ) {
    // This makes sure that text and other content follows the material style
    return Material(
      type: MaterialType.transparency,
      // make sure that the overlay content is not cut off
      child: SafeArea(
        //minimum: EdgeInsets.only(top: 0),
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          body: AddCompoundCalculator(
          ),
        ),
      ),
    );
  }

  @override
  Widget buildTransitions(
      BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
    var begin = Offset(0.0, 1.0);
    var end = Offset.zero;
    var tween = Tween(begin: begin, end: end);
    Animation<Offset> offsetAnimation = animation.drive(tween);
    // You can add your own animations for the overlay content
    return SlideTransition(
      position: offsetAnimation,
      child: FadeTransition(
        opacity: animation,
        child: child,
      ),
    );
  }
}


class CompoundInterval {
  String name;
  int value;

  CompoundInterval.name({this.name, this.value});
}

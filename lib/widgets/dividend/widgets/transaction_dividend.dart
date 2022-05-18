import 'package:MOT/bloc/dividend/dividend_bloc.dart';
import 'package:MOT/helpers/symbolSource.dart';
import 'package:MOT/shared/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TransactionDividend extends StatefulWidget {
  @override
  _TransactionDividendState createState() => _TransactionDividendState();
}

class _TransactionDividendState extends State<TransactionDividend> {
  //TextEditingController _symbolController = new TextEditingController();
  //TextEditingController _quantityController = new TextEditingController();

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool valid  = false;
  DividendStock diviStock = DividendStock();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      decoration: new BoxDecoration(
        border: new Border(
            top: new BorderSide(color: Theme.of(context).bottomAppBarColor)),
        color: Theme.of(context).primaryColor,
      ),
      padding:
          const EdgeInsets.only(top: 8.0, bottom: 8.0, right: 16.0, left: 16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: Form(
              key: _formKey,
              child: new Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Stock symbol",
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.white38),
                      ),
                      SizedBox(
                        height: 3,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.3,
                        child: TextFormField(
                          //controller: _symbolController,
                          autofocus: true,
                          onSaved: (value) {
                            diviStock.symbol = value;
                          },
                          onChanged: (value){
                            if(valid){
                              setState(() {
                                valid= !valid;
                              });
                            }
                          },
                          autocorrect: false,
                          textCapitalization: TextCapitalization.characters,
                          decoration: new InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5.0)),
                                borderSide: BorderSide(color: kTextColor)),
                            focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5.0)),
                                borderSide: BorderSide(color: kTextColor)),
                            hintText: "e.g aapl..",
                          ),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Stock Quantity",
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.white38),
                      ),
                      SizedBox(
                        height: 3,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.3,
                        child: TextFormField(
                          onSaved: (value) {
                            diviStock.quantity = int.parse(value);
                          },
                          autocorrect: false,
                          keyboardType: TextInputType.phone,
                          decoration: new InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5.0)),
                                borderSide: BorderSide(color: kTextColor)),
                            focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5.0)),
                                borderSide: BorderSide(color: kTextColor)),
                            hintText: "Quantity..",
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Container(
                  width: double.infinity,
                  child: RaisedButton(
                    elevation: 4.0,
                    color: Theme.of(context).accentColor,
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        _formKey.currentState.save();
                        if (symbolSourceList
                            .any((element) => element == diviStock.symbol)) {
                          BlocProvider.of<DividendBloc>(context).add(
                              SaveDividendSymbol(
                                  symbol: diviStock.symbol,
                                  quantity: diviStock.quantity));
                          Navigator.of(context).pop();
                        }else{
                          setState(() {
                            valid = !valid;
                          });
                        }
                      }
                    },
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0)),
                    child: Text(
                      'Add',
                      style: Theme.of(context).textTheme.subtitle1,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 8,
          ),
          valid?Text(
            "Not a valid Symbol",
            style: TextStyle(
                fontSize: 12, fontWeight: FontWeight.bold, color: Colors.red),
          ):Container(),
        ],
      ),
    );
  }
}

class DividendStock {
  String symbol;
  int quantity;

  DividendStock({this.symbol, this.quantity});
}

import 'package:MOT/models/dividend/dividendModel.dart';
import 'package:flutter/foundation.dart';

class DividendSP {
  final Dividend dividendS;
  final Dividend dividendP;
  final Dividend dividendT;

  DividendSP({
    @required this.dividendS,
    @required this.dividendP,
    @required this.dividendT,
  });

  @override
  String toString() {
    return 'DividendSP{dividendS: ${dividendS.toString()}, dividendP: ${dividendP.toString()}, dividendT: ${dividendT.toString()}}';
  }
}

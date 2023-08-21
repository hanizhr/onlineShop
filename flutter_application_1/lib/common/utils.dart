import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

const defaultScrollPhysics = BouncingScrollPhysics();

extension PriceLabel on int {
  String get withPriceLabel => this > 0 ? '$sepatateByCamma تومان' : 'رایگان';
  String get sepatateByCamma {
    final numberFormat = NumberFormat.decimalPattern();
    return numberFormat.format(this);
  }
}

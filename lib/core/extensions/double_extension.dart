extension DoubleExtension on double {
  String get toMonetaryFormat {
    String strMoney = toStringAsFixed(2);
    if (strMoney.length > 2) {
      String decimal = strMoney.split('.')[1];
      strMoney = strMoney.split('.')[0];
      strMoney = strMoney.replaceAll(RegExp(r'\D'), '');
      strMoney = strMoney.replaceAll(RegExp(r'\B(?=(\d{3})+(?!\d))'), ',');
      strMoney += '.' + decimal;
    }
    return strMoney;
  }
}
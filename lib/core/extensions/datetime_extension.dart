extension DateTimeExtension on DateTime {
  /// Output: 2020-12-12
  String get format {
    return '$year-${month.toString().padLeft(2,'0')}-${day.toString().padLeft(2,'0')}';
  }
  String get ddmmyyyy {
    return '${day.toString().padLeft(2,'0')}/${month.toString().padLeft(2,'0')}/$year';
  }
  String get mmyyyy => '${month.toString().padLeft(2,'0')}/$year';
  String get formatCodeMapping {
    return '$year${month.toString().padLeft(2,'0')}${day.toString().padLeft(2,'0').padLeft(2, '0')}${hour.toString().padLeft(2, '0')}${minute.toString().padLeft(2, '0')}';
  }
  String get formatCodeBranch {
    return '$year${month.toString().padLeft(2,'0')}${day.toString().padLeft(2,'0').padLeft(2, '0')}${hour.toString().padLeft(2, '0')}${minute.toString().padLeft(2, '0')}';
  }
  String get formatDateHuman {
    return '${day.toString().padLeft(2,'0').padLeft(2, '0')}/${month.toString().padLeft(2,'0')}/$year';
  }
  String get formatDateAndTimeHuman {
    return '${day.toString().padLeft(2,'0').padLeft(2, '0')}/${month.toString().padLeft(2,'0')}/$year ${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
  }
  String get formatDateday => '$day de ${getMonthName(month).toLowerCase()} del $year';
  String get formatDateMonth => '${getMonthName(month)} del $year';

  String  getMonthName(int month){
    switch(month){
      case 1:
      return 'Enero';
      case 2:
      return 'Febrero';
      case 3:
      return 'Marzo';
      case 4:
      return 'Abril';
      case 5:
      return 'Mayo';
      case 6:
      return 'Junio';
      case 7:
      return 'Julio';
      case 8:
      return 'Agosto';
      case 9:
      return 'Septiembre';
      case 10:
      return 'Octubre';
      case 11:
      return 'Noviembre';
      case 12:
      return 'Diciembre';
    }
    return '-';
  }

}
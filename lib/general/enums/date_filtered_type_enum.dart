enum DateFilteredType{
  day, month, range
}

extension Extention on DateFilteredType {
  String get parseToString {
    switch (this) {
      case DateFilteredType.day:
        return 'DateFilteredType.day';
      case DateFilteredType.month:
        return 'DateFilteredType.month';
      case DateFilteredType.range:
        return 'DateFilteredType.range';
    }
    return '';
  }

  String get toStringAPI {
    switch (this) {
      case DateFilteredType.day:
        return 'DAY';
      case DateFilteredType.month:
        return 'MONTH';
      case DateFilteredType.range:
        return 'RANGE';
    }
    return '';
  }
}

DateFilteredType dateFilteredTypeFromString(String strDateFilteredType) {
  switch (strDateFilteredType) {
    case 'DateFilteredType.day':
      return DateFilteredType.day;
    case 'DateFilteredType.month':
      return DateFilteredType.month;
    case 'DateFilteredType.range':
      return DateFilteredType.range;
  }
  return null;
}

DateFilteredType dateFilteredTypeFromStringApi(String strDateFilteredType) {
  switch (strDateFilteredType) {
    case 'DAY':
      return DateFilteredType.day;
    case 'MONTH':
      return DateFilteredType.month;
    case 'RANGE':
      return DateFilteredType.range;
  }
  return null;
}
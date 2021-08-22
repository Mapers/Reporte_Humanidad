enum TypeQuery{
  totalMount, request, attentions
}

const TOTAL_MOUNT_TYPE_QUERY = 'TOTAL_MOUNT';
const REQUEST_TYPE_QUERY = 'REQUEST';
const ATTENTION_TYPE_QUERY = 'ATTENTION';

extension Extention on TypeQuery {
  String get parseToString {
    switch (this) {
      case TypeQuery.totalMount:
        return TOTAL_MOUNT_TYPE_QUERY;
      case TypeQuery.request:
        return REQUEST_TYPE_QUERY;
      case TypeQuery.attentions:
        return ATTENTION_TYPE_QUERY;
    }
    return '';
  }

  String get toValue {
    switch (this) {
      case TypeQuery.totalMount:
        return 'Monto Total';
      case TypeQuery.request:
        return 'Pedidos';
      case TypeQuery.attentions:
        return 'Atencciones';
    }
    return '';
  }
}

TypeQuery typeQueryFromString(String strTypeQuery) {
  switch (strTypeQuery) {
    case TOTAL_MOUNT_TYPE_QUERY:
      return TypeQuery.totalMount;
    case REQUEST_TYPE_QUERY:
      return TypeQuery.request;
    case ATTENTION_TYPE_QUERY:
      return TypeQuery.attentions;
  }
  return null;
}
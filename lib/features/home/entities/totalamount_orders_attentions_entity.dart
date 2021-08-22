import 'package:meta/meta.dart';

class TotalAmountOrdersAttentionEntity{
  DateTime lastUpdate;
  double totalAmount;
  int orders;
  int attentions;
  TotalAmountOrdersAttentionEntity({ @required this.lastUpdate, @required this.totalAmount, @required this.orders, @required this.attentions,});

  Map<String, dynamic> get toMap => {
    'LAST_UPDATE': lastUpdate.toString(),
    'TOTAL_AMOUNT': totalAmount,
    'ORDERS': orders,
    'ATTENTIONS': attentions,
  };

  factory TotalAmountOrdersAttentionEntity.fromJsonLocal(Map<String, dynamic> dataJson){
    return TotalAmountOrdersAttentionEntity(
      lastUpdate: DateTime.parse((dataJson['LAST_UPDATE'] as String).trim()),
      totalAmount: (dataJson['TOTAL_AMOUNT'] as num).toDouble(),
      orders: dataJson['ORDERS'],
      attentions: dataJson['ATTENTIONS'],
    );
  }

  static List<TotalAmountOrdersAttentionEntity> fromListJson(List<dynamic> listJson){
    List<TotalAmountOrdersAttentionEntity> list = [];
    listJson.forEach((data) {
      list.add(TotalAmountOrdersAttentionEntity.fromJsonLocal(data));
    });
    return list;
  }

}
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseManager {

  DatabaseManager._privateConstructor();
  static final DatabaseManager _instance = DatabaseManager._privateConstructor();
  factory DatabaseManager() => _instance;

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<String> getUrlBase() async {
    DocumentSnapshot snapshot = await _db.collection('configuracion').doc('YvejnVNXXJ2NJxzDybyx').get();
    final data = snapshot.data();
    if(data == null) return '';
    return data['url_base'];
  }
}
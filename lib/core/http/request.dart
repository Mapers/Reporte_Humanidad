import 'dart:convert';
import 'dart:io';

import 'package:app_reporte_humanidad/core/error/exceptions.dart';
import 'package:app_reporte_humanidad/core/http/response.dart';
import 'package:app_reporte_humanidad/features/access/entities/user_entity.dart';
import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';

const Map<String, String> initalHeaders = {
  'Content-Type': 'application/json'
};

class RequestHttp{

  final http.Client client;

  RequestHttp({@required this.client});

  Future<ResponseHttp> post(String url, { Map<String, String> headers, dynamic data, UserEntity user }) async {
    ResponseHttp response;
    try {
      headers ??= {};
      headers.addAll(initalHeaders);
      if(user != null){
        headers['Authorization'] = 'Bearer ' + user.bearer;
      }
      final http.Response result = await client.post(
        url,
        headers: headers,
        body: data != null ?  jsonEncode(data) : '{}'
      );

      switch (result.statusCode) {
        case 200:
          dynamic decoding = json.decode(result.body);
          if(decoding is List<dynamic>){
            response = ResponseHttp.success({
              'data': decoding
            });
          }else{
            if(decoding['status'] != null){
              if(decoding['status'] == 401){
                throw AuthorizationException(message: 'No autorizado');
              }
            }
            response = ResponseHttp.success(decoding);
          }
          return response;
        case 401:
          throw AuthorizationException(message: 'No autorizado');
        default:
          response = ResponseHttp(success: false, data: null, error: 'Algo ha pasado: ' + result.reasonPhrase);
          return response;
      }
    } on SocketException catch (e) {
      response = ResponseHttp(success: false, data: null, error: e.toString());
    }
    return response;
  }
}
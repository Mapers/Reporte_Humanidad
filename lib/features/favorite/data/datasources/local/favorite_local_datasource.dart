import 'dart:convert';

import 'package:app_reporte_humanidad/features/access/entities/user_entity.dart';
import 'package:app_reporte_humanidad/general/entities/favorite_entity.dart';
import 'package:app_reporte_humanidad/general/entities/specialty_entity.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoriteLocalSource {

  final SharedPreferences sharedPreferences;

  FavoriteLocalSource({this.sharedPreferences});

  Future<List<FavoriteEntity>> getFavorites(List<SpecialtyEntity> allSpecialties, UserEntity user) async{
    List<String> favorites = sharedPreferences.getStringList('FAVORITE_LIST_${user.username}');
    if(favorites == null) return [];
    List<FavoriteEntity> list = FavoriteEntity.fromListString(favorites, allSpecialties);
    return list;
  }

  Future<bool> saveFavorite(FavoriteEntity newFavorite, UserEntity user) async{
    List<String> favorites = sharedPreferences.getStringList('FAVORITE_LIST_${user.username}');
    favorites ??= [];
    favorites.add(jsonEncode(newFavorite.toMap));
    await sharedPreferences.setStringList('FAVORITE_LIST_${user.username}', favorites);
    return true;
  }

  Future<bool> updateFavorite(FavoriteEntity favorite, List<SpecialtyEntity> allSpecialties, UserEntity user) async{
    List<String> favorites = sharedPreferences.getStringList('FAVORITE_LIST_${user.username}');
    favorites ??= [];
    List<String> newStrfavorites = [];
    favorites.forEach((item){
      FavoriteEntity localFavorite = FavoriteEntity.fromJsonLocal(jsonDecode(item), allSpecialties);
      if(localFavorite.id == favorite.id){
        newStrfavorites.add(jsonEncode(favorite.toMap));
      }else{
        newStrfavorites.add(item);
      }
    });
    await sharedPreferences.setStringList('FAVORITE_LIST_${user.username}', newStrfavorites);
    return true;
  }

  Future<bool> removeFavoriteByIndex(String idToDelete, UserEntity user) async{
    List<String> favorites = sharedPreferences.getStringList('FAVORITE_LIST_${user.username}');
    favorites ??= [];
    List<String> newStrfavorites = [];
    favorites.forEach((item){
      FavoriteEntity localFavorite = FavoriteEntity.fromJsonLocalWithoutSpecialites(jsonDecode(item));
      if(localFavorite.id != idToDelete){
        newStrfavorites.add(item);
      }
    });
    await sharedPreferences.setStringList('FAVORITE_LIST_${user.username}', newStrfavorites);
    return true;
  }

  Future<bool> removeAllFavorites(UserEntity user) async{
    return await sharedPreferences.remove('FAVORITE_LIST_${user.username}');
  }
}
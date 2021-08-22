import 'package:app_reporte_humanidad/features/access/data/datasources/local/access_local_datasource.dart';
import 'package:app_reporte_humanidad/features/favorite/data/datasources/local/favorite_local_datasource.dart';
import 'package:app_reporte_humanidad/general/entities/favorite_entity.dart';
import 'package:app_reporte_humanidad/general/entities/specialty_entity.dart';
import 'package:app_reporte_humanidad/general/enums/date_filtered_type_enum.dart';
import 'package:meta/meta.dart';
import 'package:uuid/uuid.dart';

class FavoriteRepository {
  final AccessLocalSource accessLocalSource;
  final FavoriteLocalSource favoriteLocalSource;
  FavoriteRepository(this.accessLocalSource, this.favoriteLocalSource);

  Future<List<FavoriteEntity>> getFavorites({@required List<SpecialtyEntity> allSpecialties}) async => await favoriteLocalSource.getFavorites(allSpecialties, await accessLocalSource.getUser());

  Future<FavoriteEntity> addFavorite(String title, DateFilteredType type, DateTime startDate, DateTime finishDate, List<SpecialtyEntity> specialties) async{
    var uuid = Uuid();
    String id = uuid.v1();
    FavoriteEntity newFavorite = FavoriteEntity(
      id: id,
      title: title,
      dateFilteredType: type,
      startDate: startDate,
      finishDate: finishDate,
      specialties: specialties
    );
    await favoriteLocalSource.saveFavorite(newFavorite, await await accessLocalSource.getUser());
    return newFavorite;
  }

  Future<void> removeFavorite(String idToDelete) async{
    await favoriteLocalSource.removeFavoriteByIndex(idToDelete, await accessLocalSource.getUser());
  }

  Future<bool> get removeAllFavorites async => await favoriteLocalSource.removeAllFavorites(await accessLocalSource.getUser());

  Future<FavoriteEntity> updateFavorite(String id, String title, DateFilteredType type, DateTime startDate, DateTime finishDate, List<SpecialtyEntity> specialties, List<SpecialtyEntity> allSpecialties) async{
    FavoriteEntity newFavorite = FavoriteEntity(
      id: id,
      title: title,
      dateFilteredType: type,
      startDate: startDate,
      finishDate: finishDate,
      specialties: specialties
    );
    await favoriteLocalSource.updateFavorite(newFavorite, allSpecialties, await accessLocalSource.getUser());
    return newFavorite;
  }

}
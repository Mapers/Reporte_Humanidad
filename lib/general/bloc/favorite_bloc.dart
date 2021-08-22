import 'dart:async';

import 'package:app_reporte_humanidad/features/favorite/data/repositories/favorite_repository.dart';
import 'package:app_reporte_humanidad/general/entities/favorite_entity.dart';
import 'package:app_reporte_humanidad/general/entities/specialty_entity.dart';
import 'package:app_reporte_humanidad/general/enums/date_filtered_type_enum.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'favorite_event.dart';
part 'favorite_state.dart';

class FavoriteBloc extends Bloc<FavoriteEvent, FavoriteState> {
  final FavoriteRepository favoriteRepository;
  FavoriteBloc(this.favoriteRepository) : super(LoadingFavoriteState());

  @override
  Stream<FavoriteState> mapEventToState(
    FavoriteEvent event,
  ) async* {
    if(event is GetListFavoriteEvent){
      yield* _getFavoriteList(event.specialties);
    }else if(event is AddFavoriteEvent){
      await favoriteRepository.addFavorite(event.title, event.type, event.startDate, event.finishDate, event.specialties);
      yield* _getFavoriteList(event.specialties);
    }else if(event is RemoveFavoriteEvent){
      await favoriteRepository.removeFavorite(event.idToDelete);
      yield* _getFavoriteList(event.specialties);
    }else if(event is RemoveAllFavoritesEvent){
      await favoriteRepository.removeAllFavorites;
      yield* _getFavoriteList(event.specialties);
    }else if(event is RestartFavoritesEvent){
      yield LoadingFavoriteState();
    }else if(event is UpdateFavoriteEvent){
      await favoriteRepository.updateFavorite(
        event.id,
        event.title,
        event.type,
        event.startDate,
        event.finishDate,
        event.specialties,
        event.allSpecialties
      );
      yield* _getFavoriteList(event.allSpecialties);
    }
  }

  Stream<FavoriteState> _getFavoriteList(List<SpecialtyEntity> allSpecialties) async* {
    yield LoadingFavoriteState();
    List<FavoriteEntity> favorites = await favoriteRepository.getFavorites(allSpecialties: allSpecialties);
    yield DataFavoriteState(favorites: favorites);
  }

}

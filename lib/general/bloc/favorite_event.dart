part of 'favorite_bloc.dart';

abstract class FavoriteEvent extends Equatable {
  const FavoriteEvent();

  @override
  List<Object> get props => [];
}

class GetListFavoriteEvent extends FavoriteEvent{
  final List<SpecialtyEntity> specialties;
  GetListFavoriteEvent({@required this.specialties});
  @override
  List<Object> get props => [];
}

class AddFavoriteEvent extends FavoriteEvent{
  final String title;
  final DateFilteredType type;
  final DateTime startDate;
  final DateTime finishDate;
  final List<SpecialtyEntity> specialties;
  AddFavoriteEvent({@required this.title, @required this.type, @required this.startDate, @required this.finishDate, @required this.specialties});

  @override
  List<Object> get props => [title, type, startDate, finishDate, specialties];
}

class UpdateFavoriteEvent extends FavoriteEvent{
  final String id;
  final String title;
  final DateFilteredType type;
  final DateTime startDate;
  final DateTime finishDate;
  final List<SpecialtyEntity> specialties;
  final List<SpecialtyEntity> allSpecialties;
  UpdateFavoriteEvent({@required this.id, @required this.title, @required this.type, @required this.startDate, @required this.finishDate, @required this.specialties, @required this.allSpecialties});

  @override
  List<Object> get props => [id, title, type, startDate, finishDate, specialties, allSpecialties];
}

class RemoveFavoriteEvent extends FavoriteEvent{
  final String idToDelete;
  final List<SpecialtyEntity> specialties;
  RemoveFavoriteEvent({@required this.idToDelete, @required this.specialties});

  @override
  List<Object> get props => [idToDelete];
}

class RemoveAllFavoritesEvent extends FavoriteEvent{
  final List<SpecialtyEntity> specialties;
  RemoveAllFavoritesEvent({@required this.specialties});
  @override
  List<Object> get props => [];
}

class RestartFavoritesEvent extends FavoriteEvent{}

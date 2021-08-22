part of 'query_filtering_bloc.dart';

abstract class QueryFilteringEvent extends Equatable {
  const QueryFilteringEvent();

  @override
  List<Object> get props => [];
}
class InitialDataQueryFilteringEvent extends QueryFilteringEvent{
  final UserEntity user;
  InitialDataQueryFilteringEvent({@required this.user} );
  @override
  List<Object> get props => [user];
}

class FilteringSpecialitiesQueryFilteringEvent extends QueryFilteringEvent{
  final UserEntity user;
  final List<SpecialtyEntity> newSpecialties;
  FilteringSpecialitiesQueryFilteringEvent({@required this.newSpecialties, @required this.user });
  @override
  List<Object> get props => [newSpecialties];
}

class FilteringDatePerDayQueryFilteringEvent extends QueryFilteringEvent{
  final UserEntity user;
  final DateTime day;
  FilteringDatePerDayQueryFilteringEvent({ @required this.day, @required this.user});
  @override
  List<Object> get props => [day];
}

class FilteringDatePerMonthQueryFilteringEvent extends QueryFilteringEvent{
  final UserEntity user;
  final DateTime month;
  FilteringDatePerMonthQueryFilteringEvent({@required this.month, @required this.user});
  @override
  List<Object> get props => [month,];
}

class FilteringDatePerRangeQueryFilteringEvent extends QueryFilteringEvent{
  final UserEntity user;
  final DateTime dateInitial;
  final DateTime dateFinal;
  FilteringDatePerRangeQueryFilteringEvent({this.dateInitial,this.dateFinal, @required this.user});
  @override
  List<Object> get props => [dateInitial, dateFinal];
}

class FilteringPerFavoriteQueryFilteringEvent extends QueryFilteringEvent{
  final UserEntity user;
  final FavoriteEntity favorite;
  FilteringPerFavoriteQueryFilteringEvent({@required this.user, @required this.favorite});
  @override
  List<Object> get props => [user, favorite];
}

class DataToEditFavoriteQueryFilteringEvent extends QueryFilteringEvent{
  final FavoriteEntity favorite;
  DataToEditFavoriteQueryFilteringEvent({@required this.favorite});
  @override
  List<Object> get props => [favorite];
}

class ReloadingQueryFilteringEvent extends QueryFilteringEvent{
  final UserEntity user;
  final List<SpecialtyEntity> specialties;
  final DateTime dateInitial;
  final DateTime dateFinal;
  final DateFilteredType typeDate;
  final FavoriteEntity favorite;
  ReloadingQueryFilteringEvent({@required this.typeDate, @required this.specialties, @required this.dateInitial, @required this.dateFinal, @required this.user, @required this.favorite});
  @override
  List<Object> get props => [dateInitial, dateFinal, specialties, typeDate];
}

class RestartQueryFilteringEvent extends QueryFilteringEvent{}
class FilterSpecialtiesQueryFilteringEvent extends QueryFilteringEvent{}
class RefreshQueryFilteringEvent extends QueryFilteringEvent{
  final UserEntity user;
  RefreshQueryFilteringEvent({@required this.user} );
  @override
  List<Object> get props => [user];
}

part of 'query_filtering_bloc.dart';

abstract class QueryFilteringState extends Equatable {
  const QueryFilteringState();

  @override
  List<Object> get props => [];
}

class LoadingQueryFilteringState extends QueryFilteringState {
  final DataQueryFilteringState prev;
  LoadingQueryFilteringState(this.prev);

  @override
  List<Object> get props => [prev];
}
class ErrorFilteringState extends QueryFilteringState {
  @override
  List<Object> get props => [];
}

class DataQueryFilteringState extends QueryFilteringState {
  final String lastUpdate;
  final double totalAmount;
  final int ordes;
  final int attentions;
  final DateTime startDate;
  final DateTime finishDate;
  final DateFilteredType typeDate;
  final List<SpecialtyEntity> specialties;
  final bool filterSpecialties;
  final FavoriteEntity favorite;

  DataQueryFilteringState({@required this.lastUpdate, @required this.specialties, @required this.totalAmount, @required this.attentions, @required this.ordes, @required this.typeDate, @required this.startDate, @required this.finishDate, this.filterSpecialties = false, @required this.favorite});

  factory DataQueryFilteringState.initial(){
    return DataQueryFilteringState(
      typeDate: DateFilteredType.day,
      lastUpdate: '-',
      filterSpecialties: false,
      startDate: DateTime.now(),
      finishDate: null,
      specialties: [],
      totalAmount: 0,
      ordes: 0,
      attentions: 0,
      favorite: null,
    );
  }

  DataQueryFilteringState copyWith({ String lastUpdate , List<SpecialtyEntity> specialties,  double totalAmount,  int ordes,  int attentions,  DateFilteredType typeDate,  DateTime startDate, DateTime finishDate, bool filterSpecialties = false, FavoriteEntity favorite}){
    return DataQueryFilteringState(
      lastUpdate: lastUpdate ?? this.lastUpdate,
      totalAmount: totalAmount ?? this.totalAmount,
      ordes: ordes ?? this.ordes,
      attentions: attentions ?? this.attentions,
      startDate: startDate ?? this.startDate,
      finishDate: finishDate ?? this.finishDate,
      typeDate: typeDate ?? this.typeDate,
      specialties: specialties ?? this.specialties,
      filterSpecialties: filterSpecialties,
      favorite: favorite ?? this.favorite
    );
  }

  @override
  List<Object> get props => [lastUpdate, specialties, totalAmount, ordes, attentions, typeDate, startDate, finishDate, filterSpecialties, favorite];
}
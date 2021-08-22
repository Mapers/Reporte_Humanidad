part of 'favorite_bloc.dart';

abstract class FavoriteState extends Equatable {
  const FavoriteState();

  @override
  List<Object> get props => [];
}

class LoadingFavoriteState extends FavoriteState {}

class ErrorFavoriteState extends FavoriteState {
  final String message;
  ErrorFavoriteState({@required this.message});

  @override
  List<Object> get props => [message];
}

class DataFavoriteState extends FavoriteState {
  final List<FavoriteEntity> favorites;
  DataFavoriteState({@required this.favorites});

  @override
  List<Object> get props => [favorites];
}

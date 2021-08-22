part of 'access_bloc.dart';

abstract class AccessState extends Equatable {
  const AccessState();

  @override
  List<Object> get props => [];
}

class CheckingAccessState extends AccessState {
  @override
  List<Object> get props => [];
}

class ErrorAccessState extends AccessState {
  final String message;
  ErrorAccessState({@required this.message});
  @override
  List<Object> get props => [message];
}

class NotHasAccessState extends AccessState {
  final RouteLayout fromRouteLayout;
  final String message;
  final UserEntity rememberedUser;
  NotHasAccessState({this.message, this.rememberedUser, this.fromRouteLayout});
  @override
  List<Object> get props => [message, rememberedUser, fromRouteLayout];
}

class HasAccessState extends AccessState {
  final UserEntity user;

  HasAccessState({
    @required this.user
  });

  @override
  List<Object> get props => [user];
}

class RecoveredAccessState extends AccessState {
  final RouteLayout fromRouteLayout;
  final UserEntity user;

  RecoveredAccessState({
    @required this.user,
    @required this.fromRouteLayout,
  });

  @override
  List<Object> get props => [user, fromRouteLayout];
}

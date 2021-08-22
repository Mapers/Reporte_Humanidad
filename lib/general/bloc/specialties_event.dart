part of 'specialties_bloc.dart';

abstract class SpecialtiesEvent extends Equatable {
  const SpecialtiesEvent();

  @override
  List<Object> get props => [];
}

class GetSpecialtiesEvent extends SpecialtiesEvent{
  final UserEntity user;
  GetSpecialtiesEvent({@required this.user} );

  @override
  List<Object> get props => [user];
}

class RestartSpecialtiesEvent extends SpecialtiesEvent{}

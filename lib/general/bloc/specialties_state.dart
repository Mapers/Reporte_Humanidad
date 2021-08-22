part of 'specialties_bloc.dart';

abstract class SpecialtiesState extends Equatable {
  const SpecialtiesState();

  @override
  List<Object> get props => [];
}

class LoadingSpecialtiesState extends SpecialtiesState {}
class ErrorSpecialtiesState extends SpecialtiesState {}

class DataSpecialtiesState extends SpecialtiesState {
  final List<SpecialtyEntity> specialties;

  DataSpecialtiesState(this.specialties);

  @override
  List<Object> get props => [specialties];
}

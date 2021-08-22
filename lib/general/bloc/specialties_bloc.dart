import 'dart:async';

import 'package:app_reporte_humanidad/core/error/exceptions.dart';
import 'package:app_reporte_humanidad/features/access/entities/user_entity.dart';
import 'package:app_reporte_humanidad/features/home/data/datasources/remote_source/specialty_remote_source.dart';
import 'package:app_reporte_humanidad/general/entities/specialty_entity.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'specialties_event.dart';
part 'specialties_state.dart';

class SpecialtiesBloc extends Bloc<SpecialtiesEvent, SpecialtiesState> {
  final SpecialtyRemoteSource specialtyRemoteSource;
  SpecialtiesBloc(this.specialtyRemoteSource) : super(LoadingSpecialtiesState());

  @override
  Stream<SpecialtiesState> mapEventToState(
    SpecialtiesEvent event,
  ) async* {
    try {
      if(event is GetSpecialtiesEvent){
        yield DataSpecialtiesState([]);
        List<SpecialtyEntity> specialties = await specialtyRemoteSource.getListSpecialty(user: event.user);
        yield DataSpecialtiesState(specialties);
      }else if(event is RestartSpecialtiesEvent){
        yield LoadingSpecialtiesState();
      }
    } on AuthorizationException catch (_) {
      yield ErrorSpecialtiesState();
    }
  }
}

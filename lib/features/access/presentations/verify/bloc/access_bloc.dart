import 'dart:async';
import 'package:app_reporte_humanidad/core/error/exceptions.dart';
import 'package:app_reporte_humanidad/features/access/data/repositories/access_respository.dart';
import 'package:app_reporte_humanidad/features/access/entities/user_entity.dart';
import 'package:app_reporte_humanidad/general/enums/route_layout.dart';
import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'access_event.dart';
part 'access_state.dart';

class AccessBloc extends Bloc<AccessEvent, AccessState> {
  final AccessRepository accessRepository;
  AccessBloc(
    this.accessRepository
  ) : super(CheckingAccessState());

  @override
  Stream<AccessState> mapEventToState(
    AccessEvent event,
  ) async* {
    if(event is VerifyAccessEvent){
      try {
        final result = await Future.wait([
          accessRepository.getUser(),
          accessRepository.saveDeviceInfo()
        ]);
        final userInLocal = result.first as UserEntity;
        if(userInLocal != null){
          if(userInLocal.rememberMe){
            yield NotHasAccessState(rememberedUser: userInLocal);
          }else{
            yield NotHasAccessState();
          }
        }else{
          yield NotHasAccessState();
        }
      } catch (_) {
        yield NotHasAccessState();
      }
    }else if(event is LogInAccessEvent){
      try {
        yield CheckingAccessState();
        accessRepository.removeCredentials();
        UserEntity userEntity = await accessRepository.logIn(username: event.username, password: event.password, rememberMe: event.rememberMe, hasFingerprint: event.hasFingerprint);
        if(event.rememberMe || event.hasFingerprint){
          await accessRepository.saveCredentials(username: event.username, password: event.password, rememberMe: event.rememberMe, hasFingerprint: event.hasFingerprint, bearer: userEntity.bearer);
        }
        yield HasAccessState(user: userEntity);
      } on ServerException catch (e) {
        yield NotHasAccessState(message: e.message);
      }
    }else if(event is LogOutAccessEvent){
      // accessRepository.removeTokenUser();
      yield NotHasAccessState();
    }else if(event is SaveCredentialsAccessEvent){
      try {
        await accessRepository.saveCredentials(username: event.username, password: event.password, rememberMe: event.rememberMe, hasFingerprint: event.hasFingerprint, bearer: event.bearer);
      } on ServerException catch (e) {
        yield NotHasAccessState(message: e.message);
      }
    }else if(event is SetNotHasAccessEvent){
      yield NotHasAccessState();
    }else if(event is UnAuthorizedAccessEvent){
      UserEntity userEntity = await accessRepository.getUser();
      if(userEntity != null){
        if(userEntity.rememberMe){
          yield NotHasAccessState(rememberedUser: userEntity, fromRouteLayout: event.routeLayout);
        }
      }else{
        yield NotHasAccessState(fromRouteLayout: event.routeLayout);
      }
    }else if(event is NotHasWithRememberedUserAccessEvent){
      yield NotHasAccessState(rememberedUser: event.user);
    }else if(event is RecoveredAccessEvent){
      try {
        yield CheckingAccessState();
        accessRepository.removeCredentials();
        UserEntity userEntity = await accessRepository.logIn(username: event.username, password: event.password, rememberMe: event.rememberMe, hasFingerprint: event.hasFingerprint);
        if(event.rememberMe || event.hasFingerprint){
          await accessRepository.saveCredentials(username: event.username, password: event.password, rememberMe: event.rememberMe, hasFingerprint: event.hasFingerprint, bearer: userEntity.bearer);
        }
        yield RecoveredAccessState(user: userEntity, fromRouteLayout: event.routeLayout);
        yield HasAccessState(user: userEntity);
      } on ServerException catch (e) {
        yield NotHasAccessState(message: e.message);
      }
    }
  }
}

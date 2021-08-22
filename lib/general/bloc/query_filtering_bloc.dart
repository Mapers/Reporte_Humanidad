import 'dart:async';
import 'package:app_reporte_humanidad/core/error/exceptions.dart';
import 'package:app_reporte_humanidad/features/access/entities/user_entity.dart';
import 'package:app_reporte_humanidad/features/home/data/datasources/remote_source/totalamount_orders_attentions_remote_source.dart';
import 'package:app_reporte_humanidad/features/home/entities/totalamount_orders_attentions_entity.dart';
import 'package:app_reporte_humanidad/general/entities/favorite_entity.dart';
import 'package:app_reporte_humanidad/general/entities/specialty_entity.dart';
import 'package:app_reporte_humanidad/general/enums/date_filtered_type_enum.dart';
import 'package:app_reporte_humanidad/core/extensions/datetime_extension.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

part 'query_filtering_event.dart';
part 'query_filtering_state.dart';

class QueryFilteringBloc extends Bloc<QueryFilteringEvent, QueryFilteringState> {
  final TotalAmountOrdersAttentionsRemoteSource _totalAmountOrdersAttentionsRemoteSource;
  QueryFilteringBloc(this._totalAmountOrdersAttentionsRemoteSource) : super(LoadingQueryFilteringState(null));

  @override
  Stream<QueryFilteringState> mapEventToState(
    QueryFilteringEvent event,
  ) async* {
    try {
      if(event is InitialDataQueryFilteringEvent){
        DateTime lastUpdate = DateTime.now();
        yield LoadingQueryFilteringState(DataQueryFilteringState.initial());
        TotalAmountOrdersAttentionEntity totalAmountOrdersAttentionss = await _totalAmountOrdersAttentionsRemoteSource.getTotalAmountOrdersAttentions(
          user: event.user,
          dateFilteredtype: DateFilteredType.day,
          dateInitial: lastUpdate,
          listSpecialty: []
        );

        yield DataQueryFilteringState(
          typeDate: DateFilteredType.day,
          startDate: DateTime.now(),
          lastUpdate: totalAmountOrdersAttentionss.lastUpdate.formatDateAndTimeHuman,
          totalAmount: totalAmountOrdersAttentionss.totalAmount,
          ordes: totalAmountOrdersAttentionss.orders,
          attentions: totalAmountOrdersAttentionss.attentions,
          specialties: [],
          favorite: null,
          finishDate: null
        );

      }else if(event is FilteringDatePerDayQueryFilteringEvent){
        DataQueryFilteringState dataQueryFiltering = state;
        yield LoadingQueryFilteringState(dataQueryFiltering.copyWith(
          startDate: event.day,
          typeDate: DateFilteredType.day
        ));
        TotalAmountOrdersAttentionEntity totalAmountOrdersAttentions = await _totalAmountOrdersAttentionsRemoteSource.getTotalAmountOrdersAttentions(
          user: event.user,
          dateFilteredtype: DateFilteredType.day,
          dateInitial: event.day,
          listSpecialty: dataQueryFiltering.specialties
        );
        yield dataQueryFiltering.copyWith(
          typeDate: DateFilteredType.day,
          startDate: event.day,
          lastUpdate: totalAmountOrdersAttentions.lastUpdate.formatDateAndTimeHuman,
          totalAmount: totalAmountOrdersAttentions.totalAmount,
          attentions: totalAmountOrdersAttentions.attentions,
          ordes: totalAmountOrdersAttentions.orders,
        );

      }else if(event is FilteringDatePerMonthQueryFilteringEvent){
        DataQueryFilteringState dataQueryFiltering = state;
        yield LoadingQueryFilteringState(dataQueryFiltering.copyWith(
          startDate: event.month,
          typeDate: DateFilteredType.month
        ));
        TotalAmountOrdersAttentionEntity totalAmountOrdersAttentions = await _totalAmountOrdersAttentionsRemoteSource.getTotalAmountOrdersAttentions(
          user: event.user,
          dateFilteredtype: DateFilteredType.month,
          dateInitial: event.month,
          listSpecialty: dataQueryFiltering.specialties
        );
        yield dataQueryFiltering.copyWith(
          typeDate: DateFilteredType.month,
          startDate: event.month,
          lastUpdate: totalAmountOrdersAttentions.lastUpdate.formatDateAndTimeHuman,
          totalAmount: totalAmountOrdersAttentions.totalAmount,
          attentions: totalAmountOrdersAttentions.attentions,
          ordes: totalAmountOrdersAttentions.orders,
        );

      }else if(event is FilteringDatePerRangeQueryFilteringEvent){
        DataQueryFilteringState dataQueryFiltering = state;
        yield LoadingQueryFilteringState(dataQueryFiltering.copyWith(
          startDate: event.dateInitial,
          finishDate: event.dateFinal,
          typeDate: DateFilteredType.range,
        ));
        TotalAmountOrdersAttentionEntity totalAmountOrdersAttentions = await _totalAmountOrdersAttentionsRemoteSource.getTotalAmountOrdersAttentions(
          user: event.user,
          dateFilteredtype: DateFilteredType.range,
          dateInitial: event.dateInitial,
          dateFinal: event.dateFinal,
          listSpecialty: dataQueryFiltering.specialties
        );
        yield dataQueryFiltering.copyWith(
          typeDate: DateFilteredType.range,
          startDate: event.dateInitial,
          finishDate: event.dateFinal,
          lastUpdate: totalAmountOrdersAttentions.lastUpdate.formatDateAndTimeHuman,
          totalAmount: totalAmountOrdersAttentions.totalAmount,
          attentions: totalAmountOrdersAttentions.attentions,
          ordes: totalAmountOrdersAttentions.orders,
        );

      }else if(event is FilteringSpecialitiesQueryFilteringEvent){
        DataQueryFilteringState dataQueryFiltering = state;
        yield dataQueryFiltering.copyWith(specialties: event.newSpecialties);
        yield LoadingQueryFilteringState(dataQueryFiltering.copyWith(
          specialties: event.newSpecialties
        ));
        TotalAmountOrdersAttentionEntity totalAmountOrdersAttentions = await _totalAmountOrdersAttentionsRemoteSource.getTotalAmountOrdersAttentions(
          user: event.user,
          dateFilteredtype: dataQueryFiltering.typeDate,
          dateInitial: dataQueryFiltering.startDate,
          dateFinal: dataQueryFiltering.finishDate,
          listSpecialty: event.newSpecialties
        );

        yield dataQueryFiltering.copyWith(
          lastUpdate: totalAmountOrdersAttentions.lastUpdate.formatDateAndTimeHuman,
          totalAmount: totalAmountOrdersAttentions.totalAmount,
          attentions: totalAmountOrdersAttentions.attentions,
          ordes: totalAmountOrdersAttentions.orders,
          specialties: event.newSpecialties
        );

      }else if(event is FilteringPerFavoriteQueryFilteringEvent){
        DataQueryFilteringState dataQueryFiltering = state;
        FavoriteEntity favorite = event.favorite;
        yield LoadingQueryFilteringState(dataQueryFiltering.copyWith(
          typeDate: favorite.dateFilteredType,
          startDate: favorite.startDate,
          finishDate: favorite.finishDate,
          specialties: favorite.specialties,
          favorite: event.favorite
        ));
        TotalAmountOrdersAttentionEntity totalAmountOrdersAttentions = await _totalAmountOrdersAttentionsRemoteSource.getTotalAmountOrdersAttentions(
          user: event.user,
          dateFilteredtype: favorite.dateFilteredType,
          dateInitial: favorite.startDate,
          dateFinal: favorite.finishDate,
          listSpecialty: favorite.specialties
        );
        yield dataQueryFiltering.copyWith(
          typeDate: favorite.dateFilteredType,
          startDate: favorite.startDate,
          finishDate: favorite.finishDate,
          lastUpdate: totalAmountOrdersAttentions.lastUpdate.formatDateAndTimeHuman,
          totalAmount: totalAmountOrdersAttentions.totalAmount,
          attentions: totalAmountOrdersAttentions.attentions,
          ordes: totalAmountOrdersAttentions.orders,
          specialties: favorite.specialties,
          favorite: event.favorite
        );
      }else if(event is RestartQueryFilteringEvent){
        yield LoadingQueryFilteringState(null);
      }else if(event is FilterSpecialtiesQueryFilteringEvent){
        DataQueryFilteringState dataQueryFiltering = state;
        yield dataQueryFiltering.copyWith(
          filterSpecialties: !dataQueryFiltering.filterSpecialties
        );
      }else if(event is ReloadingQueryFilteringEvent){
        yield LoadingQueryFilteringState(null);
        TotalAmountOrdersAttentionEntity totalAmountOrdersAttentions = await _totalAmountOrdersAttentionsRemoteSource.getTotalAmountOrdersAttentions(
          user: event.user,
          dateFilteredtype: event.typeDate,
          dateInitial: event.dateInitial,
          dateFinal: event.dateFinal,
          listSpecialty: event.specialties
        );
        yield DataQueryFilteringState(
          typeDate: event.typeDate,
          startDate: event.dateInitial,
          finishDate: event.dateFinal,
          lastUpdate: totalAmountOrdersAttentions.lastUpdate.formatDateAndTimeHuman,
          totalAmount: totalAmountOrdersAttentions.totalAmount,
          attentions: totalAmountOrdersAttentions.attentions,
          ordes: totalAmountOrdersAttentions.orders,
          specialties: event.specialties,
          favorite: event.favorite
        );
      }else if(event is RefreshQueryFilteringEvent){
        DataQueryFilteringState dataQueryFiltering = state;
        yield LoadingQueryFilteringState(dataQueryFiltering);
        TotalAmountOrdersAttentionEntity totalAmountOrdersAttentions = await _totalAmountOrdersAttentionsRemoteSource.getTotalAmountOrdersAttentions(
          user: event.user,
          dateFilteredtype: dataQueryFiltering.typeDate,
          dateInitial: dataQueryFiltering.startDate,
          dateFinal: dataQueryFiltering.finishDate,
          listSpecialty: dataQueryFiltering.specialties
        );
        yield DataQueryFilteringState(
          typeDate: dataQueryFiltering.typeDate,
          startDate: dataQueryFiltering.startDate,
          finishDate: dataQueryFiltering.finishDate,
          lastUpdate: totalAmountOrdersAttentions.lastUpdate.formatDateAndTimeHuman,
          totalAmount: totalAmountOrdersAttentions.totalAmount,
          attentions: totalAmountOrdersAttentions.attentions,
          ordes: totalAmountOrdersAttentions.orders,
          specialties: dataQueryFiltering.specialties,
          favorite: dataQueryFiltering.favorite
        );
      }else if(event is DataToEditFavoriteQueryFilteringEvent){
        DataQueryFilteringState dataQueryFiltering = state;
        FavoriteEntity favorite = event.favorite;
        yield dataQueryFiltering.copyWith(
          typeDate: favorite.dateFilteredType,
          startDate: favorite.startDate,
          finishDate: favorite.finishDate,
          specialties: favorite.specialties,
          favorite: event.favorite
        );
      }
    } on AuthorizationException catch (_) {
      LoadingQueryFilteringState loadingState = state;
      yield ErrorFilteringState();
      yield LoadingQueryFilteringState(loadingState.prev);
    }
  }

  static bool buildWhenHasData(QueryFilteringState previous, QueryFilteringState current){
    if(current is LoadingQueryFilteringState){
      return false;
    }else if(current is ErrorFilteringState){
      return false;
    }
    return true;
  }

  static bool buildWhenNotIsError(QueryFilteringState previous, QueryFilteringState current){
    if(current is ErrorFilteringState){
      return false;
    }
    return true;
  }

}


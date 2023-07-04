import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:gifts_manager/data/http/authorized_api_service.dart';
import 'package:gifts_manager/data/http/model/gift_dto.dart';

part 'gifts_event.dart';

part 'gifts_state.dart';

class GiftsBloc extends Bloc<GiftsEvent, GiftsState> {
  GiftsBloc({
    required this.authorizedApiService,
  }) : super(InitialGiftsLoadingState()) {
    on<GiftsPageLoaded>(_onGiftsPageLoaded);
    on<GiftsLoadingRequest>(_onGiftsLoadingRequest);
  }

  final AuthorizedApiService authorizedApiService;

  final gifts = <GiftDTO>[];
  bool initialErrorHappened = false;

  FutureOr<void> _onGiftsPageLoaded(
    final GiftsPageLoaded event,
    final Emitter<GiftsState> emit,
  ) async {
    await _loadGifts(emit);
  }

  FutureOr<void> _onGiftsLoadingRequest(
      final GiftsLoadingRequest event,
      final Emitter<GiftsState> emit,
      ) async {
    await _loadGifts(emit);
  }

  FutureOr<void> _loadGifts(
    final Emitter<GiftsState> emit,
  ) async {
    if (gifts.isEmpty) {
      emit(InitialGiftsLoadingState());
    }
    final giftsResponse = await authorizedApiService.getAllGifts();
    if (giftsResponse.isLeft) {
      initialErrorHappened = true;
      if (gifts.isEmpty) {
        emit(const InitialLoadingStateError());
      } else {
        //  TODO
      }
    } else {
      //  TODO

      if (giftsResponse.right.gifts.isEmpty) {
        emit(const NoGiftsState());
      } else {
        gifts.addAll(giftsResponse.right.gifts);
      }
    }
  }
}

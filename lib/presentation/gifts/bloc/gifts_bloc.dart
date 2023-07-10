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

  static const _limit = 10;
  final AuthorizedApiService authorizedApiService;
  PaginationInfo paginationInfo = PaginationInfo.initial();

  final gifts = <GiftDTO>[];
  bool initialErrorHappened = false;
  bool loading = false;

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
    if (loading) {
      return;
    }
    if (!paginationInfo.canLoadMore) {
      return;
    }
    loading = true;
    if (gifts.isEmpty) {
      emit(InitialGiftsLoadingState());
    }
    final giftsResponse = await authorizedApiService.getAllGifts(
      limit: _limit,
      offset: paginationInfo.lastLoadedPage * _limit,
    );
    if (giftsResponse.isLeft) {
      initialErrorHappened = true;
      if (gifts.isEmpty) {
        emit(const InitialLoadingStateError());
      } else {
        emit(LoadedGiftsState(
          gifts: gifts,
          showLoading: false,
          showError: true,
        ));
      }
    } else {
      initialErrorHappened = false;
      final canLoadMore = giftsResponse.right.gifts.length == _limit;
      paginationInfo = PaginationInfo(
        canLoadMore: canLoadMore,
        lastLoadedPage: paginationInfo.lastLoadedPage + 1,
      );
      if (gifts.isEmpty && giftsResponse.right.gifts.isEmpty) {
        emit(const NoGiftsState());
      } else {
        gifts.addAll(giftsResponse.right.gifts);
        emit(LoadedGiftsState(
          gifts: gifts,
          showLoading: canLoadMore,
          showError: false,
        ));
      }
    }
    loading = false;
  }
}

class PaginationInfo extends Equatable {
  final bool canLoadMore;
  final int lastLoadedPage;

  const PaginationInfo({
    required this.canLoadMore,
    required this.lastLoadedPage,
  });

  factory PaginationInfo.initial() =>
      PaginationInfo(canLoadMore: true, lastLoadedPage: 0);

  @override
  List<Object?> get props => [canLoadMore, lastLoadedPage];
}

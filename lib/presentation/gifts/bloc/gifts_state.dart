part of 'gifts_bloc.dart';

abstract class GiftsState extends Equatable {
  const GiftsState();
}

class InitialGiftsLoadingState extends GiftsState {
  @override
  List<Object> get props => [];
}

class NoGiftsState extends GiftsState {
  const NoGiftsState();

  @override
  List<Object> get props => [];
}

class InitialLoadingStateError extends GiftsState {
  const InitialLoadingStateError();

  @override
  List<Object> get props => [];
}

class LoadedGiftsState extends GiftsState {
  final List<GiftDTO> gifts;
  final bool showLoading;
  final bool showError;

  const LoadedGiftsState({
    required this.gifts,
    required this.showLoading,
    required this.showError,
  }) : assert(!(showLoading && showError));

  @override
  List<Object> get props => [
        gifts,
        showLoading,
        showError,
      ];
}

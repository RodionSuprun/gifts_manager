part of 'gifts_bloc.dart';

abstract class GiftsEvent extends Equatable {
  const GiftsEvent();
}

class GiftsPageLoaded extends GiftsEvent {
  const GiftsPageLoaded();

  @override
  List<Object?> get props => [];
}


class GiftsLoadingRequest extends GiftsEvent {
  const GiftsLoadingRequest();

  @override
  List<Object?> get props => [];
}
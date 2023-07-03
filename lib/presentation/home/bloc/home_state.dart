part of 'home_bloc.dart';

abstract class HomeState extends Equatable {
  const HomeState();
}

class HomeInitial extends HomeState {
  const HomeInitial();

  @override
  List<Object?> get props => [];
}

class HomeWithUserInfo extends HomeState {
  final UserDto user;
  final List<GiftDTO> gifts;

  const HomeWithUserInfo({
    required this.user,
    required this.gifts,
  });

  @override
  List<Object?> get props => [user, gifts];
}

class HomeLogoutState extends HomeState {
  const HomeLogoutState();

  @override
  List<Object?> get props => [];
}

part of 'create_new_present_bloc.dart';

abstract class NewPresentEvent extends Equatable {
  const NewPresentEvent();
}

class NameChanged extends NewPresentEvent {
  final String name;

  const NameChanged({required this.name});

  @override
  List<Object?> get props => [name];
}

class NameFocusLost extends NewPresentEvent {
  const NameFocusLost();

  @override
  List<Object?> get props => [];
}

class PriceChanged extends NewPresentEvent {
  final String price;

  const PriceChanged({required this.price});

  @override
  List<Object?> get props => [price];
}

class PriceFocusLost extends NewPresentEvent {
  const PriceFocusLost();

  @override
  List<Object?> get props => [];
}

class TargetChanged extends NewPresentEvent {
  final String target;

  const TargetChanged({required this.target});

  @override
  List<Object?> get props => [target];
}

class TargetFocusLost extends NewPresentEvent {
  const TargetFocusLost();

  @override
  List<Object?> get props => [];
}

class LinkChanged extends NewPresentEvent {
  final String link;

  const LinkChanged({required this.link});

  @override
  List<Object?> get props => [link];
}

class LinkFocusLost extends NewPresentEvent {
  const LinkFocusLost();

  @override
  List<Object?> get props => [];
}

class CreatePresent extends NewPresentEvent {
  const CreatePresent();

  @override
  List<Object?> get props => [];
}

class ErrorShowed extends NewPresentEvent {
  const ErrorShowed();

  @override
  List<Object?> get props => [];
}
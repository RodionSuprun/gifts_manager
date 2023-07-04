part of 'create_new_present_bloc.dart';

@immutable
abstract class NewPresentState extends Equatable {
  const NewPresentState();
}

class CreatePresentFieldsInfo extends NewPresentState {
  final CreatePresentNameError? nameError;
  final CreatePresentPriceError? priceError;
  final CreatePresentTargetError? targetError;
  final CreatePresentLinkError? linkError;

  const CreatePresentFieldsInfo({
    this.nameError,
    this.priceError,
    this.targetError,
    this.linkError,
  });

  @override
  List<Object?> get props => [
    nameError,
    priceError,
    targetError,
    linkError,
  ];
}

class CreatePresentInProgress extends NewPresentState {

  const CreatePresentInProgress();

  @override
  List<Object?> get props => [];
}

class CreatePresentCompleted extends NewPresentState {

  const CreatePresentCompleted();

  @override
  List<Object?> get props => [];
}
import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../model/errors.dart';

part 'create_new_present_event.dart';
part 'create_new_present_state.dart';

class NewPresentBloc extends Bloc<NewPresentEvent, NewPresentState> {

  String _name = "";
  bool _highlightNameError = false;
  CreatePresentNameError? _nameError = CreatePresentNameError.empty;

  String _price = "";
  bool _highlightPriceError = false;
  CreatePresentPriceError? _priceError = CreatePresentPriceError.empty;

  String _target = "";
  bool _highlightTargetError = false;
  CreatePresentTargetError? _targetError = CreatePresentTargetError.empty;

  String _link = "";
  bool _highlightLinkError = false;
  CreatePresentLinkError? _linkError = CreatePresentLinkError.empty;


  NewPresentBloc() : super(CreatePresentFieldsInfo()) {
    on<NewPresentEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}

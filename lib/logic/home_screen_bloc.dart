import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'package:task_amit/data/search_model.dart';

abstract class TravelEvent {}

class ChangeCategory extends TravelEvent {
  final int index;
  ChangeCategory(this.index);
}

class TravelState {
  final int selectedIndex;
  TravelState(this.selectedIndex);
}

class TravelBloc extends Bloc<TravelEvent, TravelState> {
  TravelBloc() : super(TravelState(0)) {
    on<ChangeCategory>((event, emit) => emit(TravelState(event.index)));
  }
}

import 'package:flutter_bloc/flutter_bloc.dart';

class SplashAnimationCubit extends Cubit<bool> {
  SplashAnimationCubit() : super(false);

  void startAnimation() {
    emit(true);
    Future.delayed(Duration(seconds: 1), () {
      emit(false);
    });
  }
}

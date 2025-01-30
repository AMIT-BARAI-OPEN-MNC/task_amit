import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_amit/router/pageName.dart';

abstract class NavigationEvent {
  final String route;
  final Map<String, dynamic>? params;
  NavigationEvent(this.route, [this.params]);
}

class NavigateTo extends NavigationEvent {
  NavigateTo(String route, [Map<String, dynamic>? params])
      : super(route, params);
}

class NavigationBloc extends Bloc<NavigationEvent, String> {
  NavigationBloc() : super(Pagename.splash);

  @override
  Stream<String> mapEventToState(NavigationEvent event) async* {
    yield event.route;
  }
}

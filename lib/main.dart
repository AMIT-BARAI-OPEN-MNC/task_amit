import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_amit/core/services/navigationServices.dart';
import 'package:task_amit/core/uttils/responsiveSizeHelper.dart';
import 'package:task_amit/data/local_db/hive_db.dart';
import 'package:task_amit/logic/SplashAnimationCubit.dart';
import 'package:task_amit/logic/bottom_nav_cubit.dart';
import 'package:task_amit/logic/favorit_bloc.dart';
import 'package:task_amit/logic/home_screen_bloc.dart';
import 'package:task_amit/logic/navigation_bloc.dart';
import 'package:task_amit/logic/search_Bloc.dart';
import 'package:task_amit/router/appRoutes.dart';
import 'package:task_amit/router/pageName.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HiveStorage.init();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => FavoriteBloc()),
        BlocProvider(create: (context) => NavigationBloc()),
        BlocProvider(
            create: (context) => SplashAnimationCubit()), // Provide Cubit
        BlocProvider(create: (context) => BottomNavCubit()),
        BlocProvider(create: (context) => TravelBloc()),
        BlocProvider(create: (context) => SearchBloc()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return BlocBuilder<NavigationBloc, String>(
      builder: (context, state) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          navigatorKey: NavigationService.navigatorKey,
          title: 'Travel App',
          initialRoute: Pagename.splash,
          onGenerateRoute: AppRoutes.generateRoute,
        );
      },
    );
  }
}

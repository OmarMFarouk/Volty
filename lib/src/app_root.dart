import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:volty/blocs/analytics_bloc/cubit.dart';
import 'package:volty/blocs/dash_bloc/dash_cubit.dart';
import 'package:volty/blocs/devices_bloc/cubit.dart';
import 'package:volty/src/app_shared.dart';
import 'package:volty/views/auth/index.dart';
import 'package:volty/views/auth/onboarding.dart';
import 'package:volty/views/auth/splash_screen.dart';
import '../blocs/auth_bloc/auth_cubit.dart';

class AppRoot extends StatelessWidget {
  const AppRoot({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => AuthCubit()..initCubit()),
          BlocProvider(create: (context) => DashCubit()),
          BlocProvider(create: (context) => DevicesCubit()),
          BlocProvider(create: (context) => AnalyticsCubit()),
        ],
        child: MaterialApp(
          theme: ThemeData(fontFamily: 'Cairo'),
          title: 'Volty',
          locale: context.locale,
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          restorationScopeId: 'Volty',
          home: FutureBuilder(
            future: AppShared.isFirstOpen(),
            builder: (context, snapshot) {
              if (!AppShared.localStorage.getBool('onboarded')!)
                return OnboardingScreen();
              else if (snapshot.data == true)
                return AuthIndex();
              else if (snapshot.data == false)
                return SplashScreen();
              else
                return OnboardingScreen();
            },
          ),
          debugShowCheckedModeBanner: false,
        ),
      ),
    );
  }
}

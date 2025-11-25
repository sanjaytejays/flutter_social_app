import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medcon/app/authentication/data/impl_auth_repo.dart';
import 'package:medcon/app/authentication/presentation/cubits/auth_cubit.dart';
import 'package:medcon/app/authentication/presentation/cubits/auth_state.dart';
import 'package:medcon/app/authentication/presentation/screens/auth_toggle_screen.dart';
import 'package:medcon/app/home/presentation/screens/home_screen.dart';
import 'package:medcon/app/posts/data/impl_post_repo.dart';
import 'package:medcon/app/posts/presentation/cubit/post_cubit.dart';
import 'package:medcon/app/profile/data/impl_profile_repo.dart';
import 'package:medcon/app/profile/presentation/cubit/profile_cubit.dart';
import 'package:medcon/theme/theme.dart';

/*

 MyApp - the root level of the app

 --------------------------------------------------------------

  Repositories: 
    1. Authentication Repo - will have core functionality and logics of methods of authentication using Firebase Auth

  Bloc Providers: for state management
    1. Authentication
    2. Profile
    3. Post
    4. Search
    5. theme

  Check Authentication state
    1. if authenticated, go to home screen
    2. if not authenticated, go to auth toggle screen(login or register)
  
*/

class MyApp extends StatelessWidget {
  // auth repo
  final authRepo = ImplAuthRepo();
  // profile repo
  final profileRepo = ImplProfileRepo();
  // post repo
  final postRepo = ImplPostRepo();
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // provide authentication cubit
    return MultiBlocProvider(
      providers: [
        // authentication cubit
        BlocProvider<AuthCubit>(
          create: (context) => AuthCubit(authRepo: authRepo)..checkAuthCubit(),
        ),
        // profile cubit
        BlocProvider<ProfileCubit>(
          create: (context) => ProfileCubit(profileRepo: profileRepo),
        ),
        // post cubit
        BlocProvider(create: (context) => PostCubit(postRepo: postRepo)),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        home: BlocConsumer<AuthCubit, AuthState>(
          builder: (context, state) {
            print(state);
            if (state is UnAuthenticated) {
              return const AuthToggleScreen();
            } else if (state is Authenticated) {
              return const HomeScreen();
            } else {
              return Scaffold(
                body: const Center(child: CircularProgressIndicator()),
              );
            }
          },
          // lister for error
          listener: (context, state) {
            print(state);
            if (state is AuthError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  behavior: SnackBarBehavior.floating,
                  duration: const Duration(seconds: 2),
                  content: Text(state.message),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}

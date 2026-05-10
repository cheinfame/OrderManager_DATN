import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:packare_manage_web/blocs/staff_bloc/staff_bloc.dart';
import 'package:packare_manage_web/presentation/dashboard_screen/screens/dashboard_screen.dart';
import 'package:packare_manage_web/presentation/authentication_screens/screens/forgot_password_screen.dart';
import 'package:packare_manage_web/presentation/authentication_screens/screens/login_screen.dart';
import 'blocs/account_bloc/account_bloc.dart';
import 'blocs/order_bloc/order_bloc.dart';
import 'locator.dart';

void main() async {
  // Initialize locator and register dependencies
  await setupLocator();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AccountBloc>(
          create: (context) => locator<AccountBloc>(),
        ),
        BlocProvider<OrderBloc>(
          create: (context) => locator<OrderBloc>(),
        ),
        BlocProvider<StaffBloc>(
          create: (context) => locator<StaffBloc>(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: '/dashboard',
        routes: {
          '/dashboard':
              (context) => DashboardScreen(),
              
          '/login':
               (context) => LoginScreen(),
          '/forgot-password':
               (context) => ForgotPasswordScreen(),
        },
        home: BlocBuilder<AccountBloc, AccountState>(
          builder: (context, state) {
            if (state.status == AccountStatus.success) {
              // return OtpVerificationScreen();
              return DashboardScreen();
            } else if (state.status == AccountStatus.loading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return DashboardScreen();
            }
          },
        ),
      ),
    );
  }
}

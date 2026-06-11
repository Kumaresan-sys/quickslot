import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'app/app_dependencies.dart';
import 'core/config/app_config.dart';
import 'core/theme.dart';
import 'domain/usecases/auth_usecases.dart';
import 'domain/usecases/get_venues_usecase.dart';
import 'domain/usecases/get_slots_usecase.dart';
import 'domain/usecases/booking_usecases.dart';

import 'presentation/blocs/auth/auth_cubit.dart';
import 'presentation/blocs/venue/venue_list_cubit.dart';
import 'presentation/blocs/venue/venue_detail_bloc.dart';
import 'presentation/blocs/booking/my_bookings_cubit.dart';

import 'presentation/pages/login_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final config = await AppConfig.load();
  runApp(QuickSlotApp(config: config));
}

class QuickSlotApp extends StatefulWidget {
  final AppDependencies? dependencies;
  final AppConfig config;
  final bool connectSocket;

  const QuickSlotApp({
    super.key,
    this.dependencies,
    required this.config,
    this.connectSocket = true,
  });

  @override
  State<QuickSlotApp> createState() => _QuickSlotAppState();
}

class _QuickSlotAppState extends State<QuickSlotApp> {
  late final AppDependencies _dependencies;

  @override
  void initState() {
    super.initState();
    _dependencies =
        widget.dependencies ??
        AppDependencies.create(
          config: widget.config,
          connectSocket: widget.connectSocket,
        );
  }

  @override
  void dispose() {
    _dependencies.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubit>(
          create: (_) => AuthCubit(
            loginUseCase: LoginUseCase(_dependencies.authRepository),
            logoutUseCase: LogoutUseCase(_dependencies.authRepository),
            checkAuthUseCase: CheckAuthUseCase(_dependencies.authRepository),
          )..checkAuth(), // Check auth on startup
        ),
        BlocProvider<VenueListCubit>(
          create: (_) => VenueListCubit(
            getVenuesUseCase: GetVenuesUseCase(_dependencies.venueRepository),
          ),
        ),
        BlocProvider<VenueDetailBloc>(
          create: (_) => VenueDetailBloc(
            getSlotsUseCase: GetSlotsUseCase(_dependencies.venueRepository),
            bookSlotUseCase: BookSlotUseCase(_dependencies.bookingRepository),
            slotUpdateSource: _dependencies.socketClient,
            bookingFailureClassifier: _dependencies.bookingFailureClassifier,
          ),
        ),
        BlocProvider<MyBookingsCubit>(
          create: (_) => MyBookingsCubit(
            getUserBookingsUseCase: GetUserBookingsUseCase(
              _dependencies.bookingRepository,
            ),
            cancelBookingUseCase: CancelBookingUseCase(
              _dependencies.bookingRepository,
            ),
          ),
        ),
      ],
      child: MaterialApp(
        title: 'QuickSlot',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.dark, // Defaulting to premium dark mode
        home: const LoginPage(),
      ),
    );
  }
}

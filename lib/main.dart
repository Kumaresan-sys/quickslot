import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/theme.dart';
import 'core/network/api_client.dart';
import 'core/network/token_storage.dart';
import 'core/network/socket_client.dart';

import 'data/repositories/auth_repository_impl.dart';
import 'data/repositories/venue_repository_impl.dart';
import 'data/repositories/booking_repository_impl.dart';

import 'domain/usecases/auth_usecases.dart';
import 'domain/usecases/get_venues_usecase.dart';
import 'domain/usecases/get_slots_usecase.dart';
import 'domain/usecases/booking_usecases.dart';

import 'presentation/blocs/auth/auth_cubit.dart';
import 'presentation/blocs/venue/venue_list_cubit.dart';
import 'presentation/blocs/venue/venue_detail_bloc.dart';
import 'presentation/blocs/booking/my_bookings_cubit.dart';

import 'presentation/pages/login_page.dart';

void main() {
  runApp(const QuickSlotApp());
}

class QuickSlotApp extends StatefulWidget {
  const QuickSlotApp({super.key});

  @override
  State<QuickSlotApp> createState() => _QuickSlotAppState();
}

class _QuickSlotAppState extends State<QuickSlotApp> {
  // Core Utils
  late final TokenStorage _tokenStorage;
  late final ApiClient _apiClient;
  late final SocketClient _socketClient;

  // Repositories
  late final AuthRepositoryImpl _authRepository;
  late final VenueRepositoryImpl _venueRepository;
  late final BookingRepositoryImpl _bookingRepository;

  @override
  void initState() {
    super.initState();
    _tokenStorage = TokenStorage();
    _apiClient = ApiClient(baseUrl: 'http://10.0.2.2:5001', tokenStorage: _tokenStorage);
    _socketClient = SocketClient(url: 'ws://10.0.2.2:5001');

    _authRepository = AuthRepositoryImpl(apiClient: _apiClient, tokenStorage: _tokenStorage);
    _venueRepository = VenueRepositoryImpl(apiClient: _apiClient);
    _bookingRepository = BookingRepositoryImpl(apiClient: _apiClient);
    
    // Connect to WebSocket
    _socketClient.connect();
  }

  @override
  void dispose() {
    _socketClient.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubit>(
          create: (_) => AuthCubit(
            loginUseCase: LoginUseCase(_authRepository),
            logoutUseCase: LogoutUseCase(_authRepository),
            checkAuthUseCase: CheckAuthUseCase(_authRepository),
          )..checkAuth(), // Check auth on startup
        ),
        BlocProvider<VenueListCubit>(
          create: (_) => VenueListCubit(
            getVenuesUseCase: GetVenuesUseCase(_venueRepository),
          ),
        ),
        BlocProvider<VenueDetailBloc>(
          create: (_) => VenueDetailBloc(
            getSlotsUseCase: GetSlotsUseCase(_venueRepository),
            bookSlotUseCase: BookSlotUseCase(_bookingRepository),
            socketClient: _socketClient,
          ),
        ),
        BlocProvider<MyBookingsCubit>(
          create: (_) => MyBookingsCubit(
            getUserBookingsUseCase: GetUserBookingsUseCase(_bookingRepository),
            cancelBookingUseCase: CancelBookingUseCase(_bookingRepository),
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

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quickslot/core/theme.dart';
import 'package:quickslot/domain/entities/user.dart';
import 'package:quickslot/domain/usecases/auth_usecases.dart';
import 'package:quickslot/presentation/blocs/auth/auth_cubit.dart';
import 'package:quickslot/presentation/pages/login_page.dart';
import 'package:quickslot/presentation/widgets/booking_bar.dart';
import 'package:quickslot/presentation/widgets/state_views.dart';

class _LoginStub implements Login {
  @override
  Future<User> call(String email, String password) async {
    return User(id: 'user1', name: 'Test User', email: email);
  }
}

class _LogoutStub implements Logout {
  @override
  Future<void> call() async {}
}

class _CheckAuthStub implements CheckAuth {
  @override
  Future<User?> call() async => null;
}

void main() {
  Widget themed(Widget child) {
    return MaterialApp(
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      home: child,
    );
  }

  testWidgets('login form shows practical validation messages', (tester) async {
    await tester.pumpWidget(
      themed(
        BlocProvider(
          create: (_) => AuthCubit(
            loginUseCase: _LoginStub(),
            logoutUseCase: _LogoutStub(),
            checkAuthUseCase: _CheckAuthStub(),
          ),
          child: const LoginPage(),
        ),
      ),
    );

    await tester.enterText(find.byType(TextFormField).at(0), '');
    await tester.enterText(find.byType(TextFormField).at(1), '');
    await tester.tap(find.text('Log in'));
    await tester.pump();

    expect(find.text('Enter your email address.'), findsOneWidget);
    expect(find.text('Enter your password.'), findsOneWidget);

    await tester.enterText(find.byType(TextFormField).at(0), 'not-an-email');
    await tester.enterText(find.byType(TextFormField).at(1), '12345');
    await tester.tap(find.text('Log in'));
    await tester.pump();

    expect(find.text('Enter a valid email address.'), findsOneWidget);
    expect(
      find.text('Password must be at least 6 characters.'),
      findsOneWidget,
    );
  });

  testWidgets('error state shows retry action', (tester) async {
    var retryCount = 0;

    await tester.pumpWidget(
      themed(
        Scaffold(
          body: StateViews.error(
            'Something went wrong. Please try again.',
            onRetry: () => retryCount++,
          ),
        ),
      ),
    );

    expect(find.text('Try again'), findsOneWidget);
    await tester.tap(find.text('Try again'));
    expect(retryCount, 1);
  });

  testWidgets('offline error state uses clear offline copy', (tester) async {
    await tester.pumpWidget(
      themed(
        Scaffold(
          body: StateViews.error(
            'You\'re offline. Check your connection and try again.',
            onRetry: () {},
          ),
        ),
      ),
    );

    expect(find.text('No connection'), findsOneWidget);
    expect(
      find.text('You\'re offline. Check your connection and try again.'),
      findsOneWidget,
    );
  });

  testWidgets('booking button is disabled until a slot is selected', (
    tester,
  ) async {
    await tester.pumpWidget(
      themed(
        const Scaffold(
          body: BookingBar(selectedSlot: null, isLoading: false, onBook: null),
        ),
      ),
    );

    final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
    expect(button.onPressed, isNull);
    expect(find.text('Choose a time'), findsOneWidget);
  });
}

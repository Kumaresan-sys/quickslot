import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/theme.dart';
import '../blocs/booking/my_bookings_cubit.dart';
import '../blocs/auth/auth_cubit.dart';
import '../utils/app_feedback.dart';
import '../widgets/booking_card.dart';
import '../widgets/state_views.dart';

class MyBookingsPage extends StatefulWidget {
  const MyBookingsPage({super.key});

  @override
  State<MyBookingsPage> createState() => _MyBookingsPageState();
}

class _MyBookingsPageState extends State<MyBookingsPage> {
  @override
  void initState() {
    super.initState();
    final authState = context.read<AuthCubit>().state;
    if (authState is AuthAuthenticated) {
      context.read<MyBookingsCubit>().loadBookings(authState.user.id);
    }
  }

  void _confirmCancel(String bookingId, String userId) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Cancel this booking?'),
        content: const Text(
          'This slot will become available to others after cancellation.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Keep booking'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              context.read<MyBookingsCubit>().cancelBooking(bookingId, userId);
            },
            child: const Text(
              'Cancel booking',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Bookings')),
      body: BlocConsumer<MyBookingsCubit, MyBookingsState>(
        listener: (context, state) {
          if (state is MyBookingsError) {
            AppFeedback.showError(context, state.message);
          }
        },
        builder: (context, state) {
          if (state is MyBookingsLoading || state is MyBookingsInitial) {
            return StateViews.loading();
          } else if (state is MyBookingsEmpty) {
            return StateViews.empty(
              'No Bookings',
              'Your upcoming venue reservations will appear here.',
              icon: Icons.event_busy_outlined,
            );
          } else if (state is MyBookingsLoaded) {
            final authState = context.read<AuthCubit>().state;
            final userId = authState is AuthAuthenticated
                ? authState.user.id
                : '';

            return RefreshIndicator(
              onRefresh: () =>
                  context.read<MyBookingsCubit>().loadBookings(userId),
              child: ListView.builder(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.lg,
                  AppSpacing.sm,
                  AppSpacing.lg,
                  AppSpacing.xl,
                ),
                itemCount: state.bookings.length + 1,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.lg),
                      child: Text(
                        'Manage your upcoming bookings and cancellations.',
                        style: TextStyle(color: context.appColors.mutedText),
                      ),
                    );
                  }
                  final booking = state.bookings[index - 1];
                  return BookingCard(
                    booking: booking,
                    onCancel: () => _confirmCancel(booking.id, userId),
                  );
                },
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}

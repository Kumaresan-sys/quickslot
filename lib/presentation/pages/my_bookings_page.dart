import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/booking/my_bookings_cubit.dart';
import '../blocs/auth/auth_cubit.dart';
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
        title: const Text('Cancel Booking?'),
        content: const Text('Are you sure you want to cancel this booking?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              context.read<MyBookingsCubit>().cancelBooking(bookingId, userId);
            },
            child: const Text(
              'Yes, Cancel',
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
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is MyBookingsLoading || state is MyBookingsInitial) {
            return StateViews.loading();
          } else if (state is MyBookingsEmpty) {
            return StateViews.empty(
              'No Bookings',
              'You haven\'t booked any slots yet.',
            );
          } else if (state is MyBookingsLoaded) {
            final authState = context.read<AuthCubit>().state;
            final userId = authState is AuthAuthenticated
                ? authState.user.id
                : '';

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: state.bookings.length,
              itemBuilder: (context, index) {
                final booking = state.bookings[index];
                return BookingCard(
                  booking: booking,
                  onCancel: () => _confirmCancel(booking.id, userId),
                );
              },
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}

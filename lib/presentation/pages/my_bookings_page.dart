import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../blocs/booking/my_bookings_cubit.dart';
import '../blocs/auth/auth_cubit.dart';
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
            child: const Text('Yes, Cancel', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Bookings'),
      ),
      body: BlocConsumer<MyBookingsCubit, MyBookingsState>(
        listener: (context, state) {
          if (state is MyBookingsError) {
             ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message), backgroundColor: Colors.red),
            );
          }
        },
        builder: (context, state) {
          if (state is MyBookingsLoading || state is MyBookingsInitial) {
            return StateViews.loading();
          } else if (state is MyBookingsEmpty) {
            return StateViews.empty('No Bookings', 'You haven\'t booked any slots yet.');
          } else if (state is MyBookingsLoaded) {
            final authState = context.read<AuthCubit>().state;
            final userId = authState is AuthAuthenticated ? authState.user.id : '';

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: state.bookings.length,
              itemBuilder: (context, index) {
                final booking = state.bookings[index];
                final isConfirmed = booking.status == 'CONFIRMED';
                final dateStr = DateFormat('MMM d, yyyy').format(DateTime.parse(booking.bookingDate));

                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              dateStr,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: isConfirmed ? Colors.green.withValues(alpha: 0.1) : Colors.red.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                booking.status,
                                style: TextStyle(
                                  color: isConfirmed ? Colors.green : Colors.red,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            )
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text('${booking.venueName ?? 'Unknown Venue'} - ${booking.location ?? 'Unknown Location'}', style: const TextStyle(fontSize: 14)),
                        const SizedBox(height: 4),
                        Text('Time: ${booking.slotTime ?? 'Unknown Time'}', style: const TextStyle(fontSize: 14, color: Colors.grey)),
                        const SizedBox(height: 16),
                        if (isConfirmed)
                          Align(
                            alignment: Alignment.centerRight,
                            child: OutlinedButton(
                              onPressed: () => _confirmCancel(booking.id, userId),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.red, side: const BorderSide(color: Colors.red),
                              ),
                              child: const Text('Cancel Booking'),
                            ),
                          )
                      ],
                    ),
                  ),
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

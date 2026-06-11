import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../domain/entities/booking.dart';

class BookingCard extends StatelessWidget {
  final Booking booking;
  final VoidCallback? onCancel;

  const BookingCard({super.key, required this.booking, this.onCancel});

  bool get _isConfirmed => booking.status == 'CONFIRMED';

  @override
  Widget build(BuildContext context) {
    final date = DateFormat(
      'MMM d, yyyy',
    ).format(DateTime.parse(booking.bookingDate));

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
                  date,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                _BookingStatusBadge(
                  status: booking.status,
                  isConfirmed: _isConfirmed,
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              '${booking.venueName ?? 'Unknown Venue'} - ${booking.location ?? 'Unknown Location'}',
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 4),
            Text(
              'Time: ${booking.slotTime ?? 'Unknown Time'}',
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            if (_isConfirmed && onCancel != null)
              Align(
                alignment: Alignment.centerRight,
                child: OutlinedButton(
                  onPressed: onCancel,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red,
                    side: const BorderSide(color: Colors.red),
                  ),
                  child: const Text('Cancel Booking'),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _BookingStatusBadge extends StatelessWidget {
  final String status;
  final bool isConfirmed;

  const _BookingStatusBadge({required this.status, required this.isConfirmed});

  @override
  Widget build(BuildContext context) {
    final color = isConfirmed ? Colors.green : Colors.red;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

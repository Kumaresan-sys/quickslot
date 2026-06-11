import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateSelectorBar extends StatelessWidget {
  final String selectedDate;
  final VoidCallback onSelectDate;

  const DateSelectorBar({
    super.key,
    required this.selectedDate,
    required this.onSelectDate,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Theme.of(context).cardColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Select Date', style: TextStyle(color: Colors.grey)),
              const SizedBox(height: 4),
              Text(
                DateFormat(
                  'EEE, MMM d, yyyy',
                ).format(DateTime.parse(selectedDate)),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.calendar_month, color: Colors.blueAccent),
            onPressed: onSelectDate,
          ),
        ],
      ),
    );
  }
}

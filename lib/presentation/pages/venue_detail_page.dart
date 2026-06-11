import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../domain/entities/venue.dart';
import '../../../domain/entities/slot.dart';
import '../blocs/venue/venue_detail_bloc.dart';
import '../blocs/venue/venue_detail_event.dart';
import '../blocs/venue/venue_detail_state.dart';
import '../widgets/booking_bar.dart';
import '../widgets/date_selector_bar.dart';
import '../widgets/slot_grid.dart';
import '../widgets/state_views.dart';

class VenueDetailPage extends StatefulWidget {
  final Venue venue;

  const VenueDetailPage({super.key, required this.venue});

  @override
  State<VenueDetailPage> createState() => _VenueDetailPageState();
}

class _VenueDetailPageState extends State<VenueDetailPage> {
  DailySlot? _selectedSlot;

  @override
  void initState() {
    super.initState();
    // Fetch slots for today
    context.read<VenueDetailBloc>().add(
      LoadSlotsEvent(
        venueId: widget.venue.id,
        date: DateFormat('yyyy-MM-dd').format(DateTime.now()),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final currentState = context.read<VenueDetailBloc>().state;
    final currentDate = DateTime.parse(currentState.selectedDate);

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: currentDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
    );
    if (picked != null && picked != currentDate) {
      if (!context.mounted) return;
      setState(() {
        _selectedSlot = null; // Clear selection on date change
      });
      context.read<VenueDetailBloc>().add(
        LoadSlotsEvent(
          venueId: widget.venue.id,
          date: DateFormat('yyyy-MM-dd').format(picked),
        ),
      );
    }
  }

  void _handleBook() {
    if (_selectedSlot == null) return;

    final state = context.read<VenueDetailBloc>().state;

    context.read<VenueDetailBloc>().add(
      BookSlotEvent(
        venueId: widget.venue.id,
        slotId: _selectedSlot!.slotId,
        date: state.selectedDate,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.venue.name)),
      body: BlocConsumer<VenueDetailBloc, VenueDetailState>(
        listener: (context, state) {
          if (state is BookingSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Booking Successful!'),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.pop(context); // Go back to venue list
          } else if (state is BookingConflict) {
            setState(() {
              _selectedSlot = null; // Clear selected slot as it's taken
            });
            showDialog(
              context: context,
              builder: (ctx) => AlertDialog(
                title: const Text('Slot Unavailable'),
                content: Text(state.message),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(ctx).pop(),
                    child: const Text('OK'),
                  ),
                ],
              ),
            );
          } else if (state is VenueDetailError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          return Column(
            children: [
              DateSelectorBar(
                selectedDate: state.selectedDate,
                onSelectDate: () => _selectDate(context),
              ),
              const Divider(height: 1),
              Expanded(
                child: Builder(
                  builder: (ctx) {
                    if (state is VenueDetailLoading) {
                      return StateViews.loading();
                    } else if (state is VenueDetailEmpty) {
                      return StateViews.empty(
                        'No Slots',
                        'There are no slots available for this date.',
                      );
                    }

                    return SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Available Slots',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          SlotGrid(
                            slots: state.slots,
                            selectedSlotId: _selectedSlot?.slotId,
                            onSlotSelected: (slot) {
                              setState(() {
                                _selectedSlot = slot;
                              });
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              BookingBar(
                selectedSlot: _selectedSlot,
                isLoading: state is BookingInProgress,
                onBook: _handleBook,
              ),
            ],
          );
        },
      ),
    );
  }
}

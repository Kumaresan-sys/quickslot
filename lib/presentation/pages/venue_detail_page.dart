import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../core/theme.dart';
import '../../../domain/entities/venue.dart';
import '../../../domain/entities/slot.dart';
import '../blocs/venue/venue_detail_bloc.dart';
import '../blocs/venue/venue_detail_event.dart';
import '../blocs/venue/venue_detail_state.dart';
import '../blocs/auth/auth_cubit.dart';
import '../widgets/booking_bar.dart';
import '../widgets/date_selector_bar.dart';
import '../widgets/slot_grid.dart';
import '../widgets/state_views.dart';
import '../utils/app_feedback.dart';

class VenueDetailPage extends StatefulWidget {
  final Venue venue;

  const VenueDetailPage({super.key, required this.venue});

  @override
  State<VenueDetailPage> createState() => _VenueDetailPageState();
}

class _VenueDetailPageState extends State<VenueDetailPage> {
  DailySlot? _selectedSlot;

  String? get _currentUserId {
    final authState = context.read<AuthCubit>().state;
    if (authState is AuthAuthenticated) return authState.user.id;
    return null;
  }

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
      _releaseSelectedSlot();
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

  void _handleSlotSelected(DailySlot slot) {
    final userId = _currentUserId;
    if (userId == null) {
      AppFeedback.showError(context, 'Please log in again.');
      return;
    }

    _releaseSelectedSlot();
    setState(() {
      _selectedSlot = slot;
    });

    context.read<VenueDetailBloc>().add(
      HoldSlotEvent(
        venueId: widget.venue.id,
        slotId: slot.slotId,
        date: context.read<VenueDetailBloc>().state.selectedDate,
        userId: userId,
      ),
    );
  }

  void _releaseSelectedSlot() {
    final selectedSlot = _selectedSlot;
    final userId = _currentUserId;
    if (selectedSlot == null || userId == null) return;

    context.read<VenueDetailBloc>().add(
      ReleaseSlotEvent(
        venueId: widget.venue.id,
        slotId: selectedSlot.slotId,
        date: context.read<VenueDetailBloc>().state.selectedDate,
        userId: userId,
      ),
    );
  }

  void _clearSelectionIfTaken(VenueDetailState state) {
    final selectedSlot = _selectedSlot;
    if (selectedSlot == null || state.slots.isEmpty) return;

    DailySlot? updatedSlot;
    for (final slot in state.slots) {
      if (slot.slotId == selectedSlot.slotId) {
        updatedSlot = slot;
        break;
      }
    }
    if (updatedSlot == null) return;

    final userId = _currentUserId;
    final heldByOther =
        updatedSlot.status == 'HELD' && updatedSlot.heldByUserId != userId;
    final booked = updatedSlot.status == 'BOOKED';
    if (!heldByOther && !booked) return;

    setState(() {
      _selectedSlot = null;
    });
    AppFeedback.showError(
      context,
      booked
          ? 'That slot was just booked. Choose another time.'
          : 'That slot is being selected by another user.',
    );
  }

  @override
  void dispose() {
    _releaseSelectedSlot();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.venue.name)),
      body: BlocConsumer<VenueDetailBloc, VenueDetailState>(
        listener: (context, state) {
          _clearSelectionIfTaken(state);
          if (state is BookingSuccess) {
            _selectedSlot = null;
            AppFeedback.showSuccess(context, 'Booking confirmed.');
            Navigator.pop(context); // Go back to venue list
          } else if (state is BookingConflict) {
            setState(() {
              _selectedSlot = null; // Clear selected slot as it's taken
            });
            showDialog(
              context: context,
              builder: (ctx) => AlertDialog(
                title: const Text('Slot no longer available'),
                content: Text(state.message),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(ctx).pop(),
                    child: const Text('Choose another slot'),
                  ),
                ],
              ),
            );
          } else if (state is VenueDetailError) {
            AppFeedback.showError(context, state.message);
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
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  'Available slots',
                                  style: Theme.of(context).textTheme.titleLarge,
                                ),
                              ),
                              Text(
                                'Live updates',
                                style: TextStyle(
                                  color: context.appColors.success,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          const SlotLegend(),
                          const SizedBox(height: 16),
                          SlotGrid(
                            slots: state.slots,
                            selectedSlotId: _selectedSlot?.slotId,
                            onSlotSelected: _handleSlotSelected,
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

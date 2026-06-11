import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/theme.dart';
import '../blocs/venue/venue_list_cubit.dart';
import '../blocs/auth/auth_cubit.dart';
import '../widgets/state_views.dart';
import '../widgets/venue_card.dart';
import 'venue_detail_page.dart';
import 'my_bookings_page.dart';
import 'login_page.dart';

class VenueListPage extends StatefulWidget {
  const VenueListPage({super.key});

  @override
  State<VenueListPage> createState() => _VenueListPageState();
}

class _VenueListPageState extends State<VenueListPage> {
  @override
  void initState() {
    super.initState();
    context.read<VenueListCubit>().loadVenues();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Find a venue'),
        actions: [
          IconButton(
            icon: const Icon(Icons.list_alt_rounded),
            tooltip: 'My Bookings',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const MyBookingsPage()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout_rounded),
            tooltip: 'Logout',
            onPressed: () {
              context.read<AuthCubit>().logout();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const LoginPage()),
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<VenueListCubit, VenueListState>(
        builder: (context, state) {
          if (state is VenueListLoading || state is VenueListInitial) {
            return StateViews.loading();
          } else if (state is VenueListError) {
            return StateViews.error(
              state.message,
              onRetry: () {
                context.read<VenueListCubit>().loadVenues();
              },
            );
          } else if (state is VenueListEmpty) {
            return StateViews.empty(
              'No Venues Found',
              'We are expanding to more courts and venues soon.',
              icon: Icons.stadium_outlined,
            );
          } else if (state is VenueListLoaded) {
            return RefreshIndicator(
              onRefresh: () => context.read<VenueListCubit>().loadVenues(),
              child: ListView.builder(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.lg,
                  AppSpacing.sm,
                  AppSpacing.lg,
                  AppSpacing.xl,
                ),
                itemCount: state.venues.length + 1,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.lg),
                      child: Text(
                        'Choose a venue to view live slot availability.',
                        style: TextStyle(color: context.appColors.mutedText),
                      ),
                    );
                  }
                  final venue = state.venues[index - 1];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.lg),
                    child: VenueCard(
                      venue: venue,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => VenueDetailPage(venue: venue),
                          ),
                        );
                      },
                    ),
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

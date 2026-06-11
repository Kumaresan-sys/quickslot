import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
        title: const Text('Venues'),
        actions: [
          IconButton(
            icon: const Icon(Icons.list_alt),
            tooltip: 'My Bookings',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const MyBookingsPage()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
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
              'We are currently expanding to your area!',
            );
          } else if (state is VenueListLoaded) {
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: state.venues.length,
              itemBuilder: (context, index) {
                final venue = state.venues[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
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
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}

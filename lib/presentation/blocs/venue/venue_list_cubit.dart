import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../domain/entities/venue.dart';
import '../../../domain/usecases/get_venues_usecase.dart';
import '../../utils/error_message_mapper.dart';

abstract class VenueListState extends Equatable {
  const VenueListState();
  @override
  List<Object?> get props => [];
}

class VenueListInitial extends VenueListState {}

class VenueListLoading extends VenueListState {}

class VenueListLoaded extends VenueListState {
  final List<Venue> venues;
  const VenueListLoaded(this.venues);
  @override
  List<Object?> get props => [venues];
}

class VenueListEmpty extends VenueListState {}

class VenueListError extends VenueListState {
  final String message;
  const VenueListError(this.message);
  @override
  List<Object?> get props => [message];
}

class VenueListCubit extends Cubit<VenueListState> {
  final GetVenues getVenuesUseCase;

  VenueListCubit({required this.getVenuesUseCase}) : super(VenueListInitial());

  Future<void> loadVenues() async {
    emit(VenueListLoading());
    try {
      final venues = await getVenuesUseCase();
      if (venues.isEmpty) {
        emit(VenueListEmpty());
      } else {
        emit(VenueListLoaded(venues));
      }
    } catch (e) {
      emit(VenueListError(ErrorMessageMapper.map(e)));
    }
  }
}

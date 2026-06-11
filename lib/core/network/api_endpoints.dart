class ApiEndpoints {
  static const authLogin = '/auth/login';
  static const authLogout = '/auth/logout';
  static const authRefresh = '/auth/refresh';
  static const venues = '/venues';
  static const bookings = '/bookings';
  static const slotsSuffix = '/slots';

  const ApiEndpoints._();

  static String venueSlots(String venueId) => '$venues/$venueId$slotsSuffix';

  static String userBookings(String userId) => '/users/$userId/bookings';

  static String booking(String bookingId) => '$bookings/$bookingId';
}

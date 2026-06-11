abstract class BookingFailureClassifier {
  bool isConflict(Object error);
}

class ApiBookingFailureClassifier implements BookingFailureClassifier {
  const ApiBookingFailureClassifier();

  @override
  bool isConflict(Object error) {
    final message = error.toString().toLowerCase();
    return message.contains('409') ||
        message.contains('conflict') ||
        message.contains('already booked');
  }
}

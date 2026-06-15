DateTime appointmentCalendarDateOnly(DateTime date) =>
    DateTime(date.year, date.month, date.day);

bool isPastAppointmentCalendarDate(DateTime date) {
  final now = DateTime.now();
  final today = appointmentCalendarDateOnly(now);
  return appointmentCalendarDateOnly(date).isBefore(today);
}

bool isPastAppointmentDateTime(DateTime dateTime) =>
    dateTime.isBefore(DateTime.now());

bool canCreateAppointmentAtSlot({
  required DateTime dateTime,
  required bool allowBackdatedAppointments,
}) {
  if (allowBackdatedAppointments) return true;
  if (isPastAppointmentCalendarDate(dateTime)) return false;
  return !isPastAppointmentDateTime(dateTime);
}

bool isAppointmentDaySelectable({
  required DateTime day,
  required bool allowBackdatedAppointments,
  DateTime? preservedCalendarDate,
}) {
  if (allowBackdatedAppointments) return true;
  final normalized = appointmentCalendarDateOnly(day);
  if (!isPastAppointmentCalendarDate(normalized)) return true;
  if (preservedCalendarDate == null) return false;
  return appointmentCalendarDateOnly(preservedCalendarDate) == normalized;
}

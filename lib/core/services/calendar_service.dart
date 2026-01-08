import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/calendar/v3.dart';
import 'package:extension_google_sign_in_as_googleapis_auth/extension_google_sign_in_as_googleapis_auth.dart';
import '../models/event_model.dart';

/// Service to interact with Google Calendar API
class CalendarService {
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [CalendarApi.calendarEventsScope],
  );

  /// Add an event to the signed-in user's primary calendar
  Future<void> addToCalendar(EventModel event) async {
    try {
      // Get authenticated client from google_sign_in extension
      final client = await _googleSignIn.authenticatedClient();

      if (client == null) {
        // Not signed in with Google or silent sign-in failed
        throw Exception(
            'User is not signed in with Google. Cannot access Calendar.');
      }

      final calendarApi = CalendarApi(client);

      // Construct DateTime from event.date and event.time ("HH:MM")
      final timeParts = event.time.split(':');
      final hour = int.parse(timeParts[0]);
      final minute = int.parse(timeParts[1]);

      final startDateTime = DateTime(
        event.date.year,
        event.date.month,
        event.date.day,
        hour,
        minute,
      );

      // Default duration: 1 hour
      final endDateTime = startDateTime.add(const Duration(hours: 1));

      final googleEvent = Event(
        summary: event.name,
        description: event.description,
        location: event.location,
        start: EventDateTime(
          dateTime: startDateTime,
          // If we don't specify timeZone, it uses the time as-is (UTC/Local conversion matters)
          // For simplicity, we send the DateTime object which dart serializes to RFC3339
        ),
        end: EventDateTime(
          dateTime: endDateTime,
        ),
      );

      // Insert event to 'primary' calendar
      await calendarApi.events.insert(googleEvent, 'primary');
    } catch (e) {
      throw Exception('Failed to add event to Google Calendar: $e');
    }
  }
}

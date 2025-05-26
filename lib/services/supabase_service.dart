import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/booking.dart';

class SupabaseService {
  final SupabaseClient _client = Supabase.instance.client;

  // Create a new booking
  Future<Booking> createBooking(Booking booking) async {
    final response = await _client
        .from('bookings')
        .insert(booking.toMap())
        .select()
        .single();
    return Booking.fromMap(response);
  }

  // Get all bookings for a user
  // Get all bookings for the current user
  Future<List<Booking>> getUserBookings() async {
    final user = _client.auth.currentUser;
    if (user == null) {
      throw Exception('User not authenticated');
    }

    final response = await _client
        .from('bookings')
        .select()
        .eq('user_id', user.id) // Filter by user_id
        .order('bookingDate', ascending: false);
    return response.map((json) => Booking.fromMap(json)).toList();
  }

  // Get a single booking by ID
  Future<Booking?> getBooking(String bookingId) async {
    try {
      final response =
          await _client.from('bookings').select().eq('id', bookingId).single();

      if (response != null) {
        return Booking.fromMap(response);
      }
      return null;
    } catch (e) {
      print('Error getting booking: $e');
      return null;
    }
  }

  // Update booking status
  Future<void> updateBookingStatus(String bookingId, String status) async {
    try {
      await _client.from('bookings').update({
        'status': status,
        'updated_at': DateTime.now().toIso8601String()
      }).eq('id', bookingId);
      print('Updated booking $bookingId status to $status');
    } catch (e) {
      print('Error updating booking status: $e');
      rethrow;
    }
  }

  // Add feedback to booking
  Future<void> addFeedback(String id, String feedback, int rating) async {
    await _client.from('bookings').update({
      'feedback': feedback,
      'rating': rating,
      'status': 'Completed'
    }).eq('id', id);
  }

  // Subscribe to booking updates
  Stream<Booking> subscribeToBooking(String id) {
    return _client
        .from('bookings')
        .stream(primaryKey: ['id'])
        .eq('id', id)
        .map((events) => Booking.fromMap(events.first));
  }

  // Get a stream of booking updates - alias for subscribeToBooking
  Stream<Booking> getBookingStream(String bookingId) {
    return _client
        .from('bookings')
        .stream(primaryKey: ['id'])
        .eq('id', bookingId)
        .map((event) => Booking.fromMap(event.first));
  }

  // Get the current user ID
  String? getCurrentUserId() {
    return _client.auth.currentUser?.id;
  }

  // Subscribe to all bookings for a user
  Stream<List<Booking>> subscribeToUserBookings(String userId) {
    return _client
        .from('bookings')
        .stream(primaryKey: ['id'])
        .eq('user_id', userId)
        .order('bookingDate', ascending: false)
        .map((events) => events.map((json) => Booking.fromMap(json)).toList());
  }

  // Add a method to update only tracking related fields
  Future<void> updateBookingTracking(
      Map<String, dynamic> updates, String bookingId) async {
    try {
      await _client.from('bookings').update(updates).eq('id', bookingId);
      // print('Updated booking $bookingId tracking details'); // uncomment for debugging
    } catch (e) {
      print('Error updating specific booking tracking details: $e');
      rethrow;
    }
  }

  // Add a method to delete a booking
  Future<void> deleteBooking(String bookingId) async {
    try {
      await _client.from('bookings').delete().eq('id', bookingId);
      print('Deleted booking with ID: $bookingId');
    } catch (e) {
      print('Error deleting booking: $e');
      rethrow;
    }
  }
}

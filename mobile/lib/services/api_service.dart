import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/court.dart';
import '../models/booking.dart';

class ApiService {
  // Update this to your backend URL
  static const String baseUrl = 'http://localhost:8000/api';

  final http.Client _client;

  ApiService({http.Client? client}) : _client = client ?? http.Client();

  Future<List<Court>> getCourts() async {
    final response = await _client.get(
      Uri.parse('$baseUrl/v1/courts'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['success'] == true) {
        return (data['data'] as List)
            .map((court) => Court.fromJson(court))
            .toList();
      }
      throw Exception(data['message'] ?? 'Failed to load courts');
    }
    throw Exception('Failed to load courts: ${response.statusCode}');
  }

  Future<Court> getCourt(int id) async {
    final response = await _client.get(
      Uri.parse('$baseUrl/v1/courts/$id'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['success'] == true) {
        return Court.fromJson(data['data']);
      }
      throw Exception(data['message'] ?? 'Failed to load court');
    }
    throw Exception('Failed to load court: ${response.statusCode}');
  }

  Future<Booking> createBooking({
    required int courtId,
    required String guestName,
    required String guestEmail,
    required String guestPhone,
    required DateTime bookingDate,
    required String startTime,
    required String endTime,
    String? notes,
  }) async {
    final response = await _client.post(
      Uri.parse('$baseUrl/v1/bookings'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'court_id': courtId,
        'guest_name': guestName,
        'guest_email': guestEmail,
        'guest_phone': guestPhone,
        'booking_date': bookingDate.toIso8601String().split('T')[0],
        'start_time': startTime,
        'end_time': endTime,
        'notes': notes,
      }),
    );

    final data = json.decode(response.body);
    if (response.statusCode == 201 && data['success'] == true) {
      return Booking.fromJson(data['data']);
    }
    throw Exception(data['message'] ?? 'Failed to create booking');
  }

  Future<List<Booking>> getMyBookings(String email) async {
    final response = await _client.get(
      Uri.parse('$baseUrl/v1/bookings/my?email=$email'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['success'] == true) {
        return (data['data'] as List)
            .map((booking) => Booking.fromJson(booking))
            .toList();
      }
      throw Exception(data['message'] ?? 'Failed to load bookings');
    }
    throw Exception('Failed to load bookings: ${response.statusCode}');
  }

  Future<void> cancelBooking(int id, String email) async {
    final response = await _client.post(
      Uri.parse('$baseUrl/v1/bookings/$id/cancel'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'email': email}),
    );

    final data = json.decode(response.body);
    if (response.statusCode != 200 || data['success'] != true) {
      throw Exception(data['message'] ?? 'Failed to cancel booking');
    }
  }
}

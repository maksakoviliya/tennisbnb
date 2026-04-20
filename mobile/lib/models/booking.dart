import 'court.dart';

class Booking {
  final int id;
  final int courtId;
  final String guestName;
  final String guestEmail;
  final String guestPhone;
  final DateTime bookingDate;
  final String startTime;
  final String endTime;
  final double totalPrice;
  final String status;
  final String? notes;
  final Court? court;

  Booking({
    required this.id,
    required this.courtId,
    required this.guestName,
    required this.guestEmail,
    required this.guestPhone,
    required this.bookingDate,
    required this.startTime,
    required this.endTime,
    required this.totalPrice,
    required this.status,
    this.notes,
    this.court,
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: json['id'],
      courtId: json['court_id'],
      guestName: json['guest_name'],
      guestEmail: json['guest_email'],
      guestPhone: json['guest_phone'],
      bookingDate: DateTime.parse(json['booking_date']),
      startTime: json['start_time'],
      endTime: json['end_time'],
      totalPrice: double.parse(json['total_price'].toString()),
      status: json['status'],
      notes: json['notes'],
      court: json['court'] != null ? Court.fromJson(json['court']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'court_id': courtId,
      'guest_name': guestName,
      'guest_email': guestEmail,
      'guest_phone': guestPhone,
      'booking_date': bookingDate.toIso8601String().split('T')[0],
      'start_time': startTime,
      'end_time': endTime,
      'notes': notes,
    };
  }

  bool get isPending => status == 'pending';
  bool get isConfirmed => status == 'confirmed';
  bool get isCancelled => status == 'cancelled';
  bool get isCompleted => status == 'completed';
  bool get isActive => isPending || isConfirmed;
}

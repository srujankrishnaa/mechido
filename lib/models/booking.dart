import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

class Booking {
  final String id;
  final String? userId;
  final String mechanicName;
  final String mechanicImage;
  final double mechanicRating;
  final String serviceType;
  final double amount;
  final DateTime bookingDate;
  final String status;
  final String? feedback;
  final int? rating;
  final String? paymentId;
  final String? paymentStatus;
  final LatLng? mechanicPosition;
  final LatLng? destinationPosition;
  final int? eta;
  final String? currentPhase;

  Booking({
    required this.id,
    this.userId,
    required this.mechanicName,
    required this.mechanicImage,
    required this.mechanicRating,
    required this.serviceType,
    required this.amount,
    required this.bookingDate,
    required this.status,
    this.feedback,
    this.rating,
    this.paymentId,
    this.paymentStatus,
    this.mechanicPosition,
    this.destinationPosition,
    this.eta,
    this.currentPhase,
  });

  // Convert to Map for storage
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'mechanicName': mechanicName,
      'mechanicImage': mechanicImage,
      'mechanicRating': mechanicRating,
      'serviceType': serviceType,
      'amount': amount,
      'bookingDate': bookingDate.toIso8601String(),
      'status': status,
      'feedback': feedback,
      'rating': rating,
      'payment_id': paymentId,
      'payment_status': paymentStatus,
      'mechanic_position': mechanicPosition != null
          ? {
              'latitude': mechanicPosition!.latitude,
              'longitude': mechanicPosition!.longitude,
            }
          : null,
      'destination_position': destinationPosition != null
          ? {
              'latitude': destinationPosition!.latitude,
              'longitude': destinationPosition!.longitude,
            }
          : null,
      'eta': eta,
      'current_phase': currentPhase,
    };
  }

  // Create from Map
  factory Booking.fromMap(Map<String, dynamic> map) {
    return Booking(
      id: map['id'],
      userId: map['user_id'],
      mechanicName: map['mechanicName'],
      mechanicImage: map['mechanicImage'],
      mechanicRating: (map['mechanicRating'] as num?)?.toDouble() ?? 0.0,
      serviceType: map['serviceType'],
      amount: (map['amount'] as num?)?.toDouble() ?? 0.0,
      bookingDate: DateTime.parse(map['bookingDate']),
      status: map['status'],
      feedback: map['feedback'],
      rating: map['rating'],
      paymentId: map['payment_id'],
      paymentStatus: map['payment_status'],
      mechanicPosition: map['mechanic_position'] != null
          ? LatLng(
              (map['mechanic_position']['latitude'] as num).toDouble(),
              (map['mechanic_position']['longitude'] as num).toDouble(),
            )
          : null,
      destinationPosition: map['destination_position'] != null
          ? LatLng(
              (map['destination_position']['latitude'] as num).toDouble(),
              (map['destination_position']['longitude'] as num).toDouble(),
            )
          : null,
      eta: map['eta'],
      currentPhase: map['current_phase'],
    );
  }
}

import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import '../models/booking.dart';
import 'supabase_service.dart';

enum ServicePhase {
  arrivingToPickup,
  returningToServiceCenter,
  servicing,
  delivering
}

// Singleton class to manage tracking service
class TrackingService {
  static final TrackingService _instance = TrackingService._internal();

  // Access the singleton instance
  static TrackingService get instance => _instance;

  factory TrackingService() {
    return _instance;
  }

  TrackingService._internal();

  // Tracking state
  Timer? _timer;
  int etaSeconds = 14 * 60; // 14 minutes in seconds
  int currentStep = 0;
  List<LatLng> _routePoints = [];
  LatLng? _mechanicPosition;
  LatLng? _destinationPosition;
  double _carRotation = 0;
  ServicePhase _currentPhase = ServicePhase.arrivingToPickup;
  bool _showFeedback = false;
  final SupabaseService _supabaseService = SupabaseService();
  StreamSubscription<Booking>? _bookingSubscription;
  String? _bookingId;
  bool _isInitialized = false;
  bool _isBackground = false;

  // Listeners
  final List<Function> _positionListeners = [];
  final List<Function> _phaseListeners = [];
  final List<Function> _etaListeners = [];

  // Getters
  LatLng? get mechanicPosition => _mechanicPosition;
  LatLng? get destinationPosition => _destinationPosition;
  double get carRotation => _carRotation;
  ServicePhase get currentPhase => _currentPhase;
  bool get showFeedback => _showFeedback;
  int get remainingEta => etaSeconds;
  bool get isInitialized => _isInitialized;
  String? get bookingId => _bookingId;
  bool get isBackground => _isBackground;

  // Hyderabad coordinates
  final LatLng _startLocation =
      const LatLng(17.3850, 78.4867); // Hyderabad center
  final LatLng _endLocation =
      const LatLng(17.4500, 78.3800); // Destination in Hyderabad

  // Predefined waypoints for demo
  final List<Map<String, dynamic>> _demoWaypoints = [
    {
      'position': LatLng(17.3850, 78.4867), // Service Center
      'name': 'Service Center',
      'duration': 0,
    },
    {
      'position': LatLng(17.3900, 78.4800),
      'name': 'Point A',
      'duration': 60, // 1 minute
    },
    {
      'position': LatLng(17.4000, 78.4700),
      'name': 'Point B',
      'duration': 60, // 1 minute
    },
    {
      'position': LatLng(17.4200, 78.4500),
      'name': 'Customer Location',
      'duration': 60, // 1 minute
    },
    {
      'position': LatLng(17.4300, 78.4200),
      'name': 'Point C',
      'duration': 60, // 1 minute
    },
    {
      'position': LatLng(17.4400, 78.4000),
      'name': 'Point D',
      'duration': 60, // 1 minute
    },
    {
      'position': LatLng(17.4500, 78.3800),
      'name': 'Service Center',
      'duration': 60, // 1 minute
    },
  ];

  void initialize(String bookingId) async {
    if (_isInitialized && _bookingId == bookingId) return;

    _bookingId = bookingId;
    _isInitialized = true;
    _isBackground = false;

    // Get current booking details from Supabase
    try {
      final booking = await _supabaseService.getBooking(bookingId);
      if (booking != null) {
        // Initialize state from booking data
        _mechanicPosition = booking.mechanicPosition ??
            _routePoints.first; // Use saved position or start of route
        _destinationPosition = booking.destinationPosition ??
            _endLocation; // Use saved or default destination
        etaSeconds = booking.eta ?? 14 * 60; // Use saved ETA or default
        _currentPhase = _getServicePhaseFromString(booking.currentPhase) ??
            ServicePhase.arrivingToPickup; // Use saved phase or default
        _showFeedback =
            booking.status == 'Completed'; // Set feedback based on status
      } else {
        // Handle case where booking is not found (e.g., deleted)
        stopTracking();
        return; // Stop initialization
      }
    } catch (e) {
      print('Error getting booking details: $e');
      // Handle error, perhaps stop tracking or show an error message
      stopTracking();
      return; // Stop initialization
    }

    _generateDemoRoute(); // Re-generate route based on potential updated positions
    _subscribeToBookingUpdates();
    startSimulation();
  }

  void _generateDemoRoute() {
    _routePoints = [];
    int totalPoints = 0;

    // Calculate total points needed based on durations
    for (int i = 0; i < _demoWaypoints.length - 1; i++) {
      int duration = _demoWaypoints[i]['duration'];
      int pointsForSegment =
          (duration * 2).clamp(10, 50); // 2 points per second, min 10, max 50
      totalPoints += pointsForSegment;
    }

    // Generate points between each waypoint
    for (int i = 0; i < _demoWaypoints.length - 1; i++) {
      LatLng start = _demoWaypoints[i]['position'];
      LatLng end = _demoWaypoints[i + 1]['position'];
      int duration = _demoWaypoints[i]['duration'];
      int pointsForSegment = (duration * 2).clamp(10, 50);

      for (int j = 0; j < pointsForSegment; j++) {
        double t = j / (pointsForSegment - 1);
        // Add some curve to the route
        double curve = sin(t * pi) * 0.001;
        double lat =
            start.latitude + t * (end.latitude - start.latitude) + curve;
        double lng =
            start.longitude + t * (end.longitude - start.longitude) + curve;
        _routePoints.add(LatLng(lat, lng));
      }
    }

    _mechanicPosition = _routePoints.first;
    _destinationPosition = _endLocation;

    // Calculate total ETA based on waypoint durations
    etaSeconds = _demoWaypoints.fold(
        0, (sum, waypoint) => sum + (waypoint['duration'] as int));
  }

  void startSimulation() {
    print('TrackingService: Starting simulation');
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      if (_bookingId != null && currentStep < _routePoints.length - 1) {
        print(
            'TrackingService: Timer fired, currentStep: $currentStep, eta: $etaSeconds');

        // Calculate car rotation based on movement direction
        if (currentStep > 0) {
          double dx = _routePoints[currentStep].longitude -
              _routePoints[currentStep - 1].longitude;
          double dy = _routePoints[currentStep].latitude -
              _routePoints[currentStep - 1].latitude;
          _carRotation = atan2(dx, dy);
        }

        currentStep++;
        _mechanicPosition = _routePoints[currentStep];

        // Decrease ETA based on current phase
        if (etaSeconds > 0) {
          if (_currentPhase == ServicePhase.arrivingToPickup ||
              _currentPhase == ServicePhase.returningToServiceCenter) {
            etaSeconds -=
                1; // Decrement by 1 second per step for movement phases
          }
        }

        // Notify listeners for immediate UI update
        _notifyPositionListeners();
        _notifyEtaListeners();

        // Update booking in Supabase periodically
        if (currentStep % 10 == 0 || etaSeconds <= 0) {
          _supabaseService.updateBookingTracking({
            'mechanic_position': _mechanicPosition != null
                ? {
                    'latitude': _mechanicPosition!.latitude,
                    'longitude': _mechanicPosition!.longitude
                  }
                : null,
            'eta': etaSeconds,
            'current_phase': _currentPhase.toString().split('.').last,
          }, _bookingId!).catchError(
              (e) => print('Error updating tracking details in Supabase: $e'));
        }
      } else if (_bookingId != null && currentStep >= _routePoints.length - 1) {
        print(
            'TrackingService: Simulation complete, handling phase completion.');
        _handlePhaseCompletion();
      } else if (_bookingId == null) {
        print('TrackingService: bookingId is null, canceling timer.');
        _timer?.cancel();
      }
    });
  }

  void _handlePhaseCompletion() async {
    print(
        'TrackingService: Handling phase completion. Current phase: $_currentPhase');
    _timer?.cancel();

    switch (_currentPhase) {
      case ServicePhase.arrivingToPickup:
        _currentPhase = ServicePhase.servicing;
        etaSeconds = 180; // 3 minutes for servicing
        if (!_isBackground) {
          _notifyPhaseListeners();
          _notifyEtaListeners();
        }

        // Update booking status and phase in Supabase
        if (_bookingId != null) {
          try {
            await _supabaseService.updateBookingStatus(
                _bookingId!, 'Servicing');
            await _supabaseService.updateBookingTracking({
              'current_phase': _currentPhase.toString().split('.').last,
              'eta': etaSeconds
            }, _bookingId!);
          } catch (e) {
            print('Error updating booking status to Servicing in Supabase: $e');
          }
        }

        // Start servicing timer
        _timer = Timer.periodic(const Duration(seconds: 1), (timer) async {
          if (etaSeconds > 0) {
            etaSeconds--;
            if (_bookingId != null && !_isBackground) {
              try {
                await _supabaseService
                    .updateBookingTracking({'eta': etaSeconds}, _bookingId!);
              } catch (e) {
                print('Error updating ETA in Supabase: $e');
              }
            }
            if (!_isBackground) {
              _notifyEtaListeners();
            }
          } else {
            _timer?.cancel();
            _currentPhase = ServicePhase.returningToServiceCenter;
            if (!_isBackground) {
              _notifyPhaseListeners();
            }

            // Update booking status and phase in Supabase
            if (_bookingId != null) {
              try {
                await _supabaseService.updateBookingStatus(
                    _bookingId!, 'Returning to Service Center');
                await _supabaseService.updateBookingTracking(
                    {'current_phase': _currentPhase.toString().split('.').last},
                    _bookingId!);
              } catch (e) {
                print(
                    'Error updating booking status to Returning to Service Center in Supabase: $e');
              }
            }

            // Reverse the route for returning phase
            _routePoints = _routePoints.reversed.toList();
            currentStep = 0;
            startSimulation();
          }
        });
        break;

      case ServicePhase.returningToServiceCenter:
        _currentPhase = ServicePhase.delivering;
        _showFeedback = true;
        if (!_isBackground) {
          _notifyPhaseListeners();
        }

        // Update booking status in database to Completed
        if (_bookingId != null) {
          try {
            await _supabaseService.updateBookingStatus(
                _bookingId!, 'Delivering');
            await _supabaseService.updateBookingTracking(
                {'current_phase': _currentPhase.toString().split('.').last},
                _bookingId!);
          } catch (e) {
            print(
                'Error updating booking status to Delivering in Supabase: $e');
          }
        }
        stopTracking();
        break;

      default:
        if (_bookingId != null) {
          try {
            await _supabaseService.updateBookingStatus(
                _bookingId!, 'Completed');
            await _supabaseService.updateBookingTracking({
              'current_phase':
                  ServicePhase.delivering.toString().split('.').last
            }, _bookingId!);
          } catch (e) {
            print(
                'Error updating booking status to Completed in Supabase from default case: $e');
          }
        }
        stopTracking();
        break;
    }
  }

  void _subscribeToBookingUpdates() {
    if (_bookingId == null) return;

    // Cancel any existing subscription
    _bookingSubscription?.cancel();

    // Subscribe to booking updates
    _bookingSubscription =
        _supabaseService.getBookingStream(_bookingId!).listen(
      (booking) {
        print(
            'Received booking update: ${booking.status}, Phase: ${booking.currentPhase}, ETA: ${booking.eta}');

        // Update local state based on booking data
        // Only update if the booking ID matches to avoid processing old updates
        if (booking.id == _bookingId) {
          print('Applying booking update for ID: ${booking.id}');

          // Update tracking position only if different to avoid unnecessary rebuilds
          if (booking.mechanicPosition != null &&
              (_mechanicPosition == null ||
                  _mechanicPosition!.latitude !=
                      booking.mechanicPosition!.latitude ||
                  _mechanicPosition!.longitude !=
                      booking.mechanicPosition!.longitude)) {
            _mechanicPosition = booking.mechanicPosition;
            if (!_isBackground) {
              _notifyPositionListeners();
            }
          }

          // Update ETA only if different
          if (booking.eta != null && etaSeconds != booking.eta) {
            etaSeconds = booking.eta!;
            if (!_isBackground) {
              _notifyEtaListeners();
            }
          }

          // Update phase only if different
          final newPhase = _getServicePhaseFromString(booking.currentPhase);
          if (newPhase != null && _currentPhase != newPhase) {
            _currentPhase = newPhase; // Update phase
            if (!_isBackground) {
              _notifyPhaseListeners();
            }
            // If phase changes to completed via Supabase update, stop tracking locally
            if (_currentPhase == ServicePhase.delivering) {
              _showFeedback = true; // Ensure feedback is shown
              stopTracking();
            }
          }

          // Also handle status changes that might not update phase immediately but are important
          if (booking.status == 'Completed' &&
              _currentPhase != ServicePhase.delivering) {
            // This case should ideally be handled by the phase update above, but as a fallback:
            _currentPhase = ServicePhase.delivering;
            _showFeedback = true;
            if (!_isBackground) {
              _notifyPhaseListeners();
            }
            stopTracking(); // Stop tracking when completed
          } else if (booking.status != 'Completed' && _showFeedback) {
            _showFeedback =
                false; // Hide feedback if status changes from completed
          }
        }
      },
      onError: (error) {
        print('Error in booking subscription: $error');
        // Handle subscription errors, e.g., try to re-subscribe or show error to user
        // Consider stopping tracking or showing an error UI if the subscription fails critically
      },
      // Optionally add onDone for when the stream closes
      onDone: () => print('Booking stream closed'),
    );
  }

  void setBackground(bool isBackground) {
    _isBackground = isBackground;
    if (!isBackground) {
      // When coming back to foreground, notify all listeners
      _notifyPositionListeners();
      _notifyPhaseListeners();
      _notifyEtaListeners();

      // Update booking status in Supabase
      if (_bookingId != null) {
        String status = '';
        switch (_currentPhase) {
          case ServicePhase.arrivingToPickup:
            status = 'Arriving to Pickup';
            break;
          case ServicePhase.returningToServiceCenter:
            status = 'Returning to Service Center';
            break;
          case ServicePhase.servicing:
            status = 'Servicing';
            break;
          case ServicePhase.delivering:
            status = 'Delivering';
            break;
        }
        _supabaseService.updateBookingStatus(_bookingId!, status);
      }
    }
  }

  void dispose() {
    _timer?.cancel();
    _bookingSubscription?.cancel();
    _isInitialized = false;
    _positionListeners.clear();
    _phaseListeners.clear();
    _etaListeners.clear();
  }

  // Add listeners
  void addPositionListener(Function callback) {
    _positionListeners.add(callback);
  }

  void addPhaseListener(Function callback) {
    _phaseListeners.add(callback);
  }

  void addEtaListener(Function callback) {
    _etaListeners.add(callback);
  }

  // Remove listeners
  void removePositionListener(Function callback) {
    _positionListeners.remove(callback);
  }

  void removePhaseListener(Function callback) {
    _phaseListeners.remove(callback);
  }

  void removeEtaListener(Function callback) {
    _etaListeners.remove(callback);
  }

  // Notify listeners
  void _notifyPositionListeners() {
    print('TrackingService: Notifying position listeners');
    for (var listener in _positionListeners) {
      listener();
    }
  }

  void _notifyPhaseListeners() {
    print('TrackingService: Notifying phase listeners');
    for (var listener in _phaseListeners) {
      listener();
    }
  }

  void _notifyEtaListeners() {
    print('TrackingService: Notifying ETA listeners');
    for (var listener in _etaListeners) {
      listener();
    }
  }

  // Helper methods
  String formatTime(int seconds) {
    int mins = seconds ~/ 60;
    int secs = seconds % 60;
    return '${mins.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  String getPhaseTitle() {
    switch (_currentPhase) {
      case ServicePhase.arrivingToPickup:
        return 'Mechanic is on the way';
      case ServicePhase.returningToServiceCenter:
        return 'Returning to service center';
      case ServicePhase.servicing:
        return 'Servicing in progress';
      case ServicePhase.delivering:
        return 'Delivering';
      default:
        return 'Unknown phase';
    }
  }

  IconData getPhaseIcon() {
    switch (_currentPhase) {
      case ServicePhase.arrivingToPickup:
        return Icons.directions_car;
      case ServicePhase.returningToServiceCenter:
        return Icons.arrow_back;
      case ServicePhase.servicing:
        return Icons.build;
      case ServicePhase.delivering:
        return Icons.check_circle;
      default:
        return Icons.help_outline;
    }
  }

  void stopTracking() {
    print('TrackingService: Stopping tracking');
    _timer?.cancel();
    _bookingSubscription?.cancel();
    _positionListeners.clear();
    _phaseListeners.clear();
    _etaListeners.clear();
    _isInitialized = false;
    _isBackground = false;
    _bookingId = null;
  }

  ServicePhase? _getServicePhaseFromString(String? phaseString) {
    if (phaseString == null) return null;
    try {
      return ServicePhase.values.firstWhere(
          (e) => e.toString().split('.').last == phaseString.toLowerCase());
    } catch (e) {
      return null;
    }
  }

  // Add this getter to expose route points for visualization
  List<LatLng> getRoutePoints() {
    return _routePoints;
  }

  // Add this method to update mechanic position
  void updateMechanicPosition(LatLng position) {
    _mechanicPosition = position;
    _notifyPositionListeners();
  }

  void updatePhase(ServicePhase phase) {
    _currentPhase = phase;
    _notifyPhaseListeners();
  }

  void updateEta(int eta) {
    etaSeconds = eta;
    _notifyEtaListeners();
  }
}

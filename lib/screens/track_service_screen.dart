import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';
import '../widgets/custom_car_marker.dart';
import '../services/supabase_service.dart';
import '../models/booking.dart';
import '../screens/home_screen.dart';
import '../services/tracking_service.dart';
import '../screens/book_service_screen.dart';

class TrackServiceScreen extends StatefulWidget {
  final bool hasBooking;
  final String? bookingId;

  const TrackServiceScreen({
    Key? key,
    this.hasBooking = false,
    this.bookingId,
  }) : super(key: key);

  @override
  State<TrackServiceScreen> createState() => _TrackServiceScreenState();
}

class _TrackServiceScreenState extends State<TrackServiceScreen>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  Widget _buildMapControlButton(IconData icon, VoidCallback onPressed) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(12),
            child: Icon(
              icon,
              color: const Color(0xFF635BFF),
              size: 20,
            ),
          ),
        ),
      ),
    );
  }

  IconData _getStatusIcon() {
    switch (_trackingService.currentPhase) {
      case ServicePhase.arrivingToPickup:
        return Icons.directions_car;
      case ServicePhase.returningToServiceCenter:
        return Icons.arrow_back;
      case ServicePhase.servicing:
        return Icons.build;
      case ServicePhase.delivering:
        return Icons.check_circle;
      default:
        return Icons.directions_car;
    }
  }

  String _getStatusSubtitle() {
    switch (_trackingService.currentPhase) {
      case ServicePhase.servicing:
        return 'Service in progress';
      case ServicePhase.delivering:
        return 'Returning to your location';
      case ServicePhase.returningToServiceCenter:
        return 'Returning to service center';
      case ServicePhase.arrivingToPickup:
        return 'ETA: ${_trackingService.formatTime(_trackingService.remainingEta)}';
      default:
        return 'ETA: ${_trackingService.formatTime(_trackingService.remainingEta)}';
    }
  }

  final MapController _mapController = MapController();
  late AnimationController _animationController;
  final TrackingService _trackingService = TrackingService.instance;
  bool _needsRebuild = false;
  bool _isMapReady = false;
  Timer? _timer;
  int _currentPathIndex = 0;
  int _etaMinutes = 10;

  // Update the demo path points to include service center return and customer delivery
  final List<LatLng> _demoPath = [
    const LatLng(17.3850, 78.4867), // Start (Service Center)
    const LatLng(17.3900, 78.4800), // Point A
    const LatLng(17.4000, 78.4700), // Point B
    const LatLng(17.4200, 78.4500), // Customer Location
    const LatLng(17.4000, 78.4700), // Return to Service Center
    const LatLng(17.3900, 78.4800), // Service Center
    const LatLng(17.4000, 78.4700), // Back to Customer
    const LatLng(17.4200, 78.4500), // Final Customer Location
  ];

  // Update phase transitions to match tracking_service.dart enum
  final Map<int, ServicePhase> _phaseTransitions = {
    3: ServicePhase.arrivingToPickup, // At customer location
    5: ServicePhase.servicing, // At service center
    6: ServicePhase.returningToServiceCenter, // Returning to customer
    7: ServicePhase.delivering, // Back at customer location
  };

  final int _stepDurationSeconds = 15; // How often the position updates
  late int _totalSteps;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _totalSteps = _demoPath.length - 1;
    _etaMinutes =
        ((_totalSteps - _currentPathIndex) * _stepDurationSeconds) ~/ 60;

    // Initialize map after a short delay to ensure widget is mounted
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {
          _isMapReady = true;
        });
        _startSimulation();
      }
    });

    // Add listeners to TrackingService
    _trackingService.addPhaseListener(_updateUI);
    _trackingService.addEtaListener(_updateUI);
    _trackingService.addPositionListener(_updateUI);
  }

  void _updateUI() {
    if (mounted) {
      setState(() {
        // Trigger rebuild to update UI based on TrackingService state
      });
    }
  }

  void _startSimulation() {
    _timer?.cancel();
    _timer = Timer.periodic(Duration(seconds: _stepDurationSeconds), (timer) {
      if (_currentPathIndex < _demoPath.length - 1) {
        setState(() {
          _currentPathIndex++;

          // Update mechanic position
          _trackingService.updateMechanicPosition(_demoPath[_currentPathIndex]);

          // Update service phase if at transition point
          if (_phaseTransitions.containsKey(_currentPathIndex)) {
            _trackingService.updatePhase(_phaseTransitions[_currentPathIndex]!);
          }

          // Update ETA based on current phase
          int remainingSteps = _demoPath.length - 1 - _currentPathIndex;
          _etaMinutes = (remainingSteps * _stepDurationSeconds) ~/ 60;

          // Adjust ETA based on phase
          switch (_trackingService.currentPhase) {
            case ServicePhase.servicing:
              _etaMinutes = 15; // Fixed 15 minutes for servicing
              break;
            case ServicePhase.delivering:
              _etaMinutes = (remainingSteps * _stepDurationSeconds) ~/ 60;
              break;
            default:
              _etaMinutes = (remainingSteps * _stepDurationSeconds) ~/ 60;
          }

          if (_etaMinutes < 0) _etaMinutes = 0;

          // Update map center
          _mapController.move(
              _demoPath[_currentPathIndex], _mapController.zoom);
        });
      } else {
        _timer?.cancel();
        setState(() {
          _etaMinutes = 0;
          _trackingService.updatePhase(ServicePhase.delivering);
        });
      }
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _animationController.dispose();
    _timer?.cancel();
    // Remove listeners from TrackingService
    _trackingService.removePhaseListener(_updateUI);
    _trackingService.removeEtaListener(_updateUI);
    _trackingService.removePositionListener(_updateUI);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Show confirmation dialog
        final shouldPop = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Stop Tracking?'),
            content: const Text(
                'Are you sure you want to stop tracking your service?'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                  // Navigate to home without stopping tracking
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => const HomeScreen()),
                    (route) => false,
                  );
                },
                child: const Text('No'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                  // Stop tracking and navigate to home
                  _trackingService.stopTracking();
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => const HomeScreen()),
                    (route) => false,
                  );
                },
                child: const Text('Yes'),
              ),
            ],
          ),
        );
        return false;
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF6F6F6),
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(80),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  const Color(0xFF635BFF),
                  const Color(0xFF8B7EFF),
                  const Color(0xFF9C88FF),
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF635BFF).withOpacity(0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: SafeArea(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () async {
                          // Show confirmation dialog
                          final shouldPop = await showDialog<bool>(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Stop Tracking?'),
                              content: const Text(
                                  'Are you sure you want to stop tracking your service?'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop(false);
                                    // Navigate to home without stopping tracking
                                    Navigator.of(context).pushAndRemoveUntil(
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const HomeScreen()),
                                      (route) => false,
                                    );
                                  },
                                  child: const Text('No'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop(true);
                                    // Stop tracking and navigate to home
                                    _trackingService.stopTracking();
                                    Navigator.of(context).pushAndRemoveUntil(
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const HomeScreen()),
                                      (route) => false,
                                    );
                                  },
                                  child: const Text('Yes'),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'LIVE TRACKING',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              letterSpacing: 1.2,
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 4),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 3),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Text(
                              'Service in Progress',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.refresh, color: Colors.white),
                        onPressed: () {
                          // Refresh tracking data
                          _startSimulation();
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        body: widget.hasBooking ? _buildTrackingUI() : _buildNoBookingUI(),
      ),
    );
  }

  Widget _buildNoBookingUI() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            const Color(0xFFF6F6F6),
            Colors.white,
          ],
        ),
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFF635BFF).withOpacity(0.1),
                      const Color(0xFF8B7EFF).withOpacity(0.05),
                    ],
                  ),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.location_off_outlined,
                  size: 64,
                  color: Colors.grey[400],
                ),
              ),
              const SizedBox(height: 32),
              const Text(
                'No Active Service Request',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2D3748),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                'You don\'t have any active service requests.\nBook a service to track your mechanic in real-time.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 48),
              Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF635BFF), Color(0xFF8B7EFF)],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF635BFF).withOpacity(0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) => const BookServiceScreen()),
                    );
                  },
                  icon:
                      const Icon(Icons.add_circle_outline, color: Colors.white),
                  label: const Text(
                    'Book a Service',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTrackingUI() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 20.0),
        child: Column(
          children: [
            // Enhanced Map Container
            Container(
              height: 380,
              width: double.infinity,
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 25,
                    offset: const Offset(0, 10),
                    spreadRadius: 0,
                  ),
                  BoxShadow(
                    color: const Color(0xFF635BFF).withOpacity(0.1),
                    blurRadius: 40,
                    offset: const Offset(0, 20),
                    spreadRadius: 0,
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: Stack(
                  children: [
                    _buildMap(),
                    // Floating Status Card on Map
                    Positioned(
                      top: 16,
                      left: 16,
                      right: 16,
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.white.withOpacity(0.95),
                              Colors.white.withOpacity(0.85),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.3),
                            width: 1,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 20,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xFF635BFF),
                                    Color(0xFF8B7EFF)
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(
                                _getStatusIcon(),
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _trackingService.getPhaseTitle(),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                      color: Color(0xFF2D3748),
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    _getStatusSubtitle(),
                                    style: TextStyle(
                                      color: _getEtaTextColor(),
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: _getEtaTextColor().withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                _etaMinutes > 0 ? '${_etaMinutes}m' : 'Now',
                                style: TextStyle(
                                  color: _getEtaTextColor(),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Enhanced Map Controls
                    Positioned(
                      right: 16,
                      bottom: 16,
                      child: Column(
                        children: [
                          _buildMapControlButton(Icons.add, () {
                            if (_trackingService.mechanicPosition != null) {
                              _mapController.move(
                                _trackingService.mechanicPosition!,
                                (_mapController.zoom + 1.0).clamp(10.0, 18.0),
                              );
                            }
                          }),
                          const SizedBox(height: 8),
                          _buildMapControlButton(Icons.remove, () {
                            if (_trackingService.mechanicPosition != null) {
                              _mapController.move(
                                _trackingService.mechanicPosition!,
                                (_mapController.zoom - 1.0).clamp(10.0, 18.0),
                              );
                            }
                          }),
                          const SizedBox(height: 8),
                          _buildMapControlButton(Icons.my_location, () {
                            if (_trackingService.mechanicPosition != null) {
                              _mapController.move(
                                _trackingService.mechanicPosition!,
                                14.0,
                              );
                            }
                          }),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 18),
            // Inside your _buildTrackingUI() method, replace the status card with this:
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 18),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.directions_car,
                    size: 24,
                    color: const Color(0xFF635BFF),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _trackingService.getPhaseTitle(),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Color(0xFF4A4A4A),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _trackingService.currentPhase ==
                                      ServicePhase.delivering ||
                                  _trackingService.currentPhase ==
                                      ServicePhase.servicing
                              ? _trackingService.getPhaseTitle()
                              : 'ETA: ${_trackingService.formatTime(_trackingService.remainingEta)}',
                          style: TextStyle(
                            color: _getEtaTextColor(),
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18.0),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.asset(
                        'assets/images/mechanic1.jpg',
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Ramu',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 1),
                          const Text(
                            'Car mechanic',
                            style: TextStyle(
                              color: Color(0xFF8E8E93),
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            _etaMinutes > 0
                                ? 'Arriving in $_etaMinutes min${_etaMinutes == 1 ? "" : "s"}'
                                : 'Arriving',
                            style: const TextStyle(
                              color: Color(0xFF27AE60),
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.star,
                                color: Color(0xFFFFB300), size: 16),
                            const SizedBox(width: 2),
                            const Text(
                              '4.8',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF4A4A4A),
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        const Text(
                          '127 reviews',
                          style: TextStyle(
                            color: Color(0xFF8E8E93),
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 18),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.only(right: 8),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF635BFF), Color(0xFF8B7EFF)],
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF635BFF).withOpacity(0.3),
                            blurRadius: 12,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: ElevatedButton.icon(
                        onPressed: () {
                          // Add haptic feedback
                          // HapticFeedback.lightImpact();
                          // Implement call functionality
                        },
                        icon: const Icon(Icons.call,
                            color: Colors.white, size: 20),
                        label: const Text(
                          'Call Mechanic',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.only(left: 8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: const Color(0xFF635BFF),
                          width: 2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF635BFF).withOpacity(0.1),
                            blurRadius: 12,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: ElevatedButton.icon(
                        onPressed: () {
                          // Add haptic feedback
                          // HapticFeedback.lightImpact();
                          // Implement message functionality
                        },
                        icon: const Icon(Icons.chat_bubble_outline,
                            color: Color(0xFF635BFF), size: 20),
                        label: const Text(
                          'Message',
                          style: TextStyle(
                            color: Color(0xFF635BFF),
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (_trackingService.showFeedback) ...[
              const SizedBox(height: 18),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18.0),
                child: _buildFeedbackSection(),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildFeedbackSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'How was your service?',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF4A4A4A),
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(5, (index) {
            return IconButton(
              icon: Icon(
                Icons.star,
                color: index < 4 ? const Color(0xFFFFB300) : Colors.grey,
                size: 32,
              ),
              onPressed: () {
                // Handle rating
              },
            );
          }),
        ),
        const SizedBox(height: 12),
        ElevatedButton(
          onPressed: () {
            _trackingService.stopTracking();
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => const HomeScreen()),
              (route) => false,
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF635BFF),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.symmetric(vertical: 12),
          ),
          child: const Text(
            'Submit Feedback',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMap() {
    if (!_isMapReady) {
      return const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF635BFF)),
        ),
      );
    }

    return FlutterMap(
      mapController: _mapController,
      options: MapOptions(
        center: _demoPath[_currentPathIndex],
        zoom: 13.0,
        minZoom: 10.0,
        maxZoom: 18.0,
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
          subdomains: const ['a', 'b', 'c'],
        ),
        PolylineLayer(
          polylines: [
            Polyline(
              points: _demoPath,
              strokeWidth: 4.0,
              color: const Color(0xFF635BFF).withOpacity(0.7),
              isDotted: true,
            ),
          ],
        ),
        MarkerLayer(
          markers: [
            Marker(
              width: 60.0,
              height: 60.0,
              point: _demoPath.last,
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        _currentPathIndex < _demoPath.length - 1
                            ? 'Customer'
                            : 'Service Center',
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF4A4A4A),
                        ),
                      ),
                    ),
                  ),
                  const Icon(
                    Icons.location_on,
                    color: Colors.red,
                    size: 30,
                  ),
                ],
              ),
            ),
          ],
        ),
        MarkerLayer(
          markers: [
            Marker(
              width: 70.0,
              height: 70.0,
              point: _demoPath[_currentPathIndex],
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF635BFF).withOpacity(0.9),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.directions_car,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Color _getEtaTextColor() {
    switch (_trackingService.currentPhase) {
      case ServicePhase.delivering:
        return const Color(0xFF27AE60);
      case ServicePhase.servicing:
        return const Color(0xFF635BFF);
      case ServicePhase.returningToServiceCenter:
        return const Color(0xFF27AE60);
      default:
        return const Color(0xFFFFB300);
    }
  }
}

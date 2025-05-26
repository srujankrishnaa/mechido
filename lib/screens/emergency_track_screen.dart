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

class EmergencyTrackScreen extends StatefulWidget {
  final bool hasBooking;
  final String? bookingId;

  const EmergencyTrackScreen({
    Key? key,
    this.hasBooking = false,
    this.bookingId,
  }) : super(key: key);

  @override
  State<EmergencyTrackScreen> createState() => _EmergencyTrackScreenState();
}

class _EmergencyTrackScreenState extends State<EmergencyTrackScreen>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  final MapController _mapController = MapController();
  late AnimationController _animationController;
  final TrackingService _trackingService = TrackingService.instance;
  bool _needsRebuild = false;
  bool _isMapReady = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    // Initialize map after a short delay to ensure widget is mounted
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {
          _isMapReady = true;
        });
      }
    });

    // Check if tracking service is already initialized
    if (_trackingService.isInitialized) {
      _initializeTracking();
    } else if (widget.hasBooking && widget.bookingId != null) {
      _initializeTracking();
    }
  }

  void _initializeTracking() {
    if (!_trackingService.isInitialized ||
        _trackingService.bookingId != widget.bookingId) {
      _trackingService.initialize(widget.bookingId!);
    }

    // Remove existing listeners to prevent duplicates
    _trackingService.removePositionListener(_onPositionChanged);
    _trackingService.removePhaseListener(_onPhaseChanged);
    _trackingService.removeEtaListener(_onEtaChanged);

    // Add listeners
    _trackingService.addPositionListener(_onPositionChanged);
    _trackingService.addPhaseListener(_onPhaseChanged);
    _trackingService.addEtaListener(_onEtaChanged);

    // Initialize map first
    _initializeMap().then((_) {
      // Force an update of the UI after map is initialized
      if (mounted) {
        _onPositionChanged();
        _onPhaseChanged();
        _onEtaChanged();
      }
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      if (_trackingService.isInitialized) {
        _trackingService.setBackground(false);
        _trackingService.addPositionListener(_onPositionChanged);
        _trackingService.addPhaseListener(_onPhaseChanged);
        _trackingService.addEtaListener(_onEtaChanged);
        _onPositionChanged();
        _onPhaseChanged();
        _onEtaChanged();
      }
    } else if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive ||
        state == AppLifecycleState.detached) {
      if (_trackingService.isInitialized) {
        _trackingService.setBackground(true);
        _trackingService.removePositionListener(_onPositionChanged);
        _trackingService.removePhaseListener(_onPhaseChanged);
        _trackingService.removeEtaListener(_onEtaChanged);
      }
    }
  }

  void _onPositionChanged() {
    if (mounted && _isMapReady) {
      setState(() {
        _needsRebuild = true;
        if (_trackingService.mechanicPosition != null) {
          _mapController.move(
            _trackingService.mechanicPosition!,
            _mapController.zoom,
          );
        }
      });
    }
  }

  void _onPhaseChanged() {
    if (mounted) {
      setState(() {
        _needsRebuild = true;
      });
    }
  }

  void _onEtaChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _initializeMap() async {
    Location location = Location();
    bool serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) return;
    }

    LocationData locationData = await location.getLocation();

    LatLng initialCenter = _trackingService.mechanicPosition ??
        LatLng(locationData.latitude!, locationData.longitude!);

    if (mounted) {
      setState(() {
        _mapController.move(
            initialCenter, 13.0); // Use fixed zoom level initially
        _needsRebuild = true;
      });
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _animationController.dispose();
    _mapController.dispose();
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
            title: const Text('Stop Emergency Tracking?'),
            content: const Text(
                'Are you sure you want to stop tracking your emergency service?'),
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
        appBar: AppBar(
          backgroundColor: const Color(0xFFE57373),
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () async {
              // Show confirmation dialog
              final shouldPop = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Stop Emergency Tracking?'),
                  content: const Text(
                      'Are you sure you want to stop tracking your emergency service?'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(false);
                        // Navigate to home without stopping tracking
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                              builder: (context) => const HomeScreen()),
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
                              builder: (context) => const HomeScreen()),
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
          title: const Text(
            'EMERGENCY SERVICE',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18,
              letterSpacing: 1.1,
            ),
          ),
          centerTitle: true,
        ),
        body: widget.hasBooking ? _buildTrackingUI() : _buildNoBookingUI(),
      ),
    );
  }

  Widget _buildNoBookingUI() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.warning_amber_rounded,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 24),
          const Text(
            'No Active Emergency Request',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF4A4A4A),
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'You don\'t have any active emergency requests.\nRequest emergency service to track your mechanic.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Color(0xFF8E8E93),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTrackingUI() {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            height: 320,
            width: double.infinity,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(32),
                bottomRight: Radius.circular(32),
              ),
            ),
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(32),
                bottomRight: Radius.circular(32),
              ),
              child: Stack(
                children: [
                  _buildMap(),
                  Positioned(
                    right: 16,
                    bottom: 16,
                    child: Column(
                      children: [
                        FloatingActionButton.small(
                          onPressed: () {
                            if (_trackingService.mechanicPosition != null) {
                              _mapController.move(
                                _trackingService.mechanicPosition!,
                                (_mapController.zoom + 1.0).clamp(10.0, 18.0),
                              );
                            }
                          },
                          backgroundColor: Colors.white,
                          child:
                              const Icon(Icons.add, color: Color(0xFFE57373)),
                        ),
                        const SizedBox(height: 8),
                        FloatingActionButton.small(
                          onPressed: () {
                            if (_trackingService.mechanicPosition != null) {
                              _mapController.move(
                                _trackingService.mechanicPosition!,
                                (_mapController.zoom - 1.0).clamp(10.0, 18.0),
                              );
                            }
                          },
                          backgroundColor: Colors.white,
                          child: const Icon(Icons.remove,
                              color: Color(0xFFE57373)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 18),
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
                  Icons.warning_amber_rounded,
                  size: 24,
                  color: const Color(0xFFE57373),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Emergency Service En Route',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Color(0xFF4A4A4A),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _trackingService
                            .formatTime(_trackingService.remainingEta),
                        style: const TextStyle(
                          color: Color(0xFFE57373),
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
              padding: const EdgeInsets.all(16),
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
                      width: 54,
                      height: 54,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Emergency Mechanic',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16)),
                        const SizedBox(height: 2),
                        const Text('24/7 Emergency Service',
                            style: TextStyle(
                                color: Color(0xFF8E8E93), fontSize: 13)),
                        const SizedBox(height: 4),
                        Text(
                          _trackingService
                              .formatTime(_trackingService.remainingEta),
                          style: const TextStyle(
                            color: Color(0xFFE57373),
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.star, color: Color(0xFFFFB300), size: 18),
                  const SizedBox(width: 2),
                  const Text('4.8',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF4A4A4A),
                          fontSize: 13)),
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
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.call, color: Colors.white),
                  label: const Text('Call Mechanic'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE57373),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 18, vertical: 12),
                  ),
                ),
                OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.message, color: Color(0xFFE57373)),
                  label: const Text('Message',
                      style: TextStyle(color: Color(0xFFE57373))),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFFE57373)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 18, vertical: 12),
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
    );
  }

  Widget _buildFeedbackSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'How was your emergency service?',
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
            backgroundColor: const Color(0xFFE57373),
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
          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFE57373)),
        ),
      );
    }

    return FlutterMap(
      mapController: _mapController,
      options: MapOptions(
        center:
            _trackingService.mechanicPosition ?? const LatLng(17.3850, 78.4867),
        zoom: 13.0,
        minZoom: 10.0,
        maxZoom: 18.0,
        onMapReady: () {
          if (mounted) {
            setState(() {
              _isMapReady = true;
            });
            // Initialize tracking after map is ready
            if (_trackingService.isInitialized) {
              _onPositionChanged();
            }
          }
        },
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
          subdomains: const ['a', 'b', 'c'],
        ),
        MarkerLayer(
          markers: [
            if (_trackingService.destinationPosition != null)
              Marker(
                width: 40.0,
                height: 40.0,
                point: _trackingService.destinationPosition!,
                child: const Icon(
                  Icons.location_on,
                  color: Color(0xFFE57373),
                  size: 40,
                ),
              ),
          ],
        ),
        if (_trackingService.mechanicPosition != null)
          MarkerLayer(
            markers: [
              Marker(
                key: ValueKey(_trackingService.mechanicPosition),
                width: 50.0,
                height: 50.0,
                point: _trackingService.mechanicPosition!,
                child: Transform.rotate(
                  angle: _trackingService.carRotation,
                  child: const CustomCarMarker(),
                ),
              ),
            ],
          ),
      ],
    );
  }
}

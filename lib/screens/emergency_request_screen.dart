import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'track_service_screen.dart';
import 'home_screen.dart'; // Import HomeScreen for navigation
import 'package:mechido/models/mechanic.dart'; // Import Mechanic model
import 'package:mechido/models/service.dart'; // Import Service model
import 'payment_screen.dart'; // Import PaymentScreen

class EmergencyRequestScreen extends StatefulWidget {
  const EmergencyRequestScreen({Key? key}) : super(key: key);

  @override
  State<EmergencyRequestScreen> createState() => _EmergencyRequestScreenState();
}

class _EmergencyRequestScreenState extends State<EmergencyRequestScreen>
    with TickerProviderStateMixin {
  // You might want to manage selected service type here
  String? _selectedServiceLabel;
  Map<String, dynamic>?
      _selectedServiceDetails; // Store the full details of the selected service
  final TextEditingController _additionalInfoController =
      TextEditingController();

  late AnimationController _slideController;
  late AnimationController _fadeController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  // Define emergency services with details and costs
  final List<Map<String, dynamic>> emergencyServices = [
    {
      'icon': Icons.local_shipping,
      'label': 'Towing Service',
      'price': 1500.0, // Example cost
      'description': 'Towing to the nearest service center',
    },
    {
      'icon': Icons.build,
      'label': 'Flat Tire Assistance',
      'price': 500.0,
      'description': 'On-spot tire change or repair',
    },
    {
      'icon': Icons.battery_charging_full,
      'label': 'Battery Jumpstart',
      'price': 400.0,
      'description': 'Jumpstart your car battery',
    },
    {
      'icon': Icons.local_gas_station,
      'label': 'Fuel Delivery',
      'price': 700.0, // Cost might include fuel price + delivery fee
      'description': 'Emergency fuel delivery',
    },
  ];

  @override
  void initState() {
    super.initState();
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    ));

    // Start animations
    _fadeController.forward();
    _slideController.forward();
  }

  @override
  void dispose() {
    _additionalInfoController.dispose();
    _slideController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF635BFF),
              Color(0xFF8B7EFF),
              Color(0xFFF6F6F6),
            ],
            stops: [0.0, 0.3, 1.0],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Enhanced AppBar
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.white.withOpacity(0.1),
                      Colors.white.withOpacity(0.05),
                    ],
                  ),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ),
                    const Expanded(
                      child: Text(
                        'Emergency Request',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                    const SizedBox(width: 48), // Balance the back button
                  ],
                ),
              ),
              // Content
              Expanded(
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Location and Car Details Section
                          Container(
                            padding: const EdgeInsets.all(20.0),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.white,
                                  Colors.white.withOpacity(0.95),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(16.0),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 20,
                                  offset: const Offset(0, 8),
                                  spreadRadius: 0,
                                ),
                                BoxShadow(
                                  color: Colors.white.withOpacity(0.8),
                                  blurRadius: 10,
                                  offset: const Offset(0, -2),
                                  spreadRadius: 0,
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [
                                        Color(0xFF635BFF),
                                        Color(0xFF8B7EFF)
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Icon(Icons.location_on,
                                      color: Colors.white, size: 24),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: const [
                                      Text(
                                        'Secunderabad,HYD', // Replace with actual location data
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF2D3748),
                                        ),
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        'padmaraonagar', // Replace with actual detailed address
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: Color(0xFF718096),
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 16),
                                // Replace with actual car image and name if available
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF7FAFC),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Row(
                                    children: [
                                      Image.asset(
                                          'assets/images/car_avatar.png',
                                          height: 32),
                                      const SizedBox(width: 8),
                                      const Text(
                                        'Swift',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: Color(0xFF2D3748),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 32),
                          // Select Emergency Service Section
                          const Text(
                            'Select Emergency Service',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF2D3748),
                            ),
                          ),
                          const SizedBox(height: 20),
                          // Use the defined list to build service options
                          ...emergencyServices.asMap().entries.map((entry) {
                            int index = entry.key;
                            Map<String, dynamic> service = entry.value;
                            return AnimatedContainer(
                              duration:
                                  Duration(milliseconds: 300 + (index * 100)),
                              child: _buildServiceOption(
                                icon: service['icon'],
                                label: service['label'],
                                price: service['price'],
                              ),
                            );
                          }).toList(),
                          const SizedBox(height: 32),
                          // Additional Information Section
                          const Text(
                            'Additional Information (Optional)',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF2D3748),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.white,
                                  Colors.white.withOpacity(0.95),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(16.0),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.08),
                                  blurRadius: 15,
                                  offset: const Offset(0, 5),
                                ),
                              ],
                            ),
                            child: TextField(
                              controller:
                                  _additionalInfoController, // This controller handles the text input
                              maxLines: 5, // Allows for multiple lines of text
                              decoration: InputDecoration(
                                hintText:
                                    'Describe the issue in more detail...',
                                hintStyle: TextStyle(
                                  color: Colors.grey[400],
                                  fontSize: 14,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16.0),
                                  borderSide: BorderSide.none,
                                ),
                                filled: true,
                                fillColor: Colors.transparent,
                                contentPadding: const EdgeInsets.all(20.0),
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                          // Upload Photos/Videos Section
                          Container(
                            padding: const EdgeInsets.all(20.0),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.white,
                                  Colors.white.withOpacity(0.95),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(16.0),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.08),
                                  blurRadius: 15,
                                  offset: const Offset(0, 5),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    // TODO: Implement photo/video upload
                                    print('Upload photos/videos tapped');
                                  },
                                  child: Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          gradient: const LinearGradient(
                                            colors: [
                                              Color(0xFFE57373),
                                              Color(0xFFEF5350)
                                            ],
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        child: const Icon(Icons.camera_alt,
                                            color: Colors.white, size: 20),
                                      ),
                                      const SizedBox(width: 16),
                                      const Expanded(
                                        child: Text(
                                          'Upload photos/videos of the issue',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            color: Color(0xFF2D3748),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 20),
                                // Separate Photo and Video Upload Buttons
                                Row(
                                  children: [
                                    Expanded(
                                      child: Container(
                                        margin:
                                            const EdgeInsets.only(right: 8.0),
                                        decoration: BoxDecoration(
                                          gradient: const LinearGradient(
                                            colors: [
                                              Color(0xFF635BFF),
                                              Color(0xFF8B7EFF)
                                            ],
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          boxShadow: [
                                            BoxShadow(
                                              color: const Color(0xFF635BFF)
                                                  .withOpacity(0.3),
                                              blurRadius: 8,
                                              offset: const Offset(0, 4),
                                            ),
                                          ],
                                        ),
                                        child: ElevatedButton.icon(
                                          onPressed: () {
                                            print('Upload Photo tapped');
                                          },
                                          icon: const Icon(Icons.photo_library,
                                              color: Colors.white, size: 18),
                                          label: const Text(
                                            'Photo',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.transparent,
                                            shadowColor: Colors.transparent,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 12),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        margin:
                                            const EdgeInsets.only(left: 8.0),
                                        decoration: BoxDecoration(
                                          gradient: const LinearGradient(
                                            colors: [
                                              Color(0xFF635BFF),
                                              Color(0xFF8B7EFF)
                                            ],
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          boxShadow: [
                                            BoxShadow(
                                              color: const Color(0xFF635BFF)
                                                  .withOpacity(0.3),
                                              blurRadius: 8,
                                              offset: const Offset(0, 4),
                                            ),
                                          ],
                                        ),
                                        child: ElevatedButton.icon(
                                          onPressed: () {
                                            print('Upload Video tapped');
                                          },
                                          icon: const Icon(Icons.videocam,
                                              color: Colors.white, size: 18),
                                          label: const Text(
                                            'Video',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.transparent,
                                            shadowColor: Colors.transparent,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 12),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 40),
                          // Request Emergency Service Button
                          Center(
                            child: Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: _selectedServiceDetails == null
                                      ? [Colors.grey[300]!, Colors.grey[400]!]
                                      : [
                                          const Color(0xFFE57373),
                                          const Color(0xFFEF5350)
                                        ],
                                ),
                                borderRadius: BorderRadius.circular(16.0),
                                boxShadow: _selectedServiceDetails != null
                                    ? [
                                        BoxShadow(
                                          color: const Color(0xFFE57373)
                                              .withOpacity(0.4),
                                          blurRadius: 15,
                                          offset: const Offset(0, 8),
                                        ),
                                      ]
                                    : [],
                              ),
                              child: ElevatedButton(
                                onPressed: _selectedServiceDetails == null
                                    ? null
                                    : () {
                                        // TODO: Implement request emergency service logic (e.g., send request to backend)
                                        print(
                                            'Request Emergency Service tapped');
                                        print(
                                            'Selected Service: $_selectedServiceLabel');
                                        print(
                                            'Additional Info: ${_additionalInfoController.text}');

                                        if (_selectedServiceDetails != null) {
                                          // Navigate to Payment Screen
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  PaymentScreen(
                                                mechanic: Mechanic(
                                                  id: 'emergency_mechanic',
                                                  name: '',
                                                  image: '',
                                                  rating: 0.0,
                                                  specialization:
                                                      _selectedServiceLabel ??
                                                          'Emergency Service',
                                                  experience: 0,
                                                  price: 0.0,
                                                ),
                                                service: Service(
                                                  id: _selectedServiceDetails![
                                                      'label'],
                                                  name:
                                                      _selectedServiceDetails![
                                                          'label'],
                                                  description:
                                                      _selectedServiceDetails![
                                                              'description'] ??
                                                          '',
                                                  price: double.parse(
                                                      _selectedServiceDetails![
                                                              'price']
                                                          .toString()),
                                                  image: '',
                                                  duration: 0,
                                                ),
                                                amount: double.parse(
                                                    _selectedServiceDetails![
                                                            'price']
                                                        .toString()),
                                              ),
                                            ),
                                          );
                                        }
                                      },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  shadowColor: Colors.transparent,
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16.0),
                                  ),
                                ),
                                child: Text(
                                  'Request Emergency Service',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: _selectedServiceDetails == null
                                        ? Colors.grey[600]
                                        : Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
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

  Widget _buildServiceOption(
      {required IconData icon, required String label, required double price}) {
    bool isSelected = _selectedServiceLabel == label;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedServiceLabel = label;
          // Find the full details of the selected service
          _selectedServiceDetails = emergencyServices.firstWhere(
            (service) => service['label'] == label, // Use label for comparison
            orElse: () =>
                {}, // Return empty map if not found (shouldn't happen with this logic)
          );
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 16.0),
        padding: const EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          gradient: isSelected
              ? const LinearGradient(
                  colors: [Color(0xFF635BFF), Color(0xFF8B7EFF)],
                )
              : LinearGradient(
                  colors: [Colors.white, Colors.white.withOpacity(0.95)],
                ),
          borderRadius: BorderRadius.circular(16.0),
          border: Border.all(
            color:
                isSelected ? Colors.transparent : Colors.grey.withOpacity(0.1),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: isSelected
                  ? const Color(0xFF635BFF).withOpacity(0.3)
                  : Colors.black.withOpacity(0.05),
              blurRadius: isSelected ? 15 : 10,
              offset: Offset(0, isSelected ? 8 : 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isSelected
                    ? Colors.white.withOpacity(0.2)
                    : const Color(0xFF635BFF).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: isSelected ? Colors.white : const Color(0xFF635BFF),
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color:
                          isSelected ? Colors.white : const Color(0xFF2D3748),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '₹${price.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: isSelected
                          ? Colors.white.withOpacity(0.9)
                          : const Color(0xFF27AE60), // Green color for price
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Icon(
                  Icons.check,
                  color: Color(0xFF635BFF),
                  size: 16,
                ),
              )
            else
              Icon(
                Icons.arrow_forward_ios,
                color: Colors.grey[400],
                size: 16,
              ),
          ],
        ),
      ),
    );
  }

  // Removed placeholder Mechanic and Service classes as they are imported.
}

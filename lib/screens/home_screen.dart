import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'my_car_details_screen.dart';
import 'book_service_screen.dart';
import 'booking_cart_screen.dart';
import 'track_service_screen.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import 'package:add_to_cart_animation/add_to_cart_animation.dart';
import 'booking_details_screen.dart';
import '../services/supabase_service.dart';
import 'emergency_request_screen.dart';
import 'account_details_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  final GlobalKey<CartIconKey> _cartKey = GlobalKey<CartIconKey>();
  late Function(GlobalKey) runAddToCartAnimation;

  final List<Map<String, dynamic>> quickActions = [
    {
      'icon': 'assets/icons/car_details.png',
      'label': 'My Car Details',
      'alert': true,
    },
    {
      'icon': 'assets/icons/book_service.png',
      'label': 'Book Service',
    },
    {
      'icon': 'assets/icons/booking_details.png',
      'label': 'Booking Details',
    },
    {
      'icon': 'assets/icons/share_app.png',
      'label': 'Share App',
    },
  ];

  final List<Map<String, dynamic>> services = [
    {
      'icon': 'assets/icons/oil_change.png',
      'label': 'Oil Change',
      'price': 350
    },
    {
      'icon': 'assets/icons/brake_pad.png',
      'label': 'Brake Pad Replacement',
      'price': 600
    },
    {
      'icon': 'assets/icons/battery.png',
      'label': 'Battery Check / Replacement',
      'price': 1200
    },
    {
      'icon': 'assets/icons/flat_tire.png',
      'label': 'Flat Tire Replacement',
      'price': 400
    },
    {
      'icon': 'assets/icons/ac_service.png',
      'label': 'AC Service',
      'price': 800
    },
    {
      'icon': 'assets/icons/engine_diag.png',
      'label': 'Engine Diagnostics',
      'price': 500
    },
    {
      'icon': 'assets/icons/periodic_service.png',
      'label': 'Periodic Service',
      'price': 1500
    },
    {
      'icon': 'assets/icons/towing.png',
      'label': 'Towing Service',
      'price': 900
    },
    {
      'icon': 'assets/icons/denting.png',
      'label': 'Car Denting & Painting Service',
      'price': 2000
    },
    {
      'icon': 'assets/icons/suspension.png',
      'label': 'Suspension System Repair',
      'price': 1800
    },
    {
      'icon': 'assets/icons/washing.png',
      'label': 'Car/Bike Washing & Interior',
      'price': 300
    },
    {
      'icon': 'assets/icons/other_complaints.png',
      'label': 'Other Complaints',
      'price': 250
    },
  ];

  @override
  Widget build(BuildContext context) {
    return AddToCartAnimation(
      cartKey: _cartKey,
      height: 24,
      width: 24,
      opacity: 0.85,
      createAddToCartAnimation: (addToCartAnimationMethod) {
        runAddToCartAnimation = addToCartAnimationMethod;
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF6F6F6),
        // Remove the AppBar completely
        body: SafeArea(
          child: Column(
            children: [
              // Location and Car Details - now directly in the body
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16.0, vertical: 12.0),
                child: Row(
                  children: [
                    const Icon(Icons.location_on,
                        color: Color(0xFF635BFF), size: 24),
                    const SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Secunderabad, HYD',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF4A4A4A),
                          ),
                        ),
                        Text(
                          'padmaraonagar',
                          style: TextStyle(
                            fontSize: 13,
                            color: Color(0xFF8E8E93),
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    // Replace with actual car image and name if available
                    Image.asset('assets/images/car_avatar.png', height: 30),
                    const SizedBox(width: 8),
                    const Text(
                      'Swift',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF4A4A4A),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const TextField(
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.search, color: Color(0xFF8E8E93)),
                      hintText: 'Search Services',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),
              ),
              // Rest of the content remains the same
              CarouselSlider(
                items: [
                  _buildBanner('Flat 50% OFF', 'On AC Service',
                      'assets/images/banner_ac.png'),
                  _buildBanner('Free Pickup & Drop', 'On All Services',
                      'assets/images/banner_tyre.png'),
                  _buildBanner('Get 1 Free Wash', 'With Every Service',
                      'assets/images/banner_wash.png'),
                ],
                options: CarouselOptions(
                  height: 140,
                  enlargeCenterPage: true,
                  autoPlay: true,
                  aspectRatio: 16 / 9,
                  autoPlayCurve: Curves.fastOutSlowIn,
                  enableInfiniteScroll: true,
                  autoPlayAnimationDuration: const Duration(milliseconds: 800),
                  viewportFraction: 0.92,
                ),
              ),
              const SizedBox(height: 12),
              // Quick Actions
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: quickActions.map((action) {
                    return _buildQuickAction(action);
                  }).toList(),
                ),
              ),
              const SizedBox(height: 8),
              // Services Grid
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: GridView.builder(
                    itemCount: services.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      childAspectRatio: 0.85,
                    ),
                    itemBuilder: (context, index) {
                      final service = services[index];
                      final cart = Provider.of<CartProvider>(context);
                      final isSelected = cart.services
                          .any((s) => s['label'] == service['label']);
                      return GestureDetector(
                        onTap: () {
                          if (isSelected) {
                            cart.removeService(service['label']);
                          } else {
                            cart.addService(service);
                          }
                        },
                        child: Stack(
                          children: [
                            _buildServiceCard(service),
                            if (isSelected)
                              Positioned(
                                right: 0,
                                top: 0,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF635BFF),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.check,
                                    color: Colors.white,
                                    size: 16,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
        // Bottom navigation bar remains the same
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
            // Navigate to cart screen if cart icon is tapped (index 2)
            if (index == 2) {
              Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (context) => const BookingCartScreen()),
              );
            }
            // Navigate to emergency request screen if emergency icon is tapped (index 1)
            else if (index == 1) {
              Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (context) => const EmergencyRequestScreen()),
              );
            }
            // Navigate to track service screen if track icon is tapped (index 3)
            else if (index == 3) {
              // Check for active bookings first
              final supabaseService = SupabaseService();
              supabaseService.getUserBookings().then((bookings) {
                // Filter for active bookings (not completed)
                final activeBookings = bookings
                    .where((booking) => booking.status != 'Completed')
                    .toList();

                if (activeBookings.isNotEmpty) {
                  // Use the most recent active booking
                  final latestBooking = activeBookings.first;
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => TrackServiceScreen(
                        hasBooking: true,
                        bookingId: latestBooking.id,
                      ),
                    ),
                  );
                } else {
                  // No active bookings, show the default screen
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const TrackServiceScreen(),
                    ),
                  );
                }
              }).catchError((error) {
                // Handle errors by showing the default screen
                print('Error checking bookings: $error');
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const TrackServiceScreen(),
                  ),
                );
              });
            }
            // Navigate to account details screen if account icon is tapped (index 4)
            else if (index == 4) {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const AccountDetailsScreen(),
                ),
              );
            }
          },
          selectedItemColor: const Color(0xFF635BFF),
          unselectedItemColor: const Color(0xFF8E8E93),
          showUnselectedLabels: true,
          items: [
            const BottomNavigationBarItem(
                icon: Icon(Icons.home), label: 'Home'),
            const BottomNavigationBarItem(
                icon: Icon(Icons.warning_amber_rounded), label: 'Emergency'),
            BottomNavigationBarItem(
              icon: AddToCartIcon(
                key: _cartKey,
                icon: Stack(
                  children: [
                    const Icon(Icons.shopping_cart_outlined),
                    Positioned(
                      right: 0,
                      top: 0,
                      child: Consumer<CartProvider>(
                        builder: (context, cart, child) {
                          final homeServiceCount = cart.services
                              .where((s) => s.containsKey('label'))
                              .length;
                          if (homeServiceCount == 0)
                            return const SizedBox.shrink();
                          return Container(
                            padding: const EdgeInsets.all(2),
                            decoration: const BoxDecoration(
                              color: Color(0xFFFF3B30),
                              shape: BoxShape.circle,
                            ),
                            constraints: const BoxConstraints(
                                minWidth: 16, minHeight: 16),
                            child: Text(
                              '$homeServiceCount',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              label: 'Cart',
            ),
            const BottomNavigationBarItem(
                icon: Icon(Icons.location_on), label: 'Track Service'),
            const BottomNavigationBarItem(
                icon: Icon(Icons.person_outline), label: 'Account'),
          ],
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          elevation: 12,
        ),
      ),
    );
  }

  Widget _buildBanner(String title, String subtitle, String img) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          colors: [Color(0xFFA095FF), Color(0xFF635BFF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 18.0, vertical: 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(title,
                      style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white)),
                  const SizedBox(height: 8),
                  Text(subtitle,
                      style:
                          const TextStyle(fontSize: 15, color: Colors.white)),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 18.0),
            child: Image.asset(img, width: 64, height: 64),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickAction(Map<String, dynamic> action) {
    return GestureDetector(
      onTap: () async {
        if (action['label'] == 'My Car Details') {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const MyCarDetailsScreen()),
          );
        } else if (action['label'] == 'Book Service') {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const BookServiceScreen()),
          );
        } else if (action['label'] == 'Booking Details') {
          Navigator.of(context).push(
            MaterialPageRoute(
                builder: (context) => const BookingDetailsScreen()),
          );
        }
        // Add more navigation for other quick actions if needed
      },
      child: Stack(
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.03),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(action['icon'], width: 26, height: 26),
                const SizedBox(height: 7),
                Text(
                  action['label'],
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF4A4A4A),
                      fontWeight: FontWeight.w500,
                      height: 1.2),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          if (action['alert'] == true)
            Positioned(
              top: 8,
              right: 8,
              child: Container(
                width: 9,
                height: 9,
                decoration: const BoxDecoration(
                  color: Color(0xFFFF3B30),
                  shape: BoxShape.circle,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildServiceCard(Map<String, dynamic> service) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 6),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            service['icon'],
            width: 24,
            height: 24,
            fit: BoxFit.contain,
          ),
          const SizedBox(height: 8),
          Text(
            service['label'],
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF4A4A4A),
              fontWeight: FontWeight.w500,
              height: 1.2,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

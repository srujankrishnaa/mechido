import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import 'booking_cart_screen.dart';

class BookingService4Screen extends StatelessWidget {
  const BookingService4Screen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F6),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            // Background image
            Container(
              height: 220,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/garage4_bg.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            // Main white card
            Container(
              margin: const EdgeInsets.only(
                  top: 140, left: 16, right: 16, bottom: 24),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 16,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Garage name and rating
                  Text(
                    'Splash Car Care',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Color(0xFF4A4A4A),
                      letterSpacing: 1.1,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.star,
                          color: Color(0xFFFFB300), size: 18),
                      const SizedBox(width: 4),
                      const Text('5.0',
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF4A4A4A),
                              fontSize: 15)),
                      const SizedBox(width: 4),
                      const Text('(1)',
                          style: TextStyle(
                              color: Color(0xFF8E8E93), fontSize: 13)),
                      const SizedBox(width: 10),
                      const Icon(Icons.location_on,
                          color: Color(0xFF635BFF), size: 18),
                      const SizedBox(width: 2),
                      const Text('Banjara Hills',
                          style: TextStyle(
                              color: Color(0xFF8E8E93), fontSize: 13)),
                      const Spacer(),
                      const Text('Shop Exp: 2018',
                          style: TextStyle(
                              color: Color(0xFF8E8E93), fontSize: 13)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Divider(color: Color(0xFFE0D7F3), thickness: 1),
                  const SizedBox(height: 12),
                  // Time slots
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFF6F6F6),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Weekdays
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text('WEEKDAYS:',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF635BFF))),
                              SizedBox(height: 4),
                              Text('Mon-Fri: 10:00am to 06:30pm',
                                  style: TextStyle(color: Color(0xFF4A4A4A))),
                            ],
                          ),
                        ),
                        Container(
                          width: 1,
                          height: 40,
                          color: const Color(0xFFE0D7F3),
                          margin: const EdgeInsets.symmetric(horizontal: 12),
                        ),
                        // Weekends
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text('WEEKENDS:',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF635BFF))),
                              SizedBox(height: 4),
                              Text('Sat-Sun: 10:00am to 06:30pm',
                                  style: TextStyle(color: Color(0xFF4A4A4A))),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: const [
                      Text('Labor Charge',
                          style: TextStyle(
                              color: Color(0xFF8E8E93),
                              fontWeight: FontWeight.bold,
                              fontSize: 13)),
                      Spacer(),
                      Text('Minimum labor charge',
                          style: TextStyle(
                              color: Color(0xFF8E8E93),
                              fontWeight: FontWeight.bold,
                              fontSize: 13)),
                      SizedBox(width: 8),
                      Text('₹650',
                          style: TextStyle(
                              color: Color(0xFF4A4A4A),
                              fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // Tabs
                  DefaultTabController(
                    length: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const TabBar(
                          labelColor: Color(0xFF635BFF),
                          unselectedLabelColor: Color(0xFF8E8E93),
                          indicatorColor: Color(0xFF635BFF),
                          labelStyle: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15),
                          tabs: [
                            Tab(text: 'About'),
                            Tab(text: 'Rating/Reviews'),
                            Tab(text: 'FAQ'),
                          ],
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 16, bottom: 8),
                          height: 280,
                          child: const TabBarView(
                            children: [
                              // About
                              SingleChildScrollView(
                                child: Align(
                                  alignment: Alignment.topLeft,
                                  child: Padding(
                                    padding: EdgeInsets.only(right: 8),
                                    child: Text(
                                      'Splash Car Care offers premium car detailing, polishing, and cleaning services in Banjara Hills, Hyderabad. Known for quality and customer satisfaction.',
                                      style: TextStyle(
                                          color: Color(0xFF4A4A4A),
                                          fontSize: 14),
                                    ),
                                  ),
                                ),
                              ),
                              // Reviews
                              SingleChildScrollView(
                                child: Align(
                                  alignment: Alignment.topLeft,
                                  child: Padding(
                                    padding: EdgeInsets.only(right: 8),
                                    child: Text(
                                      '"Better job done than expected." - Ashwin\n\n"My car looks brand new after their detailing service!" - Priya\n\n"Very professional and courteous staff." - Ramesh',
                                      style: TextStyle(
                                          color: Color(0xFF4A4A4A),
                                          fontSize: 14),
                                    ),
                                  ),
                                ),
                              ),
                              // FAQ
                              SingleChildScrollView(
                                child: Align(
                                  alignment: Alignment.topLeft,
                                  child: Padding(
                                    padding: EdgeInsets.only(right: 8),
                                    child: Text(
                                      'Q: Do you offer ceramic coating?\nA: Yes, we provide ceramic coating and paint protection film.\n\nQ: Do you offer doorstep service?\nA: Yes, doorstep car wash is available on request.\n\nQ: What products do you use?\nA: We use only premium, branded car care products.',
                                      style: TextStyle(
                                          color: Color(0xFF4A4A4A),
                                          fontSize: 14),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(
                      color: Color(0xFFE0D7F3), thickness: 1, height: 32),
                  // Garage Full Address
                  const Text(
                    'GARAGE FULL ADDRESS',
                    style: TextStyle(
                      color: Color(0xFF635BFF),
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Icon(Icons.location_on,
                          color: Color(0xFF635BFF), size: 18),
                      SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          'Banjara Hills, Hyderabad, Telangana 500033',
                          style:
                              TextStyle(color: Color(0xFF4A4A4A), fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  // Garage Staff Languages
                  const Text(
                    'GARAGE STAFF LANGUAGES',
                    style: TextStyle(
                      color: Color(0xFF635BFF),
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: const [
                      _LanguageChip(label: 'Telugu'),
                      _LanguageChip(label: 'English'),
                      _LanguageChip(label: 'Hindi'),
                    ],
                  ),
                  const SizedBox(height: 24),
                  // Buttons
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            // Set mechanic info
                            Provider.of<CartProvider>(context, listen: false)
                                .setMechanic({
                              'name': 'SPLASH CAR CARE',
                              'desc': 'Premium car detailing and cleaning',
                              'address':
                                  'Banjara Hills, Hyderabad, Telangana 500033',
                              'rating': 5.0,
                              'reviews': 1,
                              'image': 'assets/images/garage4_bg.jpg',
                              'price': 1250,
                            });
                            // Navigate to cart screen
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const BookingCartScreen(),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF635BFF),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: const Text(
                            'Confirm Booking',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {},
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Color(0xFFFF3B30)),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            backgroundColor: Colors.white,
                          ),
                          child: const Text(
                            'Cancel',
                            style: TextStyle(
                              color: Color(0xFFFF3B30),
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LanguageChip extends StatelessWidget {
  final String label;
  const _LanguageChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(
        label,
        style: const TextStyle(
          color: Color(0xFF4A4A4A),
          fontWeight: FontWeight.w500,
        ),
      ),
      backgroundColor: const Color(0xFFF6F6F6),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import 'booking_cart_screen.dart';

class BookingService2Screen extends StatelessWidget {
  const BookingService2Screen({Key? key}) : super(key: key);

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
                  image: AssetImage('assets/images/garage2_bg.jpg'),
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
                    'DILSUKHNAGAR SERVICE...'.toUpperCase(),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Color(0xFF2D2057),
                      letterSpacing: 1.1,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.star,
                          color: Color(0xFF7B4FFF), size: 18),
                      const SizedBox(width: 4),
                      const Text('4.9',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF7B4FFF),
                              fontSize: 15)),
                      const SizedBox(width: 4),
                      const Text('★ ★ ★ ★ ★',
                          style: TextStyle(
                              color: Color(0xFF7B4FFF), fontSize: 13)),
                      const SizedBox(width: 6),
                      const Text('(200)',
                          style: TextStyle(
                              color: Color(0xFF7B4FFF), fontSize: 13)),
                      const SizedBox(width: 10),
                      const Text('• Near 2KMS',
                          style: TextStyle(
                              color: Color(0xFF8E8E93), fontSize: 13)),
                    ],
                  ),
                  const SizedBox(height: 4),
                  const Text('Shop Experience : 2020 (Years Old)',
                      style: TextStyle(color: Color(0xFF8E8E93), fontSize: 13)),
                  const SizedBox(height: 16),
                  const Divider(color: Color(0xFFE0D7F3), thickness: 1),
                  const SizedBox(height: 12),
                  // Time slots
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Available Time Slots
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('AVAILABLE TIME SLOTS',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF2D2057),
                                    fontSize: 14)),
                            const SizedBox(height: 8),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Expanded(
                                    child: Text('Monday\nSaturday',
                                        style: TextStyle(
                                            color: Color(0xFF8E8E93),
                                            fontSize: 13))),
                                SizedBox(width: 8),
                                Expanded(
                                    child: Text('•  Friday\n10:00am to 05:00pm',
                                        style: TextStyle(
                                            color: Color(0xFF2D2057),
                                            fontSize: 13))),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: 1,
                        height: 48,
                        color: const Color(0xFFE0D7F3),
                        margin: const EdgeInsets.symmetric(horizontal: 12),
                      ),
                      // Weekends
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('WEEKENDS',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF2D2057),
                                    fontSize: 14)),
                            const SizedBox(height: 8),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Expanded(
                                    child: Text('Saturday\nSunday',
                                        style: TextStyle(
                                            color: Color(0xFF8E8E93),
                                            fontSize: 13))),
                                SizedBox(width: 8),
                                Expanded(
                                    child: Text(
                                        '• 09:00am\n• 10:00am o\n01:00pm',
                                        style: TextStyle(
                                            color: Color(0xFF2D2057),
                                            fontSize: 13))),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: const [
                      Text('Labor Charge',
                          style: TextStyle(
                              color: Color(0xFF4A4A4A),
                              fontWeight: FontWeight.bold,
                              fontSize: 13)),
                      SizedBox(width: 16),
                      Text('Minimum labor charge',
                          style: TextStyle(
                              color: Color(0xFF4A4A4A),
                              fontWeight: FontWeight.bold,
                              fontSize: 13)),
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
                                      'Mechido Garage is a leading car service center in Hyderabad, offering comprehensive maintenance and repair services for all vehicle types. Our skilled technicians use the latest diagnostic tools to ensure your car runs smoothly and safely. We are committed to providing quality service at transparent prices.',
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
                                      '"Excellent service! My car was fixed quickly and the price was fair. Highly recommended." - Rajesh K.\n\n"Friendly staff and professional work. They explained everything clearly." - Priya S.\n\n"Much better than the authorized service center. Will definitely come back." - Amit R.',
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
                                      'Q: Do you offer pick-up and drop-off service?\nA: Yes, we offer convenient pick-up and drop-off services within a certain radius.\n\nQ: What payment methods do you accept?\nA: We accept cash, credit/debit cards, and major digital payment methods.\n\nQ: Do you provide a warranty on repairs?\nA: Yes, we provide a warranty on parts and labor for most repairs.',
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
                          'Raigadha Thotar Area, Ravi Residency, Tejesh Nagar, Dilushakhnagar, Hyderabad – 500050',
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
                              'name': 'MECHIDO GARAGE',
                              'desc': 'Comprehensive maintenance and repair',
                              'address':
                                  'Raigadha Thotar Area, Ravi Residency, Tejesh Nagar, Dilushakhnagar, Hyderabad – 500050',
                              'rating': 4.9,
                              'reviews': 200,
                              'image': 'assets/images/garage2_bg.jpg',
                              'price': 750,
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

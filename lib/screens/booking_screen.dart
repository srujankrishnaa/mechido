import 'package:flutter/material.dart';

class BookingScreen extends StatelessWidget {
  const BookingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F6),
      appBar: AppBar(
        backgroundColor: const Color(0xFF635BFF),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'ABOUT THE GARAGE',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.1,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Image.asset(
                  'assets/images/garage1_bg.jpg',
                  width: double.infinity,
                  height: 180,
                  fit: BoxFit.cover,
                ),
                Positioned(
                  left: 16,
                  right: 16,
                  top: 120,
                  child: Material(
                    elevation: 4,
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'AutoFix Garage',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Color(0xFF4A4A4A),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(Icons.star,
                                  color: Color(0xFFFFB300), size: 18),
                              const SizedBox(width: 4),
                              Text(
                                '4.8',
                                style: const TextStyle(
                                  color: Color(0xFF4A4A4A),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '(150)',
                                style: const TextStyle(
                                  color: Color(0xFF8E8E93),
                                  fontSize: 13,
                                ),
                              ),
                              const SizedBox(width: 12),
                              const Icon(Icons.location_on,
                                  color: Color(0xFF635BFF), size: 18),
                              const SizedBox(width: 2),
                              Text(
                                'Kukatpally',
                                style: const TextStyle(
                                  color: Color(0xFF8E8E93),
                                  fontSize: 13,
                                ),
                              ),
                              const Spacer(),
                              Text(
                                'Shop Exp: 2012',
                                style: const TextStyle(
                                  color: Color(0xFF8E8E93),
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Container(
                            decoration: BoxDecoration(
                              color: Color(0xFFF6F6F6),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'AVAILABLE TIME SLOTS',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF4A4A4A),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: const [
                                          Text('WEEKDAYS:',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  color: Color(0xFF635BFF))),
                                          SizedBox(height: 4),
                                          Text('Mon-Fri: 10:00am to 08:00pm',
                                              style: TextStyle(
                                                  color: Color(0xFF4A4A4A))),
                                        ],
                                      ),
                                    ),
                                    SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: const [
                                          Text('WEEKENDS:',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  color: Color(0xFF635BFF))),
                                          SizedBox(height: 4),
                                          Text('Sat-Sun: 10:00am to 07:00pm',
                                              style: TextStyle(
                                                  color: Color(0xFF4A4A4A))),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: const [
                              Text('Labor Charge',
                                  style: TextStyle(color: Color(0xFF8E8E93))),
                              Spacer(),
                              Text('Minimum labor charge',
                                  style: TextStyle(color: Color(0xFF8E8E93))),
                              SizedBox(width: 8),
                              Text('₹550',
                                  style: TextStyle(
                                      color: Color(0xFF4A4A4A),
                                      fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 100),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: DefaultTabController(
                length: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TabBar(
                      labelColor: Color(0xFF635BFF),
                      unselectedLabelColor: Color(0xFF8E8E93),
                      indicatorColor: Color(0xFF635BFF),
                      labelStyle: const TextStyle(fontWeight: FontWeight.bold),
                      tabs: const [
                        Tab(text: 'About'),
                        Tab(text: 'Rating/Reviews'),
                        Tab(text: 'FAQ'),
                      ],
                    ),
                    Container(
                      height: 90,
                      padding: const EdgeInsets.only(top: 12),
                      child: const TabBarView(
                        children: [
                          Text(
                            'AutoFix Garage is a trusted car service center in Kukatpally, Hyderabad, offering expert repairs, maintenance, and breakdown services for all car brands. Known for reliability and customer satisfaction.',
                            style: TextStyle(color: Color(0xFF4A4A4A)),
                          ),
                          Center(
                              child: Text(
                                  '"Excellent service and friendly staff. My car was serviced on time and the pricing was fair. Highly recommended!" - Suresh R.',
                                  style: TextStyle(color: Color(0xFF4A4A4A)))),
                          Center(
                              child: Text(
                                  'FAQ: Do you offer doorstep service? Yes, we provide doorstep pickup and drop for your convenience.',
                                  style: TextStyle(color: Color(0xFF4A4A4A)))),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'GARAGE FULL ADDRESS:',
                      style: TextStyle(
                        color: Color(0xFF635BFF),
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Icon(Icons.location_on,
                            color: Color(0xFF635BFF), size: 18),
                        SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            'Plot 12, Main Road, Kukatpally, Hyderabad, Telangana 500072',
                            style: TextStyle(color: Color(0xFF4A4A4A)),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
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
                      children: [
                        _LanguageChip(label: 'Telugu'),
                        _LanguageChip(label: 'English'),
                        _LanguageChip(label: 'Hindi'),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {},
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
                    const SizedBox(height: 32),
                  ],
                ),
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

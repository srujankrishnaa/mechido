import 'package:flutter/material.dart';
import 'booking_service1.dart';
import 'booking_service2.dart';
import 'booking_service3.dart';
import 'booking_service4.dart';
import 'booking_service5.dart';

class BookServiceScreen extends StatefulWidget {
  const BookServiceScreen({Key? key}) : super(key: key);

  @override
  State<BookServiceScreen> createState() => _BookServiceScreenState();
}

class _BookServiceScreenState extends State<BookServiceScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<Map<String, dynamic>> nearbyServices = [
    {
      'name': 'AutoFix Garage',
      'image': 'assets/images/mechanic1.jpg',
      'duration': '1 Hour',
      'desc': 'Expert car repair & maintenance',
      'oldPrice': 500,
      'newPrice': 450,
      'discount': '10% Off',
    },
    {
      'name': 'Speedy Motors',
      'image': 'assets/images/mechanic2.jpg',
      'duration': '2 Hours',
      'desc': 'Quick and reliable service',
      'oldPrice': 600,
      'newPrice': 540,
      'discount': '10% Off',
    },
    {
      'name': 'Urban Auto Care',
      'image': 'assets/images/mechanic3.jpg',
      'duration': '1.5 Hours',
      'desc': 'Comprehensive vehicle care',
      'oldPrice': 700,
      'newPrice': 630,
      'discount': '10% Off',
    },
    {
      'name': 'Mech Masters',
      'image': 'assets/images/mechanic4.jpg',
      'duration': '2 Hours',
      'desc': 'Certified mechanics at your service',
      'oldPrice': 800,
      'newPrice': 720,
      'discount': '10% Off',
    },
    {
      'name': 'City Car Clinic',
      'image': 'assets/images/mechanic5.jpg',
      'duration': '1 Hour',
      'desc': 'Trusted by thousands',
      'oldPrice': 550,
      'newPrice': 495,
      'discount': '10% Off',
    },
  ];

  final List<Map<String, dynamic>> farawayServices = [
    {
      'name': 'Highway Auto Hub',
      'image': 'assets/images/mechanic1.jpg',
      'duration': '2 Hours',
      'desc': 'All repairs under one roof',
      'oldPrice': 900,
      'newPrice': 810,
      'discount': '10% Off',
    },
    {
      'name': 'Grand Garage',
      'image': 'assets/images/mechanic2.jpg',
      'duration': '1 Hour',
      'desc': 'Premium car care',
      'oldPrice': 1000,
      'newPrice': 900,
      'discount': '10% Off',
    },
    {
      'name': 'Metro Mech Point',
      'image': 'assets/images/mechanic3.jpg',
      'duration': '1.5 Hours',
      'desc': 'Modern equipment & skilled staff',
      'oldPrice': 850,
      'newPrice': 765,
      'discount': '10% Off',
    },
    {
      'name': 'Rapid Repairs',
      'image': 'assets/images/mechanic4.jpg',
      'duration': '2 Hours',
      'desc': 'Fastest turnaround time',
      'oldPrice': 950,
      'newPrice': 855,
      'discount': '10% Off',
    },
    {
      'name': 'Elite Auto Works',
      'image': 'assets/images/mechanic5.jpg',
      'duration': '1 Hour',
      'desc': 'Luxury car specialists',
      'oldPrice': 1200,
      'newPrice': 1080,
      'discount': '10% Off',
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F6),
      appBar: AppBar(
        backgroundColor: const Color(0xFF7B4FFF),
        elevation: 0,
        title: const Text('Book Service',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: const Color(0xFFD1C4E9),
          labelStyle:
              const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          tabs: const [
            Tab(text: 'Nearby Services'),
            Tab(text: 'Faraway Services'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildServiceList(nearbyServices),
          _buildServiceList(farawayServices),
        ],
      ),
    );
  }

  Widget _buildServiceList(List<Map<String, dynamic>> services) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: services.length,
      itemBuilder: (context, index) {
        final service = services[index];
        return _buildServiceCard(service);
      },
    );
  }

  Widget _buildServiceCard(Map<String, dynamic> service) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20)),
            child: Stack(
              children: [
                Image.asset(
                  service['image'],
                  width: double.infinity,
                  height: 150,
                  fit: BoxFit.cover,
                ),
                Positioned(
                  top: 12,
                  left: 12,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFF7B4FFF),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      service['discount'],
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 15),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  service['name'],
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 22),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.access_time,
                        color: Color(0xFF7B4FFF), size: 20),
                    const SizedBox(width: 6),
                    Text(service['duration'],
                        style: const TextStyle(
                            fontSize: 16,
                            color: Color(0xFF7B4FFF),
                            fontWeight: FontWeight.w500)),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.build, color: Color(0xFF7B4FFF), size: 20),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        service['desc'],
                        style: const TextStyle(
                            fontSize: 16, color: Color(0xFF4A4A4A)),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text('₹${service['oldPrice']}',
                            style: const TextStyle(
                                fontSize: 18,
                                color: Color(0xFF8E8E93),
                                decoration: TextDecoration.lineThrough)),
                        const SizedBox(width: 8),
                        Text('₹${service['newPrice']}',
                            style: const TextStyle(
                                fontSize: 20,
                                color: Color(0xFF7B4FFF),
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (service['image'] == 'assets/images/mechanic1.jpg') {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) =>
                                    const BookingService1Screen()),
                          );
                        } else if (service['image'] ==
                            'assets/images/mechanic2.jpg') {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) =>
                                    const BookingService2Screen()),
                          );
                        } else if (service['image'] ==
                            'assets/images/mechanic3.jpg') {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) =>
                                    const BookingService3Screen()),
                          );
                        } else if (service['image'] ==
                            'assets/images/mechanic4.jpg') {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) =>
                                    const BookingService4Screen()),
                          );
                        } else if (service['image'] ==
                            'assets/images/mechanic5.jpg') {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) =>
                                    const BookingService5Screen()),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF7B4FFF),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 28, vertical: 10),
                      ),
                      child: const Text('Book',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

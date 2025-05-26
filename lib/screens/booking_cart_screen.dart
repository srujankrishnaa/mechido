import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import 'payment_screen.dart';
import '../models/mechanic.dart';
import '../models/service.dart';

class BookingCartScreen extends StatelessWidget {
  const BookingCartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    final mechanic = cart.mechanic;
    final services = cart.services;
    final homeServices = services.where((s) => s.containsKey('label')).toList();
    final total =
        homeServices.fold<int>(0, (sum, s) => sum + (s['price'] as int? ?? 0));

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white.withOpacity(0.95),
                Colors.white.withOpacity(0.85),
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
        ),
        leading: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new,
                color: Color(0xFF4A4A4A), size: 20),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        title: const Text('Book Service',
            style: TextStyle(
                color: Color(0xFF2D3748),
                fontWeight: FontWeight.w700,
                fontSize: 18)),
        centerTitle: true,
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16, top: 8, bottom: 8),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Image.asset('assets/images/car_avatar.png',
                width: 28, height: 20),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color(0xFFF8F9FA),
              const Color(0xFFE9ECEF).withOpacity(0.3),
            ],
          ),
        ),
        child: homeServices.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            blurRadius: 20,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Image.asset('assets/icons/empty_cart.png',
                          width: 80, height: 80),
                    ),
                    const SizedBox(height: 24),
                    const Text('Your cart is empty',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF2D3748))),
                    const SizedBox(height: 8),
                    const Text('Add services to your cart to see them here.',
                        style:
                            TextStyle(color: Color(0xFF718096), fontSize: 16)),
                  ],
                ),
              )
            : SafeArea(
                child: SingleChildScrollView(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Mechanic info card (only show if mechanic is set)
                      if (mechanic != null)
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Colors.white,
                                const Color(0xFFF7FAFC),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.08),
                                blurRadius: 20,
                                offset: const Offset(0, 4),
                              ),
                              BoxShadow(
                                color: Colors.white.withOpacity(0.8),
                                blurRadius: 20,
                                offset: const Offset(0, -2),
                              ),
                            ],
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8, vertical: 4),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFF635BFF)
                                                .withOpacity(0.1),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          child: const Text('SELECTED',
                                              style: TextStyle(
                                                  color: Color(0xFF635BFF),
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.w600)),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Text(mechanic['name'] as String,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w700,
                                            fontSize: 18,
                                            color: Color(0xFF2D3748))),
                                    const SizedBox(height: 6),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF635BFF)
                                            .withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(mechanic['desc'] as String,
                                          style: const TextStyle(
                                              color: Color(0xFF635BFF),
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600)),
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      children: [
                                        const Icon(Icons.location_on_outlined,
                                            color: Color(0xFF718096), size: 16),
                                        const SizedBox(width: 4),
                                        Expanded(
                                          child: Text(
                                              mechanic['address'] as String,
                                              style: const TextStyle(
                                                  color: Color(0xFF718096),
                                                  fontSize: 13)),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 12),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 6),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFFFB300)
                                            .withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Icon(Icons.star_rounded,
                                              color: Color(0xFFFFB300),
                                              size: 18),
                                          const SizedBox(width: 4),
                                          Text('${mechanic['rating']}',
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.w700,
                                                  color: Color(0xFF2D3748),
                                                  fontSize: 14)),
                                          const SizedBox(width: 4),
                                          Text('(${mechanic['reviews']})',
                                              style: const TextStyle(
                                                  color: Color(0xFF718096),
                                                  fontSize: 12)),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 16),
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      blurRadius: 10,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.asset(
                                    mechanic['image']?.toString() ??
                                        'assets/images/car_avatar.png',
                                    width: 56,
                                    height: 40,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      if (mechanic != null) const SizedBox(height: 24),

                      // Services section header
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: Row(
                          children: [
                            Container(
                              width: 4,
                              height: 24,
                              decoration: BoxDecoration(
                                color: const Color(0xFF635BFF),
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                            const SizedBox(width: 12),
                            const Text('Selected Services',
                                style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 18,
                                    color: Color(0xFF2D3748))),
                            const Spacer(),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: const Color(0xFF635BFF).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text('${homeServices.length} items',
                                  style: const TextStyle(
                                      color: Color(0xFF635BFF),
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600)),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Services list
                      ...homeServices.asMap().entries.map((entry) {
                        final index = entry.key;
                        final s = entry.value;
                        return Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Colors.white,
                                const Color(0xFFF7FAFC),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(18),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.06),
                                blurRadius: 15,
                                offset: const Offset(0, 3),
                              ),
                              BoxShadow(
                                color: Colors.white.withOpacity(0.8),
                                blurRadius: 15,
                                offset: const Offset(0, -1),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(18),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF635BFF)
                                        .withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  child: Image.asset(
                                      s['icon']?.toString() ??
                                          'assets/icons/default.png',
                                      width: 28,
                                      height: 28),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(s['label']?.toString() ?? '',
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 16,
                                              color: Color(0xFF2D3748))),
                                      const SizedBox(height: 4),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFF48BB78)
                                              .withOpacity(0.1),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: Text(
                                            '₹${s['price']?.toString() ?? '0'}',
                                            style: const TextStyle(
                                                color: Color(0xFF48BB78),
                                                fontSize: 14,
                                                fontWeight: FontWeight.w700)),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFFF3B30)
                                        .withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: IconButton(
                                    icon: const Icon(
                                        Icons.delete_outline_rounded,
                                        color: Color(0xFFFF3B30),
                                        size: 22),
                                    onPressed: () {
                                      Provider.of<CartProvider>(context,
                                              listen: false)
                                          .removeService(
                                              s['label']?.toString() ?? '');
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),

                      const SizedBox(height: 8),

                      // Total section
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              const Color(0xFF635BFF).withOpacity(0.05),
                              const Color(0xFF635BFF).withOpacity(0.02),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(
                            color: const Color(0xFF635BFF).withOpacity(0.2),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Total Amount',
                                    style: TextStyle(
                                        color: Color(0xFF718096),
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500)),
                                SizedBox(height: 2),
                                Text('Including all services',
                                    style: TextStyle(
                                        color: Color(0xFF718096),
                                        fontSize: 12)),
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              decoration: BoxDecoration(
                                color: const Color(0xFF635BFF),
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFF635BFF)
                                        .withOpacity(0.3),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Text(
                                  '₹${homeServices.fold<int>(mechanic != null && mechanic['price'] != null ? mechanic['price'] as int : 0, (sum, s) => sum + (s['price'] as int? ?? 0))}',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 22,
                                      color: Colors.white)),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Confirm button
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF635BFF).withOpacity(0.3),
                              blurRadius: 20,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: ElevatedButton(
                          onPressed: () {
                            if (mechanic != null && homeServices.isNotEmpty) {
                              // Convert mechanic map to Mechanic model
                              final mechanicModel = Mechanic(
                                id: mechanic['id'] ?? '',
                                name: mechanic['name'] ?? '',
                                image: mechanic['image'] ?? '',
                                rating: (mechanic['rating'] ?? 0).toDouble(),
                                specialization: mechanic['desc'] ?? '',
                                experience: mechanic['experience'] ?? 0,
                                price: (mechanic['price'] ?? 0).toDouble(),
                              );

                              // For simplicity, let's use the first selected service
                              final s = homeServices.first;
                              final serviceModel = Service(
                                id: s['id'] ?? '',
                                name: s['label'] ?? '',
                                description: '', // Add if available
                                price: (s['price'] ?? 0).toDouble(),
                                image: s['icon'] ?? '',
                                duration: 30, // Set a default or get from s
                              );

                              final totalAmount = homeServices.fold<double>(
                                  0,
                                  (sum, s) =>
                                      sum +
                                      (s['price'] as int? ?? 0).toDouble());

                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => PaymentScreen(
                                    mechanic: mechanicModel,
                                    service: serviceModel,
                                    amount: totalAmount,
                                  ),
                                ),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF635BFF),
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 18),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.payment_rounded, size: 22),
                              const SizedBox(width: 8),
                              const Text(
                                'Proceed to Payment',
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: const Icon(Icons.arrow_forward_ios,
                                    size: 14),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}

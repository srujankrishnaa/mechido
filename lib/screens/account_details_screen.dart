import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import 'home_screen.dart';
import 'login_screen.dart';

class AccountDetailsScreen extends StatelessWidget {
  const AccountDetailsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF635BFF),
              Color(0xFF8B7EFF),
              Color(0xFFF8F9FA),
            ],
            stops: [0.0, 0.3, 1.0],
          ),
        ),
        child: SafeArea(
          child: CustomScrollView(
            slivers: [
              // Enhanced App Bar with gradient
              SliverAppBar(
                expandedHeight: 230, // Further reduced from 240 to 230
                floating: false,
                pinned: true,
                elevation: 0,
                backgroundColor: const Color(0xFF635BFF),
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color(0xFF635BFF),
                          Color(0xFF8B7EFF),
                        ],
                      ),
                    ),
                    child: SafeArea(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(height: 15), // Reduced from 16 to 15
                          // Enhanced Profile Avatar
                          Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.white.withOpacity(0.3),
                                width: 3,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 20,
                                  spreadRadius: 5,
                                ),
                              ],
                            ),
                            child: const CircleAvatar(
                              radius: 42, // Reduced from 45 to 42
                              backgroundColor: Colors.white,
                              child: Icon(
                                Icons.person,
                                size: 42, // Reduced from 45 to 42
                                color: Color(0xFF635BFF),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12), // Reduced from 15
                          // User Name
                          const Text(
                            'John Doe',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 26, // Reduced from 28 to 26
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(height: 4), // Reduced from 6
                          // Email with icon
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.email_outlined,
                                color: Colors.white.withOpacity(0.8),
                                size: 16, // Reduced from 18 to 16
                              ),
                              const SizedBox(width: 6), // Reduced from 8 to 6
                              Text(
                                'john.doe@example.com',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.9),
                                  fontSize: 14, // Reduced from 16 to 14
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6), // Reduced from 8
                          // Phone with enhanced styling
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16, // Reduced from 20 to 16
                              vertical: 8, // Reduced from 10 to 8
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(
                                  20), // Reduced from 25 to 20
                              border: Border.all(
                                color: Colors.white.withOpacity(0.2),
                                width: 1,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.phone_outlined,
                                  color: Colors.white.withOpacity(0.9),
                                  size: 16, // Reduced from 18 to 16
                                ),
                                const SizedBox(
                                    width: 8), // Reduced from 10 to 8
                                const Text(
                                  '+91 98765 43210',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14, // Reduced from 16 to 14
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              // Content
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                      20, 20, 20, 20), // Set bottom padding to 20
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Section Title
                      const Text(
                        'Account Settings',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2D3748),
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Enhanced Option Cards
                      _buildEnhancedOptionCard(
                        icon: Icons.payment_outlined,
                        title: 'Payment Details',
                        subtitle: 'Manage your payment methods',
                        color: const Color(0xFF4299E1),
                        onTap: () {
                          // TODO: Navigate to payment details
                        },
                      ),
                      _buildEnhancedOptionCard(
                        icon: Icons.history_outlined,
                        title: 'Booking History',
                        subtitle: 'View your past bookings',
                        color: const Color(0xFF48BB78),
                        onTap: () {
                          // TODO: Navigate to booking history
                        },
                      ),
                      _buildEnhancedOptionCard(
                        icon: Icons.build_outlined,
                        title: 'Service History',
                        subtitle: 'Track your service records',
                        color: const Color(0xFFED8936),
                        onTap: () {
                          // TODO: Navigate to service history
                        },
                      ),
                      _buildEnhancedOptionCard(
                        icon: Icons.help_outline,
                        title: 'Help & Support',
                        subtitle: 'Get assistance and FAQs',
                        color: const Color(0xFF9F7AEA),
                        onTap: () {
                          // TODO: Navigate to help section
                        },
                      ),
                      const SizedBox(height: 24), // Reduced from 30 to 24
                      // Enhanced Logout Button
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.red.withOpacity(0.2),
                              blurRadius: 15,
                              spreadRadius: 2,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: ElevatedButton(
                          onPressed: () {
                            _showLogoutDialog(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFE53E3E),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 18),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 0,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.logout_outlined,
                                size: 20,
                              ),
                              const SizedBox(width: 10),
                              const Text(
                                'Logout',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20), // Add space at the bottom
                    ],
                  ), // Closing Column
                ), // Closing Padding
              ), // Closing SliverToBoxAdapter
            ], // Closing slivers
          ), // Closing CustomScrollView
        ), // Closing Container
      ), // Closing SafeArea wrapper
    ); // Closing Scaffold
  }

  Widget _buildEnhancedOptionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            spreadRadius: 2,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                // Icon Container
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    icon,
                    color: color,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                // Text Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF2D3748),
                          letterSpacing: 0.2,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
                // Arrow Icon
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.grey.shade600,
                    size: 14,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.logout_outlined,
                color: Colors.red,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            const Text(
              'Logout',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        content: const Text(
          'Are you sure you want to logout from your account?',
          style: TextStyle(
            fontSize: 16,
            color: Color(0xFF4A5568),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 12,
              ),
            ),
            child: Text(
              'Cancel',
              style: TextStyle(
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              // Clear cart and navigate to login screen
              Provider.of<CartProvider>(context, listen: false).clearCart();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
                (route) => false,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 12,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'Logout',
              style: TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

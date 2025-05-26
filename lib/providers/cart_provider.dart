import 'package:flutter/material.dart';

class CartProvider extends ChangeNotifier {
  List<Map<String, dynamic>> _services = [];
  Map<String, dynamic>? _mechanic;

  List<Map<String, dynamic>> get services => _services;
  Map<String, dynamic>? get mechanic => _mechanic;

  void addService(Map<String, dynamic> service) {
    final id = service['label'] ?? service['name'];
    if (!_services.any((s) => (s['label'] ?? s['name']) == id)) {
      _services.add(service);
      notifyListeners();
    }
  }

  void removeService(String serviceId) {
    _services.removeWhere((s) => (s['label'] ?? s['name']) == serviceId);
    notifyListeners();
  }

  void setMechanic(Map<String, dynamic> mechanic) {
    _mechanic = mechanic;
    notifyListeners();
  }

  void clearCart() {
    _services = [];
    _mechanic = null;
    notifyListeners();
  }

  int get serviceCount => _services.length;
  bool get isEmpty => _services.isEmpty && _mechanic == null;

  bool isHomeService(Map<String, dynamic> service) {
    return service.containsKey('label');
  }

  int getTotalAmount() {
    int serviceTotal = services.fold<int>(
        0, (sum, service) => sum + (service['price'] as int? ?? 0));
    int mechanicCharge = mechanic?['price'] as int? ?? 0;
    return serviceTotal + mechanicCharge;
  }
}

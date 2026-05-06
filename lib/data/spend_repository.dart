import 'package:flutter/material.dart';
import 'package:spend_summary/models/category_model.dart';
import 'package:spend_summary/models/spend_summary_model.dart';
import 'package:spend_summary/models/transaction_model.dart';



class SpendRepository {
  SpendRepository._();

  static Future<SpendSummary> fetchSummary() async {
    await Future.delayed(const Duration(milliseconds: 700));
    return SpendSummary(
      totalSpend: 84320.50,
      lastMonthSpend: 71200.00,
      categories: _categories,
      transactions: _transactions,
    );
  }

  static const List<SpendCategory> _categories = [
    SpendCategory(name: 'Food',          icon: Icons.restaurant_rounded,      amount: 18420.00, color: Color(0xFFFF6B6B), transactionCount: 23),
    SpendCategory(name: 'Travel',        icon: Icons.flight_rounded,           amount: 24800.00, color: Color(0xFF4ECDC4), transactionCount: 8),
    SpendCategory(name: 'Shopping',      icon: Icons.shopping_bag_rounded,     amount: 15600.00, color: Color(0xFFFFBE0B), transactionCount: 14),
    SpendCategory(name: 'Bills',         icon: Icons.receipt_long_rounded,     amount: 12500.00, color: Color(0xFF7C6FFF), transactionCount: 6),
    SpendCategory(name: 'Health',        icon: Icons.favorite_rounded,         amount: 6200.50,  color: Color(0xFFFF9A9E), transactionCount: 4),
    SpendCategory(name: 'Entertainment', icon: Icons.movie_rounded,            amount: 4800.00,  color: Color(0xFF38BDF8), transactionCount: 7),
    SpendCategory(name: 'Transport',     icon: Icons.directions_car_rounded,   amount: 2000.00,  color: Color(0xFFA78BFA), transactionCount: 5),
  ];

  static final List<Transaction> _transactions = [
    Transaction(id: 't01', merchant: 'Swiggy',           category: 'Food',          amount: 485.00,    date: DateTime(2025,5,5,14,30),  icon: Icons.restaurant_rounded,      color: Color(0xFFFF6B6B)),
    Transaction(id: 't02', merchant: 'IndiGo Airlines',  category: 'Travel',        amount: 8200.00,   date: DateTime(2025,5,5,10,15),  icon: Icons.flight_rounded,           color: Color(0xFF4ECDC4)),
    Transaction(id: 't03', merchant: 'Amazon',           category: 'Shopping',      amount: 2340.00,   date: DateTime(2025,5,4,17,0),   icon: Icons.shopping_bag_rounded,     color: Color(0xFFFFBE0B)),
    Transaction(id: 't04', merchant: 'Netflix',          category: 'Entertainment', amount: 649.00,    date: DateTime(2025,5,4,0,0),    icon: Icons.movie_rounded,            color: Color(0xFF38BDF8)),
    Transaction(id: 't05', merchant: 'Zomato',           category: 'Food',          amount: 312.00,    date: DateTime(2025,5,4,13,20),  icon: Icons.fastfood_rounded,         color: Color(0xFFFF6B6B)),
    Transaction(id: 't06', merchant: 'Reliance Jio',     category: 'Bills',         amount: 999.00,    date: DateTime(2025,5,3,9,0),    icon: Icons.receipt_long_rounded,     color: Color(0xFF7C6FFF)),
    Transaction(id: 't07', merchant: 'Ola',              category: 'Transport',     amount: 180.00,    date: DateTime(2025,5,3,19,45),  icon: Icons.directions_car_rounded,   color: Color(0xFFA78BFA)),
    Transaction(id: 't08', merchant: 'Apollo Pharmacy',  category: 'Health',        amount: 890.50,    date: DateTime(2025,5,3,11,30),  icon: Icons.favorite_rounded,         color: Color(0xFFFF9A9E)),
    Transaction(id: 't09', merchant: 'Myntra',           category: 'Shopping',      amount: 1850.00,   date: DateTime(2025,5,2,16,10),  icon: Icons.shopping_bag_rounded,     color: Color(0xFFFFBE0B)),
    Transaction(id: 't10', merchant: 'Salary Credit',    category: 'Income',        amount: 95000.00,  date: DateTime(2025,5,1,9,0),    icon: Icons.account_balance_rounded,  color: Color(0xFF34D399), isCredit: true),
    Transaction(id: 't11', merchant: 'Starbucks',        category: 'Food',          amount: 620.00,    date: DateTime(2025,5,1,8,45),   icon: Icons.local_cafe_rounded,       color: Color(0xFFFF6B6B)),
    Transaction(id: 't12', merchant: 'Taj Hotels',       category: 'Travel',        amount: 12400.00,  date: DateTime(2025,4,30,14,0),  icon: Icons.hotel_rounded,            color: Color(0xFF4ECDC4)),
    Transaction(id: 't13', merchant: 'BESCOM',           category: 'Bills',         amount: 2100.00,   date: DateTime(2025,4,30,10,0),  icon: Icons.bolt_rounded,             color: Color(0xFF7C6FFF)),
    Transaction(id: 't14', merchant: 'Uber',             category: 'Transport',     amount: 340.00,    date: DateTime(2025,4,29,20,30), icon: Icons.directions_car_rounded,   color: Color(0xFFA78BFA)),
    Transaction(id: 't15', merchant: 'BookMyShow',       category: 'Entertainment', amount: 800.00,    date: DateTime(2025,4,29,18,0),  icon: Icons.movie_rounded,            color: Color(0xFF38BDF8)),
    Transaction(id: 't16', merchant: 'DMart',            category: 'Shopping',      amount: 3200.00,   date: DateTime(2025,4,28,11,0),  icon: Icons.shopping_cart_rounded,    color: Color(0xFFFFBE0B)),
    Transaction(id: 't17', merchant: 'Swiggy Instamart', category: 'Food',          amount: 540.00,    date: DateTime(2025,4,28,9,30),  icon: Icons.delivery_dining_rounded,  color: Color(0xFFFF6B6B)),
    Transaction(id: 't18', merchant: 'Decathlon',        category: 'Shopping',      amount: 4100.00,   date: DateTime(2025,4,27,15,0),  icon: Icons.sports_basketball_rounded,color: Color(0xFFFFBE0B)),
    Transaction(id: 't19', merchant: 'Fortis Hospital',  category: 'Health',        amount: 2800.00,   date: DateTime(2025,4,27,10,30), icon: Icons.local_hospital_rounded,   color: Color(0xFFFF9A9E)),
    Transaction(id: 't20', merchant: 'Airtel',           category: 'Bills',         amount: 499.00,    date: DateTime(2025,4,26,8,0),   icon: Icons.wifi_rounded,             color: Color(0xFF7C6FFF)),
    Transaction(id: 't21', merchant: 'Pizza Hut',        category: 'Food',          amount: 780.00,    date: DateTime(2025,4,26,20,0),  icon: Icons.local_pizza_rounded,      color: Color(0xFFFF6B6B)),
    Transaction(id: 't22', merchant: 'Rapido',           category: 'Transport',     amount: 95.00,     date: DateTime(2025,4,25,9,15),  icon: Icons.two_wheeler_rounded,      color: Color(0xFFA78BFA)),
    Transaction(id: 't23', merchant: 'Flipkart',         category: 'Shopping',      amount: 1299.00,   date: DateTime(2025,4,25,14,45), icon: Icons.shopping_bag_rounded,     color: Color(0xFFFFBE0B)),
    Transaction(id: 't24', merchant: 'Spotify',          category: 'Entertainment', amount: 119.00,    date: DateTime(2025,4,24,0,0),   icon: Icons.music_note_rounded,       color: Color(0xFF38BDF8)),
    Transaction(id: 't25', merchant: 'McDonalds',        category: 'Food',          amount: 445.00,    date: DateTime(2025,4,24,13,0),  icon: Icons.fastfood_rounded,         color: Color(0xFFFF6B6B)),
    Transaction(id: 't26', merchant: 'MakeMyTrip',       category: 'Travel',        amount: 4200.00,   date: DateTime(2025,4,23,11,0),  icon: Icons.luggage_rounded,          color: Color(0xFF4ECDC4)),
    Transaction(id: 't27', merchant: 'HDFC Home Loan',   category: 'Bills',         amount: 8900.00,   date: DateTime(2025,4,23,8,0),   icon: Icons.home_rounded,             color: Color(0xFF7C6FFF)),
    Transaction(id: 't28', merchant: 'Nykaa',            category: 'Shopping',      amount: 2150.00,   date: DateTime(2025,4,22,16,0),  icon: Icons.face_rounded,             color: Color(0xFFFFBE0B)),
    Transaction(id: 't29', merchant: 'Cult.fit',         category: 'Health',        amount: 1800.00,   date: DateTime(2025,4,22,7,30),  icon: Icons.fitness_center_rounded,   color: Color(0xFFFF9A9E)),
    Transaction(id: 't30', merchant: 'KFC',              category: 'Food',          amount: 560.00,    date: DateTime(2025,4,21,19,0),  icon: Icons.restaurant_rounded,       color: Color(0xFFFF6B6B)),
    Transaction(id: 't31', merchant: 'Hotstar',          category: 'Entertainment', amount: 299.00,    date: DateTime(2025,4,20,0,0),   icon: Icons.live_tv_rounded,          color: Color(0xFF38BDF8)),
    Transaction(id: 't32', merchant: 'Big Basket',       category: 'Food',          amount: 1840.00,   date: DateTime(2025,4,20,10,0),  icon: Icons.local_grocery_store_rounded,color: Color(0xFFFF6B6B)),
    Transaction(id: 't33', merchant: 'Indigo Cab',       category: 'Transport',     amount: 420.00,    date: DateTime(2025,4,19,17,30), icon: Icons.directions_car_rounded,   color: Color(0xFFA78BFA)),
    Transaction(id: 't34', merchant: 'IKEA',             category: 'Shopping',      amount: 5400.00,   date: DateTime(2025,4,19,13,0),  icon: Icons.chair_rounded,            color: Color(0xFFFFBE0B)),
    Transaction(id: 't35', merchant: 'Manipal Hospital', category: 'Health',        amount: 700.00,    date: DateTime(2025,4,18,11,0),  icon: Icons.medical_services_rounded, color: Color(0xFFFF9A9E)),
    Transaction(id: 't36', merchant: 'Blinkit',          category: 'Food',          amount: 280.00,    date: DateTime(2025,4,18,8,30),  icon: Icons.delivery_dining_rounded,  color: Color(0xFFFF6B6B)),
    Transaction(id: 't37', merchant: 'Tata Power',       category: 'Bills',         amount: 1800.00,   date: DateTime(2025,4,17,9,0),   icon: Icons.electrical_services_rounded,color: Color(0xFF7C6FFF)),
    Transaction(id: 't38', merchant: 'Subway',           category: 'Food',          amount: 360.00,    date: DateTime(2025,4,16,13,30), icon: Icons.lunch_dining_rounded,     color: Color(0xFFFF6B6B)),
    Transaction(id: 't39', merchant: 'Cleartrip',        category: 'Travel',        amount: 6800.00,   date: DateTime(2025,4,16,10,0),  icon: Icons.flight_takeoff_rounded,   color: Color(0xFF4ECDC4)),
    Transaction(id: 't40', merchant: 'PharmEasy',        category: 'Health',        amount: 920.00,    date: DateTime(2025,4,15,14,0),  icon: Icons.medication_rounded,       color: Color(0xFFFF9A9E)),
    Transaction(id: 't41', merchant: 'Zepto',            category: 'Food',          amount: 195.00,    date: DateTime(2025,4,15,7,0),   icon: Icons.store_rounded,            color: Color(0xFFFF6B6B)),
    Transaction(id: 't42', merchant: 'Amazon Prime',     category: 'Entertainment', amount: 299.00,    date: DateTime(2025,4,14,0,0),   icon: Icons.play_circle_rounded,      color: Color(0xFF38BDF8)),
    Transaction(id: 't43', merchant: 'Autorickshaw',     category: 'Transport',     amount: 75.00,     date: DateTime(2025,4,14,9,0),   icon: Icons.electric_rickshaw_rounded,color: Color(0xFFA78BFA)),
    Transaction(id: 't44', merchant: 'Crossword Books',  category: 'Shopping',      amount: 890.00,    date: DateTime(2025,4,13,16,0),  icon: Icons.menu_book_rounded,        color: Color(0xFFFFBE0B)),
    Transaction(id: 't45', merchant: 'Burger King',      category: 'Food',          amount: 410.00,    date: DateTime(2025,4,13,20,0),  icon: Icons.lunch_dining_rounded,     color: Color(0xFFFF6B6B)),
    Transaction(id: 't46', merchant: 'BWSSB',            category: 'Bills',         amount: 340.00,    date: DateTime(2025,4,12,8,0),   icon: Icons.water_drop_rounded,       color: Color(0xFF7C6FFF)),
    Transaction(id: 't47', merchant: 'Boat Earphones',   category: 'Shopping',      amount: 1500.00,   date: DateTime(2025,4,12,15,0),  icon: Icons.headphones_rounded,       color: Color(0xFFFFBE0B)),
    Transaction(id: 't48', merchant: 'Barista',          category: 'Food',          amount: 340.00,    date: DateTime(2025,4,11,9,0),   icon: Icons.coffee_rounded,           color: Color(0xFFFF6B6B)),
    Transaction(id: 't49', merchant: 'OYO Rooms',        category: 'Travel',        amount: 2800.00,   date: DateTime(2025,4,11,14,0),  icon: Icons.hotel_rounded,            color: Color(0xFF4ECDC4)),
    Transaction(id: 't50', merchant: 'Puma Store',       category: 'Shopping',      amount: 3200.00,   date: DateTime(2025,4,10,13,0),  icon: Icons.sports_rounded,           color: Color(0xFFFFBE0B)),
    Transaction(id: 't51', merchant: 'Natural Ice Cream',category: 'Food',          amount: 180.00,    date: DateTime(2025,4,10,17,30), icon: Icons.icecream_rounded,         color: Color(0xFFFF6B6B)),
    Transaction(id: 't52', merchant: 'Lenskart',         category: 'Health',        amount: 1890.00,   date: DateTime(2025,4,9,12,0),   icon: Icons.remove_red_eye_rounded,   color: Color(0xFFFF9A9E)),
    Transaction(id: 't53', merchant: 'Sony LIV',         category: 'Entertainment', amount: 699.00,    date: DateTime(2025,4,9,0,0),    icon: Icons.tv_rounded,               color: Color(0xFF38BDF8)),
    Transaction(id: 't54', merchant: 'Ola Electric',     category: 'Transport',     amount: 890.00,    date: DateTime(2025,4,8,10,0),   icon: Icons.electric_moped_rounded,   color: Color(0xFFA78BFA)),
    Transaction(id: 't55', merchant: 'Licious',          category: 'Food',          amount: 620.00,    date: DateTime(2025,4,8,18,30),  icon: Icons.set_meal_rounded,         color: Color(0xFFFF6B6B)),
    Transaction(id: 't56', merchant: 'Instagram Ads',    category: 'Shopping',      amount: 500.00,    date: DateTime(2025,4,7,11,0),   icon: Icons.ads_click_rounded,        color: Color(0xFFFFBE0B)),
    Transaction(id: 't57', merchant: 'Café Coffee Day',  category: 'Food',          amount: 280.00,    date: DateTime(2025,4,7,16,0),   icon: Icons.coffee_rounded,           color: Color(0xFFFF6B6B)),
  ];
}

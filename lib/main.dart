import 'package:fash_food/core/firebase/seed_categories.dart';
import 'package:fash_food/core/firebase/seed_data.dart';
import 'package:fash_food/core/firebase/seed_orders.dart';
import 'package:fash_food/core/firebase/seed_users.dart';
import 'package:fash_food/core/firebase/seed_banner.dart';
import 'package:fash_food/core/firebase/seed_combos.dart';
import 'package:fash_food/features/home/presentation/pages/home_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fash_food/config/routes/app_router.dart';
import 'package:fash_food/firebase_options.dart';
import 'package:fash_food/injection_container.dart' as di;

import 'core/firebase/seed_carts.dart';
import 'core/firebase/seed_adresses.dart';
import 'core/firebase/seed_reviews.dart';
import 'core/firebase/seed_notifications.dart';
import 'core/firebase/seed_favorites.dart';
import 'core/firebase/seed_vouchers.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await di.init();
  
  // Bỏ comment các dòng dưới đây để upload dữ liệu lên Firebase, sau đó comment lại
  // await SeedFoods.uploadFoods();
  // await SeedCategories.uploadCategories();
  // await SeedUsers.uploadUsers();
  // await SeedBanner.uploadBanner();
  //await SeedCombos.uploadCombos(); // Gọi hàm upload Combo
   // await SeedOrders.uploadOrders();
  //await SeedCarts.uploadCarts();
  //await SeedFavorites.uploadFavorites();
  //await SeedAddresses.uploadAddresses();
  //await SeedReviews.uploadReviews();
  //await SeedNotifications.uploadNotifications();
  //await SeedVouchers.uploadVouchers();
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FastFood',
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

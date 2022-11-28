import 'package:ecom_admin/pages/add_product_page.dart';
import 'package:ecom_admin/pages/category_page.dart';
import 'package:ecom_admin/pages/dashboard_page.dart';
import 'package:ecom_admin/pages/launcher_page.dart';
import 'package:ecom_admin/pages/login_page.dart';
import 'package:ecom_admin/pages/notification_page.dart';
import 'package:ecom_admin/pages/order_details_Page.dart';
import 'package:ecom_admin/pages/order_page.dart';
import 'package:ecom_admin/pages/product_details_page.dart';
import 'package:ecom_admin/pages/product_repurchase_page.dart';
import 'package:ecom_admin/pages/report_page.dart';
import 'package:ecom_admin/pages/settings_page.dart';
import 'package:ecom_admin/pages/user_list_page.dart';
import 'package:ecom_admin/pages/veiw_product_page.dart';
import 'package:ecom_admin/providers/notification_provider.dart';
import 'package:ecom_admin/providers/order_provider.dart';
import 'package:ecom_admin/providers/product_provider.dart';
import 'package:ecom_admin/providers/user_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => ProductProvider()),
      ChangeNotifierProvider(create: (_) => OrderProvider()),
      ChangeNotifierProvider(create: (_) => UserProvider()),
      ChangeNotifierProvider(create: (_) => NotificationProvider()),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Ecommerce Project',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      builder: EasyLoading.init(),
      initialRoute: LauncherPage.routeName,
      routes: {
        AddProductPage.routeName: (context) => const AddProductPage(),
        CategoryPage.routeName: (context) => const CategoryPage(),
        DashBoardPage.routeName: (context) => const DashBoardPage(),
        LauncherPage.routeName: (context) => const LauncherPage(),
        LoginPage.routeName: (context) => const LoginPage(),
        ProductDetailsPage.routeName: (context) =>const ProductDetailsPage(),
        ProductRepurchasePage.routeName: (context) => const ProductRepurchasePage(),
        ReportPage.routeName: (context) => const ReportPage(),
        SettingsPage.routeName: (context) => const SettingsPage(),
        OrderPage.routeName: (_) => const OrderPage(),
        OrderDetailsPage.routeName: (_) => const OrderDetailsPage(),
        UserListPage.routeName: (context) => const UserListPage(),
        ViewProductPage.routeName: (context) => const ViewProductPage(),
        NotificationPage.routeName: (context) => const NotificationPage(),
      },
    );
  }
}

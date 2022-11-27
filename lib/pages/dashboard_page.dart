import 'package:ecom_admin/auth/auth_service.dart';
import 'package:ecom_admin/providers/order_provider.dart';
import 'package:ecom_admin/providers/product_provider.dart';
import 'package:ecom_admin/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../custom_widgets/dashboard_item_view.dart';
import '../models/dashboard_model.dart';
import 'launcher_page.dart';

class DashBoardPage extends StatelessWidget {
  static const String routeName = '/dashboard';

  const DashBoardPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Provider.of<ProductProvider>(context,listen: false).getAllCategories();
    Provider.of<ProductProvider>(context,listen: false).getAllProducts();
    Provider.of<ProductProvider>(context,listen: false).getAllPurchases();
    Provider.of<OrderProvider>(context,listen: false).getOrderConstants();
    Provider.of<OrderProvider>(context,listen: false).getOrders();
    Provider.of<UserProvider>(context,listen: false).getAllUsers();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            onPressed: () {
           showDialog(context: context, builder: (context)=> AlertDialog(
             title: const Text('Logout'),
             content: const Text('Do you want to logout'),
             actions: [
               TextButton(onPressed: (){
                 Navigator.pop(context);
               }, child: const Text('Cancel'),),
               TextButton(onPressed: (){
                 AuthService.logOut().then(
                       (value) => Navigator.pushReplacementNamed(
                     context,
                     LauncherPage.routeName,
                   ),
                 );
               }, child: const Text('Yes'),),
             ],
           ));
            },
            icon: const Icon(
              Icons.logout,
            ),
          ),
        ],
      ),
      body: GridView.builder(
        gridDelegate:  SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: MediaQuery.of(context).size.width > 600 ? 3 : 2,
        ),
        itemCount: dashboardModelList.length,
        itemBuilder: (context, index) => DashboardItemView(
          model: dashboardModelList[index],
        ),
      ),
    );
  }
}

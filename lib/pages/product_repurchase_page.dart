import 'package:flutter/material.dart';
class ProductRepurchasePage extends StatelessWidget {
  static const String routeName = '/product_re_purchase';
  const ProductRepurchasePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Repurchase'),
      ),
    );
  }
}

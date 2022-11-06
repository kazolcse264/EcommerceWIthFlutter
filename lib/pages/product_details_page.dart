import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecom_admin/models/product_models.dart';
import 'package:ecom_admin/providers/product_provider.dart';
import 'package:ecom_admin/utils/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductDetailsPage extends StatelessWidget {
  static const String routeName = '/product_details';

  ProductDetailsPage({Key? key}) : super(key: key);
  late ProductModel productModel;
  late ProductProvider productProvider;

  @override
  Widget build(BuildContext context) {
    productProvider = Provider.of<ProductProvider>(context, listen: false);
    productModel = ModalRoute.of(context)!.settings.arguments as ProductModel;
    return Scaffold(
      appBar: AppBar(
        title: Text(productModel.productName),
      ),
      body: ListView(
        children: [
          CachedNetworkImage(
            height: 200,
            width: double.infinity,
            fit: BoxFit.cover,
            imageUrl: productModel.thumbnailImageModel.imageDownloadUrl,
            placeholder: (context, url) => const Center(
              child: CircularProgressIndicator(),
            ),
            errorWidget: (context, url, error) => const Icon(Icons.error),
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              OutlinedButton(
                  onPressed: () {}, child: const Text('Re-Purchase')),
              const SizedBox(
                width: 10,
              ),
              OutlinedButton(
                  onPressed: () {
                    _showPurchaseHistory(context, productModel);
                  },
                  child: const Text('Purchase History')),
            ],
          ),
        ],
      ),
    );
  }

  void _showPurchaseHistory(BuildContext context, ProductModel productModel) {
    showModalBottomSheet(
        context: context,
        isDismissible: true,
        builder: (context) => FutureBuilder(
              future: productProvider
                  .getPurchasesByProductId(productModel.productId!),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final purchaseList = snapshot.data;

                  return ListView.builder(
                    itemCount: purchaseList!.length,
                    itemBuilder: (context, index) {

                      final purchaseModel = purchaseList[index];
                      return ListTile(
                        title: Text(getFormattedDate(
                            purchaseModel.dateModel.timestamp.toDate())),
                        subtitle: Text('BDT ${purchaseModel.purchasePrice}'),
                        trailing:
                            Text('Quantity :${purchaseModel.purchaseQuantity}'),
                      );
                    },
                  );
                }
                if (snapshot.hasError) {
                  return const Center(child: Text('Failed to fetch data'));
                }
                return const Center(child: Text('Loading'));
              },
            ));
  }
}

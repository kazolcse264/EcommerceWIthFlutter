import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecom_admin/custom_widgets/photo_frame_view.dart';
import 'package:ecom_admin/models/image_model.dart';
import 'package:ecom_admin/models/product_models.dart';
import 'package:ecom_admin/pages/product_repurchase_page.dart';
import 'package:ecom_admin/providers/product_provider.dart';
import 'package:ecom_admin/utils/constants.dart';
import 'package:ecom_admin/utils/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class ProductDetailsPage extends StatefulWidget {
  static const String routeName = '/product_details';

  const ProductDetailsPage({Key? key}) : super(key: key);

  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  late ProductModel productModel;

  late ProductProvider productProvider;

  @override
  void didChangeDependencies() {
    productProvider = Provider.of<ProductProvider>(context, listen: false);
    productModel = ModalRoute.of(context)!.settings.arguments as ProductModel;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
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
          SizedBox(
            height: 75,
            child: Card(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  PhotoFrameView(
                    onImagePressed: () {},
                    url: productModel.additionalImageModels[0],
                    child: IconButton(
                        onPressed: () {
                          _addImage(0);
                        },
                        icon: const Icon(Icons.add)),
                  ),
                  PhotoFrameView(
                    onImagePressed: () {},
                    url: productModel.additionalImageModels[1],
                    child: IconButton(
                        onPressed: () {
                          _addImage(1);
                        },
                        icon: const Icon(Icons.add)),
                  ),
                  PhotoFrameView(
                    onImagePressed: () {},
                    url: productModel.additionalImageModels[2],
                    child: IconButton(
                        onPressed: () {
                          _addImage(2);
                        },
                        icon: const Icon(Icons.add)),
                  ),
                ],
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              OutlinedButton(
                onPressed: () => Navigator.pushNamed(
                    context, ProductRepurchasePage.routeName,
                    arguments: productModel),
                child: const Text('Re-Purchase'),
              ),
              const SizedBox(
                width: 10,
              ),
              OutlinedButton(
                  onPressed: () {
                    _showPurchaseHistory();
                  },
                  child: const Text('Purchase History')),
            ],
          ),
          ListTile(
            title: Text(productModel.productName),
            subtitle: Text(productModel.category.categoryName),
          ),
          ListTile(
            title:
                Text('Sale Price : $currencySymbol${productModel.salePrice}'),
            subtitle: Text(
                'Discount : $currencySymbol${productModel.productDiscount}%'),
            trailing: Text(
                '$currencySymbol${productProvider.priceAfterDisCount(productModel.salePrice, productModel.productDiscount)}'),
          ),
          SwitchListTile(
            value: productModel.available,
            onChanged: (value) {
              setState(() {
                productModel.available = !productModel.available;
              });
              productProvider.updateProductField(productModel.productId!,
                  productFieldAvailable, productModel.available);
            },
            title: const Text('Available'),
          ),
          SwitchListTile(
            value: productModel.featured,
            onChanged: (value) {
              setState(() {
                productModel.featured = !productModel.featured;
              });
              productProvider.updateProductField(productModel.productId!,
                  productFieldFeatured, productModel.featured);
            },
            title: const Text('Featured'),
          ),
        ],
      ),
    );
  }

  void _showPurchaseHistory() {
    showModalBottomSheet(
        context: context,
        isDismissible: true,
        builder: (context) {
          final purchaseList =
              productProvider.getPurchasesByProductId(productModel.productId!);
          return ListView.builder(
            itemCount: purchaseList.length,
            itemBuilder: (context, index) {
              final purchaseModel = purchaseList[index];
              return ListTile(
                title: Text(getFormattedDate(
                    purchaseModel.dateModel.timestamp.toDate())),
                subtitle: Text('BDT ${purchaseModel.purchasePrice}'),
                trailing: Text('Quantity :${purchaseModel.purchaseQuantity}'),
              );
            },
          );
        });
  }

  void _addImage(int index) async {
    final selectedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (selectedFile != null) {
      EasyLoading.show(status: "Please Wait");
      final imageModel = await productProvider.uploadImage(selectedFile.path);
      final previousImageList = productModel.additionalImageModels;
      previousImageList[index] = imageModel.imageDownloadUrl;
      productProvider
          .updateProductField(
              productModel.productId!, productFieldImages, previousImageList)
          .then((value) {
            setState(() {
              productModel.additionalImageModels[index] = imageModel.imageDownloadUrl;
            });
        showMsg(context, 'Uploaded');
        EasyLoading.dismiss();
      }).catchError((error) {
        showMsg(context, 'Failed to uploaded');
        EasyLoading.dismiss();
      });
    }
  }
}

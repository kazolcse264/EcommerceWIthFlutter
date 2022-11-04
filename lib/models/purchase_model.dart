import 'package:ecom_admin/models/date_model.dart';
const String collectionPurchase = 'purchase';
const String purchaseFieldPurchaseId = 'purchaseId';
const String purchaseFieldProductId = 'productId';
const String purchaseFieldPurchaseQuantity = 'purchaseQuantity';
const String purchaseFieldShortPurchasePrice = 'purchasePrice';
const String purchaseFieldDateModel = 'dateModel';

class PurchaseModel {
  String? purchaseId;
  String? productId;
  num purchaseQuantity;
  num purchasePrice;
  DateModel dateModel;

  PurchaseModel({
    this.purchaseId,
    this.productId,
    required this.purchaseQuantity,
    required this.purchasePrice,
    required this.dateModel,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      purchaseFieldPurchaseId: productId,
      purchaseFieldProductId: purchaseId,
      purchaseFieldPurchaseQuantity: purchaseQuantity,
      purchaseFieldShortPurchasePrice: purchasePrice,
      purchaseFieldDateModel: dateModel.toMap(),
    };
  }

  factory PurchaseModel.fromMap(Map<String, dynamic> map) => PurchaseModel(
    productId: map[purchaseFieldPurchaseId],
    purchaseId: map[purchaseFieldProductId],
    purchaseQuantity: map[purchaseFieldPurchaseQuantity],
    purchasePrice: map[purchaseFieldShortPurchasePrice],
    dateModel: DateModel.fromMap(map[purchaseFieldDateModel]),
  );
}

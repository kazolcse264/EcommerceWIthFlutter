import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecom_admin/models/category_model.dart';
import 'package:ecom_admin/models/product_models.dart';
import 'package:ecom_admin/models/purchase_model.dart';

class DbHelper {
  static const String collectAdmin = 'Admins';
  static final _db = FirebaseFirestore.instance;

  static Future<bool> isAdmin(String uid) async {
    final snapshot = await _db.collection(collectAdmin).doc(uid).get();
    return snapshot.exists;
  }

  static Future<void> addCategory(CategoryModel categoryModel) {
    final catDoc = _db.collection(collectionCategory).doc();
    categoryModel.categoryId = catDoc.id;
    return catDoc.set(categoryModel.toMap());
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllCategories() =>
      _db.collection(collectionCategory).snapshots();

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllProducts() =>
      _db.collection(collectionProducts).snapshots();

  static Future<QuerySnapshot<Map<String, dynamic>>> getAllPurchaseByProductId(
          String productId) =>
      _db.collection(collectionPurchase)
          .where(purchaseFieldProductId, isEqualTo: productId)
          .get();

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllProductsByCategory(
          String categoryName) =>
      _db
          .collection(collectionProducts)
          .where('$productFieldCategory.$categoryFieldCategoryName',
              isEqualTo: categoryName)
          .snapshots();

  static Future<void> addNewProduct(
      ProductModel productModel, PurchaseModel purchaseModel) {
    final wb = _db.batch(); //write batch
    final productDoc = _db.collection(collectionProducts).doc();
    final purchaseDoc = _db.collection(collectionPurchase).doc();

    productModel.productId = productDoc.id;
    purchaseModel.productId = productDoc.id;
    purchaseModel.purchaseId = purchaseDoc.id;
    wb.set(productDoc, productModel.toMap());
    wb.set(purchaseDoc, purchaseModel.toMap());

    final updatedCount =
        purchaseModel.purchaseQuantity + productModel.category.productCount;
    final catDoc = _db
        .collection(collectionCategory)
        .doc(productModel.category.categoryId);
    wb.update(catDoc, {categoryFieldProductCount: updatedCount});
    return wb.commit();
  }
}

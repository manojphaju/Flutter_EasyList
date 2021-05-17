import 'package:scoped_model/scoped_model.dart';

import '../models/product_model.dart';
import '../models/user_model.dart';



class ConnectedScopedProducts extends Model {
  List<ProductModel> _products = [];
  UserModel _authenticateUser;

  int selProductIndex;

  void addProduct(
      String title, String description, String image, double price) {
    final ProductModel newProduct = ProductModel(
        title: title, description: description, image: image, price: price, userEmail: _authenticateUser.email, userId: _authenticateUser.id);
    _products.add(newProduct);
  }

  bool _showFavorites = false;

  List<ProductModel> get allProducts {
    // this is used to fetch data of _products from outside
    return List.from(_products);
  }

  List<ProductModel> get displayedProducts {
    if (_showFavorites)
      return _products.where((ProductModel model) => model.isFavorite).toList();
    return List.from(_products);
  }

  int get selectedProductIndex {
    return selProductIndex;
  }

  ProductModel get selectedProduct {
    if (selectedProductIndex == null) return null;
    return _products[selectedProductIndex];
  }

  bool get displayFavoritesOnly {
    return _showFavorites;
  }

  void updateProduct(
      String title, String description, String image, double price) {
    final ProductModel updateProduct = ProductModel(
        title: title,
        description: description,
        price: price,
        image: image,
        userEmail: _authenticateUser.email,
        userId: _authenticateUser.id);
    _products[selectedProductIndex] = updateProduct;
  }

  void deleteProduct() {
    _products.removeAt(selectedProductIndex);
  }

  void toggleProductFavoriteStatus() {
    final bool isCurrentlyFavorite = selectedProduct.isFavorite;
    final bool newFavoriteStatus = !isCurrentlyFavorite;
    final ProductModel updateProduct = ProductModel(
      title: selectedProduct.title,
      description: selectedProduct.description,
      price: selectedProduct.price,
      image: selectedProduct.image,
      userEmail: selectedProduct.userEmail,
      userId: selectedProduct.userId,
      isFavorite: newFavoriteStatus,
    );
    _products[selectedProductIndex] = updateProduct;
    notifyListeners(); // if changes happening on save page must use
  }

  void toggleDisplayMode() {
    _showFavorites = !_showFavorites;
    notifyListeners();
  }

  void selectProduct(int index) {
    selProductIndex = index;
    notifyListeners();
  }

  void login(String email, String password) {
    _authenticateUser =
        UserModel(id: 'jdfadfjdf', email: email, password: password);
  }
}


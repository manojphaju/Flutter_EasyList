import 'dart:convert';
import 'package:scoped_model/scoped_model.dart';
import 'package:http/http.dart' as http;

import '../models/product_model.dart';
import '../models/user_model.dart';

class ConnectedScopedProducts extends Model {
  List<ProductModel> _products = [];
  String selProductId;
  UserModel _authenticateUser;
  bool _isLoading = false;
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

  String get selectedProductId {
    return selProductId;
    ;
  }

  ProductModel get selectedProduct {
    if (selectedProductId == null) return null;
    return _products.firstWhere((ProductModel product) {
      return product.id == selProductId;
    });
  }

  bool get displayFavoritesOnly {
    return _showFavorites;
  }

String baseUrl =
      'https://flutter-products-ea31e-default-rtdb.firebaseio.com/products.json';

  Future<bool> addProduct(
      String title, String description, String image, double price) async {
    _isLoading = true;
    notifyListeners();
    final Map<String, dynamic> requestData = {
      'title': title,
      'description': description,
      'image':
          'https://image.shutterstock.com/image-photo/patan-ancient-city-kathmandu-valley-260nw-1137140381.jpg',
      'price': price,
      'userEmail': _authenticateUser.email,
      'userId': _authenticateUser.id
    };
    try {
      final http.Response response =
          await http.post(Uri.parse(baseUrl), body: json.encode(requestData));

      if (response.statusCode != 200 || response.statusCode != 200) {
        _isLoading = false;
        notifyListeners();
        return false;
      }
      final Map<String, dynamic> responseData = json.decode(response.body);

      final ProductModel newProduct = ProductModel(
          id: responseData['name'],
          title: title,
          description: description,
          image: image,
          price: price,
          userEmail: _authenticateUser.email,
          userId: _authenticateUser.id);
      _products.add(newProduct);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (error) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateProduct(
      String title, String description, String image, double price) {
    _isLoading = true;
    notifyListeners();
    final Map<String, dynamic> updateData = {
      'title': title,
      'description': description,
      'price': price,
      'image':
          'https://image.shutterstock.com/image-photo/patan-ancient-city-kathmandu-valley-260nw-1137140381.jpg',
      'userEmail': _authenticateUser.email,
      'userId': _authenticateUser.id
    };
    return http
        .put(
            Uri.parse(
                'https://flutter-products-ea31e-default-rtdb.firebaseio.com/products/${selectedProduct.id}.json'),
            body: jsonEncode(updateData))
        .then((http.Response response) {
      _isLoading = false;
      final ProductModel updateProduct = ProductModel(
          id: selectedProduct.id,
          title: title,
          description: description,
          price: price,
          image: image,
          userEmail: _authenticateUser.email,
          userId: _authenticateUser.id);
      final int selectedProductIndex =
          _products.indexWhere((ProductModel product) {
        return product.id == selProductId;
      });
      _products[selectedProductIndex] = updateProduct;
      notifyListeners();
      return false;
    }).catchError((error) {
      _isLoading = false;
      notifyListeners();
      return false;
    });
  }

  Future<bool> deleteProduct() {
    _isLoading = true;
    final deletedProduct = selectedProduct.id;
    final int selectedProductIndex =
        _products.indexWhere((ProductModel product) {
      return product.id == selProductId;
    });
    _products.removeAt(selectedProductIndex);
    selProductId = null;
    notifyListeners();
    return http
        .delete(Uri.parse(
            'https://flutter-products-ea31e-default-rtdb.firebaseio.com/products/${deletedProduct}.json'))
        .then((http.Response response) {
      _isLoading = false;
      notifyListeners();
      return false;
    }).catchError((onError) {
      _isLoading = false;
      notifyListeners();
    });
  }

  void toggleProductFavoriteStatus() {
    final bool isCurrentlyFavorite = selectedProduct.isFavorite;
    final bool newFavoriteStatus = !isCurrentlyFavorite;
    final ProductModel updateProduct = ProductModel(
      id: selectedProduct.id,
      title: selectedProduct.title,
      description: selectedProduct.description,
      price: selectedProduct.price,
      image: selectedProduct.image,
      userEmail: selectedProduct.userEmail,
      userId: selectedProduct.userId,
      isFavorite: newFavoriteStatus,
    );
    final int selectedProductIndex =
        _products.indexWhere((ProductModel product) {
      return product.id == selProductId;
    });

    _products[selectedProductIndex] = updateProduct;
    notifyListeners(); // if changes happening on save page must use
  }

  void toggleDisplayMode() {
    _showFavorites = !_showFavorites;
    notifyListeners();
  }

  void selectProduct(String productId) {
    selProductId = productId;
    notifyListeners();
  }

  void login(String email, String password) {
    _authenticateUser =
        UserModel(id: 'jdfadfjdf', email: email, password: password);
  }

  Future<Null> fetchDataFromServer() {
    _isLoading = true;
    notifyListeners();
    return http.get(Uri.parse(baseUrl)).then<Null>((http.Response response) {
      final List<ProductModel> fetchedProductList = [];
      final Map<String, dynamic> productList = json.decode(response.body);
      if (productList == null) {
        _isLoading = false;
        notifyListeners();
        return;
      }
      productList.forEach((String productId, dynamic productData) {
        final ProductModel productModel = ProductModel(
            id: productId,
            title: productData['title'],
            description: productData['description'],
            price: productData['price'],
            image: productData['image'],
            userEmail: productData['userEmail'],
            userId: productData['userId']);
        fetchedProductList.add(productModel);
      });
      _products = fetchedProductList;
      _isLoading = false;
      notifyListeners();
      return;
    });
  }
}

class UtilityModel extends ConnectedScopedProducts {
  bool get isLoading {
    return _isLoading;
  }
}

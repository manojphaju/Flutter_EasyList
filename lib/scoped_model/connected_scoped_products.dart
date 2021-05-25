import 'dart:convert';
import 'dart:async';

import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rxdart/subjects.dart';
import 'package:http/http.dart' as http;

import '../models/product_model.dart';
import '../models/user_model.dart';
import '../models/auth.dart';

class ConnectedScopedProducts extends Model {
  List<ProductModel> _products = [];
  String selProductId;
  UserModel _authenticatedUser;
  bool _isLoading = false;
  bool _showFavorites = false;

  Timer _authTimer;
  PublishSubject<bool> _userSubject = PublishSubject();

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

  UserModel get user {
    return _authenticatedUser;
  }

  PublishSubject<bool> get userSubject {
    return _userSubject;
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
      'userEmail': _authenticatedUser.email,
      'userId': _authenticatedUser.id
    };
    try {
      final http.Response response = await http.post(
          Uri.parse(baseUrl + '?auth=${_authenticatedUser.token}'),
          body: json.encode(requestData));

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
          userEmail: _authenticatedUser.email,
          userId: _authenticatedUser.id);
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
      'userEmail': _authenticatedUser.email,
      'userId': _authenticatedUser.id
    };
    return http
        .put(
            Uri.parse(
                'https://flutter-products-ea31e-default-rtdb.firebaseio.com/products/${selectedProduct.id}.json?auth=${_authenticatedUser.token}'),
            body: jsonEncode(updateData))
        .then((http.Response response) {
      _isLoading = false;
      final ProductModel updateProduct = ProductModel(
          id: selectedProduct.id,
          title: title,
          description: description,
          price: price,
          image: image,
          userEmail: _authenticatedUser.email,
          userId: _authenticatedUser.id);
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
            'https://flutter-products-ea31e-default-rtdb.firebaseio.com/products/${deletedProduct}.json?auth=${_authenticatedUser.token}'))
        .then((http.Response response) {
      _isLoading = false;
      notifyListeners();
      return false;
    }).catchError((onError) {
      _isLoading = false;
      notifyListeners();
    });
  }

  void toggleProductFavoriteStatus() async {
    final bool isCurrentlyFavorite = selectedProduct.isFavorite;
    final bool newFavoriteStatus = !isCurrentlyFavorite;
    if (newFavoriteStatus) {
      final http.Response response = await http.put(
          Uri.parse(
              'https://flutter-products-ea31e-default-rtdb.firebaseio.com/products/${selectedProduct.id}/wishlistUsers/${_authenticatedUser.id}.json?auth=${_authenticatedUser.token}'),
          body: json.encode(true));
      if (response.statusCode != 200 && response.statusCode != 201) {
       
      } else {
        final http.Response response = await http.delete(
          Uri.parse(
              'https://flutter-products-ea31e-default-rtdb.firebaseio.com/products/${selectedProduct.id}/wishlistUsers/${_authenticatedUser.id}.json?auth=${_authenticatedUser.token}'),
        );
      }
    }
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

  Future<Map<String, dynamic>> authenticate(String email, String password,
      [AuthMode mode = AuthMode.Login]) async {
    _isLoading = true;
    notifyListeners();
    String authenticationUrl;
    String authenticationApiKey = 'AIzaSyC1L2hXQdZYgTUhtMZwZy-wCide6VHR5eY';
    authenticationUrl =
        'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=';
    String url = authenticationUrl + authenticationApiKey;
    Map<String, dynamic> authData = {
      'email': email,
      'password': password,
      'returnSecureToken': true
    };

    http.Response response;
    if (mode == AuthMode.Login) {
      response = await http.post(
        Uri.parse(url),
        body: json.encode(authData),
        headers: {'Content-Type': 'application/json'},
      );
    } else {
      authenticationUrl =
          'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=';
      String url = authenticationUrl + authenticationApiKey;
      response = await http.post(
        Uri.parse(url),
        body: json.encode(authData),
        headers: {'Content-Type': 'application/json'},
      );
    }

    final Map<String, dynamic> responseData = json.decode(response.body);
    bool hasError = true;
    String message = 'Something went wrong';
    if (responseData.containsKey('idToken')) {
      hasError = false;
      message = 'Authentication succeeded!';
      _authenticatedUser = UserModel(
        id: responseData['localId'],
        email: email,
        token: responseData['idToken'],
      );
      setAuthTimeout(int.parse(responseData['expiresIn']));
      _userSubject.add(true);
      final DateTime now = DateTime.now();
      final DateTime expiryTime =
          now.add(Duration(seconds: int.parse(responseData['expiresIn'])));

      final SharedPreferences preferences =
          await SharedPreferences.getInstance();
      preferences.setString('token', responseData['idToken']);
      preferences.setString('userEmail', email);
      preferences.setString('userId', responseData['localId']);
      preferences.setString('expiryTime', expiryTime.toIso8601String());
    } else if (responseData['error']['message'] == 'EMAIL_NOT_FOUND') {
      message = 'Invalid Email';
    } else if (responseData['error']['message'] == 'INVALID_PASSWORD') {
      message = 'Invalid Password';
    } else if (responseData['error']['message'] == 'EMAIL_EXISTS') {
      message = 'This email alrady exists.';
    }
    _isLoading = false;
    notifyListeners();
    return {'success': !hasError, 'message': message};
  }

  void autoAuthenticate() async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    final String token = preferences.getString('token');
    final String expiryTimeString = preferences.getString('expiryTime');
    if (token != null) {
      final DateTime now = DateTime.now();
      final parsedExpiryTime = DateTime.parse(expiryTimeString);
      if (parsedExpiryTime.isBefore(now)) {
        _authenticatedUser = null;
        notifyListeners();
        return;
      }
      final String userEmail = preferences.get('userEmail');
      final String userId = preferences.get('userId');
      final int tokenLifeSpan = parsedExpiryTime.difference(now).inSeconds;
      _authenticatedUser =
          UserModel(id: userId, email: userEmail, token: token);
      _userSubject.add(true);
      setAuthTimeout(tokenLifeSpan);
      notifyListeners();
    }
  }

  void logOut() async {
    _authenticatedUser = null;
    _authTimer.cancel();
    _userSubject.add(false);
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.remove('token');
    preferences.remove('userEmail');
    preferences.remove('userId');
  }

  void setAuthTimeout(int time) {
    _authTimer = Timer(Duration(seconds: time), logOut);
  }

  Future<Null> fetchDataFromServer() {
    _isLoading = true;
    notifyListeners();
    return http
        .get(Uri.parse(baseUrl + '?auth=${_authenticatedUser.token}'))
        .then<Null>((http.Response response) {
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

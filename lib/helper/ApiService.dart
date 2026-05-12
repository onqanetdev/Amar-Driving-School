import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ApiService {
  //static String _baseUrl = 'https://onqanet.net/dev_waqueel01/driveronhire/api/';
  //static String _baseUrl = 'https://onqanet.net/dev_waqueel01/driveronhire/api/';
  /*static String _baseUrl = 'https://gujaratdriver.com/api/';*/
  static String _baseUrl = 'https://onqanet.net/dev_waqueel01/gujratdriver/api/';

  late final String _loginUrl = _baseUrl + 'apilogin';
  late final String _registrationUrl = _baseUrl + 'register';
  late final String _checkOTPUrl = _baseUrl + 'api-verify-otp';
  late final String _categoriesListPUrl = _baseUrl + 'categories';
  late final String _categoriesProductListPUrl = _baseUrl + 'product';
  static final String _productDetailsPUrl = _baseUrl + 'product-details';
  static final String _profileDetailsUrl = _baseUrl + 'userdetail';
  static final String _cartListUrl = _baseUrl + 'cart';
  static final String APP_VERSION_CHECK = _baseUrl + "version";
  static final String _addMoreItemToCartUrl = _baseUrl + 'add-to-cart-more-item';
  static final String _updateCartItemUrl = _baseUrl + 'cart/update-product';
  static final String _updateDeliveryTimeUrl = _baseUrl + 'cart/update-delivery-time';
  static final String _checkKitchenListUrl = _baseUrl + 'get-kitchen-list';
  static final String _privacyPolicyUrl = _baseUrl + 'privacy-policy';
  static final String _termConditionUrl = _baseUrl + 'term-condition';
  static final String _aboutUsUrl = _baseUrl + 'about';
  static final String _getAddressUrl = _baseUrl + 'addresses/list';
  static final String _addAddressUrl = _baseUrl + 'addresses/add';
  static final String _updateAddressUrl = _baseUrl + 'addresses/update';
  static final String _cartCountUrl = _baseUrl + 'cart-count';
  static final String _deleteCartItemUrl = _baseUrl + 'cart-delete';
  static final String _deleteAddressUrl = _baseUrl + 'addresses/delete';
  static final String _getDeliveryUrl = _baseUrl + 'delivery-fees';
  static final String _supportUrl = _baseUrl + 'support';
  static final String _orderPlaceUrl = _baseUrl + 'orders/place';
  static final String _orderDetailsPlaceUrl = _baseUrl + 'order-detail';
  static final String _bannerListUrl = _baseUrl + 'banner';
  static final String _userProfileUpdateUrl = _baseUrl + 'user-profile-update';
  static final String _orderCancelUrl = _baseUrl + 'order-cancel';
  static final String _reOrderUrl = _baseUrl + 'orders/reorder';
  static final String _deleteAccountUrl = _baseUrl + 'delete_account';
  static final String _updateCartAddressIdUrl = _baseUrl + 'update-address-incart';
  static final String _couponApplayUrl = _baseUrl + 'coupancheck';
  static final String _notificationListUrl = _baseUrl + 'notification-list';
  static final String _notificationCountUrl = _baseUrl + 'count-notification';
  static final String _redNotification = _baseUrl + 'read-notification';
  static final String _updateFirstOrderStatusUrl = _baseUrl + 'user-status-update';
  static final String _orderRangeCheckUrl = _baseUrl + 'out-of-range';
  static final String _userLogoutUrl = _baseUrl + 'logout';
  static final String _couponListUrl = _baseUrl + 'coupan-list';
  static final String orderListUrl = _baseUrl + 'orders/list-history';
  static final String orderDetailUrl = _baseUrl + 'order-detail';

  static String _addToCartUrl(String userId) => '${_baseUrl}add-to-cart/$userId';

  static final String _serviceTypes = _baseUrl + 'service-types';
  static final String _vehicleTypes = _baseUrl + 'vehicle-types';
  static final String _getrates = _baseUrl + 'getrates';
  static final String _booking = _baseUrl + 'booking';
  static final String _bookingrate = _baseUrl + 'bookingrate';
  static final String _updateDocumentUrl = _baseUrl + "driverdocumentupload";
  static final String _updateDropLocation = _baseUrl + "droplocationchange";
  static final String _bookinghistory = _baseUrl + "bookinghistory";
  static final String calculateBookingUrl = _baseUrl + 'calculate-booking';

  // Complete booking
  static Future<dynamic> calculateBooking({
    required String bookingId,
  }) async {
    final url = Uri.parse(calculateBookingUrl,);

    final response = await http.post(
      url,
      body: {
        "booking_id": bookingId,
      },
    );

    final data = jsonDecode(response.body);
    return data;
  }

  // Login Api Call
  Future<Map<String, dynamic>> loginWithPhone(String phone) async {
    try {
      final response = await http.post(
        Uri.parse(_loginUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'phone': phone}),
      );

      final Map<String, dynamic> responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        if (responseData['status'] == true) {
          // ✅ Successful response with OTP
          return {
            'success': true,
            'message': responseData['message'] ?? 'OTP sent successfully',
            'user_id': responseData['user_id'],
            'otp': responseData['otp'],
          };
        } else {
          // ❌ Handle validation and standard failure
          final phoneError = responseData['errors']?['phone']?[0];

          return {
            'success': false,
            'message': phoneError ?? responseData['message'] ?? 'Login failed',
          };
        }
      } else {
        // ❌ Server returned non-200
        return {
          'success': false,
          'message': 'Unexpected error: ${response.statusCode}',
        };
      }
    } catch (e) {
      // ❌ Network or JSON parsing error
      return {
        'success': false,
        'message': 'Network error: $e',
      };
    }
  }

  // Login Api Call
  Future<Map<String, dynamic>> registrationWithPhone(String phone,String name) async {
    final Map<String, dynamic> bodyData = {
      'phone': phone,
      'name': name,
    };
    try {
      final response = await http.post(
        Uri.parse(_registrationUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(bodyData),
      );

      print('registration Api Parameters: $bodyData');

      final Map<String, dynamic> responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        if (responseData['status'] == true) {
          // ✅ Successful response with OTP
          return {
            'success': true,
            'message': responseData['message'] ?? 'OTP sent successfully',
            'user_id': responseData['user_id'],
            'otp': responseData['otp'],
          };
        } else {
          // ❌ Handle validation and standard failure
          final phoneError = responseData['errors']?['phone']?[0];

          return {
            'success': false,
            'message': phoneError ?? responseData['message'] ?? 'Login failed',
          };
        }
      } else {
        // ❌ Server returned non-200
        return {
          'success': false,
          'message': 'Unexpected error: ${response.statusCode}',
        };
      }
    } catch (e) {
      // ❌ Network or JSON parsing error
      return {
        'success': false,
        'message': 'Network error: $e',
      };
    }
  }

  // Check OTP Api Call
  Future<Map<String, dynamic>> checkOTP(String _user_id,String _otp,String device_token) async {

    final Map<String, dynamic> bodyData = {
      'otp': _otp,
      'user_id': _user_id,
      'device_token': device_token,
    };

    print('checkOTP Api Parameters: $bodyData');

    try {
      final response = await http.post(
        Uri.parse(_checkOTPUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(bodyData),
      );

      final Map<String, dynamic> responseData = jsonDecode(response.body);
      return responseData;
    } catch (e) {
      return {
        'success': false,
        'message': 'Network error: $e',
      };
    }
  }

  /*static Future<List<CategoryModel>> fetchOurMenuCategoriesList() async {
    final url = Uri.parse(_serviceTypes);

    try {
      final response = await http.post(url); // POST method as you said

      print("API Response Code: ${response.statusCode}");
      print("API Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data is Map && data.containsKey('data')) {
          return (data['data'] as List)
              .map((e) => CategoryModel.fromJson(e))
              .toList();
        }else {
          print("Unexpected response format");
        }
      } else {
        print('Failed to load categories');
      }
    } catch (e) {
      print("Exception while calling fetchCategories: $e");
    }

    return []; // Return empty list on failure
  }

  // Check Vehicle Type Api Call
  static Future<List<VehicleTypeModel>> fetchVehicleTypes() async {
    final url = Uri.parse(_vehicleTypes);

    try {
      final response = await http.post(url);

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);

        debugPrint("fetchVehicleTypes response: $body");


        final List list = body['data'] ?? [];

        return list
            .map((e) => VehicleTypeModel.fromJson(e))
            .where((e) => e.status == "Y")
            .toList();
      }
    } catch (e) {
      debugPrint("Vehicle API error: $e");
    }

    return [];
  }

  // Fetch Rates Api Call
  static Future<RateDescriptionModel?> fetchRates({
    required int hours,
    required int vehicleTypeId,
    required int serviceTypeId,
  }) async {
    final url = Uri.parse(_getrates,);

    try {
      final response = await http.post(
        url,
        body: {
          "hours": hours.toString(),
          "vehicle_type": vehicleTypeId.toString(),
          "stype": serviceTypeId.toString(),
        },
      );

      debugPrint("Rate API Response: ${response.body}");

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        if (json["status"] == true) {
          return RateDescriptionModel.fromJson(json);
        }
      }
    } catch (e) {
      debugPrint("Rate API error: $e");
    }

    return null;
  }

  // Booking Driver Api Call
  static Future<bool> submitBooking({
    required double? pickupLat,
    required double? pickupLng,
    required double? dropLat,
    required double? dropLng,
    required String pickupAddress,
    required String destinationAddress,
    required String startDate,
    required String endDate,
    required String pickupTime,
    required String hours,
    required int vehicleType,
    required int finalPrice,
    required int serviceTypeId,
    required int userId,
    required String transmissionType,
    String? tripType,
  }) async {
    final url = Uri.parse(_booking,);

    final Map<String, String> body = {
      "pickuplat": pickupLat?.toString() ?? "",
      "pickuplong": pickupLng?.toString() ?? "",
      "droplat": dropLat?.toString() ?? "",
      "droplong": dropLng?.toString() ?? "",
      "pickup_address": pickupAddress,
      "destination_address": destinationAddress,
      "start_date": startDate,
      "end_date": endDate,
      "pickup_time": pickupTime,
      "hours": hours,
      "vehicle_type": vehicleType.toString(),
      "finalprice": finalPrice.toString(),
      "service_type_id": serviceTypeId.toString(),
      "user_id": userId.toString(),
      "tran_type": transmissionType,
      "roundtrip": tripType == null || tripType.isEmpty
          ? ""
          : tripType == "Round Trip"
          ? "yes"
          : "no",
    };

    print("api call: pickup_lat: ${pickupLat?.toString()} pickup_lng: ${pickupLng?.toString()} drop_lat: ${dropLat?.toString()} drop_lng: ${dropLng?.toString()}");

    /// 🔹 PRINT REQUEST PARAMS
    debugPrint("BOOKING API REQUEST =>");
    body.forEach((key, value) {
      debugPrint("  $key : $value");
    });

    try {
      final response = await http.post(
        url,
        body: body,
      );

      debugPrint("BOOKING API RESPONSE => ${response.body}");

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        return json["status"] == true;
      }
    } catch (e) {
      debugPrint("BOOKING API ERROR => $e");
    }

    return false;
  }

  // Booking History Api Call
  static Future<List<BookingModel>> fetchBookingHistory({
    required String userId,
    required String status,
    required int limit,
    required int page,
  }) async {
    final body = {
      "user_id": userId.toString(),
      "status": status,
      "limit": limit.toString(),
      "page": page.toString(),
    };

    /// 🔹 PRINT REQUEST BODY
    debugPrint("📤 BookingHistory API Body:");
    debugPrint(body.toString());

    final response = await http.post(
      Uri.parse(_bookinghistory),
      body: body,
    );

    /// 🔹 PRINT RAW RESPONSE
    debugPrint("📥 BookingHistory API Response:");
    debugPrint(response.body);

    final decoded = jsonDecode(response.body);

    if (decoded['status'] == 200) {
      final String imageBaseUrl = decoded['imagepath'] ?? "";

      return (decoded['data'] as List)
          .map(
            (e) => BookingModel.fromJson(
          e,
          imageBaseUrl: imageBaseUrl,
        ),
      )
          .toList();
    } else {
      throw Exception(decoded['message'] ?? "Something went wrong");
    }
  }

  // Update Drop Location
  Future<Map<String, dynamic>> changeDropLocation({
    required String bookingId,
    required String address,
    required String lat,
    required String lng,
  }) async {
    final url = Uri.parse(
      "https://onqanet.net/dev_waqueel01/gujratdriver/api/droplocationchange",
    );

    try {
      final response = await http.post(
        url,
        body: {
          "booking_id": bookingId,
          "end_destination": address,
          "droplat": lat,
          "droplong": lng,
        },
      );

      print("📥 Status Code: ${response.statusCode}");
      print("📥 Response: ${response.body}");

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return {
          "success": false,
          "message": "Server error ${response.statusCode}"
        };
      }
    }catch (e) {
      return {
        "success": false,
        "message": "Exception: $e"
      };
    }
  }

  // ---------------- Upload Document ----------------
  static Future<Map<String, dynamic>> uploadDocument({
    required String deliverUserId,
    required String documentType,
    File? imageFile,
  }) async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse(_updateDocumentUrl),
      );

      request.fields['doc_type'] = documentType;
      request.fields['user_id'] = deliverUserId;

      if (imageFile != null) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'doc_upload',
            imageFile.path,
            contentType: http.MediaType('image', 'jpeg'),
          ),
        );
      }

      var response = await request.send();
      var respStr = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        final decoded = jsonDecode(respStr);
        return {
          "success": decoded["status"] ?? false,
          "message": decoded["message"] ?? "Unknown response",
          "data": decoded["data"] ?? {},
        };
      } else {
        return {
          "success": false,
          "message": "Failed with status ${response.statusCode}",
        };
      }
    } catch (e) {
      return {
        "success": false,
        "message": "Exception: $e",
      };
    }
  }




  // Check OTP Api Call
  static Future<List<ServiceTypeModel>> fetchServiceTypes() async {
    final url = Uri.parse(_serviceTypes);

    try {
      final response = await http.post(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data is Map && data.containsKey('data')) {
          return (data['data'] as List)
              .map((e) => ServiceTypeModel.fromJson(e))
              .toList();
        }
      }
    } catch (e) {
      debugPrint("Service type API error: $e");
    }

    return [];
  }


  // Categories List Api Call
  Future<List<CategoryModel>> fetchCategories() async {
    final url = Uri.parse(_categoriesListPUrl);

    try {
      final response = await http.post(url); // POST method as you said

      print("API Response Code: ${response.statusCode}");
      print("API Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data is Map && data.containsKey('data')) {
          List<dynamic> categoryList = data['data'];
          return categoryList.map((item) => CategoryModel.fromJson(item)).toList();
        } else {
          print("Unexpected response format");
        }
      } else {
        print('Failed to load categories');
      }
    } catch (e) {
      print("Exception while calling fetchCategories: $e");
    }

    return []; // Return empty list on failure
  }

  static Future<List<RateSection>> fetchBookingRates({
    required String serviceId,
    required String category,
  }) async {
    final url = Uri.parse(_bookingrate);

    final response = await http.post(url, body: {
      "serviceid": serviceId,
    });

    final decoded = jsonDecode(response.body);
    final List list = decoded['rates'] ?? [];

    final rawRates =
    list.map((e) => BookingRateRaw.fromJson(e)).toList();

    return _mapRatesToUI(rawRates, category);
  }

  static List<RateSection> _mapRatesToUI(
      List<BookingRateRaw> rawRates,
      String category,
      ) {
    // ================= PERMANENT =================
    if (category.toLowerCase() == "permanent") {
      if (rawRates.isEmpty) return [];

      return [
        RateSection(
          category: category,
          title: "CHARGES FOR PERMANENT DRIVER",
          vehicles: [
            VehicleRate(
              vehicleType: "Charges For Membership",
              items: rawRates.expand((r) {
                return r.description.map(
                      (e) => RateItem(
                    label: e['label']?.toString() ?? "",
                    rate: e['value']?.toString() ?? "",
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ];
    }

    // ================= LOCAL / OUTSTATION =================
    final Map<String, List<BookingRateRaw>> map = {};

    for (final rate in rawRates) {
      if (rate.duration.isEmpty) continue;
      map.putIfAbsent(rate.duration, () => []);
      map[rate.duration]!.add(rate);
    }

    final List<RateSection> sections = [];
    String durationToWords(String duration) {
      switch (duration) {
        case "1":
          return "ONE";
        case "2":
          return "TWO";
        case "3":
          return "THREE";
        case "4":
          return "FOUR";
        case "5":
          return "FIVE";
        case "6":
          return "SIX";
        case "7":
          return "SEVEN";
        case "8":
          return "EIGHT";
        case "9":
          return "NINE";
        case "10":
          return "TEN";
        case "11":
          return "ELEVEN";
        case "12":
          return "TWELVE";
        default:
          return duration.toUpperCase(); // fallback
      }
    }

    map.forEach((duration, rates) {
      sections.add(
        RateSection(
          category: category,
          title: duration=="12"?"${category.toUpperCase()} CHARGES FOR SAME DAY RETURN":duration=="1"?"${category.toUpperCase()} CHARGES FOR STAY":"${category.toUpperCase()} CHARGES FOR ${durationToWords(duration)} HOURS",
          //title: "${category.toUpperCase()} CHARGES FOR $duration HOURS",
          vehicles: rates.map((r) {
            return VehicleRate(
              vehicleType: r.transmissionType == "automatic_manual"
                  ? "Manual & Automatics"
                  : r.transmissionType == "luxury"
                  ? "Luxury Car"
                  : "Vehicle",
              items: [
                RateItem(
                  label: duration=="1"?"Per Day":"For ${durationToWords(duration)} ($duration) hours",
                  //label: "For $duration ($duration) hours",
                  rate: r.rate.isNotEmpty ? "₹${r.rate}/-" : "",
                ),
                ...r.description.map(
                      (e) => RateItem(
                    label: e['label']?.toString() ?? "",
                    rate: e['value']?.toString() ?? "",
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      );
    });

    return sections;
  }

  // Categories Product List Api Call
  Future<List<ProductModel>> fetchProductsByCategory_(String catId) async {

    final Map<String, dynamic> bodyData = {
      'cat_id': catId,
    };

    print('ProductsByCategory Api Parameters: $bodyData');

    final response = await http.post(
      Uri.parse(_categoriesProductListPUrl),
      body: jsonEncode(bodyData),
    );

    print("ProductsByCategory API Response Body: ${response.body}");

    try {
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == true && data['data'] != null) {
          return (data['data'] as List)
              .map((item) => ProductModel.fromJson(item))
              .toList();
        } else {
          return [];
        }
      } else {
        print("Exception while calling fetchCategories:");
      }
    }catch (e) {
      print("Exception while calling fetchCategories: $e");
    }

    return []; // Return empty list on failure
  }
  Future<List<ProductModel>> fetchProductsByCategory__(String catId) async {

    try {
      final response = await http.post(
        Uri.parse(_categoriesListPUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'cat_id': catId}),
      );

      final Map<String, dynamic> responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        print("Product list Response Body: $decoded");
        final data = json.decode(response.body);
        if (data['status'] == true && data['data'] != null) {
          return (data['data'] as List)
              .map((item) => ProductModel.fromJson(item))
              .toList();
        } else {
          return [];
        }
      } else {
        print("Exception while calling fetchCategories:");
        return [];
      }
    } catch (e) {
      print("Exception while calling fetchCategories: $e");
      return [];
    }
  }
  Future<List<ProductModel>> fetchProductsByCategory(String catId, int page) async {
    try {
      final response = await http.post(
        Uri.parse(_categoriesProductListPUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'cat_id': catId,
          'page': page, // optional: adjust per your backend
        }),
      );

      final data = json.decode(response.body);

      if (data['status'] == true &&
          data['data'] != null &&
          data['data']['data'] != null) {
        final List productList = data['data']['data']; // <- FIXED
        return productList.map((item) => ProductModel.fromJson(item)).toList();
      } else {
        return [];
      }
    } catch (e) {
      print("Exception while fetching products: $e");
      return [];
    }
  }

  static Future<ProductModel> fetchProductDetails(String prodCode) async {
    final response = await http.post(
      Uri.parse(_productDetailsPUrl),
      body: {'prod_code': prodCode},
    );

    final jsonData = json.decode(response.body);
    if (jsonData['status'] == true) {
      return ProductModel.fromJson(jsonData['data']);
    } else {
      throw Exception('Failed to load product details');
    }

  }

  // Check OTP Api Call
  static Future<Map<String, dynamic>> fetchProfileDetails(String _user_id) async {

    final Map<String, dynamic> bodyData = {
      'user_id': _user_id,
    };

    print('ProfileDetails Api Parameters: $bodyData');

    try {
      final response = await http.post(
        Uri.parse(_profileDetailsUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(bodyData),
      );

      final Map<String, dynamic> responseData = jsonDecode(response.body);
      return responseData;

    } catch (e) {
      return {
        'success': false,
        'message': 'Network error: $e',
      };
    }
  }

  // Add To Cart
  static Future<Map<String, dynamic>> addToCart(
      String userId, Map<String, dynamic> subscriptionData) async {

    // ✅ Print values passed
    print("➡️ addToCart() called");
    print("User ID: $userId");
    print("Subscription Data: $subscriptionData");          // Map print
    print("JSON Body: ${jsonEncode(subscriptionData)}");    // JSON print

    try {
      final response = await http.post(
        Uri.parse(_addToCartUrl(userId)),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(subscriptionData), // Convert map to JSON string here
      );

      return jsonDecode(response.body);
    } catch (e) {
      return {
        'status': false,
        'message': 'Network error: $e',
      };
    }
  }

  // Cart List
  static Future<Cart?> fetchCart(String _user_id) async {
    final Map<String, dynamic> bodyData = {
      'user_id': _user_id,
    };
    try {
      final response = await http.post(
        Uri.parse(_cartListUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(bodyData),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return CartResponse.fromJson(data).cart;
      } else {
        throw Exception("Failed to load cart");
      }
    } catch (e) {
      print("Error fetching cart: $e");
      return Cart(
        id: 0,
        planType: "",
        totalAmount: '0',
        paymentStatus: '',
        orderStatus: '',
        cartItems: [],
      ); // return null instead of Map
    }
  }

  // Add More Item To Cart
  static Future<Map<String, dynamic>> moreItemToCart(String addMoreItemJson) async {
    try {
      final response = await http.post(
        Uri.parse(_addMoreItemToCartUrl),
        headers: {'Content-Type': 'application/json'},
        body: addMoreItemJson,
      );

      return jsonDecode(response.body);
    } catch (e) {
      return {
        'status': false,
        'message': 'Network error: $e',
      };
    }
  }
  static Future<CartResponse> addMoreItemToCart(String addMoreItemJson) async {
    try {
      final response = await http.post(
        Uri.parse(_addMoreItemToCartUrl),
        headers: {'Content-Type': 'application/json'},
        body: addMoreItemJson,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return CartResponse.fromJson(data);
      } else {
        throw Exception("Failed to load cart");
      }
    } catch (e) {
      print("Error fetching cart: $e");
      final orderJson = {
        "status": false,
        "message": "Failed to Add More Item To Cart",
      };
      return CartResponse.fromJson(orderJson); // return null instead of Map
    }
  }

  // Update Cart Item
  static Future<Map<String, dynamic>> _updateCartItem(Map<String, dynamic> orderUpdateJson) async {
    try {
      final response = await http.post(
        Uri.parse("https://onqanet.net/dev_waqueel01/breakfix/api/cart/update-product"),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(orderUpdateJson), // Convert map to JSON string here
      );

      return jsonDecode(response.body);
    } catch (e) {
      return {
        'status': false,
        'message': 'Network error: $e',
      };
    }
  }


  static Future<Map<String, dynamic>> updateCartItem({
    required int userId,
    required int cartItemId,
    required int quantity,
    required int orderId,
  }) async {
    try {
      final response = await http.post(
        //Uri.parse("https://onqanet.net/dev_waqueel01/breakfix/api/cart/update-product"),
        Uri.parse(_updateCartItemUrl),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "user_id": userId,
          "cart_item_id": cartItemId,
          "quantity": quantity,
          "order_id": orderId,
        }),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return {
          "status": false,
          "message": "Server error: ${response.statusCode}"
        };
      }
    } catch (e) {
      return {"status": false, "message": "Network error: $e"};
    }
  }

  static Future<Map<String, dynamic>> updateDeliveryTime({
    required int userId,
    required String deliveryTime,
    required String date,
    required int orderId,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(_updateDeliveryTimeUrl),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "user_id": userId,
          "delivery_time": deliveryTime,
          "date": date,
          "order_id": orderId,
        }),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return {
          "status": false,
          "message": "Server error: ${response.statusCode}"
        };
      }
    } catch (e) {
      return {"status": false, "message": "Network error: $e"};
    }
  }

  static Future<Map<String, dynamic>> getKitchen() async {
    try {
      final response = await http.get(
        Uri.parse(_checkKitchenListUrl),
        headers: {
          "Content-Type": "application/json",
        },
      );

      if (response.statusCode == 200) {
        // Parse the JSON response
        return jsonDecode(response.body);
      } else {
        return {
          "status": false,
          "message": "Server error: ${response.statusCode}"
        };
      }
    } catch (e) {
      return {"status": false, "message": "Network error: $e"};
    }
  }

  static Future<Map<String, dynamic>> getAboutUs() async {
    try {
      final response = await http.get(
        Uri.parse(_aboutUsUrl),
        headers: {
          "Content-Type": "application/json",
        },
      );

      if (response.statusCode == 200) {
        // Parse the JSON response
        return jsonDecode(response.body);
      } else {
        return {
          "status": false,
          "message": "Server error: ${response.statusCode}"
        };
      }
    } catch (e) {
      return {"status": false, "message": "Network error: $e"};
    }
  }

  static Future<Map<String, dynamic>> getPrivacyPolicy() async {
    try {
      final response = await http.get(
        Uri.parse(_privacyPolicyUrl),
        headers: {
          "Content-Type": "application/json",
        },
      );

      if (response.statusCode == 200) {
        // Parse the JSON response
        return jsonDecode(response.body);
      } else {
        return {
          "status": false,
          "message": "Server error: ${response.statusCode}"
        };
      }
    } catch (e) {
      return {"status": false, "message": "Network error: $e"};
    }
  }

  static Future<Map<String, dynamic>> getTermCondition() async {
    try {
      final response = await http.get(
        Uri.parse(_termConditionUrl),
        headers: {
          "Content-Type": "application/json",
        },
      );

      if (response.statusCode == 200) {
        // Parse the JSON response
        return jsonDecode(response.body);
      } else {
        return {
          "status": false,
          "message": "Server error: ${response.statusCode}"
        };
      }
    } catch (e) {
      return {"status": false, "message": "Network error: $e"};
    }
  }

  static Future<List<Address>> fetchAddresses(String userId) async {
    final response = await http.post(
      Uri.parse(_getAddressUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "user_id": userId,
      }),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      if (data['status'] == true && data['data'] != null) {
        return (data['data'] as List)
            .map((json) => Address.fromJson(json))
            .toList();
      }
    }
    return [];
  }
  static Future<Map<String, dynamic>> updateAddress({
    required int userId,
    required String phone,
    required String address_line_one,
    required String address_line_two,
    required String state_name,
    required String country_name,
    required String zip,
    required String address_type,
    required int address_id,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(_updateAddressUrl),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "user_id": userId,
          "phone": phone,
          "address_line_one": address_line_one,
          "address_line_two": address_line_two,
          "state_name": state_name,
          "country_id": "IN",
          "country_name": country_name,
          "zip": zip,
          "address_type": address_type,
          "address_id": address_type
        }),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return {
          "status": false,
          "message": "Server error: ${response.statusCode}"
        };
      }
    } catch (e) {
      return {"status": false, "message": "Network error: $e"};
    }
  }

  static Future<Map<String, dynamic>> addAddress({
    required int userId,
    required String name,
    required String email,
    required String phone,
    required String houseNo,
    required String road,
    required String address_line_one,
    required String address_line_two,
    required String state_name,
    required String country_id,
    required String country_name,
    required String zip,
    required String address_type,
    required String latitude,
    required String longitude,
  }) async {
    try {

      final body = {
        "user_id": userId,
        "name": name,
        "email": email,
        "phone": phone,
        "house_flat_block": houseNo,
        "appartment_road_area": road,
        "address_line_one": address_line_one,
        "address_line_two": address_line_two,
        "state_name": state_name,
        "country_id": country_id,
        "country_name": country_name,
        "zip": zip,
        "address_type": address_type,
        "latitude": latitude,
        "longitude": longitude,
      };

      // 👇 Print body before sending
      print("addAddress body: ${jsonEncode(body)}");

      final response = await http.post(
        Uri.parse(_addAddressUrl),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return {
          "status": false,
          "message": "Server error: ${response.statusCode}"
        };
      }
    } catch (e) {
      return {"status": false, "message": "Network error: $e"};
    }
  }
  static Future<Map<String, dynamic>> getCartCount({
    required int userId,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(_cartCountUrl),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "user_id": userId,
        }),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return {
          "status": false,
          "message": "Server error: ${response.statusCode}"
        };
      }
    } catch (e) {
      return {"status": false, "message": "Network error: $e"};
    }
  }

  static Future<Map<String, dynamic>> deleteCartItem({
    required int userId,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(_deleteCartItemUrl),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "user_id": userId,
        }),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return {
          "status": false,
          "message": "Server error: ${response.statusCode}"
        };
      }
    } catch (e) {
      return {"status": false, "message": "Network error: $e"};
    }
  }
  static Future<Map<String, dynamic>> deleteAddress({
    required int userId,
    required int address_id,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(_deleteAddressUrl),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "user_id": userId,
          "address_id": address_id
        }),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return {
          "status": false,
          "message": "Server error: ${response.statusCode}"
        };
      }
    } catch (e) {
      return {"status": false, "message": "Network error: $e"};
    }
  }

  static Future<Map<String, dynamic>> getDeliveryCharge({
    required String userId,
    required double distance,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(_getDeliveryUrl),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "user_id": userId,
          "distance": distance,
        }),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return {
          "status": false,
          "message": "Server error: ${response.statusCode}"
        };
      }
    } catch (e) {
      return {"status": false, "message": "Network error: $e"};
    }
  }

  static Future<Map<String, dynamic>> support({
    required String userId,required String name, required String email,required String phone,required String subject,required String message
  }) async {
    try {
      final response = await http.post(
        Uri.parse(_supportUrl),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "user_id": userId,
          "name": name,
          "email": email,
          "phone": phone,
          "message": message,
        }),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return {
          "status": false,
          "message": "Server error: ${response.statusCode}"
        };
      }
    } catch (e) {
      return {"status": false, "message": "Network error: $e"};
    }
  }


  static Future<Map<String, dynamic>> placeOrder({
    required int user_id,
    required int order_id,
    required String payment_status,
    required String transaction_id,
    required int address_id,
    required String wallets_ammount,
  }) async {
    try {

      final requestBody = {
        "user_id": user_id,
        "order_id": order_id,
        "payment_status": payment_status,
        "transaction_id": transaction_id,
        "address_id": address_id,
        "wallets_ammount": wallets_ammount,
      };
      print("Order Place API Body: ${jsonEncode(requestBody)}");

      final response = await http.post(
        Uri.parse(_orderPlaceUrl),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode(requestBody),
      );
      *//*final response = await http.post(
        Uri.parse(_orderPlaceUrl),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "user_id": user_id,
          "order_id": order_id,
          "payment_status": payment_status,
          "transaction_id": transaction_id,
          "address_id": address_id,
          "wallets_ammount": wallets_ammount,
        }),
      );*//*

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return {
          "status": false,
          "message": "Server error: ${response.statusCode}"
        };
      }
    } catch (e) {
      return {"status": false, "message": "Network error: $e"};
    }
  }

  static Future<Map<String, dynamic>> getOrderHistory({
    required int user_id,
    required String order_status,
    required int limit,
    required int offset,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(_orderPlaceUrl),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "user_id": user_id,
          "order_status": order_status,
          "limit": limit,
          "offset": offset,
        }),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return {
          "status": false,
          "message": "Server error: ${response.statusCode}"
        };
      }
    } catch (e) {
      return {"status": false, "message": "Network error: $e"};
    }
  }

  static Future<Map<String, dynamic>> getBannerList_() async {
    try {
      final response = await http.post(
        Uri.parse(_bannerListUrl),
        headers: {
          "Content-Type": "application/json",
        },
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return {
          "status": false,
          "message": "Server error: ${response.statusCode}"
        };
      }
    } catch (e) {
      return {"status": false, "message": "Network error: $e"};
    }
  }

  static Future<List<BannerModel>> getBannerList() async {
    try {
      final response = await http.post(
        Uri.parse(_bannerListUrl),
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);

        if (data['data'] != null) {
          return (data['data'] as List)
              .skip(1)
              .map((json) => BannerModel.fromJson(json))
              .toList();
        }
      }
    } catch (e) {
      debugPrint("Banner API error: $e");
    }

    return [];
  }

  static Future<OrderList?> getOrderDetails({
    required String userId,
    required String orderId,
  }) async {
    final url = Uri.parse(_orderDetailsPlaceUrl);

    try {
      final response = await http.post(
        url,
        headers: {
          "Accept": "application/json",
        },
        body: {
          "user_id": userId.toString(),
          "order_id": orderId.toString(),
        },
      );

      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final orderResponse = OrderResponse.fromJson(data);
        return orderResponse.orders.isNotEmpty ? orderResponse.orders.first : null;
      } else {
        throw Exception("Failed to fetch order detail: ${response.statusCode}");
      }
    } catch (e) {
      print("Error: $e");
      return null;
    }
  }

  static Future<Map<String, dynamic>> userProfileUpdate({
    required String userId,required String name, required String email
  }) async {
    try {
      final response = await http.post(
        Uri.parse(_userProfileUpdateUrl),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "user_id": userId,
          "name": name,
          "email": email,
        }),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return {
          "status": false,
          "message": "Server error: ${response.statusCode}"
        };
      }
    } catch (e) {
      return {"status": false, "message": "Network error: $e"};
    }
  }

  static Future<Map<String, dynamic>> orderCancel({
    required String userId,required String order_id, required String cart_id, required String date, required String type
  }) async {
    try {

      final body = jsonEncode({
        "user_id": userId,
        "order_id": order_id,
        "cart_id": cart_id,
        "date": date,
        "type": type,
      });

      final response = await http.post(
        Uri.parse(_orderCancelUrl),
        headers: {
          "Content-Type": "application/json",
        },
        body: body,
      );

      print("orderCancel parameters: $body");

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return {
          "status": false,
          "message": "Server error: ${response.statusCode}"
        };
      }
    } catch (e) {
      return {"status": false, "message": "Network error: $e"};
    }
  }

  static Future<Map<String, dynamic>> reOrder({
    required int user_id,
    required int order_id,
    required String wallets_ammount,
  }) async {
    try {

      final requestBody = {
        "user_id": user_id,
        "order_id": order_id,
        "wallets_ammount": wallets_ammount,
      };
      print("reOrder API Body: ${jsonEncode(requestBody)}");

      final response = await http.post(
        Uri.parse(_reOrderUrl),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return {
          "status": false,
          "message": "Server error: ${response.statusCode}"
        };
      }
    } catch (e) {
      return {"status": false, "message": "Network error: $e"};
    }
  }

  static Future<Map<String, dynamic>> deleteAccountUs() async {
    try {
      final response = await http.post(
        Uri.parse(_deleteAccountUrl),
        headers: {
          "Content-Type": "application/json",
        },
      );

      if (response.statusCode == 200) {
        // Parse the JSON response
        return jsonDecode(response.body);
      } else {
        return {
          "status": false,
          "message": "Server error: ${response.statusCode}"
        };
      }
    } catch (e) {
      return {"status": false, "message": "Network error: $e"};
    }
  }

  static Future<Map<String, dynamic>> updateCartAddressId({
    required String userId,
    required String order_id,
    required String address_id,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(_updateCartAddressIdUrl),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "user_id": userId,
          "order_id": order_id,
          "address_id": address_id,
        }),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return {
          "status": false,
          "message": "Server error: ${response.statusCode}"
        };
      }
    } catch (e) {
      return {"status": false, "message": "Network error: $e"};
    }
  }

  static Future<Map<String, dynamic>> couponApplyApi({
    required String userId,
    required String order_id,
    required String coupan_code,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(_couponApplayUrl),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "user_id": userId,
          "order_id": order_id,
          "coupancode": coupan_code,
        }),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return {
          "status": false,
          "message": "Server error: ${response.statusCode}"
        };
      }
    } catch (e) {
      return {"status": false, "message": "Network error: $e"};
    }
  }

  static Future<List<NotificationItem>> getNotifications({
    required String userId,
    required int offset,
    required int limit,
  }) async {
    final url = Uri.parse(_notificationListUrl);

    try {
      final response = await http.post(
        url,
        body: {
          "user_id": userId,
          "offset": offset.toString(),
          "limit": limit.toString(),
        },
      );

      print("API Response: ${response.body}");

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if ((data["success"] == true || data["success"] == 1) &&
            data["data"] != null) {
          return (data["data"] as List)
              .map((e) => NotificationItem.fromJson(e))
              .toList();
        }
      }
      return [];
      return [];
    } catch (e) {
      print("❌ Error fetching notifications: $e");
      return [];
    }
  }

  static Future<Map<String, dynamic>> notificationCount({
    required String userId,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(_notificationCountUrl),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "user_id": userId,
        }),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return {
          "status": false,
          "message": "Server error: ${response.statusCode}"
        };
      }
    } catch (e) {
      return {"status": false, "message": "Network error: $e"};
    }
  }

  static Future<Map<String, dynamic>> redNotification({
    required String userId,
    required String notifyId,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(_redNotification),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "user_id": userId,
          "notify_id": notifyId,
        }),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return {
          "status": false,
          "message": "Server error: ${response.statusCode}"
        };
      }
    } catch (e) {
      return {"status": false, "message": "Network error: $e"};
    }
  }

  static Future<Map<String, dynamic>> updateFirstOrderStatus({
    required String userId,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(_updateFirstOrderStatusUrl),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "user_id": userId,
        }),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return {
          "status": false,
          "message": "Server error: ${response.statusCode}"
        };
      }
    } catch (e) {
      return {"status": false, "message": "Network error: $e"};
    }
  }

  static Future<Map<String, dynamic>> orderRangeCheck({
    required String order_id,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(_orderRangeCheckUrl),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "order_id": order_id,
        }),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return {
          "status": false,
          "message": "Server error: ${response.statusCode}"
        };
      }
    } catch (e) {
      return {"status": false, "message": "Network error: $e"};
    }
  }

  static Future<Map<String, dynamic>> userLogOut({
    required String userId
  }) async {
    try {
      final response = await http.post(
        Uri.parse(_userLogoutUrl),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "user_id": userId,
        }),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return {
          "status": false,
          "message": "Server error: ${response.statusCode}"
        };
      }
    } catch (e) {
      return {"status": false, "message": "Network error: $e"};
    }
  }

  static Future<Map<String, dynamic>> fetchCouponList(String _user_id) async {
    final Map<String, dynamic> bodyData = {
      'user_id': _user_id,
    };

    try {
      final response = await http.post(
        Uri.parse(_couponListUrl),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode(bodyData),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return {
          "status": false,
          "message": "Server error: ${response.statusCode}"
        };
      }
    } catch (e) {
      return {"status": false, "message": "Network error: $e"};
    }
  }*/

}

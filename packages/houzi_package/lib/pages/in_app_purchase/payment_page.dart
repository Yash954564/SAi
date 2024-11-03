import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:houzi_package/bloc/blocs/property_bloc.dart';
import 'package:houzi_package/files/generic_methods/utility_methods.dart';
import 'package:houzi_package/files/hooks_files/hooks_configurations.dart';
import 'package:houzi_package/models/api/api_response.dart';
import 'package:houzi_package/pages/main_screen_pages/my_home_page.dart';
import 'package:houzi_package/widgets/app_bar_widget.dart';
import 'package:houzi_package/widgets/custom_widgets/card_widget.dart';
import 'package:houzi_package/widgets/custom_widgets/text_button_widget.dart';
import 'package:houzi_package/widgets/data_loading_widget.dart';
import 'package:houzi_package/widgets/generic_text_widget.dart';
import 'package:houzi_package/widgets/toast_widget.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_android/billing_client_wrappers.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';
import 'package:in_app_purchase_storekit/in_app_purchase_storekit.dart';
import 'package:in_app_purchase_storekit/store_kit_wrappers.dart';

final bool _kAutoConsume = Platform.isIOS || true;

class PaymentPage extends StatefulWidget {
  final List<String> productIds;
  final String? packageId;
  final String? propId;
  final bool isMembership;
  final bool isFeaturedForPerListing;

  PaymentPage({
    required this.productIds,
    this.packageId,
    this.propId,
    this.isFeaturedForPerListing = false,
    required this.isMembership,
  });

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  PaymentHook paymentHook = HooksConfigurations.paymentHook;

  @override
  Widget build(BuildContext context) {
    return paymentHook(
          widget.productIds,
          widget.packageId,
          widget.propId,
          widget.isMembership,
          widget.isFeaturedForPerListing,
        ) ??
        InAppPurchaseWidget(
          productIds: widget.productIds,
          packageId: widget.packageId,
          propId: widget.propId,
          isMembership: widget.isMembership,
          isFeaturedForPerListing: widget.isFeaturedForPerListing,
        );
  }
}

class InAppPurchaseWidget extends StatefulWidget {
  final List<String> productIds;
  final String? packageId;
  final String? propId;
  final bool isMembership;
  final bool isFeaturedForPerListing;

  InAppPurchaseWidget({
    required this.productIds,
    this.packageId,
    this.propId,
    this.isFeaturedForPerListing = false,
    required this.isMembership,
  });

  @override
  State<InAppPurchaseWidget> createState() => _InAppPurchaseWidgetState();
}

class _InAppPurchaseWidgetState extends State<InAppPurchaseWidget> {
  late InAppPurchaseViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = InAppPurchaseViewModel(
      context,
      widget.productIds,
      packageId: widget.packageId,
      propId: widget.propId,
      isMembership: widget.isMembership,
      isFeaturedForPerListing: widget.isFeaturedForPerListing,
    );
    _viewModel.init();
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        appBarTitle: UtilityMethods.getLocalizedString('Payment'),
      ),
      body: StreamBuilder<PaymentState>(
        stream: _viewModel.paymentStateStream,
        initialData: _viewModel.initialState,
        builder: (context, snapshot) {
          final state = snapshot.data;
          if (state == null) {
            return Container(
              height: (MediaQuery.of(context).size.height) / 2,
              margin: const EdgeInsets.only(top: 50),
              alignment: Alignment.center,
              child: SizedBox(
                width: 80,
                height: 20,
                child: BallBeatLoadingWidget(),
              ),
            );
          } else if (state is PaymentAvailableState) {
            return _buildConnectionCheckTile(state.isAvailable);
          } else if (state is PaymentErrorState) {
            return Center(
              child: GenericTextWidget(UtilityMethods.getLocalizedString(state.error)),
            );
          } else if (state is PaymentDataState) {
            return _buildProductList(state);
          }
          return Container();
        },
      ),
    );
  }

  Widget _buildConnectionCheckTile(bool isAvailable) {
    return CardWidget(
      child: Column(
        children: <Widget>[
          if (!isAvailable)
            ListTile(
              leading: Icon(
                isAvailable ? Icons.check : Icons.block,
                color: isAvailable
                    ? Colors.green
                    : ThemeData.light().colorScheme.error,
              ),
              title: GenericTextWidget(
                  'The store is ${isAvailable ? 'available' : 'unavailable'}.'),
            ),
          if (!isAvailable) ...[
            const Divider(),
            ListTile(
              title: GenericTextWidget(
                'Not connected',
                style: TextStyle(
                  color: ThemeData.light().colorScheme.error,
                ),
              ),
              subtitle: const GenericTextWidget(
                'Unable to connect to the payments processor. Has this app been configured correctly? See the example README for instructions.',
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildProductList(PaymentDataState state) {
    final productList = state.products.map((product) {
      return ListTile(
        title: Text(product.title),
        subtitle: Text(product.description),
        trailing: TextButtonWidget(
          style: TextButton.styleFrom(
            backgroundColor: Colors.green[800],
            foregroundColor: Colors.white,
          ),
          onPressed: () => _viewModel.purchaseProduct(
              context, product, widget.packageId, widget.propId),
          child: Text(product.price),
        ),
      );
    }).toList();

    return CardWidget(
      child: ListView(
        children: [
          _buildConnectionCheckTile(state.isAvailable),
          const Divider(),
          if (state.showLoader)
            Container(
              height: (MediaQuery.of(context).size.height) / 2,
              margin: const EdgeInsets.only(top: 0),
              alignment: Alignment.center,
              child: SizedBox(
                width: 80,
                height: 20,
                child: BallBeatLoadingWidget(),
              ),
            )
          else
            ...productList,
        ],
      ),
    );
  }
}

class InAppPurchaseViewModel {
  final List<String> productIds;
  final BuildContext context;
  final String? packageId;
  final String? propId;
  final bool isMembership;
  final bool isFeaturedForPerListing;
  final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  late StreamSubscription<List<PurchaseDetails>> _subscription;
  final _paymentStateController = StreamController<PaymentState>();

  Stream<PaymentState> get paymentStateStream => _paymentStateController.stream;
  PaymentState? initialState;
  List<ProductDetails> products = [];
  List<PurchaseDetails> _purchases = [];
  // bool call = false;

  MembershipPackageUpdatedHook membershipPackageUpdatedHook = HooksConfigurations.membershipPackageUpdatedHook;
  PaymentSuccessfulHook paymentSuccessfulHook = HooksConfigurations.paymentSuccessfulHook;

  InAppPurchaseViewModel(
    this.context,
    this.productIds, {
    this.packageId,
    this.propId,
    this.isMembership = false,
    required this.isFeaturedForPerListing,
  });

  void init() async {
    // if (Platform.isIOS) {
    //   await _inAppPurchase.restorePurchases();
    // }
    // await _inAppPurchase.restorePurchases();
    _subscription = _inAppPurchase.purchaseStream.listen(
      (List<PurchaseDetails> purchases) {
        print("Calling _handlePurchaseUpdates");
        _purchases = purchases;
        _handlePurchaseUpdates(purchases);
      },
      onDone: () {
        _subscription.cancel();
      },
      onError: (error) {
        _addErrorState('Failed to retrieve purchase information');
      },
    );
    // _inAppPurchase.restorePurchases();
    await _initialize();
  }

  Future<void> _initialize() async {
    final isAvailable = await _inAppPurchase.isAvailable();
    if (!isAvailable) {
      _addErrorState('The store is unavailable');
      return;
    }

    if (Platform.isIOS) {
      final InAppPurchaseStoreKitPlatformAddition iosPlatformAddition =
          _inAppPurchase
              .getPlatformAddition<InAppPurchaseStoreKitPlatformAddition>();
      // print(iosPlatformAddition.refreshPurchaseVerificationData());
      await iosPlatformAddition.setDelegate(ExamplePaymentQueueDelegate());
    }

    _loadProducts();
  }

  void _loadProducts() async {
    print("productIds: $productIds");
    final productDetails =
        await _inAppPurchase.queryProductDetails(productIds.toSet());
    if (productDetails.error != null) {
      _addErrorState('Failed to load product details');
    } else {
      products = productDetails.productDetails;
      print("products: $products");
      if (products.isNotEmpty) {
        initialState = PaymentDataState(products, true, false);
        _paymentStateController.add(initialState!);
      } else {
        _addErrorState('No products available for purchase');
      }
    }
  }

  void _handlePurchaseUpdates(List<PurchaseDetails> purchases) {
    for (final purchase in purchases) {
      print("_handlePurchaseUpdates purchase.status: ${purchase.status}");
      // ShowToastWidget(buildContext: context, text: purchase.status.toString());
      if (purchase.status == PurchaseStatus.pending) {
        print("_handlePurchaseUpdates pending");
        // ShowToastWidget(buildContext: context, text: "Start payment process");
        initialState = PaymentDataState(products, true, true);
        _paymentStateController.add(initialState!);
      } else if (purchase.status == PurchaseStatus.error) {
        _addErrorState('Failed to complete purchase');
      } else if (purchase.status == PurchaseStatus.purchased ||
          purchase.status == PurchaseStatus.restored) {
        print(
          "_handlePurchaseUpdates calling _consumePurchase",
        );
        _consumePurchase(purchase);
      } else if (purchase.status == PurchaseStatus.canceled) {
        // print("_handlePurchaseUpdates caliing _consumePurchase",);
        // ShowToastWidget(buildContext: context, text: "canceled");
        // call = false;
        _inAppPurchase.completePurchase(purchase);
        initialState = PaymentDataState(products, true, false);
        _paymentStateController.add(initialState!);
      }
    }
  }

  Future<void> _consumePurchase(PurchaseDetails purchase) async {
    print("_consumePurchase status: ${purchase.status}");
    // if (purchase.pendingCompletePurchase && call) {
    if (purchase.pendingCompletePurchase) {
      Map<String, dynamic> iapResponse = {};
      try {
        print("_consumePurchase: purchase.pendingCompletePurchase");
        iapResponse = {
          "productID": purchase.productID,
          "purchaseID": purchase.purchaseID,
          "status": purchase.status,
          "transactionDate": purchase.transactionDate,
        };


        print("iapResponse: $iapResponse");
        String iapJson = json.encode(iapResponse);
        Map<String, dynamic> dataMap = {
          "iap": Platform.isAndroid ? "GooglePlay" : "AppStore",
          "iap_response": iapJson,
          "pack_id": packageId,
          "prop_id": propId,
          "is_prop_featured": isFeaturedForPerListing ? 1 : 0,
        };
        print("dataMap: $dataMap");

        print("PURCHASE API CALL");

        ApiResponse apiResponse = await PropertyBloc().fetchProceedWithPaymentsResponse(dataMap);
        // ShowToastWidget(buildContext: context, text: apiResponse.message);
        if (apiResponse.success) {
          _inAppPurchase.completePurchase(purchase);
          paymentSuccessfulHook(context, true);
          if (isMembership) {
            membershipPackageUpdatedHook(context, true);
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => MyHomePage()),
                    (Route<dynamic> route) => false);
          } else {
            Navigator.pop(context);
          }

        }
      } catch (e, s) {
        print("Error of payment: $s");
        print("Error of payment: $e");
        // _inAppPurchase.completePurchase(purchase);
      }
    } else {
      _inAppPurchase.completePurchase(purchase);
    }
  }

  void purchaseProduct(BuildContext context, ProductDetails product,
      String? packageId, String? propId) async {
    try {
      if (Platform.isIOS) {
        // Clean the pending transaction first
        var transactions = await SKPaymentQueueWrapper().transactions();
        transactions.forEach((skPaymentTransactionWrapper) {
          SKPaymentQueueWrapper()
              .finishTransaction(skPaymentTransactionWrapper);
        });
      }

      if (_purchases.isNotEmpty) {
        for (var _purchaseDetails in _purchases) {
          if (_purchaseDetails.pendingCompletePurchase) {
            await _inAppPurchase.completePurchase(_purchaseDetails);
          }
        }
      }

      final PurchaseParam purchaseParam =
          PurchaseParam(productDetails: product);
      initialState = PaymentDataState(products, true, true);
      _paymentStateController.add(initialState!);
      print("_kAutoConsume: $_kAutoConsume");
      _inAppPurchase.buyConsumable(
          purchaseParam: purchaseParam, autoConsume: _kAutoConsume);
    } on PlatformException catch (e) {
      if (e.code == 'storekit_duplicate_product_object') {
        // Handle the exception here...
        // await _inAppPurchase.completePurchase(_purchaseDetails);
      }
    } catch (e, s) {
      // ShowToastWidget(buildContext: context, text: e.toString());
    }
  }

  void _addErrorState(String error) {
    final errorState = PaymentErrorState(error);
    _paymentStateController.add(errorState);
  }

  void dispose() {
    _subscription.cancel();
    _paymentStateController.close();
  }
}

abstract class PaymentState {}

class PaymentAvailableState extends PaymentState {
  final bool isAvailable;

  PaymentAvailableState(this.isAvailable);
}

class PaymentLoadingState extends PaymentState {
  final bool isLoading;

  PaymentLoadingState(this.isLoading);
}

class PaymentDataState extends PaymentState {
  final List<ProductDetails> products;
  final bool isAvailable;
  final bool showLoader;

  PaymentDataState(this.products, this.isAvailable, this.showLoader);
}

class PaymentErrorState extends PaymentState {
  final String error;

  PaymentErrorState(this.error);
}

/// Example implementation of the
/// [`SKPaymentQueueDelegate`](https://developer.apple.com/documentation/storekit/skpaymentqueuedelegate?language=objc).
///
/// The payment queue delegate can be implementated to provide information
/// needed to complete transactions.
class ExamplePaymentQueueDelegate implements SKPaymentQueueDelegateWrapper {
  @override
  bool shouldContinueTransaction(
      SKPaymentTransactionWrapper transaction, SKStorefrontWrapper storefront) {
    return true;
  }

  @override
  bool shouldShowPriceConsent() {
    return false;
  }
}

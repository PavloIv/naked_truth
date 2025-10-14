import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';

import '../models/subscription_info.dart';

class SubscriptionService {

  Future<List<SubscriptionInfo>> checkSubscription() async {
    final iap = InAppPurchase.instance;
    final result = <SubscriptionInfo>[];

    final available = await iap.isAvailable();
    if (!available) {
      return result;
    }

    if (Platform.isAndroid) {
      final addition =
      iap.getPlatformAddition<InAppPurchaseAndroidPlatformAddition>();
      final purchases = await addition.queryPastPurchases();

      if (purchases.pastPurchases.isEmpty) {
        return result;
      }

      for (final purchase in purchases.pastPurchases) {
        final purchaseDate = _parsePurchaseDate(purchase.transactionDate);
        final info =
        SubscriptionInfo(productId: purchase.productID, purchaseDate: purchaseDate);

        result.add(info);
      }
    }

    if (Platform.isIOS) {
      final completer = Completer<List<SubscriptionInfo>>();

      final subscription = iap.purchaseStream.listen((purchases) {
        final iosResult = <SubscriptionInfo>[];
        for (final purchase in purchases) {
          final purchaseDate = _parsePurchaseDate(purchase.transactionDate);
          final info =
          SubscriptionInfo(productId: purchase.productID, purchaseDate: purchaseDate);

          iosResult.add(info);
        }
        completer.complete(iosResult);
      });

      await InAppPurchase.instance.restorePurchases();

      final iosPurchases = await completer.future.timeout(
        const Duration(seconds: 5),
        onTimeout: () {
          return <SubscriptionInfo>[];
        },
      );

      await subscription.cancel();
      result.addAll(iosPurchases);
    }

    return result;
  }

  DateTime? _parsePurchaseDate(String? rawDate) {
    if (rawDate == null) return null;
    if (RegExp(r'^\d+$').hasMatch(rawDate)) {
      try {
        return DateTime.fromMillisecondsSinceEpoch(int.parse(rawDate));
      } catch (_) {
        return null;
      }
    }
    try {
      return DateTime.parse(rawDate);
    } catch (_) {
      if (kDebugMode) {
        print('⚠️ Неможливо розпарсити дату покупки: $rawDate');
      }
      return null;
    }
  }
}

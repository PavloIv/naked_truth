class SubscriptionInfo {
  final String productId;
  final DateTime? purchaseDate;

  SubscriptionInfo({required this.productId, this.purchaseDate});

  bool get isPair => productId == 'premium_pair';
  bool get isSingle => productId == 'premium_single';

  @override
  String toString() =>
      'SubscriptionInfo(productId: $productId, purchaseDate: $purchaseDate)';
}
class OrderModel {
  final String orderId;
  final String date;
  final double totalAmount;
  final String paymentMethod;
  final String status;

  OrderModel({
    required this.orderId,
    required this.date,
    required this.totalAmount,
    required this.paymentMethod,
    required this.status,
  });

  Map<String, dynamic> toMap() {
    return {
      "orderId": orderId,
      "date": date,
      "totalAmount": totalAmount,
      "paymentMethod": paymentMethod,
      "status": status,
    };
  }

  factory OrderModel.fromMap(
    Map<dynamic, dynamic> map,
  ) {
    return OrderModel(
      orderId: map["orderId"],
      date: map["date"],
      totalAmount: map["totalAmount"],
      paymentMethod: map["paymentMethod"],
      status: map["status"],
    );
  }
}
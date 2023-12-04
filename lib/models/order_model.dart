class OrderModel {
  int? id;
  String? name;
  int? count;
  double? price;
  double? paid;
  double? loss;
  bool? completed;
  String type;

  OrderModel({
    this.id,
    required this.name,
    required this.count,
    required this.price,
    required this.paid,
    required this.loss,
    this.completed,
    required this.type,
  });

  @override
  String toString() {
    return "$name, $count, $price, $paid ,$loss";
  }

  Map<String, dynamic> toMap(int newCount) {
    return {
      "name": name,
      "count": newCount,
      "price": price,
      "paid": paid,
      "loss": loss,
      "completed": completed,
      "type": type,
    };
  }

  factory OrderModel.fromMap(Map<String, dynamic> map) {
    int newCount = map["count"];
    return OrderModel(
      id: map["id"],
      name: map["name"],
      count: newCount.round(),
      price: map["price"],
      paid: map["paid"],
      loss: map["loss"],
      completed: map["completed"] == 1,
      type: map["type"],
    );
  }
}

enum ProductType { terlik, panduf }

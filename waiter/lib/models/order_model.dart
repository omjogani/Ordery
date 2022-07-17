class Cart {
  late final int? id;
  final String? orderId;
  final String? name;
  final String? description;
  final int? initialPrice;
  final int? productPrice;
  final int? quantity;
  final String? image;

  Cart({
    required this.id,
    required this.orderId,
    required this.name,
    required this.description,
    required this.initialPrice,
    required this.productPrice,
    required this.quantity,
    required this.image,
  });

  Cart.fromMap(Map<dynamic, dynamic> res)
  : id = res['id'],
  orderId = res['orderId'],
  name = res['name'],
  description = res['description'],
  initialPrice = res['initialPrice'],
  productPrice = res['productPrice'],
  quantity = res['quantity'],
  image = res['image'];

  Map<String, Object?> toMap(){
    return {
      'id': id,
      'orderId' : orderId,
      'name' : name,
      'description' : description,
      'initialPrice' : initialPrice,
      'productPrice' : productPrice,
      'quantity' : quantity,
      'image' : image,
    };
  }
}
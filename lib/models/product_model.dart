import 'package:hive/hive.dart';
import 'package:get/get.dart';

part 'product_model.g.dart';

@HiveType(typeId: 0) 
class Product {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String description;

  @HiveField(3)
  final String image;

  @HiveField(4)
  final double price;

  @HiveField(5)
  RxInt quantity;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.image,
    required this.price,
    int quantity = 1,
  }) : quantity = quantity.obs;

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      image: json['image'],
      price: json['price'].toDouble(),
      quantity: json['quantity'] ?? 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'image': image,
      'price': price,
      'quantity': quantity.value,
    };
  }
}

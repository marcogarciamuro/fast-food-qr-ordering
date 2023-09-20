class Item {
  late int id;
  late String name;
  late double price;
  late String? image;
  late String? options;
  Item(this.id, this.name, this.price, this.image, this.options);

  Map toJson() {
    return {'id': id, 'name': name, 'price': price, 'image': image};
  }
}

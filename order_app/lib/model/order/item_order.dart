import 'dart:typed_data';

class ItemOrder {
  final String name;
  final String? image;
  final String? imagesByte;
  final double total;
  final List<SubItem>? subItem;

  ItemOrder({
    required this.name,
    required this.total,
    this.imagesByte,
    this.subItem,
    this.image,
  });

  factory ItemOrder.fromJson(Map<String, dynamic> json) => ItemOrder(
        name: json["name"],
        image:json["image"] != null ? json["image"] : null,
        imagesByte:json["imagesByte"] != null ?  json["imagesByte"] : null,
        total: json["total"],
        subItem: json["subItem"] != null ? List<SubItem>.from(json["subItem"].map((x) => SubItem.fromJson(x))) : null,
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "image": image != null ? image : null,
        "total": total,
        "imagesByte": imagesByte != null ? imagesByte : null,
        "subItem": subItem != null ? List<dynamic>.from(subItem!.map((x) => x)) : null,
      };
}

class SubItem {
  final String? itemName;

  SubItem({this.itemName});

  factory SubItem.fromJson(Map<String, dynamic> json) => SubItem(
        itemName: json["itemName"],
      );

  Map<String, dynamic> toJson() => {
        "itemName": itemName,
      };
}

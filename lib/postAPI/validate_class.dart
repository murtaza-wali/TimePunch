// To parse this JSON data, do
//
//     final validateModel = validateModelFromJson(jsonString);

import 'dart:convert';

ValidateModel validateModelFromJson(String str) => ValidateModel.fromJson(json.decode(str));

String validateModelToJson(ValidateModel data) => json.encode(data.toJson());

class ValidateModel {
  ValidateModel({
    required this.items,
    required this.hasMore,
    required this.limit,
    required this.offset,
    required this.count,
    required this.links,
  });

  List<Item> items;
  bool hasMore;
  int limit;
  int offset;
  int count;
  List<Link> links;

  factory ValidateModel.fromJson(Map<String, dynamic> json) => ValidateModel(
    items: List<Item>.from(json["items"].map((x) => Item.fromJson(x))),
    hasMore: json["hasMore"],
    limit: json["limit"],
    offset: json["offset"],
    count: json["count"],
    links: List<Link>.from(json["links"].map((x) => Link.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "items": List<dynamic>.from(items.map((x) => x.toJson())),
    "hasMore": hasMore,
    "limit": limit,
    "offset": offset,
    "count": count,
    "links": List<dynamic>.from(links.map((x) => x.toJson())),
  };
}

class Item {
  Item({
    required this.isactive,
  });

  String isactive;

  factory Item.fromJson(Map<String, dynamic> json) => Item(
    isactive: json["isactive"],
  );

  Map<String, dynamic> toJson() => {
    "isactive": isactive,
  };
}

class Link {
  Link({
    required this.rel,
    required this.href,
  });

  String rel;
  String href;

  factory Link.fromJson(Map<String, dynamic> json) => Link(
    rel: json["rel"],
    href: json["href"],
  );

  Map<String, dynamic> toJson() => {
    "rel": rel,
    "href": href,
  };
}

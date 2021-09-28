// To parse this JSON data, do
//
//     final version = versionFromJson(jsonString);

import 'dart:convert';

Version versionFromJson(String str) => Version.fromJson(json.decode(str));

String versionToJson(Version data) => json.encode(data.toJson());

class Version {
  Version({
    required this.versionitems,
    required this.hasMore,
    required this.limit,
    required this.offset,
    required this.count,
    required this.links,
  });

  List<Versionitem> versionitems;
  bool hasMore;
  int limit;
  int offset;
  int count;
  List<Link> links;

  factory Version.fromJson(Map<String, dynamic> json) => Version(
    versionitems: List<Versionitem>.from(json["Versionitems"].map((x) => Versionitem.fromJson(x))),
    hasMore: json["hasMore"],
    limit: json["limit"],
    offset: json["offset"],
    count: json["count"],
    links: List<Link>.from(json["links"].map((x) => Link.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "Versionitems": List<dynamic>.from(versionitems.map((x) => x.toJson())),
    "hasMore": hasMore,
    "limit": limit,
    "offset": offset,
    "count": count,
    "links": List<dynamic>.from(links.map((x) => x.toJson())),
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

class Versionitem {
  Versionitem({
    required this.apkVersion,
    required this.iosVersion,
  });

  String apkVersion;
  int iosVersion;

  factory Versionitem.fromJson(Map<String, dynamic> json) => Versionitem(
    apkVersion: json["apk_version"],
    iosVersion: json["ios_version"],
  );

  Map<String, dynamic> toJson() => {
    "apk_version": apkVersion,
    "ios_version": iosVersion,
  };
}

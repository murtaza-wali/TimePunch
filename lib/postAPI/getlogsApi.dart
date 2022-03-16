// To parse this JSON data, do
//
//     final getlogsApi = getlogsApiFromJson(jsonString);

import 'dart:convert';

GetlogsApi getlogsApiFromJson(String str) =>
    GetlogsApi.fromJson(json.decode(str));

String getlogsApiToJson(GetlogsApi data) => json.encode(data.toJson());

class GetlogsApi {
  GetlogsApi({
    required this.logsitems,
    required this.hasMore,
    required this.limit,
    required this.offset,
    required this.count,
    required this.links,
  });

  List<Logsitem> logsitems;
  bool hasMore;
  int limit;
  int offset;
  int count;
  List<Link> links;

  factory GetlogsApi.fromJson(Map<String, dynamic> json) => GetlogsApi(
        logsitems: List<Logsitem>.from(
            json["logsitems"].map((x) => Logsitem.fromJson(x))),
        hasMore: json["hasMore"],
        limit: json["limit"],
        offset: json["offset"],
        count: json["count"],
        links: List<Link>.from(json["links"].map((x) => Link.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "logsitems": List<dynamic>.from(logsitems.map((x) => x.toJson())),
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

class Logsitem {
  Logsitem({
    required this.orgCode,
    required this.accessTime,
  });

  String orgCode;
  String accessTime;

  factory Logsitem.fromJson(Map<String, dynamic> json) => Logsitem(
        orgCode: json["org_code"],
        accessTime: json["access_time"],
      );

  Map<String, dynamic> toJson() => {
        "org_code": orgCode,
        "access_time": accessTime,
      };
}
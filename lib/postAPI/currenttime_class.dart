// To parse this JSON data, do
//
//     final currentTime = currentTimeFromJson(jsonString);

import 'dart:convert';

CurrentTime currentTimeFromJson(String str) =>
    CurrentTime.fromJson(json.decode(str));

String currentTimeToJson(CurrentTime data) => json.encode(data.toJson());

class CurrentTime {
  CurrentTime({
    required this.currentTimeitems,
    required this.hasMore,
    required this.limit,
    required this.offset,
    required this.count,
    required this.links,
  });

  List<CurrentTimeitem> currentTimeitems;
  bool hasMore;
  int limit;
  int offset;
  int count;
  List<Link> links;

  factory CurrentTime.fromJson(Map<String, dynamic> json) => CurrentTime(
        currentTimeitems: List<CurrentTimeitem>.from(
            json["currentTimeitems"].map((x) => CurrentTimeitem.fromJson(x))),
        hasMore: json["hasMore"],
        limit: json["limit"],
        offset: json["offset"],
        count: json["count"],
        links: List<Link>.from(json["links"].map((x) => Link.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "currentTimeitems":
            List<dynamic>.from(currentTimeitems.map((x) => x.toJson())),
        "hasMore": hasMore,
        "limit": limit,
        "offset": offset,
        "count": count,
        "links": List<dynamic>.from(links.map((x) => x.toJson())),
      };
}

class CurrentTimeitem {
  CurrentTimeitem({
    required this.time,
  });

  String time;

  factory CurrentTimeitem.fromJson(Map<String, dynamic> json) =>
      CurrentTimeitem(
        time: json["time"],
      );

  Map<String, dynamic> toJson() => {
        "time": time,
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

import 'dart:convert';

Rol RolFromJson(String str) => Rol.fromJson(json.decode(str));

String RolToJson(Rol data) => json.encode(data.toJson());

class Rol {
  Rol({
    this.id,
    this.name,
    this.image,
    this.route,
  });

  int? id;
  String? name;
  String? image;
  String? route;

  factory Rol.fromJson(Map<String, dynamic> json) => Rol(
        id: json["id"],
        name: json["name"],
        image: json["image"],
        route: json["route"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "image": image,
        "route": route,
      };
}

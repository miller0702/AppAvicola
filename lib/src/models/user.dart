import 'dart:convert';

import 'package:appAvicola/src/models/rol.dart';


User userFromJson(String str) => User.fromJson(json.decode(str));
User userFromJsonUpdate(String str, User data) => User.fromJsonUpdate(json.decode(str), data.toJson());

String userToJson(User data) => jsonEncode(data.toJson());

class User {
  String? id;
  String? name;
  String? lastname;
  String? email;
  String? phone;
  String? password;
  String? sessionToken;
  String? image;
  List<Rol>? roles = [];

  User(
      {this.id ,
      this.name,
      this.lastname,
      this.email,
      this.phone,
      this.password,
      this.sessionToken,
      this.image,
      this.roles});

  factory User.fromJson(Map<String, dynamic> json)  => User(
        id: json["id"],
        name: json["name"],
        lastname: json["lastname"],
        email: json["email"],
        phone: json["phone"],
        password: json["password"],
        sessionToken: json["session_token"],
        image: json["image"],
        roles: json["roles"] == null ? [] : List<Rol>.from(json["roles"].map((model)=> Rol.fromJson(model))),
      );
  factory User.fromJsonUpdate(Map<String, dynamic> json,user1)  => User(
        id: json["id"],
        name: json["name"] == null ? user1.name !=null ? json["name"]=user1.name : json["name"]=null : json["name"]=json["name"],
        lastname: json["lastname"]== null ? user1.lastname !=null ? json["lastname"]=user1.lastname : json["lastname"]=null : json["lastname"]=json["lastname"],
        email: json["email"]== null ? user1.email !=null ? json["email"]=user1.email : json["email"]=null : json["email"]=json["email"],
        phone: json["phone"]== null ? user1.phone !=null ? json["phone"]=user1.phone : json["phone"]=null : json["phone"]=json["phone"],
        password: json["password"]== null ? user1.password !=null ? json["password"]=user1.password : json["password"]=null : json["password"]=json["password"],
        sessionToken: json["session_token"]== null ? user1.sessionToken !=null ? json["session_token"]=user1.sessionToken : json["session_token"]=null : json["session_token"]=json["session_token"],
        image: json["image"]== null ? user1.image !=null ? json["image"]=user1.image : json["image"]=null : json["image"]=json["image"],
        roles: json["roles"] == null ? user1.roles !=null ? json["roles"]=user1.roles : json["roles"]=null : json["roles"]=json["roles"],
      );

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'lastname': lastname,
      'email': email,
      'phone': phone,
      'password': password,
      'session_token': sessionToken,
      'image': image,
      'roles': roles?.map((role) => role.toJson()).toList(),
    };
  }
}

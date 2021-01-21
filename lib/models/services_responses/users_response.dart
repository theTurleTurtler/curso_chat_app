// To parse this JSON data, do
//
//     final usersResponse = usersResponseFromJson(jsonString);

import 'dart:convert';

import 'package:chat_app/models/entities/user.dart';

UsersResponse usersResponseFromJson(String str) => UsersResponse.fromJson(json.decode(str));

String usersResponseToJson(UsersResponse data) => json.encode(data.toJson());

class UsersResponse {
    UsersResponse({
        this.ok,
        this.msg,
        this.users,
        this.from,
    });

    bool ok;
    String msg;
    List<User> users;
    int from;

    factory UsersResponse.fromJson(Map<String, dynamic> json) => UsersResponse(
        ok: json["ok"],
        msg: json["msg"],
        users: List<User>.from(json["users"].map((x) => User.fromJson(x))),
        from: json["from"],
    );

    Map<String, dynamic> toJson() => {
        "ok": ok,
        "msg": msg,
        "users": List<dynamic>.from(users.map((x) => x.toJson())),
        "from": from,
    };
}

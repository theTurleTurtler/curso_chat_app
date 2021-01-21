import 'dart:convert';

import 'package:chat_app/models/entities/user.dart';

LoginResponse loginResponseFromJson(String str) => LoginResponse.fromJson(json.decode(str));
String loginResponseToJson(LoginResponse data) => json.encode(data.toJson());

class LoginResponse {
    LoginResponse({
        this.ok,
        this.msg,
        this.user,
        this.token,
    });

    bool ok;
    String msg;
    User user;
    String token;

    factory LoginResponse.fromJson(Map<String, dynamic> json) => LoginResponse(
        ok: json["ok"],
        msg: json["msg"],
        user: User.fromJson(json["user"]),
        token: json["token"],
    );

    Map<String, dynamic> toJson() => {
        "ok": ok,
        "msg": msg,
        "user": user.toJson(),
        "token": token,
    };
}
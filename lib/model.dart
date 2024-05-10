import 'dart:convert';

Note productsFromJson(String str) => Note.fromJson(json.decode(str));
List<Note> listNotesFromJson(String result) =>
    List<Note>.from(jsonDecode(result).map((e) => Note.fromJson(e)));
String productsToJson(Note data) => json.encode(data.toJson());

class Note {
  Note({
    this.id,
    this.title,
    this.body,
    this.createTime,
    this.editTime,
  });

  Note.fromJson(dynamic json) {
    id = json['id'];
    title = json['title'];
    body = json['body'];
    createTime = json['createTime'];
    editTime = json['editTime'];
  }
  String? id;
  String? title;
  String? body;
  String? createTime;
  String? editTime;

  Map<String, dynamic> toJson() {
    final map = <String, Object?>{};
    map['id'] = id;
    map['title'] = title;
    map['body'] = body;
    map['createTime'] = createTime;
    map['editTime'] = editTime;
    return map;
  }
}

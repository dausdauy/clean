import 'base_model.dart';

class AlbumModel extends BaseModel {
  int? userId;
  int? idAlbum;
  String? titleAlbum;

  AlbumModel({
    this.userId,
    this.idAlbum,
    this.titleAlbum,
  }) : super(id: idAlbum, title: titleAlbum);

  @override
  BaseModel fromJson(Map<String, dynamic> json) => AlbumModel(
        userId: json["userId"],
        idAlbum: json["id"],
        titleAlbum: json["title"],
      );
}

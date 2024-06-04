// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'UserModel.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserModelAdapter extends TypeAdapter<UserModel> {
  @override
  final int typeId = 1;

  @override
  UserModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserModel(
      seedColor: fields[8] as Color,
      latSessionSongs: (fields[0] as Map).cast<String, dynamic>(),
      homeScreenData: (fields[7] as Map).cast<String, dynamic>(),
      songsHistory: (fields[4] as List)
          .map((dynamic e) => (e as Map).cast<String, dynamic>())
          .toList(),
      userPlaylists: (fields[6] as List)
          .map((dynamic e) => (e as Map).cast<String, dynamic>())
          .toList(),
      favouriteSongs: (fields[5] as List)
          .map((dynamic e) => (e as Map).cast<String, dynamic>())
          .toList(),
      downloadedSongIds: (fields[9] as List).cast<String>(),
      userName: fields[1] as String,
      perfferdLanguage: fields[2] as String,
      audioQuality: fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, UserModel obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.latSessionSongs)
      ..writeByte(1)
      ..write(obj.userName)
      ..writeByte(2)
      ..write(obj.perfferdLanguage)
      ..writeByte(3)
      ..write(obj.audioQuality)
      ..writeByte(4)
      ..write(obj.songsHistory)
      ..writeByte(5)
      ..write(obj.favouriteSongs)
      ..writeByte(6)
      ..write(obj.userPlaylists)
      ..writeByte(7)
      ..write(obj.homeScreenData)
      ..writeByte(8)
      ..write(obj.seedColor)
      ..writeByte(9)
      ..write(obj.downloadedSongIds);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

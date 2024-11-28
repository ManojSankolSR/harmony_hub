class AlbumModel {}

class SongInfoModel {
  final String name;
  final String subtitle;
  final String language;
  final int year;

  SongInfoModel(
      {required this.name,
      required this.subtitle,
      required this.language,
      required this.year});
}

class LRCLIB {
  final String artist_name;
  final String album_name;
  final String track_name;
  final String duration;

  LRCLIB(
      {required this.artist_name,
      required this.album_name,
      required this.track_name,
      required this.duration});
}

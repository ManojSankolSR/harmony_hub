class Globalconstants {
  static Duration parseDuration(String s) {
    int hours = 0;
    int minutes = 0;
    int micros;
    List<String> parts = s.split(':');
    if (parts.length > 2) {
      hours = int.parse(parts[parts.length - 3]);
    }
    if (parts.length > 1) {
      minutes = int.parse(parts[parts.length - 2]);
    }
    micros = (double.parse(parts[parts.length - 1]) * 1000000).round();
    return Duration(hours: hours, minutes: minutes, microseconds: micros);
  }

  static const Map<String, dynamic> PlaylistLoadingData = {
    "id": "1134595537",
    "name": "English: India Superhits Top 50",
    "subtitle": "79.2K Followers",
    "type": "playlist",
    "header_desc":
        "Most streamed this week.                                                                                         \nArtist On Cover : Ed Sheeran.",
    "url":
        "https://www.jiosaavn.com/featured/english-india-superhits-top-50/aXoCADwITrUCObrEMJSxEw__",
    "image":
        "https://c.saavncdn.com/editorial/English-IndiaSuperhitsTop50_20240614061809.jpg?bch=1718347884",
    "language": "",
    "explicit": false,
    "list_count": 50,
    "list_type": "",
    "user_id": "phulki_user",
    "is_dolby_content": false,
    "last_updated": "2024-06-14T06:21:24.000Z",
    "username": "phulki_user",
    "firstname": "JioSaavn",
    "lastname": "",
    "follower_count": 79238,
    "fan_count": 70351,
    "share": 1,
    "video_count": 0,
    "songs": [
      {
        "id": "riybhkJ4",
        "name": "One Love",
        "subtitle": "Blue - The Platinum Collection",
        "type": "song",
        "url": "https://www.jiosaavn.com/song/one-love/AgESUxxbfQc",
        "image":
            "https://c.saavncdn.com/155/The-Platinum-Collection-English-2013-50x50.jpg",
        "language": "english",
        "year": 2013,
        "header_desc": "",
        "play_count": 9781954,
        "explicit": false,
        "list": "",
        "list_type": "",
        "list_count": 0,
        "music": "Webbe, Ryan, Rustan, Mikkel Se, James, Hermansen, Costa",
        "artist_map": {
          "artists": [
            {
              "id": "455138",
              "name": "James",
              "url": "https://www.jiosaavn.com/artist/james-songs/nhqzCDO4lVI_",
              "role": "Music",
              "type": "artist",
              "image": [
                {
                  "quality": "50x50",
                  "link":
                      "https://c.saavncdn.com/446/Single-Relation-Punjabi-2017-20180130210516-50x50.jpg"
                },
                {
                  "quality": "150x150",
                  "link":
                      "https://c.saavncdn.com/446/Single-Relation-Punjabi-2017-20180130210516-150x150.jpg"
                },
                {
                  "quality": "500x500",
                  "link":
                      "https://c.saavncdn.com/446/Single-Relation-Punjabi-2017-20180130210516-500x500.jpg"
                }
              ]
            },
            {
              "id": "483873",
              "name": "Blue",
              "url": "https://www.jiosaavn.com/artist/blue-songs/5YHgOvFf9nM_",
              "role": "Singer",
              "type": "artist",
              "image":
                  "https://c.saavncdn.com/155/The-Platinum-Collection-English-2013-50x50.jpg"
            },
            {
              "id": "502368",
              "name": "Ryan",
              "url": "https://www.jiosaavn.com/artist/ryan-songs/zGfdfAVbCjw_",
              "role": "Music",
              "type": "artist",
              "image": [
                {
                  "quality": "50x50",
                  "link":
                      "https://c.saavncdn.com/305/Last-Seen-Punjabi-2017-50x50.jpg"
                },
                {
                  "quality": "150x150",
                  "link":
                      "https://c.saavncdn.com/305/Last-Seen-Punjabi-2017-150x150.jpg"
                },
                {
                  "quality": "500x500",
                  "link":
                      "https://c.saavncdn.com/305/Last-Seen-Punjabi-2017-500x500.jpg"
                }
              ]
            },
            {
              "id": "563704",
              "name": "Mikkel Se",
              "url":
                  "https://www.jiosaavn.com/artist/mikkel-se-songs/zTiYB23XSAI_",
              "role": "Music",
              "type": "artist",
              "image": ""
            },
            {
              "id": "563711",
              "name": "Rustan",
              "url":
                  "https://www.jiosaavn.com/artist/rustan-songs/wwRo8hGzNMQ_",
              "role": "Music",
              "type": "artist",
              "image": ""
            },
            {
              "id": "647153",
              "name": "Hermansen",
              "url":
                  "https://www.jiosaavn.com/artist/hermansen-songs/v9btAAKroIM_",
              "role": "Music",
              "type": "artist",
              "image": [
                {
                  "quality": "50x50",
                  "link":
                      "https://c.saavncdn.com/397/Introverted-English-2013-50x50.jpg"
                },
                {
                  "quality": "150x150",
                  "link":
                      "https://c.saavncdn.com/397/Introverted-English-2013-150x150.jpg"
                },
                {
                  "quality": "500x500",
                  "link":
                      "https://c.saavncdn.com/397/Introverted-English-2013-500x500.jpg"
                }
              ]
            },
            {
              "id": "679128",
              "name": "Webbe",
              "url": "https://www.jiosaavn.com/artist/webbe-songs/1qRNqZQJPqM_",
              "role": "Music",
              "type": "artist",
              "image": ""
            },
            {
              "id": "679129",
              "name": "Costa",
              "url": "https://www.jiosaavn.com/artist/costa-songs/R1yJP5nsbiY_",
              "role": "Music",
              "type": "artist",
              "image": [
                {
                  "quality": "50x50",
                  "link":
                      "https://c.saavncdn.com/artists/Costa_000_20210603104923_50x50.jpg"
                },
                {
                  "quality": "150x150",
                  "link":
                      "https://c.saavncdn.com/artists/Costa_000_20210603104923_150x150.jpg"
                },
                {
                  "quality": "500x500",
                  "link":
                      "https://c.saavncdn.com/artists/Costa_000_20210603104923_500x500.jpg"
                }
              ]
            }
          ],
          "featured_artists": [],
          "primary_artists": [
            {
              "id": "483873",
              "name": "Blue",
              "url": "https://www.jiosaavn.com/artist/blue-songs/5YHgOvFf9nM_",
              "role": "Primary_artists",
              "type": "artist",
              "image": [
                {
                  "quality": "50x50",
                  "link":
                      "https://c.saavncdn.com/759/All-Rise-English-2003-50x50.jpg"
                },
                {
                  "quality": "150x150",
                  "link":
                      "https://c.saavncdn.com/759/All-Rise-English-2003-150x150.jpg"
                },
                {
                  "quality": "500x500",
                  "link":
                      "https://c.saavncdn.com/759/All-Rise-English-2003-500x500.jpg"
                }
              ]
            }
          ]
        },
        "album": "The Platinum Collection",
        "album_id": "1211666",
        "album_url":
            "https://www.jiosaavn.com/album/the-platinum-collection/xV6NaYVMiY0_",
        "label": "Innocent",
        "label_url": "/label/innocent-albums/hndH5mTIFAs_",
        "origin": "playlist",
        "is_dolby_content": false,
        "320kbps": true,
        "download_url": [
          {
            "quality": "12kbps",
            "link":
                "https://aac.saavncdn.com/155/9f7092dc8b23628596fb0d6a033af361_12.mp4"
          },
          {
            "quality": "48kbps",
            "link":
                "https://aac.saavncdn.com/155/9f7092dc8b23628596fb0d6a033af361_48.mp4"
          },
          {
            "quality": "96kbps",
            "link":
                "https://aac.saavncdn.com/155/9f7092dc8b23628596fb0d6a033af361_96.mp4"
          },
          {
            "quality": "160kbps",
            "link":
                "https://aac.saavncdn.com/155/9f7092dc8b23628596fb0d6a033af361_160.mp4"
          },
          {
            "quality": "320kbps",
            "link":
                "https://aac.saavncdn.com/155/9f7092dc8b23628596fb0d6a033af361_320.mp4"
          }
        ],
        "duration": 205,
        "rights": {
          "code": "0",
          "cacheable": "true",
          "delete_cached_object": "false",
          "reason": ""
        },
        "has_lyrics": false,
        "lyrics_snippet": "",
        "starred": false,
        "release_date": "2013-07-10",
        "triller_available": false,
        "copyright_text": "©  2013 Innocent",
        "vcode": "010912291611975",
        "vlink":
            "https://jiotunepreview.jio.com/content/Converted/010912291567798.mp3"
      },
      {
        "id": "u2flpAk4",
        "name": "Cheri Cheri Lady",
        "subtitle": "Modern Talking - Let's Talk About Love",
        "type": "song",
        "url": "https://www.jiosaavn.com/song/cheri-cheri-lady/BVoNXQRxXAc",
        "image":
            "https://c.saavncdn.com/155/The-Platinum-Collection-English-2013-50x50.jpg",
        "language": "english",
        "year": 1988,
        "header_desc": "",
        "play_count": 7299287,
        "explicit": false,
        "list": "",
        "list_type": "",
        "list_count": 0,
        "music": "Dieter Bohlen",
        "artist_map": {
          "artists": [
            {
              "id": "581698",
              "name": "Dieter Bohlen",
              "url":
                  "https://www.jiosaavn.com/artist/dieter-bohlen-songs/a4,FAIcR7kI_",
              "role": "Music, Lyricist",
              "type": "artist",
              "image": [
                {
                  "quality": "50x50",
                  "link":
                      "https://c.saavncdn.com/422/Dieter-the-hits-English-2006-20180331131123-50x50.jpg"
                },
                {
                  "quality": "150x150",
                  "link":
                      "https://c.saavncdn.com/422/Dieter-the-hits-English-2006-20180331131123-150x150.jpg"
                },
                {
                  "quality": "500x500",
                  "link":
                      "https://c.saavncdn.com/422/Dieter-the-hits-English-2006-20180331131123-500x500.jpg"
                }
              ]
            },
            {
              "id": "581699",
              "name": "Modern Talking",
              "url":
                  "https://www.jiosaavn.com/artist/modern-talking-songs/7gZPtB9i6Jc_",
              "role": "Singer",
              "type": "artist",
              "image": [
                {
                  "quality": "50x50",
                  "link":
                      "https://c.saavncdn.com/490/Original-80-s-2014-50x50.jpg"
                },
                {
                  "quality": "150x150",
                  "link":
                      "https://c.saavncdn.com/490/Original-80-s-2014-150x150.jpg"
                },
                {
                  "quality": "500x500",
                  "link":
                      "https://c.saavncdn.com/490/Original-80-s-2014-500x500.jpg"
                }
              ]
            }
          ],
          "featured_artists": [],
          "primary_artists": [
            {
              "id": "581699",
              "name": "Modern Talking",
              "url":
                  "https://www.jiosaavn.com/artist/modern-talking-songs/7gZPtB9i6Jc_",
              "role": "Primary_artists",
              "type": "artist",
              "image": [
                {
                  "quality": "50x50",
                  "link":
                      "https://c.saavncdn.com/490/Original-80-s-2014-50x50.jpg"
                },
                {
                  "quality": "150x150",
                  "link":
                      "https://c.saavncdn.com/490/Original-80-s-2014-150x150.jpg"
                },
                {
                  "quality": "500x500",
                  "link":
                      "https://c.saavncdn.com/490/Original-80-s-2014-500x500.jpg"
                }
              ]
            }
          ]
        },
        "album": "Let's Talk About Love",
        "album_id": "17784359",
        "album_url":
            "https://www.jiosaavn.com/album/lets-talk-about-love/qGusWqRveVU_",
        "label": "Hansa Local",
        "label_url": "/label/hansa-local-albums/0UybD0ze9-c_",
        "origin": "playlist",
        "is_dolby_content": false,
        "320kbps": true,
        "download_url": [
          {
            "quality": "12kbps",
            "link":
                "https://aac.saavncdn.com/112/c54a2ce49a6806ac20ebd95dd8000c69_12.mp4"
          },
          {
            "quality": "48kbps",
            "link":
                "https://aac.saavncdn.com/112/c54a2ce49a6806ac20ebd95dd8000c69_48.mp4"
          },
          {
            "quality": "96kbps",
            "link":
                "https://aac.saavncdn.com/112/c54a2ce49a6806ac20ebd95dd8000c69_96.mp4"
          },
          {
            "quality": "160kbps",
            "link":
                "https://aac.saavncdn.com/112/c54a2ce49a6806ac20ebd95dd8000c69_160.mp4"
          },
          {
            "quality": "320kbps",
            "link":
                "https://aac.saavncdn.com/112/c54a2ce49a6806ac20ebd95dd8000c69_320.mp4"
          }
        ],
        "duration": 225,
        "rights": {
          "code": "0",
          "cacheable": "true",
          "delete_cached_object": "false",
          "reason": ""
        },
        "has_lyrics": false,
        "lyrics_snippet": "",
        "starred": false,
        "release_date": "1988-12-02",
        "triller_available": false,
        "copyright_text": "(P) 1985 Sony Music Entertainment Germany GmbH",
        "vcode": "010910140244330",
        "vlink":
            "https://jiotunepreview.jio.com/content/Converted/010910140256974.mp3"
      },
      {
        "id": "6o8JoQ8b",
        "name": "Perfect",
        "subtitle": "Ed Sheeran - ÷",
        "type": "song",
        "url": "https://www.jiosaavn.com/song/perfect/RgdTexthD1E",
        "image":
            "https://c.saavncdn.com/155/The-Platinum-Collection-English-2013-50x50.jpg",
        "language": "english",
        "year": 2017,
        "header_desc": "",
        "play_count": 71325167,
        "explicit": false,
        "list": "",
        "list_type": "",
        "list_count": 0,
        "music": "",
        "artist_map": {
          "artists": [
            {
              "id": "578407",
              "name": "Ed Sheeran",
              "url":
                  "https://staging.jiosaavn.com/artist/ed-sheeran-songs/bWIDsVrU6DE_",
              "role": "Singer",
              "type": "artist",
              "image": [
                {
                  "quality": "50x50",
                  "link": "http://c.saavncdn.com/artists/Ed_Sheeran_50x50.jpg"
                },
                {
                  "quality": "150x150",
                  "link": "http://c.saavncdn.com/artists/Ed_Sheeran_150x150.jpg"
                },
                {
                  "quality": "500x500",
                  "link": "http://c.saavncdn.com/artists/Ed_Sheeran_500x500.jpg"
                }
              ]
            }
          ],
          "featured_artists": [],
          "primary_artists": [
            {
              "id": "578407",
              "name": "Ed Sheeran",
              "url":
                  "https://staging.jiosaavn.com/artist/ed-sheeran-songs/bWIDsVrU6DE_",
              "role": "Primary_artists",
              "type": "artist",
              "image": [
                {
                  "quality": "50x50",
                  "link": "http://c.saavncdn.com/artists/Ed_Sheeran_50x50.jpg"
                },
                {
                  "quality": "150x150",
                  "link": "http://c.saavncdn.com/artists/Ed_Sheeran_150x150.jpg"
                },
                {
                  "quality": "500x500",
                  "link": "http://c.saavncdn.com/artists/Ed_Sheeran_500x500.jpg"
                }
              ]
            }
          ]
        },
        "album": "÷",
        "album_id": "10436096",
        "album_url": "https://www.jiosaavn.com/album/%c3%b7/KelXOKU4pi4_",
        "label": "Atlantic Records UK",
        "label_url": "/label/atlantic-records-uk-albums/Nq1WxI8CVrI_",
        "origin": "playlist",
        "is_dolby_content": false,
        "320kbps": true,
        "download_url": [
          {
            "quality": "12kbps",
            "link":
                "https://aac.saavncdn.com/286/71bb6cc3391ddf619a4a3f1a1134f1c4_12.mp4"
          },
          {
            "quality": "48kbps",
            "link":
                "https://aac.saavncdn.com/286/71bb6cc3391ddf619a4a3f1a1134f1c4_48.mp4"
          },
          {
            "quality": "96kbps",
            "link":
                "https://aac.saavncdn.com/286/71bb6cc3391ddf619a4a3f1a1134f1c4_96.mp4"
          },
          {
            "quality": "160kbps",
            "link":
                "https://aac.saavncdn.com/286/71bb6cc3391ddf619a4a3f1a1134f1c4_160.mp4"
          },
          {
            "quality": "320kbps",
            "link":
                "https://aac.saavncdn.com/286/71bb6cc3391ddf619a4a3f1a1134f1c4_320.mp4"
          }
        ],
        "duration": 263,
        "rights": {
          "code": "0",
          "cacheable": "true",
          "delete_cached_object": "false",
          "reason": ""
        },
        "has_lyrics": false,
        "lyrics_snippet": "",
        "starred": false,
        "release_date": "2017-03-03",
        "triller_available": false,
        "copyright_text":
            "℗ 2017, Asylum Records UK, a division of Atlantic Records UK, a Warner Music Group company.",
        "vcode": "010910140683676",
        "vlink":
            "https://jiotunepreview.jio.com/content/Converted/010910140647552.mp3"
      },
      {
        "id": "t5e4VTsk",
        "name": "Unstoppable",
        "subtitle": "Sia - Unstoppable",
        "type": "song",
        "url": "https://www.jiosaavn.com/song/unstoppable/BF0OBSJkRFg",
        "image":
            "https://c.saavncdn.com/155/The-Platinum-Collection-English-2013-50x50.jpg",
        "language": "english",
        "year": 2016,
        "header_desc": "",
        "play_count": 47836820,
        "explicit": false,
        "list": "",
        "list_type": "",
        "list_count": 0,
        "music": "Sia Furler, Christopher Braide",
        "artist_map": {
          "artists": [
            {
              "id": "568164",
              "name": "Christopher Braide",
              "url":
                  "https://www.jiosaavn.com/artist/christopher-braide-songs/sfw1RUQUD4E_",
              "role": "Music, Lyricist",
              "type": "artist",
              "image": ""
            },
            {
              "id": "568707",
              "name": "Sia",
              "url": "https://www.jiosaavn.com/artist/sia-songs/C4hxFiXrHws_",
              "role": "Singer",
              "type": "artist",
              "image": [
                {
                  "quality": "50x50",
                  "link":
                      "https://c.saavncdn.com/artists/Sia_002_20200921152829_50x50.jpg"
                },
                {
                  "quality": "150x150",
                  "link":
                      "https://c.saavncdn.com/artists/Sia_002_20200921152829_150x150.jpg"
                },
                {
                  "quality": "500x500",
                  "link":
                      "https://c.saavncdn.com/artists/Sia_002_20200921152829_500x500.jpg"
                }
              ]
            },
            {
              "id": "1988757",
              "name": "Sia Furler",
              "url":
                  "https://www.jiosaavn.com/artist/sia-furler-songs/th8a5wwJBi8_",
              "role": "Music, Lyricist",
              "type": "artist",
              "image": ""
            }
          ],
          "featured_artists": [],
          "primary_artists": [
            {
              "id": "568707",
              "name": "Sia",
              "url": "https://www.jiosaavn.com/artist/sia-songs/C4hxFiXrHws_",
              "role": "Primary_artists",
              "type": "artist",
              "image": [
                {
                  "quality": "50x50",
                  "link":
                      "https://c.saavncdn.com/artists/Sia_002_20200921152829_50x50.jpg"
                },
                {
                  "quality": "150x150",
                  "link":
                      "https://c.saavncdn.com/artists/Sia_002_20200921152829_150x150.jpg"
                },
                {
                  "quality": "500x500",
                  "link":
                      "https://c.saavncdn.com/artists/Sia_002_20200921152829_500x500.jpg"
                }
              ]
            }
          ]
        },
        "album": "Unstoppable",
        "album_id": "1759517",
        "album_url": "https://www.jiosaavn.com/album/unstoppable/1Tm2aGl16CM_",
        "label": "Monkey Puzzle Records/RCA Records",
        "label_url":
            "/label/monkey-puzzle-recordsrca-records-albums/MKT34Ph9xHY_",
        "origin": "playlist",
        "is_dolby_content": false,
        "320kbps": true,
        "download_url": [
          {
            "quality": "12kbps",
            "link":
                "https://aac.saavncdn.com/552/26b33054461788c6282e4ac814d3769f_12.mp4"
          },
          {
            "quality": "48kbps",
            "link":
                "https://aac.saavncdn.com/552/26b33054461788c6282e4ac814d3769f_48.mp4"
          },
          {
            "quality": "96kbps",
            "link":
                "https://aac.saavncdn.com/552/26b33054461788c6282e4ac814d3769f_96.mp4"
          },
          {
            "quality": "160kbps",
            "link":
                "https://aac.saavncdn.com/552/26b33054461788c6282e4ac814d3769f_160.mp4"
          },
          {
            "quality": "320kbps",
            "link":
                "https://aac.saavncdn.com/552/26b33054461788c6282e4ac814d3769f_320.mp4"
          }
        ],
        "duration": 218,
        "rights": {
          "code": "0",
          "cacheable": "true",
          "delete_cached_object": "false",
          "reason": ""
        },
        "has_lyrics": false,
        "lyrics_snippet": "",
        "starred": false,
        "release_date": "2016-01-21",
        "triller_available": false,
        "copyright_text":
            "(P) 2015 Monkey Puzzle Records, under exclusive license to RCA Records",
        "vcode": "010910140266829",
        "vlink":
            "https://jiotunepreview.jio.com/content/Converted/010910140279460.mp3"
      },
      {
        "id": "icJam_5l",
        "name": "Shape of You",
        "subtitle": "Ed Sheeran - Shape of You",
        "type": "song",
        "url": "https://www.jiosaavn.com/song/shape-of-you/GQshUBlvAl8",
        "image":
            "https://c.saavncdn.com/155/The-Platinum-Collection-English-2013-50x50.jpg",
        "language": "english",
        "year": 2017,
        "header_desc": "",
        "play_count": 141664606,
        "explicit": false,
        "list": "",
        "list_type": "",
        "list_count": 0,
        "music": "",
        "artist_map": {
          "artists": [
            {
              "id": "578407",
              "name": "Ed Sheeran",
              "url":
                  "https://www.jiosaavn.com/artist/ed-sheeran-songs/bWIDsVrU6DE_",
              "role": "Singer",
              "type": "artist",
              "image": [
                {
                  "quality": "50x50",
                  "link": "http://c.saavncdn.com/artists/Ed_Sheeran_50x50.jpg"
                },
                {
                  "quality": "150x150",
                  "link": "http://c.saavncdn.com/artists/Ed_Sheeran_150x150.jpg"
                },
                {
                  "quality": "500x500",
                  "link": "http://c.saavncdn.com/artists/Ed_Sheeran_500x500.jpg"
                }
              ]
            }
          ],
          "featured_artists": [],
          "primary_artists": [
            {
              "id": "578407",
              "name": "Ed Sheeran",
              "url":
                  "https://www.jiosaavn.com/artist/ed-sheeran-songs/bWIDsVrU6DE_",
              "role": "Primary_artists",
              "type": "artist",
              "image": [
                {
                  "quality": "50x50",
                  "link": "http://c.saavncdn.com/artists/Ed_Sheeran_50x50.jpg"
                },
                {
                  "quality": "150x150",
                  "link": "http://c.saavncdn.com/artists/Ed_Sheeran_150x150.jpg"
                },
                {
                  "quality": "500x500",
                  "link": "http://c.saavncdn.com/artists/Ed_Sheeran_500x500.jpg"
                }
              ]
            }
          ]
        },
        "album": "Shape of You",
        "album_id": "3320300",
        "album_url": "https://www.jiosaavn.com/album/shape-of-you/LYFPGAzSOik_",
        "label": "Atlantic Records UK",
        "label_url": "/label/atlantic-records-uk-albums/Nq1WxI8CVrI_",
        "origin": "playlist",
        "is_dolby_content": false,
        "320kbps": true,
        "download_url": [
          {
            "quality": "12kbps",
            "link":
                "https://aac.saavncdn.com/126/da7cde34b008294e181842062530546d_12.mp4"
          },
          {
            "quality": "48kbps",
            "link":
                "https://aac.saavncdn.com/126/da7cde34b008294e181842062530546d_48.mp4"
          },
          {
            "quality": "96kbps",
            "link":
                "https://aac.saavncdn.com/126/da7cde34b008294e181842062530546d_96.mp4"
          },
          {
            "quality": "160kbps",
            "link":
                "https://aac.saavncdn.com/126/da7cde34b008294e181842062530546d_160.mp4"
          },
          {
            "quality": "320kbps",
            "link":
                "https://aac.saavncdn.com/126/da7cde34b008294e181842062530546d_320.mp4"
          }
        ],
        "duration": 233,
        "rights": {
          "code": "0",
          "cacheable": "true",
          "delete_cached_object": "false",
          "reason": ""
        },
        "has_lyrics": false,
        "lyrics_snippet": "",
        "starred": false,
        "release_date": "2017-01-06",
        "triller_available": false,
        "copyright_text":
            "℗ 2017, Asylum Records UK, a division of Atlantic Records UK, a Warner Music Group company.",
        "vcode": "010912582132946",
        "vlink":
            "https://jiotunepreview.jio.com/content/Converted/010912582089482.mp3"
      },
      {
        "id": "hp1oULSo",
        "name": "Summertime Sadness",
        "subtitle": "Lana Del Rey - Born To Die - The Paradise Edition",
        "type": "song",
        "url": "https://www.jiosaavn.com/song/summertime-sadness/GBhaXiF8ZFw",
        "image":
            "https://c.saavncdn.com/155/The-Platinum-Collection-English-2013-50x50.jpg",
        "language": "english",
        "year": 2012,
        "header_desc": "",
        "play_count": 4722512,
        "explicit": true,
        "list": "",
        "list_type": "",
        "list_count": 0,
        "music": "Rick Nowels, Elizabeth Grant",
        "artist_map": {
          "artists": [
            {
              "id": "522358",
              "name": "Rick Nowels",
              "url":
                  "https://www.jiosaavn.com/artist/rick-nowels-songs/jmDFKEpDXgg_",
              "role": "Music, Lyricist",
              "type": "artist",
              "image": ""
            },
            {
              "id": "601595",
              "name": "Lana Del Rey",
              "url":
                  "https://www.jiosaavn.com/artist/lana-del-rey-songs/t9kCeOt4Jao_",
              "role": "Singer",
              "type": "artist",
              "image": [
                {
                  "quality": "50x50",
                  "link":
                      "https://c.saavncdn.com/artists/Lana_Del_Rey_002_20201127112356_50x50.jpg"
                },
                {
                  "quality": "150x150",
                  "link":
                      "https://c.saavncdn.com/artists/Lana_Del_Rey_002_20201127112356_150x150.jpg"
                },
                {
                  "quality": "500x500",
                  "link":
                      "https://c.saavncdn.com/artists/Lana_Del_Rey_002_20201127112356_500x500.jpg"
                }
              ]
            },
            {
              "id": "601596",
              "name": "Elizabeth Grant",
              "url":
                  "https://www.jiosaavn.com/artist/elizabeth-grant-songs/ovuHIeXGzhg_",
              "role": "Music, Lyricist",
              "type": "artist",
              "image": ""
            }
          ],
          "featured_artists": [],
          "primary_artists": [
            {
              "id": "601595",
              "name": "Lana Del Rey",
              "url":
                  "https://www.jiosaavn.com/artist/lana-del-rey-songs/t9kCeOt4Jao_",
              "role": "Primary_artists",
              "type": "artist",
              "image": [
                {
                  "quality": "50x50",
                  "link":
                      "https://c.saavncdn.com/artists/Lana_Del_Rey_002_20201127112356_50x50.jpg"
                },
                {
                  "quality": "150x150",
                  "link":
                      "https://c.saavncdn.com/artists/Lana_Del_Rey_002_20201127112356_150x150.jpg"
                },
                {
                  "quality": "500x500",
                  "link":
                      "https://c.saavncdn.com/artists/Lana_Del_Rey_002_20201127112356_500x500.jpg"
                }
              ]
            }
          ]
        },
        "album": "Born To Die - The Paradise Edition",
        "album_id": "1111201",
        "album_url":
            "https://www.jiosaavn.com/album/born-to-die-the-paradise-edition/caDjUVpGXcc_",
        "label": "Polydor Records",
        "label_url": "/label/polydor-records-albums/CbDxnnVlPIA_",
        "origin": "playlist",
        "is_dolby_content": false,
        "320kbps": true,
        "download_url": [
          {
            "quality": "12kbps",
            "link":
                "https://aac.saavncdn.com/970/4763bedd263706f943b94ba59d2e3feb_12.mp4"
          },
          {
            "quality": "48kbps",
            "link":
                "https://aac.saavncdn.com/970/4763bedd263706f943b94ba59d2e3feb_48.mp4"
          },
          {
            "quality": "96kbps",
            "link":
                "https://aac.saavncdn.com/970/4763bedd263706f943b94ba59d2e3feb_96.mp4"
          },
          {
            "quality": "160kbps",
            "link":
                "https://aac.saavncdn.com/970/4763bedd263706f943b94ba59d2e3feb_160.mp4"
          },
          {
            "quality": "320kbps",
            "link":
                "https://aac.saavncdn.com/970/4763bedd263706f943b94ba59d2e3feb_320.mp4"
          }
        ],
        "duration": 265,
        "rights": {
          "code": "0",
          "cacheable": "true",
          "delete_cached_object": "false",
          "reason": ""
        },
        "has_lyrics": false,
        "lyrics_snippet": "",
        "starred": false,
        "release_date": "2012-01-01",
        "triller_available": false,
        "copyright_text":
            "℗ 2012 Lana Del Rey, under exclusive licence to Polydor Ltd. (UK). Under exclusive licence to Interscope Records in the USA",
        "vcode": "010912292132493",
        "vlink":
            "https://jiotunepreview.jio.com/content/Converted/010912292088927.mp3"
      },
      {
        "id": "4RmwbCw4",
        "name": "Cheap Thrills",
        "subtitle": "Sia - Cheap Thrills",
        "type": "song",
        "url": "https://www.jiosaavn.com/song/cheap-thrills/RDoGRhZzQAc",
        "image":
            "https://c.saavncdn.com/155/The-Platinum-Collection-English-2013-50x50.jpg",
        "language": "english",
        "year": 2015,
        "header_desc": "",
        "play_count": 113446588,
        "explicit": false,
        "list": "",
        "list_type": "",
        "list_count": 0,
        "music": "Sia Furler, Greg Kurstin",
        "artist_map": {
          "artists": [
            {
              "id": "566183",
              "name": "Greg Kurstin",
              "url":
                  "https://www.jiosaavn.com/artist/greg-kurstin-songs/KfmpE496lLA_",
              "role": "Music, Lyricist",
              "type": "artist",
              "image": [
                {
                  "quality": "50x50",
                  "link":
                      "https://c.saavncdn.com/823/Pocketful-Of-Sunshine-2008-50x50.jpg"
                },
                {
                  "quality": "150x150",
                  "link":
                      "https://c.saavncdn.com/823/Pocketful-Of-Sunshine-2008-150x150.jpg"
                },
                {
                  "quality": "500x500",
                  "link":
                      "https://c.saavncdn.com/823/Pocketful-Of-Sunshine-2008-500x500.jpg"
                }
              ]
            },
            {
              "id": "568707",
              "name": "Sia",
              "url": "https://www.jiosaavn.com/artist/sia-songs/C4hxFiXrHws_",
              "role": "Singer",
              "type": "artist",
              "image": [
                {
                  "quality": "50x50",
                  "link":
                      "https://c.saavncdn.com/artists/Sia_002_20200921152829_50x50.jpg"
                },
                {
                  "quality": "150x150",
                  "link":
                      "https://c.saavncdn.com/artists/Sia_002_20200921152829_150x150.jpg"
                },
                {
                  "quality": "500x500",
                  "link":
                      "https://c.saavncdn.com/artists/Sia_002_20200921152829_500x500.jpg"
                }
              ]
            },
            {
              "id": "1988757",
              "name": "Sia Furler",
              "url":
                  "https://www.jiosaavn.com/artist/sia-furler-songs/th8a5wwJBi8_",
              "role": "Music, Lyricist",
              "type": "artist",
              "image": ""
            }
          ],
          "featured_artists": [],
          "primary_artists": [
            {
              "id": "568707",
              "name": "Sia",
              "url": "https://www.jiosaavn.com/artist/sia-songs/C4hxFiXrHws_",
              "role": "Primary_artists",
              "type": "artist",
              "image": [
                {
                  "quality": "50x50",
                  "link":
                      "https://c.saavncdn.com/artists/Sia_002_20200921152829_50x50.jpg"
                },
                {
                  "quality": "150x150",
                  "link":
                      "https://c.saavncdn.com/artists/Sia_002_20200921152829_150x150.jpg"
                },
                {
                  "quality": "500x500",
                  "link":
                      "https://c.saavncdn.com/artists/Sia_002_20200921152829_500x500.jpg"
                }
              ]
            }
          ]
        },
        "album": "Cheap Thrills",
        "album_id": "1744101",
        "album_url":
            "https://www.jiosaavn.com/album/cheap-thrills/d-w-VzXfYCU_",
        "label": "Monkey Puzzle Records/RCA Records",
        "label_url":
            "/label/monkey-puzzle-recordsrca-records-albums/MKT34Ph9xHY_",
        "origin": "playlist",
        "is_dolby_content": false,
        "320kbps": true,
        "download_url": [
          {
            "quality": "12kbps",
            "link":
                "https://aac.saavncdn.com/722/7f3218eb23ec7273f73d5317e5083d7e_12.mp4"
          },
          {
            "quality": "48kbps",
            "link":
                "https://aac.saavncdn.com/722/7f3218eb23ec7273f73d5317e5083d7e_48.mp4"
          },
          {
            "quality": "96kbps",
            "link":
                "https://aac.saavncdn.com/722/7f3218eb23ec7273f73d5317e5083d7e_96.mp4"
          },
          {
            "quality": "160kbps",
            "link":
                "https://aac.saavncdn.com/722/7f3218eb23ec7273f73d5317e5083d7e_160.mp4"
          },
          {
            "quality": "320kbps",
            "link":
                "https://aac.saavncdn.com/722/7f3218eb23ec7273f73d5317e5083d7e_320.mp4"
          }
        ],
        "duration": 210,
        "rights": {
          "code": "0",
          "cacheable": "true",
          "delete_cached_object": "false",
          "reason": ""
        },
        "has_lyrics": false,
        "lyrics_snippet": "",
        "starred": false,
        "release_date": "2015-12-17",
        "triller_available": false,
        "copyright_text":
            "(P) 2015 Monkey Puzzle Records, under exclusive license to RCA Records",
        "vcode": "010910140238455",
        "vlink":
            "https://jiotunepreview.jio.com/content/Converted/010910140251099.mp3"
      },
      {
        "id": "HtWvQ-bx",
        "name": "Dandelions",
        "subtitle": "Ruth B. - Dandelions",
        "type": "song",
        "url": "https://www.jiosaavn.com/song/dandelions/OBw8RyUdVUs",
        "image":
            "https://c.saavncdn.com/155/The-Platinum-Collection-English-2013-50x50.jpg",
        "language": "english",
        "year": 2017,
        "header_desc": "",
        "play_count": 14880832,
        "explicit": false,
        "list": "",
        "list_type": "",
        "list_count": 0,
        "music": "Ruth Berhe",
        "artist_map": {
          "artists": [
            {
              "id": "1312475",
              "name": "Ruth Berhe",
              "url":
                  "https://www.jiosaavn.com/artist/ruth-berhe-songs/fyMiyUCO3KQ_",
              "role": "Music, Lyricist",
              "type": "artist",
              "image": ""
            },
            {
              "id": "1892029",
              "name": "Ruth B.",
              "url":
                  "https://www.jiosaavn.com/artist/ruth-b.-songs/nO02r5ZHlGo_",
              "role": "Singer",
              "type": "artist",
              "image": [
                {
                  "quality": "50x50",
                  "link":
                      "http://c.saavncdn.com/artists/Ruth_B__000_20230829070409_50x50.jpg"
                },
                {
                  "quality": "150x150",
                  "link":
                      "http://c.saavncdn.com/artists/Ruth_B__000_20230829070409_150x150.jpg"
                },
                {
                  "quality": "500x500",
                  "link":
                      "http://c.saavncdn.com/artists/Ruth_B__000_20230829070409_500x500.jpg"
                }
              ]
            }
          ],
          "featured_artists": [],
          "primary_artists": [
            {
              "id": "1892029",
              "name": "Ruth B.",
              "url":
                  "https://www.jiosaavn.com/artist/ruth-b.-songs/nO02r5ZHlGo_",
              "role": "Primary_artists",
              "type": "artist",
              "image": [
                {
                  "quality": "50x50",
                  "link":
                      "http://c.saavncdn.com/artists/Ruth_B__000_20230829070409_50x50.jpg"
                },
                {
                  "quality": "150x150",
                  "link":
                      "http://c.saavncdn.com/artists/Ruth_B__000_20230829070409_150x150.jpg"
                },
                {
                  "quality": "500x500",
                  "link":
                      "http://c.saavncdn.com/artists/Ruth_B__000_20230829070409_500x500.jpg"
                }
              ]
            }
          ]
        },
        "album": "Dandelions",
        "album_id": "10663733",
        "album_url": "https://www.jiosaavn.com/album/dandelions/bGHRxBdMT2E_",
        "label": "Columbia",
        "label_url": "/label/columbia-albums/wMrKglyRi74_",
        "origin": "playlist",
        "is_dolby_content": false,
        "320kbps": true,
        "download_url": [
          {
            "quality": "12kbps",
            "link":
                "https://aac.saavncdn.com/400/8cc5771338db2fa8cc57545aa68777dc_12.mp4"
          },
          {
            "quality": "48kbps",
            "link":
                "https://aac.saavncdn.com/400/8cc5771338db2fa8cc57545aa68777dc_48.mp4"
          },
          {
            "quality": "96kbps",
            "link":
                "https://aac.saavncdn.com/400/8cc5771338db2fa8cc57545aa68777dc_96.mp4"
          },
          {
            "quality": "160kbps",
            "link":
                "https://aac.saavncdn.com/400/8cc5771338db2fa8cc57545aa68777dc_160.mp4"
          },
          {
            "quality": "320kbps",
            "link":
                "https://aac.saavncdn.com/400/8cc5771338db2fa8cc57545aa68777dc_320.mp4"
          }
        ],
        "duration": 233,
        "rights": {
          "code": "0",
          "cacheable": "true",
          "delete_cached_object": "false",
          "reason": ""
        },
        "has_lyrics": false,
        "lyrics_snippet": "",
        "starred": false,
        "release_date": "2017-04-28",
        "triller_available": false,
        "copyright_text":
            "(P) 2017 Columbia Records, a Division of Sony Music Entertainment",
        "vcode": "010910140727208",
        "vlink":
            "https://jiotunepreview.jio.com/content/Converted/010910140684350.mp3"
      },
      {
        "id": "3IoDK8qI",
        "name": "Levitating",
        "subtitle": "Dua Lipa - Future Nostalgia",
        "type": "song",
        "url": "https://www.jiosaavn.com/song/levitating/QyEEdT8IRno",
        "image":
            "https://c.saavncdn.com/155/The-Platinum-Collection-English-2013-50x50.jpg",
        "language": "english",
        "year": 2020,
        "header_desc": "",
        "play_count": 10131004,
        "explicit": true,
        "list": "",
        "list_type": "",
        "list_count": 0,
        "music":
            "Clarence Coffee Jr, Dua Lipa, Sarah Hudson, Stephen Kozmeniuk",
        "artist_map": {
          "artists": [
            {
              "id": "573802",
              "name": "Clarence Coffee Jr",
              "url":
                  "https://www.jiosaavn.com/artist/clarence-coffee-jr-songs/2mX96rBxCYU_",
              "role": "Music",
              "type": "artist",
              "image": ""
            },
            {
              "id": "599533",
              "name": "Stephen Kozmeniuk",
              "url":
                  "https://www.jiosaavn.com/artist/stephen-kozmeniuk-songs/lS1-2YuC5oc_",
              "role": "Music",
              "type": "artist",
              "image": ""
            },
            {
              "id": "702498",
              "name": "Sarah Hudson",
              "url":
                  "https://www.jiosaavn.com/artist/sarah-hudson-songs/pW4Y,NKAPPI_",
              "role": "Music",
              "type": "artist",
              "image": [
                {
                  "quality": "50x50",
                  "link":
                      "https://c.saavncdn.com/587/Gypsy-Girl-A-Cappella--English-2017-20191123100913-50x50.jpg"
                },
                {
                  "quality": "150x150",
                  "link":
                      "https://c.saavncdn.com/587/Gypsy-Girl-A-Cappella--English-2017-20191123100913-150x150.jpg"
                },
                {
                  "quality": "500x500",
                  "link":
                      "https://c.saavncdn.com/587/Gypsy-Girl-A-Cappella--English-2017-20191123100913-500x500.jpg"
                }
              ]
            },
            {
              "id": "1274170",
              "name": "Dua Lipa",
              "url":
                  "https://www.jiosaavn.com/artist/dua-lipa-songs/r-OWIKgpX2I_",
              "role": "Music, Singer",
              "type": "artist",
              "image": [
                {
                  "quality": "50x50",
                  "link":
                      "https://c.saavncdn.com/artists/Dua_Lipa_004_20231120090922_50x50.jpg"
                },
                {
                  "quality": "150x150",
                  "link":
                      "https://c.saavncdn.com/artists/Dua_Lipa_004_20231120090922_150x150.jpg"
                },
                {
                  "quality": "500x500",
                  "link":
                      "https://c.saavncdn.com/artists/Dua_Lipa_004_20231120090922_500x500.jpg"
                }
              ]
            }
          ],
          "featured_artists": [],
          "primary_artists": [
            {
              "id": "1274170",
              "name": "Dua Lipa",
              "url":
                  "https://www.jiosaavn.com/artist/dua-lipa-songs/r-OWIKgpX2I_",
              "role": "Primary_artists",
              "type": "artist",
              "image": [
                {
                  "quality": "50x50",
                  "link":
                      "https://c.saavncdn.com/artists/Dua_Lipa_004_20231120090922_50x50.jpg"
                },
                {
                  "quality": "150x150",
                  "link":
                      "https://c.saavncdn.com/artists/Dua_Lipa_004_20231120090922_150x150.jpg"
                },
                {
                  "quality": "500x500",
                  "link":
                      "https://c.saavncdn.com/artists/Dua_Lipa_004_20231120090922_500x500.jpg"
                }
              ]
            }
          ]
        },
        "album": "Future Nostalgia",
        "album_id": "23241654",
        "album_url":
            "https://www.jiosaavn.com/album/future-nostalgia/ITIyo-GDr7A_",
        "label": "Warner Records",
        "label_url": "/label/warner-records-albums/8FBCbUPZpYc_",
        "origin": "playlist",
        "is_dolby_content": false,
        "320kbps": true,
        "download_url": [
          {
            "quality": "12kbps",
            "link":
                "https://aac.saavncdn.com/665/7790c3b9097592113008eaf1031d6e57_12.mp4"
          },
          {
            "quality": "48kbps",
            "link":
                "https://aac.saavncdn.com/665/7790c3b9097592113008eaf1031d6e57_48.mp4"
          },
          {
            "quality": "96kbps",
            "link":
                "https://aac.saavncdn.com/665/7790c3b9097592113008eaf1031d6e57_96.mp4"
          },
          {
            "quality": "160kbps",
            "link":
                "https://aac.saavncdn.com/665/7790c3b9097592113008eaf1031d6e57_160.mp4"
          },
          {
            "quality": "320kbps",
            "link":
                "https://aac.saavncdn.com/665/7790c3b9097592113008eaf1031d6e57_320.mp4"
          }
        ],
        "duration": 203,
        "rights": {
          "code": "0",
          "cacheable": "true",
          "delete_cached_object": "false",
          "reason": ""
        },
        "has_lyrics": false,
        "lyrics_snippet": "",
        "starred": false,
        "release_date": "2020-03-27",
        "triller_available": false,
        "copyright_text":
            "℗ 2020  Dua Lipa Limited under exclusive license to Warner Records UK, a division of Warner Music UK Limited",
        "vcode": "010912582260286",
        "vlink":
            "https://jiotunepreview.jio.com/content/Converted/010912582216415.mp3"
      },
    ],
    "subtitle_desc": ["2h 54m", "50 Songs", "70,351 Fans"],
    "modules": {
      "related_playlist": {
        "title": "Related Playlist",
        "subtitle": "",
        "source": "/playlist/recommend",
        "position": 2,
        "params": {"id": "1134595537"}
      },
      "currently_trending_playlists": {
        "title": "Currently Trending Playlists",
        "subtitle": "",
        "source": "/get/trending",
        "position": 3,
        "params": {"type": "playlist", "lang": "english"}
      },
      "artists": {
        "title": "Artists",
        "subtitle": "",
        "source": "artists",
        "position": 4
      }
    }
  };

  static const Map<String, dynamic> HomePageloadingData = {
    "trending": {
      "title": "Trending Now",
      "subtitle": "",
      "position": 1,
      "source": "/get/trending",
      "featured_text": "",
      "data": [
        {
          "id": "54799556",
          "name": "V. Ravichandran Crazy Collections",
          "subtitle": "S.P. Balasubrahmanyam",
          "type": "album",
          "language": "kannada",
          "play_count": 0,
          "duration": 0,
          "explicit": false,
          "year": 0,
          "url":
              "https://www.jiosaavn.com/album/v.-ravichandran-crazy-collections/7ilxd6Nf248_",
          "header_desc": "",
          "list_count": 0,
          "list_type": "",
          "image":
              "https://c.saavncdn.com/071/V-Ravichandran-Crazy-Collections-Kannada-2024-20240530151329-50x50.jpg?bch=477101",
          "artist_map": {
            "artists": [
              {
                "id": "741999",
                "name": "S.P. Balasubrahmanyam",
                "url":
                    "https://www.jiosaavn.com/artist/s.p.-balasubrahmanyam-songs/Ix5AC5h7LSg_",
                "role": "",
                "type": "artist",
                "image":
                    "https://c.saavncdn.com/artists/S_P_Balasubrahmanyam_50x50.jpg"
              }
            ],
            "featured_artists": [],
            "primary_artists": []
          },
          "song_count": 15,
          "songs": []
        },
        {
          "id": "54799556",
          "name": "V. Ravichandran Crazy Collections",
          "subtitle": "S.P. Balasubrahmanyam",
          "type": "album",
          "language": "kannada",
          "play_count": 0,
          "duration": 0,
          "explicit": false,
          "year": 0,
          "url":
              "https://www.jiosaavn.com/album/v.-ravichandran-crazy-collections/7ilxd6Nf248_",
          "header_desc": "",
          "list_count": 0,
          "list_type": "",
          "image":
              "https://c.saavncdn.com/071/V-Ravichandran-Crazy-Collections-Kannada-2024-20240530151329-50x50.jpg?bch=477101",
          "artist_map": {
            "artists": [
              {
                "id": "741999",
                "name": "S.P. Balasubrahmanyam",
                "url":
                    "https://www.jiosaavn.com/artist/s.p.-balasubrahmanyam-songs/Ix5AC5h7LSg_",
                "role": "",
                "type": "artist",
                "image":
                    "https://c.saavncdn.com/artists/S_P_Balasubrahmanyam_50x50.jpg"
              }
            ],
            "featured_artists": [],
            "primary_artists": []
          },
          "song_count": 15,
          "songs": []
        },
        {
          "id": "54799556",
          "name": "V. Ravichandran Crazy Collections",
          "subtitle": "S.P. Balasubrahmanyam",
          "type": "album",
          "language": "kannada",
          "play_count": 0,
          "duration": 0,
          "explicit": false,
          "year": 0,
          "url":
              "https://www.jiosaavn.com/album/v.-ravichandran-crazy-collections/7ilxd6Nf248_",
          "header_desc": "",
          "list_count": 0,
          "list_type": "",
          "image":
              "https://c.saavncdn.com/071/V-Ravichandran-Crazy-Collections-Kannada-2024-20240530151329-50x50.jpg?bch=477101",
          "artist_map": {
            "artists": [
              {
                "id": "741999",
                "name": "S.P. Balasubrahmanyam",
                "url":
                    "https://www.jiosaavn.com/artist/s.p.-balasubrahmanyam-songs/Ix5AC5h7LSg_",
                "role": "",
                "type": "artist",
                "image":
                    "https://c.saavncdn.com/artists/S_P_Balasubrahmanyam_50x50.jpg"
              }
            ],
            "featured_artists": [],
            "primary_artists": []
          },
          "song_count": 15,
          "songs": []
        },
        {
          "id": "54799556",
          "name": "V. Ravichandran Crazy Collections",
          "subtitle": "S.P. Balasubrahmanyam",
          "type": "album",
          "language": "kannada",
          "play_count": 0,
          "duration": 0,
          "explicit": false,
          "year": 0,
          "url":
              "https://www.jiosaavn.com/album/v.-ravichandran-crazy-collections/7ilxd6Nf248_",
          "header_desc": "",
          "list_count": 0,
          "list_type": "",
          "image":
              "https://c.saavncdn.com/071/V-Ravichandran-Crazy-Collections-Kannada-2024-20240530151329-50x50.jpg?bch=477101",
          "artist_map": {
            "artists": [
              {
                "id": "741999",
                "name": "S.P. Balasubrahmanyam",
                "url":
                    "https://www.jiosaavn.com/artist/s.p.-balasubrahmanyam-songs/Ix5AC5h7LSg_",
                "role": "",
                "type": "artist",
                "image":
                    "https://c.saavncdn.com/artists/S_P_Balasubrahmanyam_50x50.jpg"
              }
            ],
            "featured_artists": [],
            "primary_artists": []
          },
          "song_count": 15,
          "songs": []
        },
        {
          "id": "54799556",
          "name": "V. Ravichandran Crazy Collections",
          "subtitle": "S.P. Balasubrahmanyam",
          "type": "album",
          "language": "kannada",
          "play_count": 0,
          "duration": 0,
          "explicit": false,
          "year": 0,
          "url":
              "https://www.jiosaavn.com/album/v.-ravichandran-crazy-collections/7ilxd6Nf248_",
          "header_desc": "",
          "list_count": 0,
          "list_type": "",
          "image":
              "https://c.saavncdn.com/071/V-Ravichandran-Crazy-Collections-Kannada-2024-20240530151329-50x50.jpg?bch=477101",
          "artist_map": {
            "artists": [
              {
                "id": "741999",
                "name": "S.P. Balasubrahmanyam",
                "url":
                    "https://www.jiosaavn.com/artist/s.p.-balasubrahmanyam-songs/Ix5AC5h7LSg_",
                "role": "",
                "type": "artist",
                "image":
                    "https://c.saavncdn.com/artists/S_P_Balasubrahmanyam_50x50.jpg"
              }
            ],
            "featured_artists": [],
            "primary_artists": []
          },
          "song_count": 15,
          "songs": []
        },
      ]
    },
    "charts": {
      "title": "Top Charts",
      "subtitle": "",
      "position": 2,
      "source": "/get/charts",
      "featured_text": "The top movers this week, from our editors.",
      "data": [
        {
          "id": "1134548194",
          "name": "India Superhits Top 50",
          "subtitle": "",
          "type": "playlist",
          "url":
              "https://www.jiosaavn.com/featured/india-superhits-top-50/VuJUPQ9ch77bB,U5Yp5iAA__",
          "explicit": false,
          "image":
              "https://c.saavncdn.com/editorial/IndiaSuperhitsTop50_20240524035434.jpg",
          "first_name": "JioSaavn",
          "count": 50
        },
        {
          "id": "110858205",
          "name": "Trending Today",
          "subtitle": "JioSaavn",
          "type": "playlist",
          "url":
              "https://www.jiosaavn.com/featured/trending-today/I3kvhipIy73uCJW60TJk1Q__",
          "explicit": false,
          "image":
              "https://c.saavncdn.com/editorial/charts_TrendingToday_134351_20230826113717.jpg",
          "first_name": "JioSaavn",
          "language": "kannada"
        },
        {
          "id": "845149976",
          "name": "Romantic Top 40 - Kannada",
          "subtitle": "JioSaavn",
          "type": "playlist",
          "url":
              "https://www.jiosaavn.com/featured/romantic-top-40-kannada/eM6m7c9EezbfemJ68FuXsA__",
          "explicit": false,
          "image":
              "https://c.saavncdn.com/editorial/charts_RomanticTop40-Kannada_178758_20220311175403.jpg",
          "first_name": "JioSaavn",
          "language": "kannada"
        },
        {
          "id": "1170578921",
          "name": "Kannada 2010s",
          "subtitle": "JioSaavn",
          "type": "playlist",
          "url":
              "https://www.jiosaavn.com/featured/kannada-2010s/rWnmDnVVdyNm4zJandeM4A__",
          "explicit": false,
          "image":
              "https://c.saavncdn.com/editorial/charts_Kannada2010s_181223_20240408062005.jpg",
          "first_name": "JioSaavn",
          "language": "kannada"
        },
        {
          "id": "901538806",
          "name": "Kannada 1960s",
          "subtitle": "JioSaavn",
          "type": "playlist",
          "url":
              "https://www.jiosaavn.com/featured/kannada-1960s/2FMOcHaLvdHfemJ68FuXsA__",
          "explicit": false,
          "image":
              "https://c.saavncdn.com/editorial/charts_Kannada1960s_20240509085123.jpg",
          "first_name": "JioSaavn",
          "language": "kannada"
        },
      ]
    },
    "albums": {
      "title": "New Releases",
      "subtitle": "",
      "position": 3,
      "source": "/get/albums",
      "featured_text": "",
      "data": [
        {
          "id": "54729129",
          "name": "Nodoka (From \"Pushpa 2 The Rule\")",
          "subtitle":
              "Shreya Ghoshal, Devi Sri Prasad, VARADARAJ CHIKKABALLAPURA, VARADARAJ CHIKKABALLAPURA, Devi Sri Prasad, Shreya Ghoshal, Devi Sri Prasad, VARADARAJ CHIKKABALLAPURA",
          "type": "album",
          "language": "kannada",
          "play_count": 0,
          "duration": 0,
          "explicit": false,
          "year": 0,
          "url":
              "https://www.jiosaavn.com/album/nodoka-from-pushpa-2-the-rule/6zdSnKDyksU_",
          "header_desc": "",
          "list_count": 0,
          "list_type": "",
          "image":
              "https://c.saavncdn.com/610/Nodoka-From-Pushpa-2-The-Rule-Kannada-2024-20240528221012-50x50.jpg",
          "artist_map": {
            "artists": [
              {
                "id": "455130",
                "name": "Shreya Ghoshal",
                "url":
                    "https://www.jiosaavn.com/artist/shreya-ghoshal-songs/lIHlwHaxTZ0_",
                "role": "Music, Music",
                "type": "artist",
                "image": ""
              },
              {
                "id": "455170",
                "name": "Devi Sri Prasad",
                "url":
                    "https://www.jiosaavn.com/artist/devi-sri-prasad-songs/M0dlT,PMjDs_",
                "role": "Music, Music, Music",
                "type": "artist",
                "image": ""
              },
              {
                "id": "9913852",
                "name": "VARADARAJ CHIKKABALLAPURA",
                "url":
                    "https://www.jiosaavn.com/artist/varadaraj-chikkaballapura-songs/i7VDseoEV8w_",
                "role": "Music, Music, Music",
                "type": "artist",
                "image": ""
              }
            ],
            "featured_artists": [],
            "primary_artists": []
          },
          "song_count": 0,
          "songs": []
        },
        {
          "id": "54729129",
          "name": "Nodoka (From \"Pushpa 2 The Rule\")",
          "subtitle":
              "Shreya Ghoshal, Devi Sri Prasad, VARADARAJ CHIKKABALLAPURA, VARADARAJ CHIKKABALLAPURA, Devi Sri Prasad, Shreya Ghoshal, Devi Sri Prasad, VARADARAJ CHIKKABALLAPURA",
          "type": "album",
          "language": "kannada",
          "play_count": 0,
          "duration": 0,
          "explicit": false,
          "year": 0,
          "url":
              "https://www.jiosaavn.com/album/nodoka-from-pushpa-2-the-rule/6zdSnKDyksU_",
          "header_desc": "",
          "list_count": 0,
          "list_type": "",
          "image":
              "https://c.saavncdn.com/610/Nodoka-From-Pushpa-2-The-Rule-Kannada-2024-20240528221012-50x50.jpg",
          "artist_map": {
            "artists": [
              {
                "id": "455130",
                "name": "Shreya Ghoshal",
                "url":
                    "https://www.jiosaavn.com/artist/shreya-ghoshal-songs/lIHlwHaxTZ0_",
                "role": "Music, Music",
                "type": "artist",
                "image": ""
              },
              {
                "id": "455170",
                "name": "Devi Sri Prasad",
                "url":
                    "https://www.jiosaavn.com/artist/devi-sri-prasad-songs/M0dlT,PMjDs_",
                "role": "Music, Music, Music",
                "type": "artist",
                "image": ""
              },
              {
                "id": "9913852",
                "name": "VARADARAJ CHIKKABALLAPURA",
                "url":
                    "https://www.jiosaavn.com/artist/varadaraj-chikkaballapura-songs/i7VDseoEV8w_",
                "role": "Music, Music, Music",
                "type": "artist",
                "image": ""
              }
            ],
            "featured_artists": [],
            "primary_artists": []
          },
          "song_count": 0,
          "songs": []
        },
        {
          "id": "54729129",
          "name": "Nodoka (From \"Pushpa 2 The Rule\")",
          "subtitle":
              "Shreya Ghoshal, Devi Sri Prasad, VARADARAJ CHIKKABALLAPURA, VARADARAJ CHIKKABALLAPURA, Devi Sri Prasad, Shreya Ghoshal, Devi Sri Prasad, VARADARAJ CHIKKABALLAPURA",
          "type": "album",
          "language": "kannada",
          "play_count": 0,
          "duration": 0,
          "explicit": false,
          "year": 0,
          "url":
              "https://www.jiosaavn.com/album/nodoka-from-pushpa-2-the-rule/6zdSnKDyksU_",
          "header_desc": "",
          "list_count": 0,
          "list_type": "",
          "image":
              "https://c.saavncdn.com/610/Nodoka-From-Pushpa-2-The-Rule-Kannada-2024-20240528221012-50x50.jpg",
          "artist_map": {
            "artists": [
              {
                "id": "455130",
                "name": "Shreya Ghoshal",
                "url":
                    "https://www.jiosaavn.com/artist/shreya-ghoshal-songs/lIHlwHaxTZ0_",
                "role": "Music, Music",
                "type": "artist",
                "image": ""
              },
              {
                "id": "455170",
                "name": "Devi Sri Prasad",
                "url":
                    "https://www.jiosaavn.com/artist/devi-sri-prasad-songs/M0dlT,PMjDs_",
                "role": "Music, Music, Music",
                "type": "artist",
                "image": ""
              },
              {
                "id": "9913852",
                "name": "VARADARAJ CHIKKABALLAPURA",
                "url":
                    "https://www.jiosaavn.com/artist/varadaraj-chikkaballapura-songs/i7VDseoEV8w_",
                "role": "Music, Music, Music",
                "type": "artist",
                "image": ""
              }
            ],
            "featured_artists": [],
            "primary_artists": []
          },
          "song_count": 0,
          "songs": []
        },
        {
          "id": "54729129",
          "name": "Nodoka (From \"Pushpa 2 The Rule\")",
          "subtitle":
              "Shreya Ghoshal, Devi Sri Prasad, VARADARAJ CHIKKABALLAPURA, VARADARAJ CHIKKABALLAPURA, Devi Sri Prasad, Shreya Ghoshal, Devi Sri Prasad, VARADARAJ CHIKKABALLAPURA",
          "type": "album",
          "language": "kannada",
          "play_count": 0,
          "duration": 0,
          "explicit": false,
          "year": 0,
          "url":
              "https://www.jiosaavn.com/album/nodoka-from-pushpa-2-the-rule/6zdSnKDyksU_",
          "header_desc": "",
          "list_count": 0,
          "list_type": "",
          "image":
              "https://c.saavncdn.com/610/Nodoka-From-Pushpa-2-The-Rule-Kannada-2024-20240528221012-50x50.jpg",
          "artist_map": {
            "artists": [
              {
                "id": "455130",
                "name": "Shreya Ghoshal",
                "url":
                    "https://www.jiosaavn.com/artist/shreya-ghoshal-songs/lIHlwHaxTZ0_",
                "role": "Music, Music",
                "type": "artist",
                "image": ""
              },
              {
                "id": "455170",
                "name": "Devi Sri Prasad",
                "url":
                    "https://www.jiosaavn.com/artist/devi-sri-prasad-songs/M0dlT,PMjDs_",
                "role": "Music, Music, Music",
                "type": "artist",
                "image": ""
              },
              {
                "id": "9913852",
                "name": "VARADARAJ CHIKKABALLAPURA",
                "url":
                    "https://www.jiosaavn.com/artist/varadaraj-chikkaballapura-songs/i7VDseoEV8w_",
                "role": "Music, Music, Music",
                "type": "artist",
                "image": ""
              }
            ],
            "featured_artists": [],
            "primary_artists": []
          },
          "song_count": 0,
          "songs": []
        },
      ]
    },
    "playlists": {
      "title": "Editorial Picks",
      "subtitle": "",
      "position": 4,
      "source": "/get/featured-playlists",
      "featured_text": "",
      "data": [
        {
          "id": "828919201",
          "name": "Best Of 2000s  - Kannada",
          "subtitle": "5.9K Followers",
          "type": "playlist",
          "header_desc": "",
          "url":
              "https://www.jiosaavn.com/featured/best-of-2000s-kannada/NyMkku2HJmQGSw2I1RxdhQ__",
          "image":
              "https://c.saavncdn.com/editorial/AllDayShuffle2000sKannada_20230831121613.jpg",
          "explicit": false,
          "user_id": "phulki_user",
          "last_updated": "2024-04-23T02:53:17.000Z",
          "firstname": "JioSaavn",
          "follower_count": 5874,
          "songs": []
        },
        {
          "id": "158224954",
          "name": " Let's Play - Ilaiyaraaja - Kannada",
          "subtitle": "399 Followers",
          "type": "playlist",
          "header_desc": "",
          "url":
              "https://www.jiosaavn.com/featured/-lets-play-ilaiyaraaja-kannada/QYx9NnRNnMfufxkxMEIbIw__",
          "image":
              "https://c.saavncdn.com/editorial/Let_sPlayIlaiyaraaja_20240213093932.jpg",
          "explicit": false,
          "user_id": "phulki_user",
          "last_updated": "2024-03-29T00:25:45.000Z",
          "firstname": "JioSaavn",
          "follower_count": 399,
          "songs": []
        },
        {
          "id": "2677587",
          "name": "K. S. Chithra 2000 Hits - Kannada",
          "subtitle": "2.1K Followers",
          "type": "playlist",
          "header_desc": "",
          "url":
              "https://www.jiosaavn.com/featured/k.-s.-chithra-2000-hits-kannada/gXVp8mbKAfc_",
          "image":
              "https://c.saavncdn.com/editorial/ChithraClassics_20240527093019.jpg",
          "explicit": false,
          "user_id": "phulki_user",
          "last_updated": "2024-05-27T02:48:48.000Z",
          "firstname": "JioSaavn",
          "follower_count": 2063,
          "songs": []
        },
      ]
    }
  };
}

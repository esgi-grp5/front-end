import 'package:sqflite/sqflite.dart';
import 'package:wishflix/models/music_model.dart';

class MusicCacheProvider {
  static const _name = "MusicsDatabase.db";
  static const _version = 2;
  late Database database;
  static const tableName = 'musics';

  initDatabase() async {
    database = await openDatabase(_name, version: _version,
        onCreate: (Database db, int version) async {
      await db.execute('''CREATE TABLE $tableName (
                    id INTEGER PRIMARY KEY AUTOINCREMENT,
                    image TEXT,
                    name TEXT,
                    slug TEXT,
                    genre TEXT,
                    dateSortie TEXT,
                    artist TEXT,
                    description TEXT,
                    note INTEGER,
                    album TEXT
                    )''');
    });
  }

  /* Future<int> insertDefaultData() async {
    await initDatabase();
    Music music = Music(
      image: "assets/images/Kerman.png",
      genre: "Rap",
      dateSortie: "2002",
      name: "Lose yourself",
      slug: "Lose yourself",
      artist: "eminem",
      album: "Oui",
    );
    await insertMusic(music);
    music = Music(
      image: "assets/images/Kerman.png",
      genre: "Rap",
      dateSortie: "2002",
      name: "Lose yourself",
      slug: "Lose yourself",
      artist: "eminem",
      album: "Oui",
    );
    return await insertMusic(music);
  } */

  Future<int> insertMusic(Music music) async {
    await initDatabase();
    return await database.insert(tableName, music.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<int> updateMusic(Music music) async {
    await initDatabase();
    return await database.update(tableName, music.toMap(),
        where: "id = ?",
        whereArgs: [music.id],
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Music>> getAllMusics() async {
    await initDatabase();
    var result = await database.query(tableName);
    return result.map((e) => Music.fromJson(e)).toList();
  }

  Future<Map<String, dynamic>?> getMusics(int id) async {
    await initDatabase();
    var result =
        await database.query(tableName, where: "id = ?", whereArgs: [id]);

    if (result.isNotEmpty) {
      return result.first;
    }

    return null;
  }

  Future<int> deleteMusic(int id) async {
    await initDatabase();
    print("id: $id");
    return await database.delete(tableName, where: "id = ?", whereArgs: [id]);
    // return await database.rawDelete('DELETE FROM $tableName WHERE id = ?', [id]);
  }

  Future<void> deleteAll() async {
    await initDatabase();
    await database.execute("drop table if exists $tableName");
    return await database.execute('''CREATE TABLE $tableName (
                    id INTEGER PRIMARY KEY AUTOINCREMENT,
                    image TEXT,
                    name TEXT,
                    slug TEXT,
                    genre TEXT,
                    dateSortie TEXT,
                    description TEXT,
                    note INTEGER,
                    artist TEXT,
                    album TEXT
                    )''');
  }

  closeDatabase() async {
    await database.close();
  }
}

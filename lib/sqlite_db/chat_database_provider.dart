import 'package:digital_local_library/sqlite_db/database_provider.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class ChatDatabaseProvider extends DatabaseProvider{
  static const String TABLE_CHAT = "chat";
  static const String COLUMN_DATABASE_ID = "dbId";
  static const String COLUMN_CHAT_DOCUMENT_ID = "chatDocumentId";
  static const String COLUMN_PEERNAME = "peerName";
  static const String COLUMN_PEER_AVATAR_URL = "peerAvatarURL";
  static const String COLUMN_MESSAGES = "messages";

  ChatDatabaseProvider._();
  static final ChatDatabaseProvider db = ChatDatabaseProvider._();

  Database _database;
  Future<Database> get database async {
    if(_database != null) {
      return _database;
    }
    _database = await createDatabase();
    return _database;
  }

  Future<Database> createDatabase() async {
    String dbPath = await getDatabasesPath();

    return await openDatabase(
      join(dbPath, 'chatsDB.db'),
      version: 1,
      onCreate: (db, version) async {
        (await database).execute(
          "CREATE TABLE $TABLE_CHAT ("
          "$COLUMN_DATABASE_ID INTEGER PRIMARY KEY"
          "$COLUMN_CHAT_DOCUMENT_ID TEXT,"
          "$COLUMN_PEERNAME TEXT,"
          "$COLUMN_PEER_AVATAR_URL TEXT,"
          "$COLUMN_MESSAGES TEXT"
          ")",
        );
      }
    );
  }
}
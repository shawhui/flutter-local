import 'package:sqflite/sqflite.dart';
import 'package:flutter_local_book/util/utils.dart';

final String tableBookshelfModel = 'bookshelfModel';
final String columnId = '_id';
final String columnBookId = 'bookId';
final String columnBookName = 'bookName';
final String columnCover = 'cover';
final String columnUpdatedAt = 'updatedAt';
final String columnChapterOrder = 'chapterOrder';
final String columnShelf = 'shelf';

class BookshelfModel {

  int id;
  int bookId;
  String bookName;
  String author;
  String cover;
  int updateAt;
  int chapterOrder;
  bool shelf;

  BookshelfModel({this.bookId, this.author, this.cover, this.chapterOrder, this.updateAt, this.shelf, this.bookName});

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      columnBookId: bookId,
      columnBookName: bookName,
      columnCover:cover,
      columnUpdatedAt:updateAt,
      columnChapterOrder:chapterOrder,
      columnShelf:shelf == true ? 1:0
    };
    if (id != null) {
      map[columnId] = id;
    }
    return map;
  }

  BookshelfModel.fromMap(Map<String, dynamic> map) {
    id = map[columnId];
    bookId = map[columnBookId];
    bookName = map[columnBookName];
    cover = map[columnCover];
    updateAt = map[columnUpdatedAt];
    chapterOrder = map[columnChapterOrder];
    shelf = map[columnShelf] == 1;
  }
}


class BookshelfModelProvider {
  Database db;
  Future open(String path) async {
    db = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
          await db.execute('''
create table $tableBookshelfModel ( 
  $columnId integer primary key autoincrement, 
  $columnBookId integer not null,
  $columnBookName text not null,
  $columnCover text not null,
  $columnUpdatedAt integer not null,
  $columnChapterOrder integer not null,
  $columnShelf integer not null)
''');
        });
  }

  Future<BookshelfModel> insert(BookshelfModel bookshelfModel) async {
    bookshelfModel.id = await db.insert(tableBookshelfModel, bookshelfModel.toMap());
    return bookshelfModel;
  }

  Future<BookshelfModel> getBookshelfModel(int id) async {
    List<Map> maps = await db.query(tableBookshelfModel,
        columns: [columnId, columnBookId, columnBookName, columnCover, columnUpdatedAt, columnChapterOrder, columnShelf],
        where: '$columnId = ?',
        whereArgs: [id]);
    if (maps.length > 0) {
      return BookshelfModel.fromMap(maps.first);
    }
    return null;
  }

  Future<List<BookshelfModel>> getAll() async {
    List<Map> maps = await db.query(tableBookshelfModel,
      columns: [columnId, columnBookId, columnBookName, columnCover, columnUpdatedAt, columnChapterOrder, columnShelf],
      where: '$columnShelf = ?',
      whereArgs: [1],
      orderBy: '$columnUpdatedAt desc',
    );

    return listEmpty(maps) ? null : maps.map<BookshelfModel>((Map map){
      return BookshelfModel.fromMap(map);
    }).toList();
  }


  Future<int> delete(int id) async {
    return await db.delete(tableBookshelfModel, where: '$columnId = ?', whereArgs: [id]);
  }

  Future<int> update(BookshelfModel bookshelfModel) async {
    return await db.update(tableBookshelfModel, bookshelfModel.toMap(),
        where: '$columnId = ?', whereArgs: [bookshelfModel.id]);
  }

  Future close() async => db.close();

}


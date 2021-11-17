import 'package:sqflite/sqflite.dart';
import 'package:flutter_local_book/util/utils.dart';

final String tableBookChapterModel = 'bookChapterModel';
final String columnId = '_id';
final String columnBookId = 'bookId';
final String columnTitle = 'title';
final String columnChapterOrder = 'chapterOrder';
final String columnChapterText = 'chapterText';
final String columnUpdatedAt = 'updatedAt';

class BookChapterModel {

  int id;
  int bookId;
  String title;
  int chapterOrder;
  String chapterText;
  int updateAt;

  BookChapterModel(this.bookId, this.title, this.chapterOrder, this.chapterText, this.updateAt);

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      columnBookId: bookId,
      columnTitle: title,
      columnChapterOrder:chapterOrder,
      columnChapterText:chapterText,
      columnUpdatedAt:updateAt
    };
    if (id != null) {
      map[columnId] = id;
    }
    return map;
  }

  BookChapterModel.fromMap(Map<String, dynamic> map) {
    id = map[columnId];
    bookId = map[columnBookId];
    title = map[columnTitle];
    chapterOrder = map[columnChapterOrder];
    chapterText = map[columnChapterText];
    updateAt = map[columnUpdatedAt];
  }
}


class BookChapterModelProvider {
  Database db;
  Future open(String path) async {
    db = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
          await db.execute('''
create table $tableBookChapterModel ( 
  $columnId integer primary key autoincrement, 
  $columnBookId integer not null,
  $columnTitle text not null,
  $columnChapterOrder integer not null,
  $columnChapterText text not null,
  $columnUpdatedAt integer not null)
''');
        });
  }

  Future<BookChapterModel> insert(BookChapterModel bookChapterModel) async {
    bookChapterModel.id = await db.insert(tableBookChapterModel, bookChapterModel.toMap());
    return bookChapterModel;
  }

  Future<List<BookChapterModel>> getBookChapterByBookId(int bookId, {bool isDesc=false}) async {
    List<Map> maps = await db.query(tableBookChapterModel,
      columns: [columnId, columnBookId, columnTitle, columnChapterOrder],
      where: '$columnBookId = ?',
      whereArgs: [bookId],
      orderBy: isDesc ? '$columnChapterOrder desc':'$columnChapterOrder asc'
    );
    return listEmpty(maps) ? null : maps.map<BookChapterModel>((Map map){
      return BookChapterModel.fromMap(map);
    }).toList();

  }

  Future<BookChapterModel> getBookChapterModel(int id) async {
    List<Map> maps = await db.query(tableBookChapterModel,
      columns: [columnId, columnBookId, columnTitle, columnChapterOrder, columnChapterText, columnUpdatedAt],
      where: '$columnId = ?',
      whereArgs: [id],
      limit: 1
    );
    if (maps.length > 0) {
      return BookChapterModel.fromMap(maps.first);
    }
    return null;
  }

  Future<BookChapterModel> getBookIdChapterId(int bookId, int chapterOrder) async {
    List<Map> maps = await db.query(tableBookChapterModel,
      columns: [columnId, columnBookId, columnTitle, columnChapterOrder, columnChapterText, columnUpdatedAt],
      where: '$columnBookId = ? and $columnChapterOrder = ?',
      whereArgs: [bookId, chapterOrder],
      limit: 1
    );

    if (maps.length > 0) {
      return BookChapterModel.fromMap(maps.first);
    }
    return null;
  }

  Future<int> deleteByBookId(int bookId) async {
    return await db.delete(tableBookChapterModel, where: '$columnBookId = ?', whereArgs: [bookId]);
  }

  Future<int> delete(int id) async {
    return await db.delete(tableBookChapterModel, where: '$columnId = ?', whereArgs: [id]);
  }

  Future<int> update(BookChapterModel bookChapterModel) async {
    return await db.update(tableBookChapterModel, bookChapterModel.toMap(),
        where: '$columnId = ?', whereArgs: [bookChapterModel.id]);
  }

  Future close() async => db.close();

}


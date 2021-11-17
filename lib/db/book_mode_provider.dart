import 'package:sqflite/sqflite.dart';
import 'package:flutter_local_book/util/utils.dart';


final String tableBookModel = 'bookModel';
final String columnId = '_id';
final String columnBookName = 'bookName';
final String columnUpdatedAt = 'updatedAt';
final String columnLastChapter = 'lastChapter';
final String columnLastPage = 'lastPage';
final String columnTotalChapter = 'totalChapter';
final String columnLastChapterTitle = 'lastChapterTitle';

class BookModel {

  int id;
  String bookName;
  int lastChapter;
  int lastPage;
  int totalChapter;
  String lastChapterTitle;
  int updateAt;

  BookModel(this.bookName, this.lastChapter, this.lastPage, {this.totalChapter=0, this.lastChapterTitle='', this.updateAt});

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      columnBookName: bookName,
      columnLastChapter: lastChapter,
      columnLastPage: lastPage,
      columnTotalChapter: totalChapter,
      columnLastChapterTitle: lastChapterTitle,
      columnUpdatedAt: updateAt
    };
    if (id != null) {
      map[columnId] = id;
    }
    return map;
  }

  BookModel.fromMap(Map<String, dynamic> map) {
    id = map[columnId];
    bookName = map[columnBookName];
    lastChapter = map[columnLastChapter];
    lastPage = map[columnLastPage];
    totalChapter = map[columnTotalChapter];
    lastChapterTitle = map[columnLastChapterTitle];
    updateAt = map[columnUpdatedAt];
  }
}


class BookModelProvider {
  Database db;
  Future open(String path) async {
    db = await openDatabase(path, version: 6,
        onCreate: (Database db, int version) async {
          print('onCreate');
          await db.execute('''
create table $tableBookModel ( 
  $columnId integer primary key autoincrement, 
  $columnBookName text not null,
  $columnLastChapter integer not null,
  $columnLastPage integer not null,
  $columnTotalChapter integer not null,
  $columnLastChapterTitle text not null,
  $columnUpdatedAt integer not null)
''');
        }, onUpgrade: (Database db, int oldVersion, int newVersion) async {
          print('onUpgrade');
          await db.execute('ALTER TABLE $tableBookModel ADD $columnLastChapterTitle integer not null default ""');
        });
  }

  Future<BookModel> insert(BookModel bookModel) async {
    bookModel.id = await db.insert(tableBookModel, bookModel.toMap());
    return bookModel;
  }

  Future<BookModel> getBookModel(int id) async {
    List<Map> maps = await db.query(tableBookModel,
        columns: [columnId, columnBookName, columnLastChapter, columnLastPage, columnTotalChapter, columnLastChapterTitle, columnUpdatedAt],
        where: '$columnId = ?',
        whereArgs: [id]);
    if (maps.length > 0) {
      return BookModel.fromMap(maps.first);
    }
    return null;
  }

  Future<BookModel> getBookByName(String name) async {
    List<Map> maps = await db.query(tableBookModel,
      columns: [columnId, columnBookName, columnLastChapter, columnLastPage, columnTotalChapter, columnLastChapterTitle, columnUpdatedAt],
      where: '$columnBookName = ?',
      whereArgs: [name],
      limit: 1
    );
    if (maps.length > 0) {
      return BookModel.fromMap(maps.first);
    }
    return null;
  }

  Future<List<BookModel>> getAll() async {
    List<Map> maps = await db.query(tableBookModel,
      columns: [columnId, columnBookName, columnLastChapter, columnLastPage, columnTotalChapter, columnLastChapterTitle, columnUpdatedAt],
      orderBy: '$columnUpdatedAt desc',
    );

    return listEmpty(maps) ? null : maps.map<BookModel>((Map map){
      return BookModel.fromMap(map);
    }).toList();
  }


  Future<int> delete(int id) async {
    return await db.delete(tableBookModel, where: '$columnId = ?', whereArgs: [id]);
  }

  Future<int> update(BookModel bookModel) async {
    return await db.update(tableBookModel, bookModel.toMap(),
        where: '$columnId = ?', whereArgs: [bookModel.id]);
  }

  Future close() async => db.close();

}


import 'package:flutter/material.dart';
import 'package:flutter_local_book/db/book_mode_provider.dart';
import 'package:flutter_local_book/public.dart';
import 'package:flutter_local_book/util/utils.dart';
class BookShelfNotify with ChangeNotifier {

  List<BookModel> bookshelfList;

  List<BookModel> getList() => bookshelfList;

  bool isEmpty() {
    return listEmpty(bookshelfList);
  }

  Future syncBook() async {
    bookshelfList = await bookModelProvider.getAll();
    notifyListeners();
  }

  BookModel getByBookId(int bookId) {
    if(listEmpty(bookshelfList)) {
      return null;
    }

    return bookshelfList.firstWhere((BookModel model) {
      return model.id == bookId;
    });
  }

  Future setReadBook(int bookId, int lastChapter, int lastPage) async {
    BookModel bookModel = getByBookId(bookId);
    bookModel.lastChapter = lastChapter;
    bookModel.lastPage = lastPage;
    bookModelProvider.update(bookModel);

  }

}
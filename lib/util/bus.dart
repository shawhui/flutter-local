import 'package:event_bus/event_bus.dart';


EventBus eventBus = EventBus();

class UserLogin {

  bool isSuccess;

  UserLogin(this.isSuccess);

}


class BookShelfUpdate {

  bool update;

  BookShelfUpdate(this.update);

}

class MeUpdate {

  bool update;

  MeUpdate(this.update);

}

class BookDetailUpdate {

  bool update;
  int chapter;
  int bookId;
  BookDetailUpdate(this.update, this.bookId, {this.chapter});

}


class ReaderUpdate {

  bool update;
  ReaderUpdate(this.update);

}


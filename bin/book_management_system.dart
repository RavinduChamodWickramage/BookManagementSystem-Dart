import 'dart:io';

enum BookStatus { available, borrowed }

class Book {
  String _title;
  String _author;
  String _isbn;
  BookStatus _status;

  Book(this._title, this._author, this._isbn,
      {BookStatus status = BookStatus.available})
      : _status = status;

  String get title => _title;
  set title(String value) {
    if (value.isNotEmpty) {
      _title = value;
    } else {
      print("Title cannot be empty.");
    }
  }

  String get author => _author;
  set author(String value) {
    if (value.isNotEmpty) {
      _author = value;
    } else {
      print("Author name cannot be empty.");
    }
  }

  String get isbn => _isbn;
  set isbn(String value) {
    if (value.isNotEmpty) {
      _isbn = value;
    } else {
      print("ISBN cannot be empty.");
    }
  }

  BookStatus get status => _status;
  set status(BookStatus value) => _status = value;

  @override
  String toString() {
    return 'Book{Title: $title, Author: $author, ISBN: $isbn, Status: $status}';
  }
}

class TextBook extends Book {
  String _subjectArea;
  int _gradeLevel;

  TextBook(String title, String author, String isbn, this._subjectArea,
      this._gradeLevel,
      {BookStatus status = BookStatus.available})
      : super(title, author, isbn, status: status);

  String get subjectArea => _subjectArea;
  set subjectArea(String value) {
    if (value.isNotEmpty) {
      _subjectArea = value;
    } else {
      print("Subject area cannot be empty.");
    }
  }

  int get gradeLevel => _gradeLevel;
  set gradeLevel(int value) {
    if (value >= 1 && value <= 12) {
      _gradeLevel = value;
    } else {
      print("Grade level should be between 1 and 12.");
    }
  }

  @override
  String toString() {
    return 'TextBook{Title: $title, Author: $author, ISBN: $isbn, Subject Area: $_subjectArea, Grade Level: $_gradeLevel, Status: $status}';
  }
}

class BookCollection {
  List<Book> _books = [];

  void addBook(Book book) {
    _books.add(book);
    print("${book} added successfully.");
  }

  void addTextBook(TextBook textBook) {
    addBook(textBook);
  }

  void removeBook(String isbn) {
    int initialLength = _books.length;
    _books.removeWhere((book) => book.isbn == isbn);

    if (_books.length < initialLength) {
      print('Removed book with ISBN: $isbn');
    } else {
      print('No book found with ISBN: $isbn');
    }
  }

  void updateBookStatus(String isbn) {
    try {
      Book book = _books.firstWhere((book) => book.isbn == isbn);

      if (book.status == BookStatus.available) {
        book.status = BookStatus.borrowed;
        print('Updated status: Book with ISBN $isbn is now borrowed.');
      } else {
        book.status = BookStatus.available;
        print('Updated status: Book with ISBN $isbn is now available.');
      }
    } catch (e) {
      print('No book found with ISBN: $isbn');
    }
  }

  List<Book> searchByTitle(String title) {
    return _books
        .where((book) => book.title.toLowerCase().contains(title.toLowerCase()))
        .toList();
  }

  List<Book> searchByAuthor(String author) {
    return _books
        .where(
            (book) => book.author.toLowerCase().contains(author.toLowerCase()))
        .toList();
  }

  List<Book> searchByISBN(String isbn) {
    return _books.where((book) => book.isbn == isbn).toList();
  }

  List<Book> searchByStatus(BookStatus status) {
    return _books.where((book) => book.status == status).toList();
  }

  List<TextBook> searchBySubjectArea(String subjectArea) {
    return _books
        .where((book) => book is TextBook && book.subjectArea == subjectArea)
        .cast<TextBook>()
        .toList();
  }

  List<TextBook> searchByGradeLevel(int gradeLevel) {
    return _books
        .where((book) => book is TextBook && book.gradeLevel == gradeLevel)
        .cast<TextBook>()
        .toList();
  }

  void displayBooks() {
    if (_books.isEmpty) {
      print("No books in the collection.");
    } else {
      for (var book in _books) {
        print(book);
      }
    }
  }
}

void main(List<String> arguments) {
  var collection = BookCollection();

  print("Welcome to the Book Management System...!!");

  int choice;

  do {
    print("\nMenu:");
    print("\t1. Add a book");
    print("\t2. Remove a book");
    print("\t3. Update book status");
    print("\t4. Search books");
    print("\t5. Display books");
    print("\t0. Exit");
    stdout.write("\nEnter your choice: ");

    choice = int.tryParse(stdin.readLineSync() ?? '') ?? -1;

    switch (choice) {
      case 1:
        addBook(collection);
        break;
      case 2:
        removeBook(collection);
        break;
      case 3:
        updateBookStatus(collection);
        break;
      case 4:
        searchBooks(collection);
        break;
      case 5:
        collection.displayBooks();
        break;
      case 0:
        print("Exiting the Book Management System.");
        break;
      default:
        print("Invalid choice. Please try again.");
    }
  } while (choice != 0);
}

void addBook(BookCollection collection) {
  stdout.write("Enter book title: ");
  String title = stdin.readLineSync() ?? '';
  stdout.write("Enter book author: ");
  String author = stdin.readLineSync() ?? '';
  stdout.write("Enter book ISBN: ");
  String isbn = stdin.readLineSync() ?? '';

  stdout.write("Is this a textbook? (yes/no): ");
  String isTextBook = stdin.readLineSync() ?? '';

  if (isTextBook.toLowerCase() == 'yes') {
    stdout.write("Enter subject area: ");
    String subjectArea = stdin.readLineSync() ?? '';
    stdout.write("Enter grade level (1-12): ");
    int gradeLevel = int.tryParse(stdin.readLineSync() ?? '') ?? 0;

    if (gradeLevel >= 1 && gradeLevel <= 12) {
      TextBook textBook =
          TextBook(title, author, isbn, subjectArea, gradeLevel);
      collection.addTextBook(textBook);
    } else {
      stdout.write(
          "Invalid grade level. Please enter a value between 1 and 12.\n");
    }
  } else {
    Book book = Book(title, author, isbn);
    collection.addBook(book);
  }
}

void removeBook(BookCollection collection) {
  print("Enter ISBN of the book to remove:");
  String isbnToRemove = stdin.readLineSync() ?? '';
  collection.removeBook(isbnToRemove);
}

void updateBookStatus(BookCollection collection) {
  print("Enter ISBN of the book to update status:");
  String isbnToUpdate = stdin.readLineSync() ?? '';
  collection.updateBookStatus(isbnToUpdate);
}

void searchBooks(BookCollection collection) {
  print("Search by: 1. Title 2. Author 3. ISBN 4. Status");
  String searchChoice = stdin.readLineSync() ?? '';

  switch (searchChoice) {
    case '1':
      print("Enter title to search:");
      String searchTitle = stdin.readLineSync() ?? '';
      List<Book> titleResults = collection.searchByTitle(searchTitle);
      if (titleResults.isEmpty) {
        print("No books found with the title containing '$searchTitle'.");
      } else {
        titleResults.forEach((book) => print(book));
      }
      break;
    case '2':
      print("Enter author to search:");
      String searchAuthor = stdin.readLineSync() ?? '';
      List<Book> authorResults = collection.searchByAuthor(searchAuthor);
      if (authorResults.isEmpty) {
        print("No books found by author '$searchAuthor'.");
      } else {
        authorResults.forEach((book) => print(book));
      }
      break;
    case '3':
      print("Enter ISBN to search:");
      String searchIsbn = stdin.readLineSync() ?? '';
      List<Book> isbnResults = collection.searchByISBN(searchIsbn);
      if (isbnResults.isEmpty) {
        print("No book found with ISBN '$searchIsbn'.");
      } else {
        isbnResults.forEach((book) => print(book));
      }
      break;
    case '4':
      print("Enter status to search (available/borrowed):");
      String statusInput = stdin.readLineSync() ?? '';
      BookStatus status = statusInput.toLowerCase() == 'borrowed'
          ? BookStatus.borrowed
          : BookStatus.available;
      List<Book> statusResults = collection.searchByStatus(status);
      if (statusResults.isEmpty) {
        print("No books found with status '$statusInput'.");
      } else {
        statusResults.forEach((book) => print(book));
      }
      break;
    default:
      print("Invalid choice.");
  }
}

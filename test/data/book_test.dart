import 'package:flutter_test/flutter_test.dart';
import 'package:digital_local_library/data/book.dart';

void main() {
  group('Book data class', () {
    test('should fetch information about a book given its ISBN', () async {
      final book = await Book.getByIsbn("9783423050012");

      expect(book.title, "Bürgerliches Gesetzbuch");
      expect(book.author, "");
    });
  });
}

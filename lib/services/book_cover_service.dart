import 'dart:convert';
import 'package:http/http.dart' as http;

class BookCoverService {
  static Future<String?> fetchCoverUrl(String title, String author) async {
    final query = Uri.encodeComponent('$title $author');
    final url = Uri.parse(
        'https://openlibrary.org/search.json?q=$query&limit=1&fields=cover_i');

    final response = await http.get(
      url,
      headers: {'User-Agent': 'pooks_books/1.0 (personal reading journal app)'},
    );

    if (response.statusCode != 200) {
      throw Exception('API returned ${response.statusCode}: ${response.body}');
    }

    final data = jsonDecode(response.body);
    final docs = data['docs'] as List?;
    if (docs == null || docs.isEmpty) return null;

    final coverId = docs[0]['cover_i'];
    if (coverId == null) return null;

    final imageUrl = 'https://covers.openlibrary.org/b/id/$coverId-M.jpg';
    return imageUrl;
  }
}
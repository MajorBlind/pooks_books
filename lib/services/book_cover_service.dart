import 'dart:convert';
import 'package:http/http.dart' as http;

class BookCoverService{
  static Future<String?> fetchCoverUrl(String title, String author) async{
    final query = Uri.encodeComponent('intitle:$title inauthor:$author');
    final url = Uri.parse('https://www.googleapis.com/books/v1/volumes?q=$query&maxResults=1');

    final response = await http.get(url);
    if(response.statusCode != 200){
      return null;
    }

    final data = jsonDecode(response.body);
    final items = data['items'] as List?;
    if(items == null || items.isEmpty){
      return null;
    }

    final imageLinks = items[0]['volumeInfo']?['imageLinks'];
    if(imageLinks == null){
      return null;
    }

    return(imageLinks['thumbnail'] as String?)?.replaceFirst('http://', "https://");
  }
}
enum ReadingStatus {wantToRead, reading, read}

class Book{
  final int? id;
  final String title;
  final String author;
  final String? series;
  final ReadingStatus status;
  final DateTime? startDate;
  final DateTime? finishDate;
  final double? rating;
  final int? spiceRating;
  final String? notes;
  final String? summary;
  final String? coverPath;

  Book({
    this.id,
    required this.title,
    required this.author,
    this.series,
    this.status = ReadingStatus.wantToRead,
    this.startDate,
    this.finishDate,
    this.rating,
    this.spiceRating,
    this.notes,
    this.summary,
    this.coverPath,
  });

  Map<String, dynamic> toMap(){
    return{
      'id': id,
      'title': title,
      'author': author,
      'series': series,
      'status': status.name,
      'startDate': startDate?.toIso8601String(),
      'finishDate': finishDate?.toIso8601String(),
      'rating': rating,
      'spiceRating': spiceRating,
      'notes': notes,
      'summary': summary,
      'coverPath': coverPath,
    };
  }

  factory Book.fromMap(Map<String, dynamic> map){
    return Book(
      id: map['id'] as int?,
      title: map['title'] as String,
      author: map['author'] as String,
      series: map['series'] as String?,
      status: ReadingStatus.values.byName(map['status'] as String),
      startDate: map['startDate'] != null
        ? DateTime.parse(map['startDate'] as String)
        : null,
      finishDate: map['finishDate'] != null
        ? DateTime.parse(map['finishDate'] as String)
        : null,
      rating: map['rating'] as double?,
      spiceRating: map['spiceRating'] as int?,
      notes: map['notes'] as String?,
      summary: map['summary'] as String?,
      coverPath: map['coverPath'] as String?,
    );
  }
}

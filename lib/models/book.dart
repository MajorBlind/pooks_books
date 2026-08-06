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
}

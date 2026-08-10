import 'package:flutter/material.dart';
import '../models/book.dart';
import '../database/database_helper.dart';
import '../widgets/journal_card.dart';
import '../services/book_cover_service.dart';

class AddBookScreen extends StatefulWidget{
  final Book? bookToEdit;

  const AddBookScreen({super.key, this.bookToEdit});

  @override
  State<AddBookScreen> createState() => _AddBookScreenState();
}

class _AddBookScreenState extends State<AddBookScreen>{
  // Instance vars for Title & Author JournalCard
  final _titleController = TextEditingController();
  final _authorController = TextEditingController();
  final _seriesController = TextEditingController();
  ReadingStatus _status = ReadingStatus.wantToRead;
  // Instance vars for Reading Timeline JournalCard
  DateTime? _startDate;
  DateTime? _finishDate;
  // Instance vars for Rating and Spice Journal Card
  int _rating = 0;
  int _spiceRating = 0;
  // Instance vars for feelings section
  final List<String> _selectedFeelings = [];
  final List<String> _presetFeelings = ['Inspired', 'Nostalgic', 'Tense', 'Hopeful', 'sad'];
  final _customFeelingController = TextEditingController();
  // Instance vars for plot/summary section
  final _summaryController = TextEditingController();
  // Insatnce vars for fav quote & notes/review section
  final _quoteController = TextEditingController();
  final _notesController = TextEditingController();
  // Instance vars for loved characters section
  final List<String> _characters = [];
  final _characterController = TextEditingController();
  // Instance vars for would I recommend section
  bool? _wouldRecommend;

  String? _coverPath;
  bool _isFetchingCover = false;

  @override
  void initState() {
    super.initState();
    final book = widget.bookToEdit;
    if(book != null){
      _titleController.text = book.title;
      _authorController.text = book.author;
      _seriesController.text = book.series ?? '';
      _status = book.status;
      _startDate = book.startDate;
      _finishDate = book.finishDate;
      _rating = book.rating?.toInt() ?? 0;
      _spiceRating = book.spiceRating ?? 0;
      _selectedFeelings.addAll(book.feelings);
      _summaryController.text = book.summary ?? '';
      _quoteController.text = book.quote ?? '';
      _notesController.text = book.notes ?? '';
      _characters.addAll(book.characters);
      _wouldRecommend = book.wouldRecommend;
      _coverPath = book.coverPath;
    }
  }

  @override
  void dispose(){
    _titleController.dispose();
    _authorController.dispose();
    _seriesController.dispose();
    _customFeelingController.dispose();
    _summaryController.dispose();
    _quoteController.dispose();
    _notesController.dispose();
    _characterController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pink.shade200,
        title: Text(widget.bookToEdit != null ? 'Edit Book' : 'Add a book'),
      ),
      
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              JournalCard(
                title: 'Title & Author',
                tagColor: const Color(0xFFD98D74),
                child: Column(
                  children: [
                    TextField(
                      controller: _titleController,
                      decoration: const InputDecoration(labelText: 'Title'),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _authorController,
                      decoration: const InputDecoration(labelText: 'Author'),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _seriesController,
                      decoration: const InputDecoration(labelText: 'Series'),
                    ),
                    const SizedBox(height: 10),
                    DropdownButtonFormField<ReadingStatus>(
                      initialValue: _status,
                      decoration: const InputDecoration(labelText: 'Status'),
                      items: ReadingStatus.values.map((status) {
                        return DropdownMenuItem(
                          value: status,
                          child: Text(_statusLabel(status)),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _status = value!;
                        });
                      },
                    ),

                    const SizedBox(height: 10),
                    OutlinedButton.icon(
                      onPressed: _isFetchingCover ? null : _fetchCover,
                      icon: _isFetchingCover
                          ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                          : const Icon(Icons.image_search),
                        label: Text(_isFetchingCover ? 'Searching...' : 'Find Cover'),
                    ),
                    if(_coverPath != null) ...[
                      const SizedBox(height: 10),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          _coverPath!,
                          height: 140,
                          errorBuilder: (context, error, stackTrace) => const Text('Could not load cover image'),
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              JournalCard(
                title: 'Reading Timeline',
                tagColor: const Color(0xFFA9B79E),
                child: Row(
                  children: [
                    Expanded(
                      child: _buildDateField(
                        'Started', _startDate, () => _pickDate(isStart: true)),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _buildDateField(
                        'Finished', _finishDate, () => _pickDate(isStart: false)),
                    ),
                  ],
                ),
              ),

              JournalCard(
                title: "Rating & Spice",
                tagColor: const Color(0xFFD9A86C),
                child: Row(
                  children: [
                    // Rating section
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text ('Rating'),
                          _buildIconRow(
                            icon: Icons.favorite,
                            color: Colors.pink,
                            value: _rating,
                            onChanged: (v) => setState(() => _rating = v),
                          ),
                        ],
                      ),
                    ),

                    // Spicy rating section
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Spice'),
                          _buildIconRow(
                            icon: Icons.local_fire_department,
                            color: Colors.deepOrange,
                            value: _spiceRating,
                            onChanged: (v) => setState(() => _spiceRating = v),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Feelings section
              JournalCard(
                title: 'This Book Made Me Feel...',
                tagColor: const Color(0xFFE3A9A9),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        ..._presetFeelings.map((feeling) {
                          final selected = _selectedFeelings.contains(feeling);
                          return FilterChip(
                            label: Text(
                              feeling,
                              style: TextStyle(
                                color: selected ? Colors.white : null,
                              ),
                            ),
                            selected: selected,
                            selectedColor: const Color(0xFFE3A9A9),
                            checkmarkColor: Colors.white,
                            onSelected: (isSelected) {
                              setState(() {
                                if(isSelected) {
                                  _selectedFeelings.add(feeling);
                                }else {
                                  _selectedFeelings.remove(feeling);
                                }
                              });
                            },
                          );
                        }),
                        ..._selectedFeelings
                          .where((f) => !_presetFeelings.contains(f))
                          .map((feeling) {
                          return InputChip(
                            label: Text(
                              feeling,
                              style: const TextStyle(color: Colors.white),
                            ),
                            backgroundColor: const Color(0xFFE3A9A9),
                            deleteIconColor: Colors.white,
                            onDeleted: () {
                              setState(() {
                                _selectedFeelings.remove(feeling);
                              });
                            },
                          );
                        }),
                      ],
                    ),

                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _customFeelingController,
                            decoration: const InputDecoration(
                              hintText: 'Add your own feeling...',
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: () {
                            final text = _customFeelingController.text.trim();
                            if (text.isNotEmpty) {
                              setState(() {
                                _selectedFeelings.add(text);
                                _customFeelingController.clear();
                              });
                            }
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              JournalCard(
                title: 'The Plot',
                tagColor: const Color(0xFFA9B79E),
                child: TextField(
                  controller: _summaryController,
                  maxLines: 7,
                  decoration: const InputDecoration(
                    hintText: 'What\'s This Book About',
                    border: InputBorder.none,
                  ),
                ),
              ),

              JournalCard(
                title: 'Favorite Quote',
                tagColor: const Color(0xFFD9A86C),
                child: TextField(
                  controller: _quoteController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    hintText: '"Keep moving Forward" - Walt Disney',
                    border: InputBorder.none,
                  ),
                ),
              ),

              JournalCard(
                title: 'What I Thought',
                tagColor:const Color(0xFFD98D74),
                child: TextField(
                  controller: _notesController,
                  maxLines: 5,
                  decoration: const InputDecoration(
                    hintText: 'I think the book...',
                    border: InputBorder.none,
                  ),
                ),
              ),

              JournalCard(
                title: 'Characters I Loved',
                tagColor: const Color(0xFFE3A9A9),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _characters.map((name) {
                        return Chip(
                          label: Text(name),
                          onDeleted: () {
                            setState(() {
                              _characters.remove(name);
                            });
                          },
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _characterController,
                            decoration: const InputDecoration(
                              hintText: 'Add a character...'
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: () {
                            final text = _characterController.text.trim();
                            if(text.isNotEmpty) {
                              setState(() {
                                _characters.add(text);
                                _characterController.clear();
                              });
                            }
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              JournalCard(
                title: 'Would I Recommend?',
                tagColor: const Color(0xFFD9A86C),
                child: Row(
                  children: [
                    Expanded(
                      child: ChoiceChip(
                        label: const Text('Yes'),
                        selected: _wouldRecommend == true,
                        selectedColor: const Color(0xFFA9B79E),
                        onSelected: (_) {
                          setState(() => _wouldRecommend = true);
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ChoiceChip(
                        label: const Text('Maybe'),
                        selected: _wouldRecommend == null,
                        selectedColor: const Color(0xFFD9A86C),
                        onSelected: (_) {
                          setState(() => _wouldRecommend = null);
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ChoiceChip(
                        label: const Text('Not Really'),
                        selected: _wouldRecommend == false,
                        selectedColor: const Color(0xFFE3A9A9),
                        onSelected: (_) {
                          setState(() => _wouldRecommend = false);
                        },
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () async {
                  final book = Book(
                    id: widget.bookToEdit?.id,
                    title: _titleController.text,
                    author: _authorController.text,
                    series: _seriesController.text.isEmpty
                        ? null
                        : _seriesController.text,
                    status: _status,
                    startDate: _startDate,
                    finishDate: _finishDate,
                    rating: _rating == 0 ? null : _rating.toDouble(),
                    spiceRating: _spiceRating == 0 ? null : _spiceRating,
                    feelings: _selectedFeelings,
                    summary: _summaryController.text.isEmpty
                        ? null
                        : _summaryController.text,
                    quote: _quoteController.text.isEmpty
                        ? null
                        : _quoteController.text,
                    notes: _notesController.text.isEmpty
                        ? null
                        : _notesController.text,
                        characters: _characters,
                        wouldRecommend: _wouldRecommend
                  );

                  if(widget.bookToEdit != null){
                    await DatabaseHelper.instance.updateBook(book);
                  }else {
                    await DatabaseHelper.instance.insertBook(book);
                  }

                  if(context.mounted){
                    Navigator.pop(context);
                  }
                },
                child: const Text('Save Book'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _statusLabel(ReadingStatus status){
    switch(status){
      case ReadingStatus.wantToRead:
        return 'Want To Read';
      case ReadingStatus.reading:
        return 'Reading';
      case ReadingStatus.read:
        return 'Read';
    }
  }

  Future<void> _pickDate({required bool isStart}) async{
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );

    if (picked != null){
      setState(() {
        if(isStart) {
          _startDate = picked;
        }else {
          _finishDate = picked;
        }
      });
    }
  }

  Widget _buildDateField(String label, DateTime? date, VoidCallback onTap){
    return InkWell(
      onTap: onTap,
      child: InputDecorator(
        decoration: InputDecoration(labelText: label),
        child: Text(date == null
            ? 'Not set'
            : '${date.month}/${date.day}/${date.year}'),
      ),
    );
  }

  Widget _buildIconRow({
    required IconData icon,
    required Color color,
    required int value,
    required ValueChanged<int> onChanged,
  }) {
    return Row(
      children: List.generate(5, (index) {
        final filled = index < value;
        return IconButton(
          padding: EdgeInsets.zero,
          icon: Icon(
            icon,
            color: filled ? color: color.withValues(alpha: 0.25),
          ),
          onPressed: () => onChanged(index + 1),
        );
      }),
    );
  }

  Future<void> _fetchCover() async{
    if(_titleController.text.isEmpty || _authorController.text.isEmpty){
      return;
    }

    setState(() => _isFetchingCover = true);
    final url = await BookCoverService.fetchCoverUrl(
      _titleController.text, _authorController.text
    );

    setState(() {
      _coverPath = url;
      _isFetchingCover = false;
    });
  }
}

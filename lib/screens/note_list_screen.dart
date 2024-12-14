import 'package:flutter/material.dart';
import 'package:sqflite_project/provider/them_provider.dart';
import '../models/note.dart';
import '../services/database_service.dart';
import '../widgets/note_tile.dart';
import 'note_screen.dart';
import 'package:provider/provider.dart';

class NotesListScreen extends StatefulWidget {
  @override
  _NotesListScreenState createState() => _NotesListScreenState();
}

class _NotesListScreenState extends State<NotesListScreen> {
  late DatabaseService _dbService;
  late List<Note> _notes;
  List<Note> _filteredNotes = [];
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _dbService = DatabaseService();
    _loadNotes();
  }

  void _loadNotes() async {
    _notes = await _dbService.getNotes();
    _filterNotes();
  }

  void _filterNotes() {
    setState(() {
      _filteredNotes = _notes.where((note) {
        return note.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            note.content.toLowerCase().contains(_searchQuery.toLowerCase());
      }).toList();
    });
  }

  void _navigateToNoteScreen([Note? note]) {
    Navigator.of(context)
        .push(MaterialPageRoute(
      builder: (context) => NoteScreen(note: note),
    ))
        .then((_) {
      _loadNotes();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text('Notes'),
        actions: [
          IconButton(
            icon: Icon(context.watch<ThemeProvider>().isDarkMode
                ? Icons.wb_sunny
                : Icons.nights_stay),
            onPressed: () => context.read<ThemeProvider>().toggleTheme(),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(45.0),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14.0),
            child: TextField(
              decoration: InputDecoration(
                suffixIcon: Icon(Icons.search),
                hintText: 'Search...',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                _searchQuery = value;
                _filterNotes();
              },
            ),
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: _filteredNotes.length,
        itemBuilder: (context, index) {
          return NoteTile(
            note: _filteredNotes[index],
            onTap: () => _navigateToNoteScreen(_filteredNotes[index]),
            onDelete: () async {
              await _dbService.deleteNote(_filteredNotes[index].id!);
              _loadNotes();
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToNoteScreen(),
        child: Icon(Icons.add),
      ),
    );
  }
}

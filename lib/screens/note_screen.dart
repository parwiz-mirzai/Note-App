import 'package:flutter/material.dart';
import '../models/note.dart';
import '../services/database_service.dart';

class NoteScreen extends StatefulWidget {
  final Note? note;

  NoteScreen({this.note});

  @override
  _NoteScreenState createState() => _NoteScreenState();
}

class _NoteScreenState extends State<NoteScreen> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  late DatabaseService _dbService;

  @override
  void initState() {
    super.initState();
    _dbService = DatabaseService();
    if (widget.note != null) {
      _titleController.text = widget.note!.title;
      _contentController.text = widget.note!.content;
    }
  }

  void _saveNote() async {
    if (widget.note == null) {
      await _dbService.insertNote(Note(
        title: _titleController.text,
        content: _contentController.text,
      ));
    } else {
      await _dbService.updateNote(Note(
        id: widget.note!.id,
        title: _titleController.text,
        content: _contentController.text,
      ));
    }
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(widget.note == null ? 'New Note' : 'Edit Note'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: _titleController,
                decoration: InputDecoration(labelText: 'Title'),
              ),
              TextField(
                maxLines: null,
                maxLength: null,
                expands: false,
                controller: _contentController,
                decoration: InputDecoration(labelText: 'Content'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveNote,
                child: Text('Save Note'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

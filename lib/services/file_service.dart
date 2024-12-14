import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../models/note.dart';

class FileService {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/notes.txt');
  }

  Future<String> readNotes() async {
    try {
      final file = await _localFile;
      return await file.readAsString();
    } catch (e) {
      return '';
    }
  }

  Future<File> writeNotes(List<Note> notes) async {
    final file = await _localFile;
    String notesString =
        notes.map((note) => '${note.title}\n${note.content}').join('\n\n');
    return file.writeAsString(notesString);
  }
}

import 'package:flutter/material.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart';

void main() {
  runApp(const MaterialApp(
    home: FormCreator(),
  ));
}

class FormCreator extends StatefulWidget {
  const FormCreator({super.key});

  @override
  _FormCreatorState createState() => _FormCreatorState();
}

class _FormCreatorState extends State<FormCreator> {
  final List<Map<String, dynamic>> _questions = [];

  void _addQuestion() {
    setState(() {
      _questions.add({
        'type': 'Short Answer',
        'question': '',
        'options': [],
        'file': null,
      });
    });
  }

  void _updateQuestion(int index, String value) {
    setState(() {
      _questions[index]['question'] = value;
    });
  }

  void _updateType(int index, String type) {
    setState(() {
      _questions[index]['type'] = type;
      if (type == 'Multiple Choice') {
        _questions[index]['options'] = [''];
      } else {
        _questions[index]['options'] = [];
      }
    });
  }

  void _addOption(int index) {
    setState(() {
      _questions[index]['options'].add('');
    });
  }

  void _updateOption(int qIndex, int oIndex, String value) {
    setState(() {
      _questions[qIndex]['options'][oIndex] = value;
    });
  }

  void _pickFile(int index) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      setState(() {
        _questions[index]['file'] = File(result.files.single.path!);
      });
    }
  }

  void _saveForm() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Form created successfully!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Form Creator')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: _questions.length,
                itemBuilder: (context, index) {
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextFormField(
                            decoration: const InputDecoration(labelText: 'Question'),
                            onChanged: (value) => _updateQuestion(index, value),
                          ),
                          DropdownButton<String>(
                            value: _questions[index]['type'],
                            items: ['Short Answer', 'Multiple Choice', 'File Upload']
                                .map((type) => DropdownMenuItem(
                              value: type,
                              child: Text(type),
                            ))
                                .toList(),
                            onChanged: (value) => _updateType(index, value!),
                          ),
                          if (_questions[index]['type'] == 'Multiple Choice')
                            Column(
                              children: [
                                ...List.generate(_questions[index]['options'].length, (oIndex) {
                                  return TextFormField(
                                    decoration: InputDecoration(
                                      labelText: 'Option ${oIndex + 1}',
                                    ),
                                    onChanged: (value) => _updateOption(index, oIndex, value),
                                  );
                                }),
                                TextButton(
                                  onPressed: () => _addOption(index),
                                  child: const Text('Add Option'),
                                )
                              ],
                            ),
                          if (_questions[index]['type'] == 'File Upload')
                            Column(
                              children: [
                                ElevatedButton(
                                  onPressed: () => _pickFile(index),
                                  child: const Text('Upload File'),
                                ),
                                if (_questions[index]['file'] != null)
                                  Text('File selected: ${_questions[index]['file']!.path}'),
                              ],
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: _addQuestion,
              child: const Text('Add Question'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _saveForm,
              child: const Text('Save Form'),
            ),
          ],
        ),
      ),
    );
  }
}
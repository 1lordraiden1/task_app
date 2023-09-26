import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:task_app/sql_helper.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> _journals = [];

  bool _isLoading = true;

  Future<void> _addItem() async {
    await SQLHelper.createItem(_titleController.text, _desController.text);
    _refreshJournals();

    print("we have ${_journals.length} task");
  }

  void _refreshJournals() async {
    final data = await SQLHelper.getItems();
    setState(() {
      _journals = data;
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _refreshJournals();
    print("we have ${_journals.length} task");
  }

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _desController = TextEditingController();
  void _showForm(int? id) {
    if (id != null) {
      final existingJournal = _journals.firstWhere(
        (element) => element['id'] == id,
      );
      _titleController.text = existingJournal['title'];
      _desController.text = existingJournal['description'];
    }

    showModalBottomSheet(
      context: context,
      elevation: 5,
      isScrollControlled: true,
      builder: (_) => Container(
        padding: EdgeInsets.only(
          top: 15,
          left: 15,
          right: 15,
          bottom: MediaQuery.of(context).viewInsets.bottom * 120,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _titleController,
              validator: (dynamic value) {
                if (value.toString().isEmpty) {
                  return 'Enter Title';
                }
              },
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                label: Text('Task title'),
                prefix: Icon(Icons.abc_outlined),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            TextFormField(
              controller: _desController,
              validator: (dynamic value) {
                if (value.toString().isEmpty) {
                  return 'Enter Description';
                }
              },
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                label: Text(
                  'Task Descirption',
                ),
                prefix: Icon(
                  Icons.abc_outlined,
                ),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            ElevatedButton(
              onPressed: () async {
                if (id == null) {
                  await _addItem();
                }
                if (id == null) {
                  // await _updateItem();
                }

                _titleController.text = '';
                _desController.text = '';

                Navigator.of(context).pop();
              },
              child: id == null ? Text("Create New") : Text("Update"),
            ),
            SizedBox(
              height: 15,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tasks"),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.add,
        ),
        onPressed: () => _showForm(null),
      ),
    );
  }
}

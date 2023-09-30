import 'package:flutter/material.dart';

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

  Future<void> _deleteItem(int id) async {
    await SQLHelper.deleteItem(id);
    _refreshJournals();

    print("Item $id deleted successfully");

    print("we have ${_journals.length} task");
  }

  Future<void> _updateItem(int id) async {
    await SQLHelper.updateItem(id, _titleController.text, _desController.text);
    _refreshJournals();

    print("Item $id updated successfully");
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
              decoration: const InputDecoration(
                label: Text('Task title'),
                prefix: Icon(Icons.abc_outlined),
              ),
            ),
            const SizedBox(
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
              decoration: const InputDecoration(
                label: Text(
                  'Task Descirption',
                ),
                prefix: Icon(
                  Icons.abc_outlined,
                ),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            ElevatedButton(
              onPressed: () async {
                if (id == null) {
                  await _addItem();
                }
                if (id != null) {
                  await _updateItem(id);
                }

                _titleController.text = '';
                _desController.text = '';

                Navigator.of(context).pop();
              },
              child: id == null ? const Text("Create New") : const Text("Update"),
            ),
            const SizedBox(
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
      body: ListView.builder(
        itemBuilder: (context, index) => Card(
          color: Colors.blue[800],
          margin: const EdgeInsets.all(15),
          child: ListTile(
            title: Text(
              _journals[index]['title'],
              style: const TextStyle(color: Colors.white),
            ),
            subtitle: Text(
              _journals[index]['description'],
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
            trailing: SizedBox(
              width: 100,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () => _showForm(_journals[index]['id']),
                    icon: const Icon(Icons.edit),
                  ),
                  IconButton(
                    onPressed: () => _deleteItem(_journals[index]['id']),
                    icon: const Icon(Icons.delete),
                  ),
                ],
              ),
            ),
          ),
        ),
        itemCount: _journals.length,
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(
          Icons.add,
        ),
        onPressed: () => _showForm(null),
      ),
    );
  }
}

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
    print("we have ${_journals} task");
  }

  void _showForm(int id) {}
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

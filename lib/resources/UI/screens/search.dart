import 'dart:async';
import 'package:flutter/material.dart';

// TODO: Implement search screen
class Explore extends StatelessWidget {
  const Explore({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Explore'),
    );
  }
}

class SearchScreenDialog extends StatefulWidget {
  const SearchScreenDialog({Key? key}) : super(key: key);

  @override
  State<SearchScreenDialog> createState() => _SearchScreenDialogState();
}

class _SearchScreenDialogState extends State<SearchScreenDialog> {
  late TextEditingController searchController;

  late StreamController searchStreamController;

  @override
  void initState() {
    super.initState();
    searchStreamController = StreamController();

    searchController = TextEditingController();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

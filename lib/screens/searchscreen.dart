import 'package:flutter/material.dart';
import 'package:vidmedia/widgets/searchresults.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = new TextEditingController();
  String? search = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(""),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(left: 20, right: 20),
              child: textFeld(
                  hintText: "Search videos...",
                  icon: Icons.search_outlined,
                  inputType: TextInputType.name,
                  maxLines: 1,
                  controller: _searchController),
            ),
            if (search == "")
              Center(
                child: Text("No results found"),
              ),
          ],
        ),
      ),
    );
  }

  Widget textFeld({
    required String hintText,
    required IconData icon,
    required TextInputType inputType,
    required int maxLines,
    required TextEditingController controller,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextFormField(
        onFieldSubmitted: (String text) {
          setState(() {
            search = text;
          });
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => SearchResult(search: search)));
        },
        cursorColor: Colors.purple,
        controller: controller,
        keyboardType: inputType,
        maxLines: maxLines,
        decoration: InputDecoration(
          prefixIcon: Container(
            margin: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.purple,
            ),
            child: Icon(
              icon,
              size: 20,
              color: Colors.white,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              color: Colors.transparent,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              color: Colors.transparent,
            ),
          ),
          hintText: hintText,
          alignLabelWithHint: true,
          border: InputBorder.none,
          fillColor: Colors.purple.shade50,
          filled: true,
        ),
      ),
    );
  }
}

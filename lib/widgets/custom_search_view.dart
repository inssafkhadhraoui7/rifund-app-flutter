import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProjectSearchPage extends StatefulWidget {
  @override
  _ProjectSearchPageState createState() => _ProjectSearchPageState();
}

class _ProjectSearchPageState extends State<ProjectSearchPage> {
  List<String> _projects = [];
  List<String> _filteredProjects = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchProjects();
    _searchController.addListener(_filterProjects);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _fetchProjects() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('projects').get();
    setState(() {
      _projects = snapshot.docs.map((doc) => doc['name'] as String).toList();
      _filteredProjects = _projects; // Show all projects initially
    });
  }

  void _filterProjects() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredProjects = _projects
          .where((project) => project.toLowerCase().contains(query))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Project Search')),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(), // Unfocus when tapping outside
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              CustomSearchView(
                controller: _searchController,
                hintText: 'Search Projects',
              ),
              SizedBox(height: 16.0),
              Expanded(
                child: ListView.builder(
                  itemCount: _filteredProjects.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(_filteredProjects[index]),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomSearchView extends StatelessWidget {
  const CustomSearchView({
    Key? key,
    this.alignment,
    this.width,
    this.controller,
    this.focusNode,
    this.autofocus = false,
    this.textStyle,
    this.textInputType = TextInputType.text,
    this.maxLines,
    this.hintText,
    this.hintStyle,
    this.prefix,
    this.suffix,
    this.contentPadding,
    this.borderDecoration,
    this.fillColor,
    this.filled = true,
    this.onChanged,
  }) : super(key: key);

  final Alignment? alignment;
  final double? width;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final bool? autofocus;
  final TextStyle? textStyle;
  final TextInputType? textInputType;
  final int? maxLines;
  final String? hintText;
  final TextStyle? hintStyle;
  final Widget? prefix;
  final Widget? suffix;
  final EdgeInsets? contentPadding;
  final InputBorder? borderDecoration;
  final Color? fillColor;
  final bool? filled;
  final Function(String)? onChanged;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.maxFinite,
      child: TextFormField(
        controller: controller,
        focusNode: focusNode,
        autofocus: autofocus ?? false,
        style: textStyle ?? Theme.of(context).textTheme.bodyText1,
        keyboardType: textInputType,
        maxLines: maxLines ?? 1,
        decoration: decoration(context),
        onChanged: onChanged,
      ),
    );
  }

  InputDecoration decoration(BuildContext context) => InputDecoration(
        hintText: hintText ?? "",
        hintStyle: hintStyle ?? Theme.of(context).textTheme.bodyText2, // Ensure this is set correctly
        prefixIcon: prefix ?? Icon(Icons.search, color: Colors.grey),
        suffixIcon: suffix ?? IconButton(
          onPressed: () => controller?.clear(),
          icon: Icon(Icons.clear, color: Colors.grey.shade600),
        ),
        isDense: true,
        contentPadding: contentPadding ?? EdgeInsets.symmetric(vertical: 15.0, horizontal: 12.0),
        fillColor: fillColor ?? Theme.of(context).colorScheme.surface,
        filled: filled ?? true,
        border: borderDecoration ?? OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0),
          borderSide: BorderSide(color: Theme.of(context).colorScheme.primary, width: 1),
        ),
        enabledBorder: borderDecoration ?? OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0),
          borderSide: BorderSide(color: Theme.of(context).colorScheme.primary, width: 1),
        ),
        focusedBorder: borderDecoration ?? OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0),
          borderSide: BorderSide(color: Theme.of(context).colorScheme.primary, width: 2),
        ),
      );
}

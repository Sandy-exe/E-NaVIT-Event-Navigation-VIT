import 'package:flutter/material.dart';
import 'package:material_floating_search_bar_2/material_floating_search_bar_2.dart';

class SearchFunction extends StatelessWidget {
  final FloatingSearchBarController controller = FloatingSearchBarController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FloatingSearchBar(
        controller: controller,
        body: Center(child: Text('Search Page')),
        transition: CircularFloatingSearchBarTransition(),
        physics: const BouncingScrollPhysics(),
        title: Text('Search'),
        hint: "Let's Play.....",
        actions: [
          FloatingSearchBarAction.searchToClear()
        ],
        onQueryChanged: (query) {
          // Handle search query changed
        },
        onSubmitted: (query) {
          // Handle submitted search query
        },
        builder: (BuildContext context, Animation<double> transition) {
          return Container(); // Return your search results here
        },
      ),
    );
  }
}
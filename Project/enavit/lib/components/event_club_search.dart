import 'package:flutter/material.dart';
import 'package:material_floating_search_bar_2/material_floating_search_bar_2.dart';

class FloatingSearchBarWidget extends StatefulWidget {
  const FloatingSearchBarWidget({super.key});

  @override
  State<FloatingSearchBarWidget> createState() => _FloatingSearchBarWidgetState();
}

class _FloatingSearchBarWidgetState extends State<FloatingSearchBarWidget> {

  @override
  void initState() {
    super.initState();
  }
  List<String> myData = ['Item 1', 'Item 2', 'Item 3'];
  @override
  Widget build(BuildContext context) {
    final isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
    return FloatingSearchBar(
      backgroundColor: Colors.grey[200],
        automaticallyImplyDrawerHamburger: false,
        automaticallyImplyBackButton: false,
        borderRadius: BorderRadius.circular(25),
        leadingActions: [
          FloatingSearchBarAction(
            showIfOpened: false,
            child: CircularButton(
              icon: const Icon(Icons.search),
              onPressed: () {},
            ),
          )
        ],
        hint: 'Search...',
        scrollPadding: const EdgeInsets.only(top: 16, bottom: 56),
        transitionDuration: const Duration(milliseconds: 800),
        transitionCurve: Curves.easeInOut,
        physics: const BouncingScrollPhysics(),
        axisAlignment: isPortrait ? 0.0 : -1.0,
        openAxisAlignment: 0.0,
        width: isPortrait ? 600 : 500,
        debounceDelay: const Duration(milliseconds: 500),
        onQueryChanged: (query) {
          print(query);
        },
        // Specify a custom transition to be used for
        // animating between opened and closed stated.
        transition: CircularFloatingSearchBarTransition(),
        actions: [
          FloatingSearchBarAction(
            showIfOpened: false,
            child: CircularButton(
              icon: const Icon(Icons.filter_list),
              onPressed: () {

              },
            ),
          ),
          FloatingSearchBarAction.searchToClear(
            showIfClosed: false,
          ),
        ],
        builder: (context, transition) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Material(
              color: Colors.white,
              elevation: 4.0,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: myData.map((e) => ListTile(title: Text(e))).toList(),
              ),
            ),
          );
        },
    
      // child: const TextField(
      //   decoration: InputDecoration(
      //     hintText: "Search",
      //     hintStyle: TextStyle(color: Colors.grey),
      //     prefixIcon: Icon(Icons.search, color: Colors.grey),
      //     border: InputBorder.none,
      //   ),
      // ),
    );
  }
}

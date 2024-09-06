import 'dart:math';

import 'package:enavit_main/components/approver_search_model.dart';
import 'package:enavit_main/services/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:material_floating_search_bar_2/material_floating_search_bar_2.dart';
import 'package:provider/provider.dart';
// +import 'package:implicitly_animated_reorderable_list_2/implicitly_animated_reorderable_list_2.dart';
// import 'package:implicitly_animated_reorderable_list_2/transitions.dart';
import '../models/og_models.dart';

class FloatingSearchBarWidgetApprover extends StatefulWidget {
  const FloatingSearchBarWidgetApprover({super.key});

  @override
  State<FloatingSearchBarWidgetApprover> createState() =>
      _FloatingSearchBarWidgetApproverState();
}

class _FloatingSearchBarWidgetApproverState
    extends State<FloatingSearchBarWidgetApprover> {
  final FloatingSearchBarController controller = FloatingSearchBarController();

  int _index = 0;
  int get index => _index;
  set index(int value) {
    _index = min(value, 2);
    _index == 2 ? controller.hide() : controller.show();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    return Consumer<ApproverSearchModel>(
      builder: (BuildContext context, value, _) => FloatingSearchBar(
        height: 50,
        controller: controller,
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
        scrollPadding: const EdgeInsets.only(top: 16),
        margins: const EdgeInsets.only(bottom: 0),
        transitionDuration: const Duration(milliseconds: 800),
        transitionCurve: Curves.easeInOut,
        physics: const BouncingScrollPhysics(),
        axisAlignment: isPortrait ? 0.0 : -1.0,
        openAxisAlignment: 0.0,
        width: isPortrait ? 600 : 500,
        debounceDelay: const Duration(milliseconds: 100),
        onQueryChanged: value.onQueryChanged,
        progress: false, //value.isLoading,
        // Specify a custom transition to be used for
        // animating between opened and closed stated.
        onKeyEvent: (KeyEvent keyEvent) {
          if (keyEvent.logicalKey == LogicalKeyboardKey.escape) {
            controller.query = '';
            controller.close();
          }
        },
        transition: CircularFloatingSearchBarTransition(),
        actions: [
          FloatingSearchBarAction(
            showIfOpened: false,
            child: CircularButton(
              icon: const Icon(Icons.filter_list),
              onPressed: () {
                Services services = Services();
                services.getParticipantData(context);
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
                children: value.suggestions.map((suggestion) {
                  return buildItem(context, suggestion);
                }).toList(),
              ),
            ),
          );

          // Container(
          //   padding: const EdgeInsets.symmetric(vertical: 16),
          //   child: Material(
          //     color: Colors.white,
          //     borderRadius: BorderRadius.circular(8),
          //     clipBehavior: Clip.antiAlias,
          //     child: ImplicitlyAnimatedList<Users>(
          //       shrinkWrap: true,
          //       physics: const NeverScrollableScrollPhysics(),
          //       items: value.suggestions,
          //       insertDuration: const Duration(milliseconds: 500),
          //       itemBuilder: (BuildContext context, Animation<double> animation,
          //           Users item, _) {
          //         return SizeFadeTransition(
          //           animation: animation,
          //           child: buildItem(context, item),
          //         );
          //       },
          //       updateItemBuilder: (BuildContext context,
          //           Animation<double> animation, Users item) {
          //         return FadeTransition(
          //           opacity: animation,
          //           child: buildItem(context, item),
          //         );
          //       },
          //       areItemsTheSame: (Users a, Users b) => a == b,
          //     ),
          //   ),
          // );
        },

        // child: const TextField(
        //   decoration: InputDecoration(
        //     hintText: "Search",
        //     hintStyle: TextStyle(color: Colors.grey),
        //     prefixIcon: Icon(Icons.search, color: Colors.grey),
        //     border: InputBorder.none,
        //   ),
        // ),
      ),
    );
  }

  Widget buildItem(BuildContext context, Users user) {
    final ThemeData theme = Theme.of(context);
    final TextTheme textTheme = theme.textTheme;

    final ApproverSearchModel model =
        Provider.of<ApproverSearchModel>(context, listen: false);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        InkWell(
          onTap: () {
            FloatingSearchBar.of(context)?.close();
            Future<void>.delayed(
              const Duration(milliseconds: 800),
              () => model.clear(user),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: <Widget>[
                SizedBox(
                  width: 36,
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 500),
                    child: model.suggestions == history
                        ? const Icon(Icons.history, key: Key('history'))
                        : const Icon(Icons.list, key: Key('item')),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        user.name,
                        style: textTheme.titleMedium,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        user.regNo,
                        style: textTheme.bodyMedium
                            ?.copyWith(color: Colors.grey.shade600),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        // if (model.suggestions.isNotEmpty && item != model.suggestions.last)
        //   const Divider(height: 0),
      ],
    );
  }
}

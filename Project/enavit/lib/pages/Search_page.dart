import 'package:flutter/material.dart';
import '../components/Event_tile.dart';
import '../models/event.dart';
import '../models/add_Event.dart';
import 'package:provider/provider.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {

  void addEventToUser(Event event) {
    Provider.of<AddEvent>(context, listen: false).addEventToUser(event);
    // get a Event from Event list
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const  Text('Successfully Added'),
        content: Text('You have successfully added ${event.name} to your list'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
  return Consumer<AddEvent>(
    builder: (context, value, child)=> Column(
        children: [
          //search bar
          Container(
            padding: const EdgeInsets.all(12),
            margin: const EdgeInsets.symmetric(horizontal: 25.0),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(25.0),
            ),
            child: const Row(
              children: [
                Text("Search",style: TextStyle(color: Colors.grey),
                ),
                Icon(
                  Icons.search,
                  color: Colors.grey,
                ),
              ],
            ),
          ),

          //HOT Picks
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 25.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'Available Events',
                  style: TextStyle(
                    fontSize: 24.0, 
                    fontWeight: FontWeight.bold
                    ),
                ),
                Text(
                  "See All",
                  style: TextStyle(
                    color: Colors.blue,
                    ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 10.0,),
          
          //Event List
          Expanded(
            child: ListView.builder(
            itemCount: 3,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context,index) {
              // get a Event from Event list
              Event event = value.getEventList()[index];
              return EventTile(
                event: event,
                onTap: () => addEventToUser(event),
              );
            },
          ),
          ),
        ],
      )
    ); 
  }
}
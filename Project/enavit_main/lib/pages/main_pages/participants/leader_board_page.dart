import 'package:enavit_main/models/og_models.dart';
import 'package:flutter/material.dart';
import 'package:enavit_main/services/leaderBoard.dart';

class LeaderBoardPage extends StatefulWidget {
  final String title;

  const LeaderBoardPage({super.key, required this.title});

  @override
  State<LeaderBoardPage> createState() => _LeaderBoardPageState();
}

class _LeaderBoardPageState extends State<LeaderBoardPage>
    with SingleTickerProviderStateMixin {
  var dropdown = ["Revenue", "Follower Count", "Events Count"];
  var dropdownValue = "Revenue";
  late double tabViewLength = 0;
  late TabController _tabController;
  LeaderBoard leaderBoard = LeaderBoard();
  List<Event> events = [];
  List<Club> clubs = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    fetchData();
  }

  Future<void> fetchData() async {
    print('Fetching data...');
    events = await leaderBoard.getRankingEvents();
    clubs = await leaderBoard.getRankingClubs();
    print('Data fetched');
    tabViewLength = events.length.toDouble() * 100;
    print(tabViewLength);

    setState(() {
      isLoading = false;
    });
  }

  void updateFilter() {
    setState(() {
      isLoading = true;
    });
    if (dropdownValue == "Revenue") {
      clubs.sort((a, b) => b.revenue.compareTo(a.revenue));
    } else if (dropdownValue == "Follower Count") {
      clubs.sort((a, b) => b.followers.length.compareTo(a.followers.length));
    } else if (dropdownValue == "Events Count") {
      clubs.sort((a, b) => b.events.length.compareTo(a.events.length));
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Widget buildLeaderBoard(List<Event> data) {
    return ListView.builder(
      itemCount: data.length,
      itemBuilder: (context, index) {
        Event item = data[index];
        return GestureDetector(
          onTap: () {
            print('Pressed: ${item.eventName}');
          },
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.0),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 8.0,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  item.eventName,
                  style: const TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${index + 1}',
                  style: const TextStyle(
                    fontSize: 16.0,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget buildLeaderBoardClub(List<Club> data) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(40, 20, 20, 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Categorized by:',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton(
                    dropdownColor: Colors.black,
                    value: dropdownValue,
                    iconEnabledColor: Colors.white,
                    icon: const Icon(Icons.keyboard_arrow_down),
                    iconSize: 30,
                    style: const TextStyle(
                      fontSize: 15,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                    items: dropdown.map((String items) {
                      return DropdownMenuItem(
                        value: items,
                        child: Center(child: Text(items)),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        dropdownValue = newValue!;
                        updateFilter();
                      });
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              Club item = data[index];
              return GestureDetector(
                onTap: () {
                  print('Pressed: ${item.clubName}');
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 16.0),
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12.0),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 8.0,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        item.clubName,
                        style: const TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${index + 1}',
                        style: const TextStyle(
                          fontSize: 16.0,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title.isEmpty ? "" : widget.title),
        backgroundColor: Colors.grey[300],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50.0),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: TabBar(
              controller: _tabController,
              dividerColor: Colors.transparent,
              indicatorPadding: const EdgeInsets.symmetric(horizontal: 5.0),
              unselectedLabelColor: const Color.fromARGB(255, 0, 0, 0),
              labelColor: Colors.white,
              indicatorSize: TabBarIndicatorSize.tab,
              indicator: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.black,
              ),
              tabs: const [
                Tab(text: 'Events'),
                Tab(text: 'Clubs'),
              ],
            ),
          ),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
              controller: _tabController,
              children: [
                buildLeaderBoard(events),
                buildLeaderBoardClub(clubs),
              ],
            ),
      backgroundColor: Colors.grey[300],
    );
  }
}

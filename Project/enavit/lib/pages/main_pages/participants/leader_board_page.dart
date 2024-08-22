import 'package:enavit/models/og_models.dart';
import 'package:flutter/material.dart';
import 'package:enavit/services/leaderBoard.dart';

class LeaderBoardPage extends StatefulWidget {
  final String title;

  const LeaderBoardPage({super.key, required this.title});

  @override
  State<LeaderBoardPage> createState() => _LeaderBoardPageState();
}

class _LeaderBoardPageState extends State<LeaderBoardPage>
    with SingleTickerProviderStateMixin {
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
    return ListView.builder(
      itemCount: data.length,
      itemBuilder: (context, index) {
        Club item = data[index];
        return GestureDetector(
          onTap: () {
            print('Pressed: ${item.clubName}');
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
                const Text('Clubs'),
              ],
            ),
      backgroundColor: Colors.grey[300],
    );
  }
}

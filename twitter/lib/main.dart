import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:developer' as developer;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Twitter',
      theme: ThemeData(
        //colorScheme: ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 20, 23, 26)),
        textTheme: const TextTheme(
          headlineMedium: TextStyle(
            color: Color.fromARGB(255, 20, 23, 26),
            fontSize: 24,
            fontFamily: 'Arial',
          ),
        ),
        scaffoldBackgroundColor: Color.fromARGB(255, 20, 23, 26),
      ),
      home: const MyHomePage(title: 'Twitter'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class Tweet {
  final int id;
  final int? parentId;
  final String username;
  final String handle;
  final String text;
  final List<String>? images;

  Tweet({
    required this.id,
    required this.parentId,
    required this.username,
    required this.handle,
    required this.text,
    required this.images,
  });

  factory Tweet.fromJson(Map<String, dynamic> json) {
    return Tweet(
      id: json['id'],
      parentId: json['parentId'],
      username: json['username'],
      handle: json['handle'],
      text: json['text'],
      images:
          json['images'] != null
              ? List<String>.from(json['images'].map((x) => x))
              : null,
    );
  }
}

class TweetList extends StatelessWidget {
  final List<Tweet> tweets;

  const TweetList({super.key, required this.tweets});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: tweets.length,
      itemBuilder: (context, index) {
        final tweet = tweets[index];
        return Card(
          color: const Color.fromARGB(255, 33, 37, 41),
          margin: const EdgeInsets.all(8.0),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      tweet.username,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 8.0),
                    Text(
                      tweet.handle,
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
                const SizedBox(height: 8.0),
                Text(tweet.text, style: const TextStyle(color: Colors.white)),
                if (tweet.images != null && tweet.images!.isNotEmpty) ...[
                  const SizedBox(height: 8.0),
                  SizedBox(
                    height: 100, // Adjust as needed
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: tweet.images!.length,
                      itemBuilder: (context, imageIndex) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Image.network(tweet.images![imageIndex]),
                        );
                      },
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;
  late Future<List<Tweet>> _tweetsFuture;

  @override
  void initState() {
    super.initState();
    _tweetsFuture = readJson();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<List<Tweet>> readJson() async {
    final String response = await DefaultAssetBundle.of(
      context,
    ).loadString('assets/tweets.json');
    final List<dynamic> data = await json.decode(response);
    //developer.log('$data', name: 'JSON Data');
    List<Tweet> tweets = data.map((tweet) => Tweet.fromJson(tweet)).toList();
    //for (var tweet in tweets) {
    //developer.log('Tweet: ${tweet.text}', name: 'Tweet Text');
    //developer.log('Username: ${tweet.username}', name: 'Username');
    //developer.log('Handle: ${tweet.handle}', name: 'Handle');
    //developer.log('Image: ${tweet.images}', name: 'Image');
    //developer.log('Parent ID: ${tweet.parentId}', name: 'Parent ID');
    //developer.log('ID: ${tweet.id}', name: 'ID');
    // }
    return tweets;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title, style: const TextStyle(color: Colors.white)),
        backgroundColor: const Color.fromARGB(255, 20, 23, 26),
      ),
      body: FutureBuilder<List<Tweet>>(
        future: _tweetsFuture,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return TweetList(tweets: snapshot.data!);
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error loading tweets: ${snapshot.error}',
                style: const TextStyle(color: Colors.white),
              ),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(color: Colors.white),
            );
          }
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color.fromARGB(255, 20, 23, 26),
        showUnselectedLabels: false,
        showSelectedLabels: false,
        selectedIconTheme: const IconThemeData(color: Colors.white, size: 30),
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.search_outlined),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Notifications',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.mail), label: 'Messages'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white,
        onTap: _onItemTapped,
      ),
    );
  }
}

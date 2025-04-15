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
      home: const MyHomePage(
      title: 'Twitter',
      ),
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
  final int? id;
  final int parentId;
  final String username;
  final String handle;
  final String text;
  final Image? image;

  Tweet({required this.id, required this.parentId, required this.username, required this.handle, required this.text, required this.image});

  factory Tweet.fromJson(Map<String, dynamic> json) {
    return Tweet(
      id: json['id'],
      parentId: json['parentId'],
      username: json['username'],
      handle: json['handle'],
      text: json['text'],
      image: json['image'],
    );
  }
}

class _MyHomePageState extends State<MyHomePage> {

  int _selectedIndex = 0;  

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<void> readJson() async{
    final String response = await DefaultAssetBundle.of(context).loadString('assets/tweets.json');
    final data = await json.decode(response);
    developer.log(data);
    // Parse the JSON data and use it in your app
    // For example, you can convert it to a list of objects or display it in a widget
    List<Tweet> tweets = (data as List).map((tweet) => Tweet.fromJson(tweet)).toList();
    // use a log framework to print the tweets
    for (var tweet in tweets) {
      //use dart:developer log fucntion to print the tweets and not the math function
      developer.log('Tweet: ${tweet.text}');
      developer.log('Username: ${tweet.username}');
      developer.log('Handle: ${tweet.handle}');
      developer.log('Image: ${tweet.image}');
      developer.log('Parent ID: ${tweet.parentId}');
      developer.log('ID: ${tweet.id}');
      // ignore: avoid_print
      ('Tweet: ${tweet.text}');
      

    }
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(




        bottomNavigationBar: BottomNavigationBar(
    
          type: BottomNavigationBarType.fixed,
          backgroundColor: Color.fromARGB(255, 20, 23, 26),
          showUnselectedLabels: false,
          showSelectedLabels: false,
          selectedIconTheme: IconThemeData(
            color: Colors.white,
            size: 30,
          ),
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search_outlined),
              label: 'Search',
            ),

            BottomNavigationBarItem(
              icon: Icon(Icons.notifications),
              label: 'Notifications',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.mail),
              label: 'Messages',
            ),
  
            
          ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white,
          onTap: _onItemTapped,
        ),

    

  );
  }
}

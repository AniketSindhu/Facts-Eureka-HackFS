import 'dart:convert';
import 'dart:typed_data';
import 'package:facts/Providers/homeScreenProvider.dart';
import 'package:facts/Screens/ThreadItem.dart';
import 'package:facts/Screens/ngrok.dart';
import 'package:facts/Widgets/AppbarMain.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AllThreads extends StatefulWidget {
  final int postId;
  AllThreads({@required this.postId});

  @override
  _AllThreadsState createState() => _AllThreadsState();
}

class _AllThreadsState extends State<AllThreads> {
  List<Thread> threads = [];
  bool _isLoading = true;
  getAllThreads() async {
    http.Response response = await http.get(
      ngrokAddress + "/getallthreads/" + widget.postId.toString(),
    );

    var data = json.decode(response.body);

    for (var thread in data) {
      List<int> image = [];
      List tempImage = jsonDecode(thread["image"]);

      for (var item in tempImage) {
        image.add(item);
      }

      Thread _thread = Thread(
        body: thread["content"],
        threadID: thread["threadId"],
        publisher: thread["user"],
        threads: thread["threads"],
        title: thread["title"],
        upvotes: thread["upvotes"],
        postID: thread["postId"],
        image: Uint8List.fromList(image),
      );
      threads.add(_thread);

      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    getAllThreads();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appbarMain,
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Container(
              child: ListView.separated(
                itemBuilder: (context, index) => ThreadItem(
                  thread: threads[index],
                ),
                separatorBuilder: (context, index) => Divider(),
                itemCount: threads.length,
              ),
            ),
    );
  }
}

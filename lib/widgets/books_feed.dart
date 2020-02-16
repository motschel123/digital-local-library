import 'package:digital_local_libary/widgets/book_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BooksFeed extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new BooksFeedState();
}

class BooksFeedState extends State<BooksFeed> {
  List<String> bookImagePaths = [];

  @override
  void initState() {
    super.initState();
    getNewData2();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      child: ListView.builder(
        itemCount: bookImagePaths.length,
        itemBuilder: (BuildContext context, int index) {
          return new BookCard(bookImagePaths[index]);
        },
      ),
      onRefresh: () {
        return getNewData();
      },
      
    );
  }

  Future<Null> getNewData() async{
    await Future.delayed(Duration(seconds: 1));
    setState(() {
      bookImagePaths = ["assets/testData/cafe-am-rande.jpg", "assets/testData/kaffee.jpg"];
    });
    return null;
  }

  Future<Null> getNewData2() async {
    await Future.delayed(Duration(seconds: 1));
    setState(() {
      bookImagePaths = ["assets/testData/kaffee.jpg"];
    });
    return null; 
  }
}

import 'package:cached_network_image/cached_network_image.dart';
import 'package:digital_local_library/firebase_interfaces/chatting.dart';
import 'package:digital_local_library/sign_in/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:digital_local_library/data/book.dart';

class BookCard implements ExpansionPanelRadio {
  final Book book;
  final Object value;

  final UniqueKey key;

  ExpansionPanelHeaderBuilder _headerBuilder;
  Widget _body;
  bool _isExpanded;
  bool _canTapOnHeader;

  BookCard({this.key, @required this.book, @required this.value}) {
    _canTapOnHeader = true;
    _isExpanded = false;
    _body = _buildBody();
    _headerBuilder = (BuildContext context, bool isExpaned) => _buildHeader();
  }

  Widget _buildBookDescription() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: new RichText(
        text: TextSpan(
          text: 'Description: ',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
          children: [
            TextSpan(
              text: book.description,
              style: TextStyle(fontWeight: FontWeight.normal),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody() {
    return Container(
      color: Colors.grey[200],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(
                  left: 16.0,
                ),
                child: Container(
                  alignment: FractionalOffset.bottomCenter,
                  child: Text("from: ${book.owner.displayName}"),
                ),
              ),
              Builder(builder: (context) {
                return Container(
                  alignment: FractionalOffset.centerRight,
                  child: FlatButton(
                    onPressed: () async {
                      String currentUid =
                          (await AuthProvider.of(context).currentUser())
                              .uid;
                      if (currentUid == book.owner.uid) {
                        Scaffold.of(context).showSnackBar(SnackBar(
                          content: Text("That's your own book"),
                        ));
                      } else {
                        (await ChattingInterface(currentUser: AuthProvider.of(context).currentUser()).getChatWith(book.owner.uid)).pushChatScreen(context);
                      }
                    },
                    child: Text("Message"),
                  ),
                );
              }),
            ],
          ),
          if (book.description != "") _buildBookDescription(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      height: 120.0,
      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Container(
            alignment: FractionalOffset.centerLeft,
            child: CachedNetworkImage(
              placeholder: (context, url) => CircularProgressIndicator(),
              errorWidget: (context, url, error) => Icon(Icons.error),
              imageUrl: book.imagePath,
            ),
          ),
          Expanded(
            child: Container(
              height: 120.0,
              margin: EdgeInsets.only(
                left: 16.0,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Text(
                    book.title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "by ${book.author}",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget get body => _body;

  @override
  bool get canTapOnHeader => _canTapOnHeader;

  @override
  get headerBuilder => _headerBuilder;

  @override
  bool get isExpanded => _isExpanded;
}

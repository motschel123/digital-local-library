import 'package:cached_network_image/cached_network_image.dart';
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

  Widget _buildBody() {
    return Container(
      color: Colors.grey[200],
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(
              left: 16.0,
            ),
            child: Container(
              alignment: FractionalOffset.bottomCenter,
              child: Text("from Max Mustermann"),
            ),
          ),
          Container(
            alignment: FractionalOffset.centerRight,
            child: FlatButton(
              onPressed: () {},
              child: Text("Message"),
            ),
          )
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
                    book.author,
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

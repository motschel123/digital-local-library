import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:digital_local_library/data/book.dart';

class BookCard implements ExpansionPanelRadio {
  final Book book;

  ExpansionPanelHeaderBuilder _headerBuilder;
  Widget _body;
  bool _isExpanded;
  bool _canTapOnHeader;
  Object _value;

  BookCard({@required this.book}) {
    _canTapOnHeader = true;
    _isExpanded = false;
    _body = Text("Von Marcel Schöckel");
    _value = book;
    _headerBuilder = (BuildContext context, bool isExpaned) => isExpanded
        ? null
        : Container(
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

  @override
  Object get value => _value;
}

import 'package:digital_local_library/consts/Consts.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class AppBarModel extends Model {
  final TextEditingController _filter = new TextEditingController();

  Widget _appBarTitle = new Text(Consts.HOMESCREEN_TITLE);
  String _searchText = "";
  Icon _searchIcon = new Icon(Icons.search);

  Widget get appBarTitle => _appBarTitle;

  String get searchText => _searchText;

  Icon get searchIcon => _searchIcon;

  AppBarModel() {
    _filter.addListener(() {
      if (_filter.text.isEmpty) {
        _searchText = "";
      } else {
        _searchText = _filter.text;
      }
      notifyListeners();
    });
  }

  void searchPressed() {
    if (this._searchIcon.icon == Icons.search) {
      this._searchIcon = new Icon(Icons.close);
      this._appBarTitle = new TextField(
        controller: _filter,
        decoration: new InputDecoration(
          prefixIcon: new Icon(Icons.search),
          hintText: 'Search a Book...',
        ),
      );
    } else {
      this._searchIcon = new Icon(Icons.search);
      this._appBarTitle = new Text(Consts.HOMESCREEN_TITLE);
      _filter.clear();
    }
    notifyListeners();
  }
}

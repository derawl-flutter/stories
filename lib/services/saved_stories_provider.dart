import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';

class SavedBooks extends ChangeNotifier{

  List savedStories = [];
  List items = [];

  List get stories => savedStories;


  void getStories(){
    var box = Hive.box('savedStories');
    savedStories = box.get('saved_stories');

  }

  void addSotires(data){
    var box = Hive.box('savedStories');
    savedStories.add(data);
    box.put('saved_stories', savedStories);
    notifyListeners();
  }

  void removeStories(data){
    var box = Hive.box('savedStories');
    savedStories.removeAt(data);
    print(data);
    box.put('saved_stories', savedStories);
    notifyListeners();
  }

  void filter_stories(String value){
    if(value == ''){
      var box = Hive.box('savedStories');
      savedStories = box.get('saved_stories');
    }else{
      print(value);
      savedStories = savedStories.where((element){
        print(element);
        return element['name'].startsWith(value);
      }).toList();
    }
    notifyListeners();
  }


}
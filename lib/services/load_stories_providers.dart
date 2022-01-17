import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'http_server.dart';

class LoadStories extends ChangeNotifier{

  Map stories = {};

  Map get stories_map=>stories;


  void LoadStory() async{
    var African = await Serve().FilteredData('fetch_genre', '', 'African');
    var Fantasy = await Serve().FilteredData('fetch_genre', '', 'Fantasy');
    var History = await Serve().FilteredData('fetch_genre', '', 'History');
    var Scifi  = await Serve().FilteredData('fetch_genre', '', 'Scifi');
    var FolkLore  = await Serve().FilteredData('fetch_genre', '', 'FolkLore');
    var Magical  = await Serve().FilteredData('fetch_genre', '', 'Magical');
    var Western  = await Serve().FilteredData('fetch_genre', '', 'Western');
    var MesoAmerican  = await Serve().FilteredData('fetch', '', 'MesoAmerican');
    var Scary  = await Serve().FilteredData('fetch_genre', '', 'Scary');
    var Asian  = await Serve().FilteredData('fetch_genre', '', 'Asian');
    var FairyTales  = await Serve().FilteredData('fetch_genre', '', 'Fairy Tales');
    var Other  = await Serve().FilteredData('fetch_genre', '', 'Other');
    var All  = await Serve().FilteredData('fetch', '', 'All');
    stories['African'] = African;
    stories['Fantasy'] = Fantasy;
    stories['History'] = History;
    stories['Scifi'] = Scifi;
    stories['FolkLore'] = FolkLore;
    stories['Magical'] = Magical;
    stories['Western'] = Western;
    stories['Other'] = Other;
    stories['MesoAmerican'] = MesoAmerican;
    stories['Scary'] = Scary;
    stories['Asian'] = Asian;
    stories['FairyTales'] = FairyTales;
    stories['All'] = All;
    notifyListeners();
  }

  List returnIds(){
    List ids = [];
    for (var i in stories['ALL']['data']){
      ids.add(i['id']);
    }
    notifyListeners();
    return ids;
  }

}
import 'package:flutter/material.dart';
import '../popular_stories.dart';
import '../components/story_book.dart';
import '../services/http_server.dart';
import 'details.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import '../services/saved_stories_provider.dart';
import '../services/load_stories_providers.dart';
import '../components/book_loading.dart';
String searchTerm = '';
bool hasNoValues = false;
class SearchPage2 extends StatefulWidget {
  static const String route = '/search1';
  const SearchPage2({Key? key}) : super(key: key);

  @override
  State<SearchPage2> createState() => _SearchPageState2();
}

class _SearchPageState2 extends State<SearchPage2> {
  List FilterData(popular){
    List dataList = [];
    if(searchTerm != ''){
      for(var data in popular){
        if(data['name'].toString().toLowerCase().contains(searchTerm.toLowerCase().trim())){
          dataList.add(data);
        }
      }
    }else{
      dataList = popular;
    }
    return dataList;
  }
  //Get functions---------------------------------------------------------
  Future Load(String genre) async{
    var popular = await this.context.watch<LoadStories>().stories_map[genre]['data'];
    List dataList =  FilterData(popular);
    return dataList;
  }
  


  @override
  void initState() {
    // TODO: implement initState
    context.read<LoadStories>().LoadStory();
    super.initState();
  }



  //Get functions done------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    List books = Fecth().returnProducts();
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        leading: IconButton(onPressed: (){searchTerm = ''; Navigator.pop(context);}, icon: Icon(Icons.arrow_back),),
        bottom: PreferredSize(
            child:Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 2),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                //border: Border.all(width: 1, color: Colors.black),
              ),
              child: TextField(
                onChanged: (value){
                  setState(() {
                    searchTerm = value;
                  });
                },
                decoration:InputDecoration(
                    prefixIcon: Icon(Icons.search, color: Colors.black45,),
                    hintText: 'Search for your favourite stories',
                    focusColor: Colors.white,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    fillColor: Colors.white
                ),

              ),
            ),
            preferredSize: Size.fromHeight(40)),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            BuilderWidget(method: Load('FolkLore'), title: 'FolkLore'),
            BuilderWidget(method: Load('Fantasy'), title: 'Fantasy'),
            BuilderWidget(method: Load('FairyTales'), title: 'Fairy Tales'),
            BuilderWidget(method: Load('Magical'), title: 'Magical'),
            BuilderWidget(method: Load('History'), title: 'History'),
            BuilderWidget(method: Load('Scifi'), title: 'Scifi'),
            BuilderWidget(method: Load('Scary'), title: 'Scary'),
            BuilderWidget(method: Load('Other'), title: 'Other'),
          ],
        )
      )

    );
  }
}


class BuilderWidget extends StatefulWidget {
  BuilderWidget({Key? key, required this.method, required this.title}) : super(key: key);
  final Future method;
  final String title;

  @override
  State<BuilderWidget> createState() => _BuilderWidgetState();
}

class _BuilderWidgetState extends State<BuilderWidget> {
  bool isSavedBook(ids, id){
    if(ids.contains(id)){
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: widget.method,
      builder: (context, AsyncSnapshot snapshot){
        if(!snapshot.hasData && !snapshot.hasError){
          return Center(child: CircularProgressIndicator());
        }else if(snapshot.hasData){
          hasNoValues = false;
          if(snapshot.data.length > 0) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 10,),
                Container(
                    margin: EdgeInsets.only(left: 10),
                    child: Text(widget.title.toString(), style: TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.w900,
                        fontSize: 22),)
                ),
                SizedBox(height: 5,),
                Container(
                  height: MediaQuery
                      .of(context)
                      .size
                      .height * 0.2,
                  width: double.infinity,
                  margin: EdgeInsets.symmetric(vertical: 10),
                  child: ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) {
                      List ids = [];
                      var box = Hive.box('savedStories');
                      var id =  snapshot.data[index]['id'];
                      var items = box.get('saved_stories');
                      if (items.length > 0){
                        for(var i in items){
                          ids.add(i['id']);
                        }
                      }
                      bool isSavedIcon = isSavedBook(ids, id);
                      return Stack(
                        children: [
                          StoryBook(
                            bookImage: snapshot.data[index]['image'],
                            pressed: () {
                              Navigator.push(
                                  context, MaterialPageRoute(builder: (context) {
                                return DetailsPage(
                                  id: snapshot.data[index]['id'],
                                  coverImage: snapshot.data[index]['image'],);
                              }));
                            },
                          ),
                          Positioned(
                            left: 87,
                            top: -7,
                            child: IconButton(onPressed: (){
                              setState(() {
                                isSavedIcon = !isSavedIcon;
                              });

                              List stories = [];
                              List ids = [];
                              var box = Hive.box('savedStories');
                              var image =  snapshot.data[index]['image'].toString();
                              var id =  snapshot.data[index]['id'];
                              var items = box.get('saved_stories');
                              if (items.length > 0){
                                for(var i in items){
                                  stories.add(i);
                                  ids.add(i['id']);
                                }
                              }
                              bool isSaved = isSavedBook(ids, id);
                              if (isSaved == false){
                                context.read<SavedBooks>().addSotires({'id':id, 'image':image, 'name':snapshot.data[index]['name'].toString().toLowerCase(), 'pages': snapshot.data[index]['story']});
                              }

                            },
                                icon: Icon(isSavedIcon ? Icons.favorite:Icons.favorite_border, color: Colors.lightBlueAccent, size: 24,)
                            ),
                          )
                        ],
                      );
                    },
                    scrollDirection: Axis.horizontal,

                  ),
                ),
              ],
            );
          }else{
            return Container();
          }
          //else{
          //   hasNoValues = true;
          //   return Container();
          // }
        }
        return BookLoading();

      },
    );
  }
}

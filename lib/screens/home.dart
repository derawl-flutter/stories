import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';
import 'package:stories/screens/account.dart';
import 'package:stories/services/saved_stories_provider.dart';
import '../popular_stories.dart';
import 'details.dart';
import 'search.dart';
import '../components/story_book.dart';
import '../services/http_server.dart';
import 'st.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import '../components/book_loading.dart';
class MyHomePage extends StatefulWidget {
  static const String route = '/home';
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future data() async{
    var items = await Serve().Data('fetch');
    return items['data'];
  }

  bool isSavedBook(ids, id){
    if(ids.contains(id)){
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    List stories = Fecth().returnProducts();
    return Scaffold(
      backgroundColor: Color(0xff9354b9),
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.blue.shade900,
                  Color(0xff9354b9),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [0.3, 0.7],
              )
          ),
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Heading(),
                Container(
                  height: 420.0,
                  child: FutureBuilder(
                    future: data(),
                      builder: (context, AsyncSnapshot item){
                        if(item.hasData){
                          return Swiper(
                            itemCount: item.data.length,
                            itemWidth: MediaQuery.of(context).size.width - 2 * 54,
                            layout: SwiperLayout.STACK,
                            itemBuilder: (context, index){
                              String image = item.data[index]['image'].toString();
                              List ids = [];
                              var box = Hive.box('savedStories');
                              var id =  item.data[index]['id'];
                              var items = box.get('saved_stories');
                              if (items.length > 0){
                                for(var i in items){
                                  stories.add(i);
                                  ids.add(i['id']);
                                }
                              }
                              bool isSavedIcon = isSavedBook(ids, id);
                              return InkWell(
                                onTap: () async{
                                  Navigator.push(context, MaterialPageRoute(builder: (context){
                                    return DetailsPage(id: item.data[index]['id'], planetInfo: item.data[index]['id'], coverImage: item.data[index]['image'],);
                                  }));
                                },
                                child: Stack(
                                  children: [
                                    Column(
                                      children: [
                                        SizedBox(height: 20),
                                        Container(
                                          height: 350,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            image: DecorationImage(image:  NetworkImage(item.data[index]['image'] != null? image : 'https://i.ibb.co/nQPfjD7/6b2015b8f444.jpg'), fit: BoxFit.fill),
                                            borderRadius: BorderRadius.circular(20)
                                          ),
                                        ),
                                      ],
                                    ),
                                    Positioned(
                                      left: 200,
                                      top: 20,
                                      child: IconButton(onPressed: (){
                                        setState(() {
                                          isSavedIcon = !isSavedIcon;
                                        });

                                        List stories = [];
                                        List ids = [];
                                        var box = Hive.box('savedStories');
                                        var image =  item.data[index]['image'].toString();
                                        var id =  item.data[index]['id'];
                                        var items = box.get('saved_stories');
                                        if (items.length > 0){
                                          for(var i in items){
                                            stories.add(i);
                                            ids.add(i['id']);
                                          }
                                        }
                                        bool isSaved = isSavedBook(ids, id);
                                        if (isSaved == false){
                                          context.read<SavedBooks>().addSotires({'id':id, 'image':image, 'name':item.data[index]['name'].toString().toLowerCase(), 'pages': item.data[index]['story']});
                                        }

                                      },
                                          icon: Icon(isSavedIcon ? Icons.favorite:Icons.favorite_border, color: Colors.lightBlueAccent, size: 30,)
                                      ),
                                    )
                                    // Container(
                                    //   margin: EdgeInsets.only(top: 20),
                                    //   child: CircleAvatar(
                                    //     backgroundImage: NetworkImage(
                                    //       image,
                                    //     ),
                                    //   ),
                                    //   // child: Image.network(image),
                                    //   width: double.infinity,
                                    //   height: 190,
                                    //
                                    // )
                                  ],
                                ),

                              );
                            },

                          );
                        }else{
                          return Container(child: Center(child: CircularProgressIndicator()),);
                        }
                      }),

                ),

                //Second section---------------------------------------
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                              margin: EdgeInsets.only(left: 10),
                              child: Text('Suggestions', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 22),)
                          ),
                          Container(
                            height: MediaQuery.of(context).size.height * 0.2,
                            width: double.infinity,
                            margin: EdgeInsets.symmetric(vertical: 10),
                            child: FutureBuilder(
                              future: data(),
                              builder: (context, AsyncSnapshot snapshot){
                                if(snapshot.hasData){
                                  return ListView.builder(
                                    itemCount: snapshot.data.length,
                                    itemBuilder: (context, index){
                                      List ids = [];
                                      var box = Hive.box('savedStories');
                                      var id =  snapshot.data[index]['id'];
                                      var items = box.get('saved_stories');
                                      if (items.length > 0){
                                        for(var i in items){
                                          stories.add(i);
                                          ids.add(i['id']);
                                        }
                                      }
                                      bool isSavedIcon = isSavedBook(ids, id);
                                        return Stack(
                                          children: [
                                            StoryBook(
                                              bookImage: snapshot.data[index]['image'],
                                              pressed: (){
                                                Navigator.push(context, MaterialPageRoute(builder: (context){
                                                  return DetailsPage(id: snapshot.data[index]['id'], coverImage: snapshot.data[index]['image'],);
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

                                  );
                                }
                                return BookLoading();
                              },
                            )
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigator(),
    );
  }
}

class BottomNavigator extends StatelessWidget {
  const BottomNavigator({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
          color: Color(0xff6751b5),
          borderRadius: BorderRadius.vertical(top: Radius.circular(0))
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Row(
            children: [
              IconButton(onPressed: (){}, icon: Icon(Icons.explore, color: Colors.white, size: 32,)),
              Text('Explore', style: TextStyle(color: Colors.white, fontSize: 20),)
            ],
          ),
          IconButton(onPressed: (){
            Navigator.pushNamed(context, SearchPage2.route);

          }, icon: Icon(Icons.search, color: Colors.white70,  size: 32,)),
          IconButton(onPressed: (){
            Navigator.pushNamed(context, SavedStories.route);
          }, icon: Icon(Icons.favorite_border, color: Colors.white70,  size: 32,)),

        ],
      ),
    );
  }
}

class Heading extends StatelessWidget {
  const Heading({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Explore',
            style: TextStyle(
                fontSize: 44,
                color: Colors.white,
                fontWeight: FontWeight.bold),
          ),
          Text(
            'stories',
            style: TextStyle(
                fontSize: 24,
                color: Colors.white,
                fontWeight: FontWeight.w300),
          ),
          // DropdownButton<String>(
          //   items: [
          //     DropdownMenuItem(
          //       child: Text(
          //         'African Tales',
          //         style: TextStyle(color: Colors.white70,
          //             fontWeight: FontWeight.w500,
          //             fontSize: 24
          //         ),
          //       ),
          //     ),
          //   ],
          //   onChanged: (value){},
          //   underline: SizedBox(),
          //
          // ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../popular_stories.dart';
import '../components/story_book.dart';
import '../services/http_server.dart';
import 'details.dart';

String searchTerm = '';
class SearchPage extends StatefulWidget {
  static const String route = '/search';
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  Future FilteredData() async{
    var items = await Serve().FilteredData('fetch', searchTerm, 'African');
    print(items['data'][0]);
    return items['data'];
  }

  @override
  Widget build(BuildContext context) {
    List books = Fecth().returnProducts();
    print(books[0]['image']);

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
                  FilteredData();
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20,),
                Container(
                    margin: EdgeInsets.only(left: 10),
                    child: Text('Popular', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w900, fontSize: 22),)
                ),
                SizedBox(height: 5,),
                Container(
                    height: MediaQuery.of(context).size.height * 0.2,
                    width: double.infinity,
                    margin: EdgeInsets.symmetric(vertical: 10),
                    child: FutureBuilder(
                      future: FilteredData(),
                      builder: (context, AsyncSnapshot snapshot){
                        if(snapshot.hasData){
                          return ListView.builder(
                            itemCount: snapshot.data.length,
                            itemBuilder: (context, index){
                              return StoryBook(
                                  bookImage: snapshot.data[index]['image'],
                                pressed: (){
                                  Navigator.push(context, MaterialPageRoute(builder: (context){
                                    return DetailsPage(planetInfo: snapshot.data[index]['story'], coverImage: snapshot.data[index]['image'],);
                                  }));
                                },
                              );
                            },
                            scrollDirection: Axis.horizontal,

                          );
                        }else if(snapshot.hasError){
                          return Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text('No data available'),
                          );
                        }
                        return Center(child: CircularProgressIndicator());
                      },
                    )
                ),

              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20,),
                Container(
                    margin: EdgeInsets.only(left: 10),
                    child: Text('Fanatsy', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w900, fontSize: 22),)
                ),
                SizedBox(height: 5,),
                Container(
                    height: MediaQuery.of(context).size.height * 0.2,
                    width: double.infinity,
                    margin: EdgeInsets.symmetric(vertical: 10),
                    child: FutureBuilder(
                      future: FilteredData(),
                      builder: (context, AsyncSnapshot snapshot){
                        if(snapshot.hasData){
                          return ListView.builder(
                            itemCount: snapshot.data.length,
                            itemBuilder: (context, index){
                              return StoryBook(
                                  bookImage: snapshot.data[index]['image'],
                                pressed: (){
                                  Navigator.push(context, MaterialPageRoute(builder: (context){
                                    return DetailsPage(planetInfo: snapshot.data[index]['story'], coverImage: snapshot.data[index]['image'],);
                                  }));
                                },
                              );
                            },
                            scrollDirection: Axis.horizontal,

                          );
                        }
                        return Center(child: CircularProgressIndicator());
                      },
                    )
                ),

              ],
            ),
          ],
        ),
      ),

    );
  }
}



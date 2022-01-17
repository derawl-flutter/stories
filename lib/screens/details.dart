import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../books.dart';
import '../popular_stories.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:stories/services/admob_helper.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/http_server.dart';
import '../services/load_stories_providers.dart';
import 'package:provider/provider.dart';
import 'dart:math';
int pgo = 0;

class DetailsPage extends StatefulWidget {
  static const String route = '/details';
  DetailsPage({Key? key, required this.coverImage, this.planetInfo, this.id}) : super(key: key);

  final int? planetInfo;
  final String coverImage;
  final int? id;

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  List stories_list = [];
  int randomInt = 0;

  PageController controller = PageController(
      initialPage: 3
      );

  // ignore: prefer_typing_uninitialized_variables
  //Future? story;

  Future returnStories() async{
    Map store = await Serve().returnStoryPages(widget.id);
    List storyList = store['data'];
    return storyList;
  }


  InterstitialAd? interstitialAd;
  bool isInterstitialAdReady = false;

  _loadAd(){
    InterstitialAd.load(
        adUnitId: AdMobHelper.interId,
        request: AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
            onAdLoaded: (ad){
              this.interstitialAd = ad;
              ad.fullScreenContentCallback = FullScreenContentCallback(
                onAdDismissedFullScreenContent: (ad){

                }
              );
              isInterstitialAdReady = true;
            },
            onAdFailedToLoad: (err){
              print(err);
            }));
  }


  Future returnAllStories() async{
    var all = await Serve().Data('fetch');
    stories_list = all['data'];
  }

  Future returnSuggestion() async{
    var suggestion =  await Serve().Suggestion(widget.id);
    List data = suggestion['data'];
    return data;

  }

  @override
  void initState(){
    _loadAd();
    // TODO: implement initState
   returnAllStories();
    WidgetsBinding.instance!.addPostFrameCallback((_) async {
      await returnAllStories();
      setState(() {
        stories_list.retainWhere((element) => element['id'] == widget.id);
        randomInt = Random().nextInt(stories_list.length-1);
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    interstitialAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    print(stories_list);
    print(stories_list.length);

    print("----------------------------------------------------------------");

    // popular.removeWhere((value) => value['id'] == widget.id);
    // print('length ${popular.length}');


    return WillPopScope(
      onWillPop: () async{
        if(isInterstitialAdReady == true){
          interstitialAd?.show();
        }
        Navigator.pop(context);
        return false;
      },
      child: Scaffold(

        body: SafeArea(
          bottom: false,
          child: FutureBuilder(
            future: returnStories(),
            builder: (BuildContext context,  AsyncSnapshot snapshot){
              if(snapshot.hasData){
                List story_chosen = snapshot.data;
                return PageView.builder(

                    itemCount: story_chosen.length + 1,
                    scrollBehavior: ScrollBehavior(),
                    itemBuilder: (context, index){
                      Widget currentPage;
                      //print(story_chosen.length);
                      if(index == 0){
                        currentPage = Hero(
                          tag: widget.coverImage,
                          child: Container(
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: NetworkImage(widget.coverImage),
                                    fit: BoxFit.fill

                                )
                            ),
                          ),
                        );
                      }else{
                        if (story_chosen.length == 0){
                          currentPage = Container();
                        }else if(index == 1 && index < story_chosen.length){
                          currentPage = Stack(
                          children: [
                            Opacity(
                              opacity: 0.08,
                              child: Center(
                                  child: CircleAvatar(
                                    radius: 250,
                                    backgroundImage: NetworkImage(
                                        widget.coverImage),
                                  )
                                ,)
                              ,),
                            Positioned(
                              right: -60,
                              top: -19,
                              child: Hero(
                                tag:  widget.coverImage,
                                child: CircleAvatar(
                                  radius: 100,
                                  backgroundImage: NetworkImage(
                                    widget.coverImage,

                                  ),
                                ),
                              ),
                            ),
                            SingleChildScrollView(
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 100,),
                                  Text(story_chosen[0]['name'],
                                    style: TextStyle(
                                        fontWeight: FontWeight.w900,
                                        fontSize: 60,
                                        color: Colors.grey.shade400
                                    ),
                                  ),
                                  Divider(color: Colors.black45,),
                                  Html(data: story_chosen[index]['story'],
                                    style: {
                                      'h3': Style(fontSize: FontSize.xxLarge, fontWeight: FontWeight.w300),
                                      'p': Style(fontSize: FontSize.xxLarge, fontWeight: FontWeight.w300),
                                      'h2': Style(fontSize: FontSize.xxLarge, fontWeight: FontWeight.w300),
                                    },
                                  ),
                                ],
                              ),
                            ),

                          ],
                        );} else if(index < story_chosen.length){
                          currentPage = Stack(
                            children: [
                              Container(
                                height: MediaQuery.of(context).size.height * 1,
                                child: Opacity(
                                  opacity: 0.05,
                                  child: Image.network(
                                      widget.coverImage,
                                      fit: BoxFit.cover
                                  )
                                  ,),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
                                child: Container(
                                  height: MediaQuery.of(context).size.height * 1,
                                  child: ListView(
                                      children: [
                                        Html(data: story_chosen[index]['story'],
                                          style: {
                                            'h3': Style(fontSize: FontSize.xxLarge, fontWeight: FontWeight.w300),
                                            'p': Style(fontSize: FontSize.xxLarge, fontWeight: FontWeight.w300),
                                            'h2': Style(fontSize: FontSize.xxLarge, fontWeight: FontWeight.w300),
                                          },
                                        ),
                                      ]
                                  ),
                                ),
                              ),
                            ],
                          );
                        }else{
                          currentPage = Stack(
                            children: [
                              Opacity(
                                opacity: 0.06,
                                child: Center(
                                  child: CircleAvatar(
                                    radius: 250,
                                    backgroundImage: NetworkImage(
                                        widget.coverImage),
                                  )
                                  ,)
                                ,),
                              Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(height: 50),
                                    Text('THE END', style: GoogleFonts.aladin(fontSize: 56)
                                    ),
                                    FutureBuilder(
                                        future: returnSuggestion(),
                                        builder: (context, AsyncSnapshot snapshot){
                                          if(snapshot.hasData){
                                            return Container(
                                              child: Center(child: Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  SizedBox(height: 20),
                                                  Text('Up Next', style: GoogleFonts.lato(fontSize: 20)),
                                                  SizedBox(height: 10),
                                                  GestureDetector(
                                                    onTap: (){
                                                      if(isInterstitialAdReady == true){
                                                        interstitialAd?.show();
                                                      }
                                                      Navigator.pop(context);
                                                      Navigator.push(context, MaterialPageRoute(builder: (context){
                                                        return DetailsPage(
                                                            id: snapshot.data[0]['id'],
                                                            planetInfo: snapshot.data[0]['id'],
                                                            coverImage: snapshot.data[0]['image']
                                                        );
                                                      }));
                                                    },
                                                    child: Column(
                                                      children: [
                                                        CircleAvatar(
                                                          radius: 60,
                                                          backgroundImage: NetworkImage(snapshot.data[0]['image'].toString()),
                                                        ),
                                                        SizedBox(height: 5,),
                                                        Text(snapshot.data[0]['name'], style: GoogleFonts.lato(fontSize: 20, color: Colors.blue, fontWeight: FontWeight.w700),)
                                                      ],
                                                    ),
                                                  ),

                                                ],
                                              )),
                                            );
                                          }else{
                                            return CircularProgressIndicator(color: Colors.purple,);
                                          }

                                        }
                                    )
                                  ],
                                ),
                              ),
                            ],
                          );
                        }
                      }
                      return currentPage;
                    }
                    );
              }else{
                return Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(image: NetworkImage(widget.coverImage), fit: BoxFit.fill)
                  ),
                  child: Container(
                    color: Colors.white.withOpacity(0.4),
                      child: Center(child: CircularProgressIndicator())),);
              }
            },
          )



        ),
      ),
    );
  }
}


// currentPage = Column(
//   children: [
//     Stack(
//       children: [
//         SingleChildScrollView(
//           padding: EdgeInsets.symmetric(horizontal: 20),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               SizedBox(height: 300,),
//               Text(
//                 story_chosen[index]['title'],
//                 style: TextStyle(
//                   fontSize: 40.0,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               SizedBox(height: 10.0,),
//               Divider(color: Colors.black45,),
//               Text('Story Text')
//             ],
//           ),
//         ),
//         Positioned(
//           right: -60,
//           child: Image.asset(
//             planetInfo['image'],
//             width: 200,
//           ),
//         ),
//         Positioned(
//             top: 60,
//             left: 30,
//             child: Text('5',
//               style: TextStyle(
//                   fontWeight: FontWeight.w900,
//                   fontSize: 247,
//                   color: Colors.grey.shade300
//               ),
//             )
//         )
//       ],
//     ),
//
//   ],
// );
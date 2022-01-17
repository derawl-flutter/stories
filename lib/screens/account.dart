import 'package:flutter/material.dart';
import 'package:stories/components/story_book1.dart';
import 'details.dart';
import 'package:stories/services/saved_stories_provider.dart';
import 'package:provider/provider.dart';
import '../services/admob_helper.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
String searchTerm = '';
class SavedStories extends StatefulWidget {
  const SavedStories({Key? key}) : super(key: key);
  static const String route = '/account';

  @override
  State<SavedStories> createState() => _SavedStoriesState();
}

class _SavedStoriesState extends State<SavedStories> {
  late BannerAd _bannerAd;
  bool _isBannerAdReady = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _bannerAd = BannerAd(
        size: AdSize.banner,
        adUnitId: AdMobHelper.bannerId,
        listener: BannerAdListener(

            onAdLoaded: (_){
              setState(() {
                _isBannerAdReady = true;
                print('loaded');
              });
            },


            onAdFailedToLoad: (ad, err){
              print('ad failed to load');
              _isBannerAdReady = false;
              ad.dispose();
            }
        ),


        request: AdRequest()
    );

    _bannerAd.load();
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _bannerAd.dispose();
  }
  @override
  Widget build(BuildContext context) {
    List stories =  context.watch<SavedBooks>().stories;
    return Scaffold(
        appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        leading: IconButton(onPressed: (){Navigator.pop(context);}, icon: Icon(Icons.arrow_back),),
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
                    searchTerm = value;
                    context.read<SavedBooks>().filter_stories(searchTerm);
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
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 20,),
                  Text('Your Favourite Stories', style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 27,
                  ),),
                  SizedBox(height: 20,),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.75,
                    child: GridView.builder(
                      itemCount: stories.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            mainAxisSpacing: 30
                        ),
                        itemBuilder: (context, index){
                          return Stack(
                            children: [
                              StoryBook(
                                  bookImage: stories[index]['image'],
                                  pressed: (){
                                    Navigator.push(context, MaterialPageRoute(builder: (context){
                                      return DetailsPage(id: stories[index]['id'], coverImage: stories[index]['image'],);
                                    }));
                                  }
                                  ),
                              Positioned(
                                left: 95,
                                  top: 0,
                                  child: GestureDetector(
                                    onTap: (){
                                      context.read<SavedBooks>().removeStories(index);
                                    },
                                    child: Container(
                                      padding: EdgeInsets.symmetric(horizontal: 9, vertical: 6),
                                      child: Text('x', style: TextStyle(color: Colors.white, fontSize: 16),),
                                      decoration: BoxDecoration(
                                        color: Colors.redAccent,
                                        borderRadius: BorderRadius.circular(20)
                                      )
                                    ),
                                  ),
                              )
                            ],
                          );
                        }),
                  ),

                ],
              ),
            ),
            if(_isBannerAdReady)
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                    height: 60,
                    child: AdWidget(ad: _bannerAd)),
              ),
          ],
        ),

    );
  }
}

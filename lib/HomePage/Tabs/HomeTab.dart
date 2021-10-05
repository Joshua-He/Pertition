import 'package:carousel_slider/carousel_slider.dart';
import 'package:colorful_safe_area/colorful_safe_area.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:pertition/Ads/ad_helper.dart';
import 'package:pertition/BackendFunctions/Posts.dart';
import 'package:pertition/BackendFunctions/UploadMedia.dart';
import 'package:pertition/Media/VideoConstructor.dart';
import 'package:pertition/constants.dart';

import 'package:video_player/video_player.dart';

class HomeTab extends StatefulWidget {
  @override
  _HomeTabState createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  VideoPlayerController _controller;
  int test = 0;
  Map<String, dynamic> posts;
  List<int> postsLikes;

  InterstitialAd _interstitialAd;
  int _numInterstitialLoadAttempts = 0;

  getPosts() async {
    getPostsMain('{"appcategory": "main"}').then((value) {
      setState(() {
        posts = value;
        postsLikes = List.filled(posts["Count"], 0);
      });
    });
  }

  //BannerAd _ad;

  // TODO: Add _isAdLoaded
  //bool _isAdLoaded = false;

  @override
  void initState() {
    getPosts();

    _controller = VideoPlayerController.network(
        'https://pertition-media-testing.s3.us-west-2.amazonaws.com/Joshua+He-IMG_0013.mov')
      ..initialize().then((_) {
        setState(() {});
      });

    super.initState();
/*
    _ad = BannerAd(
      adUnitId: AdHelper.bannerAdUnitId,
      size: AdSize.banner,
      request: AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) {
          setState(() {
            _isAdLoaded = true;
          });
        },
        onAdFailedToLoad: (ad, error) {
          // Releases an ad resource when it fails to load
          ad.dispose();

          print('Ad load failed (code=${error.code} message=${error.message})');
        },
      ),
    );

    _ad.load();
    */
  }

  @override
  void dispose() {
    // _ad.dispose();
    super.dispose();
    _controller.dispose();
  }

  getWidth(String category) {
    if (category == "deforestation") {
      return 0.26;
    }
    if (category == "water") {
      return 0.13;
    }
    if (category == "pollution") {
      return 0.2;
    }
    if (category == "emissions") {
      return 0.2;
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
    var padding = MediaQuery.of(context).padding;
    double height =
        MediaQuery.of(context).size.height - padding.top - padding.bottom;
    double width = MediaQuery.of(context).size.width;

    scrollFeedMain(int count) {
      return Container(
        height: height * 1,
        child: ListView.builder(
            itemCount: count,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                margin: EdgeInsets.only(bottom: height * 0.04),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ///Picture arousel
                    CarouselSlider.builder(
                      options: CarouselOptions(
                        enableInfiniteScroll: false,
                        onPageChanged: (index, reason) {},
                        viewportFraction: 1,
                      ),
                      itemCount: posts["Items"][index]["mediacount"],
                      itemBuilder: (BuildContext context, int itemIndex,
                              int pageViewIndex) =>
                          Container(
                        width: width,
                        child: posts["Items"][index]["media"][itemIndex]
                                    .substring(posts["Items"][index]["media"]
                                                [itemIndex]
                                            .length -
                                        4) ==
                                ".mov"
                            ? GestureDetector(
                                onTap: () {
                                  _controller.play();
                                  _controller.setLooping(true);
                                },
                                child: AspectRatio(
                                    aspectRatio: _controller.value.aspectRatio,
                                    child: VideoPlayer(_controller)),
                              )
                            //VideoConstructor(
                            //  url: posts["Items"][index]["media"][itemIndex])
                            : Image.network(
                                posts["Items"][index]["media"][itemIndex],
                                fit: BoxFit.cover,
                              ),
                      ),
                    ),

                    ///location and category and userid
                    Container(
                      margin: EdgeInsets.only(top: height * 0.02),
                      padding: EdgeInsets.only(
                          left: width * 0.04, right: width * 0.03),
                      child: Stack(
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                ///Profile Picture
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(100),
                                  child: Container(
                                    height: height * 0.04,
                                    width: height * 0.04,
                                    child: Image.asset(
                                      'pictures/clean.jpg',
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    GestureDetector(
                                      onTap: () {},
                                      child: Container(
                                        margin: EdgeInsets.only(
                                            left: width * 0.02,
                                            bottom: width * 0.01),
                                        child: Text(
                                          posts["Items"][index]["userid"],
                                          style: TextStyle(fontSize: 15),
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {},
                                      child: Container(
                                        margin:
                                            EdgeInsets.only(left: width * 0.02),
                                        child: Text(
                                          posts["Items"][index]["address"]
                                                      .length <
                                                  41
                                              ? posts["Items"][index]["address"]
                                              : posts["Items"][index]["address"]
                                                      .substring(0, 41) +
                                                  "..",
                                          style: TextStyle(
                                              fontSize: 12, color: Colors.grey),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    Container(
                      padding: EdgeInsets.only(
                          left: width * 0.03, right: width * 0.03),
                      margin: EdgeInsets.only(
                          top: width * 0.02, left: width * 0.015),
                      child: Text(posts["Items"][index]["caption"],
                          style: TextStyle(fontSize: 14)),
                    ),

                    ///trees and comments
                    Container(
                      width: width,
                      height: height * 0.05,
                      margin: EdgeInsets.only(top: height * 0.01),
                      padding: EdgeInsets.only(
                          left: width * 0.03, right: width * 0.03),
                      child: Stack(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              GestureDetector(
                                onTap: () {},
                                child: Container(
                                  height: height * 0.05,
                                  width: width * 0.11,
                                  margin: EdgeInsets.only(left: width * 0.0),
                                  child: Icon(
                                    FlutterIcons.comment_evi,
                                    size: 35,
                                  ),
                                ),
                              ),

                              ///dynamic like
                              /*
                              test == 0
                                  ? GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          test = 1;
                                        });
                                      },
                                      child: Container(
                                        margin: EdgeInsets.only(left: width * 0.02),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Container(
                                                  height: height * 0.014,
                                                  width: height * 0.014,
                                                  decoration: BoxDecoration(
                                                    color: white,
                                                    border: Border(
                                                      left: BorderSide(
                                                          width: 1, color: black),
                                                      top: BorderSide(
                                                          width: 1, color: black),
                                                      bottom: BorderSide(
                                                          width: 1, color: black),
                                                      right: BorderSide(
                                                          width: 0.5, color: black),
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  height: height * 0.014,
                                                  width: height * 0.014,
                                                  decoration: BoxDecoration(
                                                    color: white,
                                                    border: Border(
                                                      left: BorderSide(
                                                          width: 0.5, color: black),
                                                      top: BorderSide(
                                                          width: 1, color: black),
                                                      bottom: BorderSide(
                                                          width: 1, color: black),
                                                      right: BorderSide(
                                                          width: 1, color: black),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Container(
                                              height: height * 0.014,
                                              width: height * 0.014,
                                              decoration: BoxDecoration(
                                                color: white,
                                                border: Border(
                                                  left: BorderSide(
                                                      width: 1, color: black),
                                                  bottom: BorderSide(
                                                      width: 1, color: black),
                                                  right: BorderSide(
                                                      width: 1, color: black),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                  : GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          test = 0;
                                        });
                                      },
                                      child: Container(
                                        margin: EdgeInsets.only(left: width * 0.02),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Container(
                                                  height: height * 0.014,
                                                  width: height * 0.014,
                                                  color: Colors.green,
                                                ),
                                                Container(
                                                  height: height * 0.014,
                                                  width: height * 0.014,
                                                  color: Colors.green.withRed(200),
                                                ),
                                              ],
                                            ),
                                            Container(
                                              height: height * 0.014,
                                              width: height * 0.014,
                                              color: Colors.brown.withRed(200),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                    */
                              ///+1
                              GestureDetector(
                                onTap: () {
                                  InterstitialAd.load(
                                      adUnitId:
                                          'ca-app-pub-8355251097720440/6548109517',
                                      request: AdRequest(),
                                      adLoadCallback:
                                          InterstitialAdLoadCallback(
                                        onAdLoaded: (InterstitialAd ad) {
                                          // Keep a reference to the ad so you can show it later.
                                          this._interstitialAd = ad;
                                        },
                                        onAdFailedToLoad: (LoadAdError error) {
                                          print(
                                              'InterstitialAd failed to load: $error');
                                        },
                                      ));
                                  if (postsLikes[index] == 1) {
                                    setState(() {
                                      postsLikes[index] = 0;
                                    });
                                  } else {
                                    setState(() {
                                      postsLikes[index] = 1;
                                    });
                                  }
                                },
                                child: Container(
                                  margin: EdgeInsets.only(top: height * 0.005),
                                  padding: EdgeInsets.only(left: width * 0.016),
                                  height: height * 0.03,
                                  width: width * 0.18,
                                  decoration: BoxDecoration(
                                      color: postsLikes[index] == 1
                                          ? Colors.green.withOpacity(0.7)
                                          : Colors.grey.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(12)),
                                  child: Row(
                                    children: [
                                      ///Tree logo
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            test = 0;
                                          });
                                        },
                                        child: postsLikes[index] == 1
                                            ? Container(
                                                margin: EdgeInsets.only(
                                                    left: width * 0.02),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Container(
                                                          height: height * 0.01,
                                                          width: height * 0.01,
                                                          color: Colors.green,
                                                        ),
                                                        Container(
                                                          height: height * 0.01,
                                                          width: height * 0.01,
                                                          color: Colors.green
                                                              .withRed(200),
                                                        ),
                                                      ],
                                                    ),
                                                    Container(
                                                      height: height * 0.01,
                                                      width: height * 0.01,
                                                      color: Colors.brown
                                                          .withRed(200),
                                                    )
                                                  ],
                                                ),
                                              )
                                            : Container(
                                                margin: EdgeInsets.only(
                                                    left: width * 0.02),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Container(
                                                          height: height * 0.01,
                                                          width: height * 0.01,
                                                          color: Colors.white,
                                                        ),
                                                        Container(
                                                            height:
                                                                height * 0.01,
                                                            width:
                                                                height * 0.01,
                                                            color: white),
                                                      ],
                                                    ),
                                                    Container(
                                                        height: height * 0.01,
                                                        width: height * 0.01,
                                                        color: white)
                                                  ],
                                                ),
                                              ),
                                      ),
                                      Container(
                                        margin:
                                            EdgeInsets.only(left: width * 0.01),
                                        child: Text("+1"),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Container(
                              width: width *
                                  getWidth(posts["Items"][index]["category"]),
                              height: height * 0.03,
                              decoration: BoxDecoration(
                                color: Colors.blueAccent,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Center(
                                child: Text(posts["Items"][index]["category"],
                                    style: TextStyle(color: white)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }),
      );
    }

    return Container(
      width: width,
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
                margin: EdgeInsets.only(top: height * 0.015),
                padding: EdgeInsets.symmetric(
                  vertical: height * 0.015,
                ), //horizontal: width * 0.03),
                decoration: BoxDecoration(
                    color: white, borderRadius: BorderRadius.circular(12)),
                width: width * 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /*
                    Container(
                      child: AdWidget(ad: _ad),
                      width: width,
                      height: 72.0,
                      alignment: Alignment.center,
                    ),
*/
/*
                    AspectRatio(
                        aspectRatio: _controller.value.aspectRatio,
                        child: VideoPlayer(_controller)),
                        */

                    posts == null
                        ? Container()
                        : scrollFeedMain(posts["Count"]),
                  ],
                )),
          ],
        ),
      ),
    );
  }
}

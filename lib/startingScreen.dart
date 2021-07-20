import 'package:ad_tv/VideoPlayerWidget.dart';
import 'package:ad_tv/productDetailsWidget.dart';
import 'package:ad_tv/providerAndFunctionFile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:video_player/video_player.dart';

const Color bgColor = Colors.blue;
const Color textColor = Colors.white;

class StartingScreen extends StatefulWidget {
  static final ItemScrollController itemScrollController =
      ItemScrollController();
  static final ItemPositionsListener itemPositionsListener =
      ItemPositionsListener.create();
  static late VideoPlayerController videoPlayerController;

  @override
  _StartingScreenState createState() => _StartingScreenState();
}

class _StartingScreenState extends State<StartingScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late double dragStatus = 0;

  @override
  void initState() {
    super.initState();
    StartingScreen.videoPlayerController =
        VideoPlayerController.asset('video/video.mp4')
          ..initialize().then((value) {
            setState(() {});
          });
    _animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 2));
  }

  @override
  void dispose() {
    _animationController.dispose();
    StartingScreen.videoPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black87,
        centerTitle: true,
        title: Text('Ad Tv'),
      ),
      body: Container(
        color: dragStatus.isNegative ? Colors.white : Colors.black87,
        child: StartingScreen.videoPlayerController.value.isInitialized
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Container(
                      child: GestureDetector(
                        onVerticalDragUpdate: (drag) {
                          dragStatus = drag.primaryDelta!;
                          setState(() {});
                          if (dragStatus.isNegative) {
                            _animationController.forward();
                            StartingScreen.videoPlayerController.pause();
                          }
                          if (!dragStatus.isNegative) {
                            _animationController.reverse();
                            StartingScreen.videoPlayerController.play();
                            Provider.of<VideoAndProductDetails>(context,
                                    listen: false)
                                .productWidgetBuildFunction(false);
                          }
                          // print(dragStatus);
                        },
                        child: VideoPlayerWidget(),
                      ),
                    ),
                  ),
                  if (dragStatus.isNegative)
                    Expanded(
                      child: ProductDetailsWidget(
                        context: context,
                      ),
                    ),
                ],
              )
            : Center(
                child: Text('Video is loading. Please Wait.'),
              ),
      ),
    );
  }
}

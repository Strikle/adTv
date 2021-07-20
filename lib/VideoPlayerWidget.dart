import 'package:ad_tv/providerAndFunctionFile.dart';
import 'package:ad_tv/startingScreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerWidget extends StatefulWidget {
  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: StartingScreen.videoPlayerController.value.aspectRatio,
      child: Stack(
        children: [
          GestureDetector(
            onTap: () {
              StartingScreen.videoPlayerController.value.isPlaying
                  ? StartingScreen.videoPlayerController.pause()
                  : StartingScreen.videoPlayerController.play();
              Provider.of<VideoAndProductDetails>(context, listen: false)
                  .isFunctionExecuted(false);
              setState(() {});
            },
            child: Stack(
              children: [
                VideoPlayer(StartingScreen.videoPlayerController),
                StartingScreen.videoPlayerController.value.isPlaying
                    ? Container(
                        color: Colors.transparent,
                      )
                    : Center(
                        child: Icon(
                          Icons.play_arrow,
                          color: Colors.redAccent,
                          size: 100,
                        ),
                      ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: VideoProgressIndicator(
              StartingScreen.videoPlayerController,
              padding: EdgeInsets.all(2),
              allowScrubbing: true,
            ),
          ),
        ],
      ),
    );
  }
}

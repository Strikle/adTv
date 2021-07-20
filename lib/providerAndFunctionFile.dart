import 'package:ad_tv/startingScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

List listOfProduct = ['Product', 'Product 2', 'Product 3'];

class VideoAndProductDetails with ChangeNotifier {
  int index = 0;
  int videoIndex = 0;
  int videoPlayed = 0;
  late bool isProductWidgetBuild = false;
  late bool isFunctionAlreadyExecuted = false;

  void trackingVideoPlayed() {
    videoPlayed = StartingScreen.videoPlayerController.value.position.inSeconds;
    notifyListeners();
  }

  void changingIndex(int _index) {
    index = _index;
    index = videoIndex;
    notifyListeners();
  }

  void changingVideoIndex(int _index) {
    videoIndex = _index;
    notifyListeners();
  }

  void syncingProductWithVideo() {
    if (videoIndex != index && isProductWidgetBuild) {
      if (videoIndex == 0) {
        if (videoPlayed >= 29) {
          StartingScreen.videoPlayerController.seekTo(Duration(seconds: 0));
          index = 0;
          notifyListeners();
        }
        return;
      }

      if (videoIndex == 1) {
        if (videoPlayed > 60 || videoPlayed <= 30) {
          StartingScreen.videoPlayerController.seekTo(Duration(seconds: 31));
          index = 1;
          notifyListeners();
        }
        return;
      }
      if (videoIndex == 2) {
        if (videoPlayed < 60) {
          StartingScreen.videoPlayerController.seekTo(Duration(seconds: 61));
          index = 2;
          notifyListeners();
          return;
        }
      }
    }
  }

  bool productWidgetBuildFunction(bool status) {
    isProductWidgetBuild = status;
    notifyListeners();
    return isProductWidgetBuild;
  }

  bool isFunctionExecuted(bool status) {
    isFunctionAlreadyExecuted = status;
    notifyListeners();
    return isFunctionAlreadyExecuted;
  }
}

void syncDetailsAndVideo(
    {required int videoPlayed,
    required bool status,
    required bool isFunctionAlreadyExecuted,
    required BuildContext context}) async {
  if (status) {
    if (isFunctionAlreadyExecuted) {
      if (videoPlayed == 30 || videoPlayed == 60) {
        WidgetsBinding.instance!.addPostFrameCallback((_) {
          Provider.of<VideoAndProductDetails>(context, listen: false)
              .isFunctionExecuted(false);
        });
        return;
      }
    }
    if (videoPlayed <= 29 && isFunctionAlreadyExecuted == false) {
      WidgetsBinding.instance!.addPostFrameCallback((_) {
        Provider.of<VideoAndProductDetails>(context, listen: false)
            .isFunctionExecuted(true);
        StartingScreen.itemScrollController
            .scrollTo(index: 0, duration: Duration(milliseconds: 100));
        Provider.of<VideoAndProductDetails>(context, listen: false)
            .changingIndex(0);
      });

      return;
    }
    if (videoPlayed < 60 &&
        videoPlayed > 31 &&
        isFunctionAlreadyExecuted == false) {
      WidgetsBinding.instance!.addPostFrameCallback((_) {
        Provider.of<VideoAndProductDetails>(context, listen: false)
            .isFunctionExecuted(true);
        StartingScreen.itemScrollController
            .scrollTo(index: 1, duration: Duration(milliseconds: 100));
        Provider.of<VideoAndProductDetails>(context, listen: false)
            .changingIndex(1);
      });

      return;
    }
    if (videoPlayed < 90 &&
        videoPlayed > 60 &&
        isFunctionAlreadyExecuted == false) {
      WidgetsBinding.instance!.addPostFrameCallback((_) {
        Provider.of<VideoAndProductDetails>(context, listen: false)
            .isFunctionExecuted(true);
        StartingScreen.itemScrollController
            .scrollTo(index: 2, duration: Duration(milliseconds: 100));
        Provider.of<VideoAndProductDetails>(context, listen: false)
            .changingIndex(2);
      });

      return;
    }
  }
}

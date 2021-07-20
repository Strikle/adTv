import 'package:ad_tv/firebaseFile.dart';
import 'package:ad_tv/providerAndFunctionFile.dart';
import 'package:ad_tv/startingScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class ProductDetailsWidget extends StatefulWidget {
  final BuildContext context;

  ProductDetailsWidget({required this.context});

  @override
  _ProductDetailsWidgetState createState() => _ProductDetailsWidgetState();
}

class _ProductDetailsWidgetState extends State<ProductDetailsWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 1));
    _animationController.forward();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      Provider.of<VideoAndProductDetails>(widget.context, listen: false)
          .productWidgetBuildFunction(true);
      Provider.of<VideoAndProductDetails>(context, listen: false)
          .isFunctionExecuted(false);
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var itemDetails = Provider.of<List<FirebaseProvider>>(widget.context);
    return SlideTransition(
      position: Tween<Offset>(begin: Offset(0.0, 0.3), end: Offset.zero)
          .animate(_animationController),
      child: ScrollablePositionedList.builder(
          itemScrollController: StartingScreen.itemScrollController,
          itemPositionsListener: StartingScreen.itemPositionsListener,
          itemCount: itemDetails.length,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: ValueListenableBuilder<Iterable<ItemPosition>>(
                  builder: (context, value, child) {
                    _executeAfterBuild(value, widget.context);
                    return ListWidget(
                      index: index,
                      itemDetails: itemDetails,
                    );
                  },
                  valueListenable:
                      StartingScreen.itemPositionsListener.itemPositions),
            );
          }),
    );
  }

  void _executeAfterBuild(var value, BuildContext context) {
    int videoPlayed = Provider.of<VideoAndProductDetails>(context).videoPlayed;
    bool status =
        Provider.of<VideoAndProductDetails>(context).isProductWidgetBuild;
    bool isFunctionAlreadyExecuted =
        Provider.of<VideoAndProductDetails>(context).isFunctionAlreadyExecuted;
    syncDetailsAndVideo(
        videoPlayed: videoPlayed,
        status: status,
        isFunctionAlreadyExecuted: isFunctionAlreadyExecuted,
        context: context);
    WidgetsBinding.instance!.addPostFrameCallback(
      (_) {
        if (value.isNotEmpty) {
          int indexPosition = value
              .where((ItemPosition position) => position.itemTrailingEdge > 0)
              .reduce((ItemPosition min, ItemPosition position) =>
                  position.itemTrailingEdge < min.itemTrailingEdge
                      ? position
                      : min)
              .index;
          Provider.of<VideoAndProductDetails>(context, listen: false)
              .changingVideoIndex(indexPosition);
        }
        Provider.of<VideoAndProductDetails>(context, listen: false)
            .trackingVideoPlayed();

        if (status) {
          Provider.of<VideoAndProductDetails>(context, listen: false)
              .syncingProductWithVideo();
        }
      },
    );
  }
}

class ListWidget extends StatelessWidget {
  final int index;
  final itemDetails;

  ListWidget({required this.itemDetails, required this.index});

  @override
  Widget build(BuildContext context) {
    String productTitle = itemDetails[index].title;
    // String productID = itemDetails[index].id;
    String productPrice = itemDetails[index].price;
    String productDetails = itemDetails[index].details;
    String productImage = itemDetails[index].image;
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Container(
       // height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: ListTile(
          title: Text(
            productTitle,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          trailing: Text(
            productPrice,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          leading: productImage == 'null'
              ? Image.asset('images/iphone.jpg')
              : Image.network(
                  productImage,
                  fit: BoxFit.fill,
                ),
          subtitle: Text(productDetails,
              style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16)),
        ),
      ),
    );
  }
}

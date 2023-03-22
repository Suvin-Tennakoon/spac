import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:spac/models/suvin/AuctionItem.model.dart';
import 'package:spac/repositories/suvin/AuctionItem.repository.dart';
import 'package:flutter_countdown_timer/index.dart';
import 'package:spac/screens/suvin/UpdateAd.dart';


//this widget will propogate the list of items by peoplewise
class AuctionListView extends StatefulWidget {
  const AuctionListView(
      {Key? key,
      this.auctionItem,
      this.animationController,
      this.animation,
      required this.callback})
      : super(key: key);

  final Function callback;
  final AuctionItem? auctionItem;
  final AnimationController? animationController;
  final Animation<double>? animation;

  @override
  State<AuctionListView> createState() => _AuctionListViewState();
}

class _AuctionListViewState extends State<AuctionListView> {
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.animationController!,
      builder: (BuildContext context, Widget? child) {
        return FadeTransition(
          opacity: widget.animation!,
          child: Transform(
            transform: Matrix4.translationValues(
                0.0, 50 * (1.0 - widget.animation!.value), 0.0),
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 24, right: 24, top: 8, bottom: 16),
              child: InkWell(
                splashColor: Colors.transparent,
                
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(16.0)),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.6),
                        offset: const Offset(4, 4),
                        blurRadius: 16,
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(16.0)),
                    child: Stack(
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            AspectRatio(
                              aspectRatio: 2,
                              child: Image.network(
                                widget.auctionItem!.imageurls[0],
                                fit: BoxFit.cover,
                              ),
                            ),
                            Container(
                              color: Color(0xffF7EBE1),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Expanded(
                                    child: Container(
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 16, top: 8, bottom: 8),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                              widget.auctionItem!.subject,
                                              textAlign: TextAlign.left,
                                              style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 22,
                                              ),
                                            ),
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: <Widget>[
                                                Padding(
                                                    padding: EdgeInsets.only(
                                                        top: 40)),
                                                Icon(
                                                  Icons.timer,
                                                  size: 20,
                                                  color: Colors.red,
                                                ),
                                                Expanded(
                                                    child: CountdownTimer(
                                                  textStyle: TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.red,
                                                  ),
                                                  endTime: widget
                                                          .auctionItem
                                                          ?.expdatetime
                                                          ?.millisecondsSinceEpoch ??
                                                      0,
                                                )),
                                              ],
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 6, right: 0),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: <Widget>[
                                                  Text(
                                                    widget.auctionItem?.items
                                                            ?.join(', ') ??
                                                        '',
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        color: Colors.grey
                                                            .withOpacity(0.8)),
                                                  ),
                                                  Transform(
                                                    transform: Matrix4
                                                        .translationValues(
                                                            70, 0, 0),
                                                    child: Text(
                                                      "Buy now at \$${widget.auctionItem?.buyoutprice}",
                                                      style: TextStyle(
                                                          fontSize: 14,
                                                          color: Colors.grey
                                                              .withOpacity(
                                                                  0.8)),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        right: 16, top: 8),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: <Widget>[
                                        Text(
                                          '\$ ${widget.auctionItem?.currentbid}',
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 22,
                                          ),
                                        ),
                                        Text(
                                          'highest bid',
                                          style: TextStyle(
                                              fontSize: 14,
                                              color:
                                                  Colors.grey.withOpacity(0.8)),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Positioned(
                          top: 15,
                          right: 25,
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: const BorderRadius.all(
                                Radius.circular(32.0),
                              ),
                              onTap: () {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        AlertDialog(
                                          title: const Text(
                                              'Deletion Auction Item'),
                                          content: const Text(
                                              'Do You Really Want to Delete the Item? This Action Cannot be Reversed.'),
                                          actions: <Widget>[
                                            TextButton(
                                              onPressed: () => Navigator.pop(
                                                  context, 'Cancel'),
                                              child: const Text('Cancel'),
                                            ),
                                            TextButton(
                                                onPressed: () async {
                                                  LoadingDialog.show(context);
                                                  for (String x in widget
                                                      .auctionItem!.imageurls) {
                                                    FirebaseStorage storage =
                                                        FirebaseStorage
                                                            .instance;
                                                    Reference ref =
                                                        storage.refFromURL(x);
                                                    await ref.delete();
                                                  }

                                                  AuctionItemRepository repo =
                                                      AuctionItemRepository();
                                                  repo.deleteAuctionItem(
                                                      widget.auctionItem!.id);

                                                  LoadingDialog.hide(context);
                                                  Navigator.pop(context);
                                                  widget.callback();
                                                },
                                                child: const Text('OK')),
                                          ],
                                        ));
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Icon(Icons.delete_forever,
                                      size: 30, color: Colors.red),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 15,
                          right: 85,
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: const BorderRadius.all(
                                Radius.circular(32.0),
                              ),
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => UpdateItem(
                                              itemid: widget.auctionItem!.id,
                                              auctionitem: widget.auctionItem,
                                            )));
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Icon(
                                    Icons.edit_square,
                                    size: 30,
                                    color: Colors.green,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}


class LoadingDialog extends StatelessWidget {
  static void show(BuildContext context, {Key? key}) => showDialog<void>(
        context: context,
        useRootNavigator: false,
        barrierDismissible: false,
        builder: (_) => LoadingDialog(key: key),
      ).then((_) => FocusScope.of(context).requestFocus(FocusNode()));

  static void hide(BuildContext context) => Navigator.pop(context);

  const LoadingDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Center(
        child: Card(
          child: Container(
            width: 150,
            height: 130,
            padding: const EdgeInsets.all(12.0),
            child: Center(
              child: Column(
                children: const [
                  CircularProgressIndicator(),
                  SizedBox(
                    height: 15.0,
                  ),
                  Text(
                    "Deleting",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.blue),
                    textAlign: TextAlign.center,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

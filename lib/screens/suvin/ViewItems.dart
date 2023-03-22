import 'package:flutter/material.dart';
import 'package:spac/models/suvin/AuctionItem.model.dart';
import 'package:spac/repositories/suvin/AuctionItem.repository.dart';
import 'package:spac/screens/suvin/auc_list_view.dart';

//this widget will display auction items placed by individual people
class ViewAuctionItems extends StatefulWidget {
  final String userdata;
  const ViewAuctionItems({super.key, required this.userdata});

  @override
  State<ViewAuctionItems> createState() => _ViewAuctionItemsState();
}

class _ViewAuctionItemsState extends State<ViewAuctionItems>
    with TickerProviderStateMixin {
  AnimationController? animationController;
  List<AuctionItem>? _auctionItems;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    animationController = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);

    AuctionItemRepository repo = AuctionItemRepository();
    repo.getAllAuctionItems().then((value) {
      List<AuctionItem> localitems = [];

      for (AuctionItem ai in value) {
        if (ai.sellermail == widget.userdata) {
          localitems.add(ai);
        }
      }
      setState(() {
        _auctionItems = localitems;
      });
    });

    super.initState();
  }

  @override
  void dispose() {
    animationController?.dispose();
    super.dispose();
  }

  Future<void> _refreshList() async {
    setState(() {
      _auctionItems = null; // Set to null to show loading indicator
    });

    AuctionItemRepository repo = AuctionItemRepository();
    List<AuctionItem> items = await repo.getAllAuctionItems();

    List<AuctionItem> localitems = [];

    for (AuctionItem ai in items) {
      if (ai.sellermail == widget.userdata) {
        localitems.add(ai);
      }
    }

    setState(() {
      _auctionItems = localitems;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF7EBE1),
      appBar: AppBar(
          title: Row(
            children: const [
              SizedBox(width: 60), // Add spacing between icon and text
              Text('Placed Auctions'),
            ],
          ),
          backgroundColor: Color(0xff132137)),
      body: Container(
        child: Scaffold(
          body: _auctionItems != null
              ? SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      const SizedBox(
                        height: 30,
                      ),
                      Text(
                        "Hello, ${widget.userdata} !!",
                        style: TextStyle(fontSize: 20),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: _auctionItems?.length,
                        padding: const EdgeInsets.only(top: 8),
                        scrollDirection: Axis.vertical,
                        itemBuilder: (BuildContext context, int index) {
                          final int count = _auctionItems!.length > 10
                              ? 10
                              : _auctionItems!.length;
                          final Animation<double> animation =
                              Tween<double>(begin: 0.0, end: 1.0).animate(
                                  CurvedAnimation(
                                      parent: animationController!,
                                      curve: Interval((1 / count) * index, 1.0,
                                          curve: Curves.fastOutSlowIn)));
                          animationController?.forward();
                          return AuctionListView(
                            callback: _refreshList,
                            auctionItem: _auctionItems?[index],
                            animation: animation,
                            animationController: animationController!,
                          );
                        },
                      ),
                    ],
                  ),
                )
              : const LoadingDialog(),
        ),
      ),
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
                  CircularProgressIndicator(
                    color: Colors.green,
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                  Text(
                    "Please Wait While We Fetch Your Auctions...",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.green),
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

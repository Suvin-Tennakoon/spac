import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:spac/models/suvin/AuctionItem.model.dart';
import 'package:spac/repositories/suvin/AuctionItem.repository.dart';
import 'package:spac/screens/suvin/ChoiceType.dart';
import 'package:spac/screens/suvin/auc_list_all.dart';
import 'package:spac/screens/suvin/auc_list_view.dart';

//this widget will display auction items placed by all the community
class ViewAllAuctionItems extends StatefulWidget {
  //need to change this to get authenticated mail of the user
  final String userdata = "Suvin";
  const ViewAllAuctionItems({super.key});

  @override
  State<ViewAllAuctionItems> createState() => _ViewAllAuctionItemsState();
}

class _ViewAllAuctionItemsState extends State<ViewAllAuctionItems>
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
      setState(() {
        _auctionItems = value;
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

    setState(() {
      _auctionItems = items;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF7EBE1),
      appBar: AppBar(
          title: Row(
            children: const [
              SizedBox(width: 100), // Add spacing between icon and text
              Text('All Placed Auctions'),
            ],
          ),
          backgroundColor: Color(0xff132137)),

      floatingActionButton: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            FloatingActionButton.extended(
              heroTag: null,
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => IntroductionAnimationScreen(
                            userdata: widget.userdata)));
              },
              icon: const Icon(Icons.sell),
              label: const Text('PLACE AD'),
            ),
          ],
        ),
      ),

      //submit button
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      body: Container(
        child: Scaffold(
          body: _auctionItems != null
              ? Stack(
                  children: <Widget>[
                    InkWell(
                      splashColor: Colors.transparent,
                      focusColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      onTap: () {
                        FocusScope.of(context).requestFocus(FocusNode());
                      },
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
                          Expanded(
                            child: NestedScrollView(
                              controller: _scrollController,
                              headerSliverBuilder: (BuildContext context,
                                  bool innerBoxIsScrolled) {
                                return <Widget>[
                                  SliverList(
                                    delegate: SliverChildBuilderDelegate(
                                        (BuildContext context, int index) {
                                      return Column(
                                        children: <Widget>[],
                                      );
                                    }, childCount: 1),
                                  ),
                                ];
                              },
                              body: Container(
                                color: Color(0xffF7EBE1),
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: _auctionItems?.length,
                                  padding: const EdgeInsets.only(top: 8),
                                  scrollDirection: Axis.vertical,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    final int count = _auctionItems!.length > 10
                                        ? 10
                                        : _auctionItems!.length;
                                    final Animation<double> animation =
                                        Tween<double>(begin: 0.0, end: 1.0)
                                            .animate(CurvedAnimation(
                                                parent: animationController!,
                                                curve: Interval(
                                                    (1 / count) * index, 1.0,
                                                    curve:
                                                        Curves.fastOutSlowIn)));
                                    animationController?.forward();
                                    return AuctionListAllView(
                                      callback: _refreshList,
                                      auctionItem: _auctionItems?[index],
                                      animation: animation,
                                      animationController: animationController!,
                                    );
                                  },
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
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
                    "Please Wait While We Fetch All Auctions...",
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

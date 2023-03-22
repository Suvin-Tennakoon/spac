import 'package:flutter/material.dart';
import 'package:spac/screens/suvin/AddItem.dart';

//used and modified the open source code from
//https://github.com/mitesh77/Best-Flutter-UI-Templates.git
// for small portion of the UI Screen
class IntroductionAnimationScreen extends StatefulWidget {
  final String userdata;

  const IntroductionAnimationScreen({Key? key, required this.userdata})
      : super(key: key);

  @override
  _IntroductionAnimationScreenState createState() =>
      _IntroductionAnimationScreenState();
}

class _IntroductionAnimationScreenState
    extends State<IntroductionAnimationScreen> with TickerProviderStateMixin {
  AnimationController? _animationController;

  @override
  void initState() {
    _animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 0));
    _animationController?.animateTo(0.0);
    super.initState();
  }

  @override
  void dispose() {
    _animationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF7EBE1),
      body: ClipRect(
        child: Center(
          child: ChoiceType(
              animationController: _animationController!,
              userdata: widget.userdata),
        ),
      ),
    );
  }
}

class ChoiceType extends StatefulWidget {
  final AnimationController animationController;
  final String userdata;

  const ChoiceType(
      {Key? key, required this.animationController, required this.userdata})
      : super(key: key);

  @override
  _ChoiceTypeState createState() => _ChoiceTypeState();
}

class _ChoiceTypeState extends State<ChoiceType> {
  @override
  Widget build(BuildContext context) {
    final _introductionanimation =
        Tween<Offset>(begin: Offset(0, 0), end: Offset(0.0, -1.0))
            .animate(CurvedAnimation(
      parent: widget.animationController,
      curve: Interval(
        0.0,
        0.2,
        curve: Curves.fastOutSlowIn,
      ),
    ));
    return SlideTransition(
      position: _introductionanimation,
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Image.asset(
                'assets/suvin/bidding_image.png',
                fit: BoxFit.cover,
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
              child: Text(
                "Proceed Auctioning",
                style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 64, right: 64),
              child: Text(
                "An auction is not just a public sale of goods or services, it's a captivating performance where bidders engage in a thrilling dance with the auctioneer, their hearts beating fast, their minds racing with strategies, their eyes locked on the prize.",
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(
              height: 48,
            ),
            Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).padding.bottom + 16),
              child: InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              AddItem(userdata: widget.userdata)));
                },
                child: Container(
                  height: 58,
                  padding: const EdgeInsets.only(
                    left: 56.0,
                    right: 56.0,
                    top: 16,
                    bottom: 16,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(38.0),
                    color: Color(0xff132137),
                  ),
                  child: const Text(
                    "Let's begin",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

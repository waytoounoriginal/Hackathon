import 'package:flutter/material.dart';
import 'dart:math' as math;

import '../others/color_scheme.dart';
import '../others/frontend_icons_icons.dart';

import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    //  DEBUG
    final kPercent = .3;

    ;

    Widget _userInfoButton() => Row(
          children: [
            Flexible(
                flex: 2,
                child: Container(
                  height: 110,
                  decoration: ContainerDecorations.whiteContainerDeco.copyWith(
                    color: AppColorScheme.lightGreen,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(25),
                    child: FittedBox(
                      fit: BoxFit.contain,
                      child: Row(
                        children: [
                          Icon(
                            FrontendIcons.fingerprint_stroke,
                            color: AppColorScheme.greishWhite,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(
                            'User\nInformation',
                            style: TextSchemes.titleStyle
                                .copyWith(color: AppColorScheme.greishWhite),
                          )
                        ],
                      ),
                    ),
                  ),
                )),
            Flexible(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Container(
                  height: 110,
                  decoration: ContainerDecorations.whiteContainerDeco
                      .copyWith(color: AppColorScheme.greishWhite),
                  child: Center(
                    child: Icon(
                      Icons.arrow_forward_ios_outlined,
                      color: AppColorScheme.darkGreen,
                    ),
                  ),
                ),
              ),
            )
          ],
        );

    return Scaffold(
      backgroundColor: AppColorScheme.normalGreen,
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: AnimationLimiter(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: AnimationConfiguration.toStaggeredList(
                duration: const Duration(milliseconds: 750),
                childAnimationBuilder: (widget) => SlideAnimation(
                      horizontalOffset: 50.0,
                      child: FadeInAnimation(
                        child: widget,
                      ),
                    ),
                children: [
                  SizedBox(
                    height: 50,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Image.asset('assets/images/logos/logo.png'),
                        const Text('X',
                            style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.w600)),
                        Image.asset('assets/images/logos/dreamIT.png')
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  Container(
                    height: 50,
                    width: width * .75,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: AppColorScheme.greishWhite,
                        boxShadow: [
                          const BoxShadow(
                              offset: Offset(4, 4),
                              color: Colors.black12,
                              blurRadius: 10)
                        ]),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        //  mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Icon(
                            Icons.insights,
                            color: AppColorScheme.normalGreen,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'User Insights',
                                style: TextSchemes.titleStyle,
                              ),
                              Container(
                                height: 2,
                                width: 70,
                                decoration: BoxDecoration(
                                    color: AppColorScheme.normalGreen,
                                    borderRadius: BorderRadius.circular(30)),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  _Dashboard(
                    kPercent: kPercent,
                    size: width * .5,
                    users: 345,
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  _userInfoButton()
                ]),
          )),
        ),
      ),
    );
  }
}

class _Dashboard extends StatefulWidget {
  final double kPercent;
  final double size;
  final int users;
  const _Dashboard(
      {super.key,
      required this.kPercent,
      required this.size,
      required this.users});

  @override
  State<_Dashboard> createState() => __DashboardState();
}

class __DashboardState extends State<_Dashboard> with TickerProviderStateMixin {
  double rad(double no) => (no * math.pi) / 180;
  final degOffset = 20.0;

  late var startAngle, endAngle, susStart, susEnd;

  late Tween<double> legitAnim;
  late Tween<double> endAnim;

  late Tween<double> numberAnim;

  late AnimationController chartController;
  late Animation anim1, anim2, anim3;

  @override
  void initState() {
    startAngle = rad(0 - degOffset);
    endAngle = rad(360 * widget.kPercent);

    susStart = endAngle;
    susEnd = rad(360 - 2 * degOffset) - susStart;

    legitAnim = Tween<double>(begin: startAngle, end: endAngle);

    endAnim = Tween<double>(begin: susStart, end: susEnd);

    numberAnim = Tween<double>(begin: 0, end: (1.0 - widget.kPercent) * 100);

    chartController =
        AnimationController(vsync: this, duration: const Duration(milliseconds: 1500));

    anim1 = legitAnim.animate(
        CurvedAnimation(parent: chartController, curve: Curves.decelerate));

    anim2 = endAnim.animate(
        CurvedAnimation(parent: chartController, curve: Curves.decelerate));

    anim3 = numberAnim.animate(
        CurvedAnimation(parent: chartController, curve: Curves.decelerate));

    chartController.forward();

    super.initState();
  }

  @override
  void dispose() {
    chartController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.size,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: widget.size,
            decoration: ContainerDecorations.whiteContainerDeco,
            child: Padding(
              padding: const EdgeInsets.all(27.5),
              child: AnimatedBuilder(
                animation: chartController,
                builder: ((context, child) => Stack(
                      alignment: Alignment.center,
                      children: [
                        CustomPaint(
                          painter: CirclePainter(
                              legitStart: startAngle,
                              legitEnd: anim1.value,
                              susStart: susStart,
                              susEnd: anim2.value),
                          size: MediaQuery.of(context).size,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: SizedBox(
                            height: 200,
                            child: FittedBox(
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Text(
                                    '${anim3.value.toStringAsFixed(1)}%',
                                    style: TextSchemes.titleStyle.copyWith(
                                        color: AppColorScheme.susRed,
                                        fontSize: 30),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    'of users are\nflagged as suspicious.',
                                    textAlign: TextAlign.center,
                                    style: TextSchemes.titleStyle.copyWith(
                                        color: AppColorScheme.susRed,
                                        fontSize: 10),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    )),
              ),
            ),
          ),
          const SizedBox(
            width: 20,
          ),
          Expanded(
            flex: 2,
            child: AnimationLimiter(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: AnimationConfiguration.toStaggeredList(
                  duration: const Duration(milliseconds: 1000),
                  childAnimationBuilder: (widget) => SlideAnimation(
                    verticalOffset: 50,
                    child: FadeInAnimation(
                      child: widget,
                    ),
                  ),
                  children: [
                    Container(
                      height: 85,
                      decoration: ContainerDecorations.whiteContainerDeco,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Icon(
                                  Icons.person_outline_outlined,
                                  color: AppColorScheme.darkGreen,
                                ),
                                FittedBox(
                                  child: Text(
                                    'Total Users',
                                    style: TextSchemes.titleStyle.copyWith(
                                        color: AppColorScheme.darkGreen),
                                  ),
                                )
                              ],
                            ),
                            Text(
                              widget.users.toString(),
                              style: TextSchemes.titleStyle.copyWith(
                                  color: AppColorScheme.darkGreen,
                                  fontSize: 30),
                            )
                          ],
                        ),
                      ),
                    ),
                    Container(
                      height: 85,
                      decoration: ContainerDecorations.whiteContainerDeco,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Icon(
                                  Icons.person_outline_outlined,
                                  color: AppColorScheme.susRed,
                                ),
                                FittedBox(
                                  child: Text(
                                    'Suspicious\nUsers',
                                    style: TextSchemes.titleStyle
                                        .copyWith(color: AppColorScheme.susRed),
                                  ),
                                )
                              ],
                            ),
                            Text(
                              (widget.users * (1 - widget.kPercent))
                                  .floor()
                                  .toString(),
                              style: TextSchemes.titleStyle.copyWith(
                                  color: AppColorScheme.susRed, fontSize: 30),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class CirclePainter extends CustomPainter {
  final double legitStart;
  final double legitEnd;
  final double susStart;
  final double susEnd;
  CirclePainter(
      {required this.legitEnd,
      required this.susEnd,
      required this.legitStart,
      required this.susStart});

  // final degOffset = 20.0;
  //  double rad(double no) => (no * math.pi) / 180;

  @override
  void paint(Canvas canvas, Size size) {
    //  final Offset center = Offset(size.width / 2, size.height / 2);
    final rect = Rect.fromLTRB(0, 0, size.width, size.height);

    //  var startAngle = rad(0 - degOffset);
    //  var endAngle = rad(360 * legitPercent);

    //  var susStart = endAngle;
    //  var susEnd = rad(360 - 2 * degOffset) - susStart;

    Paint paintLegit = Paint()
      ..color = AppColorScheme.lightGreen
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 15
      ..style = PaintingStyle.stroke;

    Paint paintSus = Paint()
      ..color = AppColorScheme.susRed
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 15
      ..style = PaintingStyle.stroke;

    canvas.drawArc(rect, legitStart, legitEnd, false, paintLegit);
    canvas.drawArc(rect, susStart, susEnd, false, paintSus);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return true;
  }
}

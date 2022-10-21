import 'package:flutter/material.dart';
import 'dart:math' as math;

import '../others/color_scheme.dart';
import '../others/frontend_icons_icons.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    //  DEBUG
    final kPercent = .5;

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

    Widget _dashboardsInfo() => Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: Container(
                height: 200,
                decoration: ContainerDecorations.whiteContainerDeco,
                child: Padding(
                    padding: const EdgeInsets.all(27.5),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        CustomPaint(
                          painter: CirclePainter(legitPercent: kPercent),
                          size: MediaQuery.of(context).size,
                        ),
                        Column(
                          children: [
                            Text(
                              '${(1.0 - kPercent) * 100}%',
                              style: TextSchemes.titleStyle.copyWith(
                                  color: AppColorScheme.susRed, fontSize: 30),
                            )
                          ],
                        ),
                      ],
                    )),
              ),
            ),
            const SizedBox(
              width: 20,
            ),
            Expanded(
              flex: 2,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    height: 75,
                    decoration: ContainerDecorations.whiteContainerDeco,
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  Container(
                    height: 75,
                    decoration: ContainerDecorations.whiteContainerDeco,
                  ),
                ],
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
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
              _dashboardsInfo(),
              const SizedBox(
                height: 50,
              ),
              _userInfoButton()
            ],
          ),
        ),
      ),
    );
  }
}

class CirclePainter extends CustomPainter {
  final double legitPercent;
  CirclePainter({required this.legitPercent});

  final degOffset = 20.0;

  double rad(double no) => (no * math.pi) / 180;

  @override
  void paint(Canvas canvas, Size size) {
    final Offset center = Offset(size.width / 2, size.height / 2);
    final rect = Rect.fromLTRB(0, 0, size.width, size.height);

    var startAngle = rad(0 - degOffset);
    var endAngle = rad(360 * legitPercent);

    var susStart = endAngle;
    var susEnd = rad(360 - 2 * degOffset) - susStart;

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

    canvas.drawArc(rect, startAngle, endAngle, false, paintLegit);
    canvas.drawArc(rect, susStart, susEnd, false, paintSus);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return true;
  }
}

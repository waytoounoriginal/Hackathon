import 'package:flutter/material.dart';
import 'dart:math' as math;

import '../others/color_scheme.dart';
import '../others/frontend_icons_icons.dart';
import '../others/navbar.dart';
import '../others/person.dart';

import './map.dart';

import 'package:intl/intl.dart';

class AccountViewer extends StatefulWidget {
  const AccountViewer({super.key});

  @override
  State<AccountViewer> createState() => _AccountViewerState();
}

class _AccountViewerState extends State<AccountViewer>
    with TickerProviderStateMixin {
  late IntTween expansionAnim1, expansionAnim2;
  late Animation anim1, anim2, opac1, opac2, circleAnimation;
  late AnimationController animController1,
      animController2,
      opacCtrler1,
      circleController,
      opacCtrler2;

  // double opacity1 = 1.0, opacity2 = 0.0;
  late Tween opacity1, opacity2, zoomTween;

  late PageController pageController;

  late Offset center;

  @override
  void dispose() {
    animController1.dispose();
    animController2.dispose();
    opacCtrler1.dispose();
    opacCtrler2.dispose();
    circleController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    expansionAnim1 = IntTween(begin: 2000, end: 1000);
    expansionAnim2 = IntTween(begin: 1000, end: 2000);

    center = Offset.zero;

    opacity1 = Tween(begin: 1.0, end: 0.0);
    opacity2 = Tween(begin: 0.0, end: 1.0);

    animController1 = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));

    animController2 = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));

    circleController =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));

    zoomTween = Tween<double>(begin: 0, end: 100);

    circleAnimation = zoomTween.animate(
        CurvedAnimation(parent: circleController, curve: Curves.easeIn));

    opacCtrler1 = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));

    opacCtrler2 = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));

    anim1 = expansionAnim1
        .animate(CurvedAnimation(parent: animController1, curve: Curves.ease));

    anim2 = expansionAnim2
        .animate(CurvedAnimation(parent: animController2, curve: Curves.ease));

    opac1 = opacity1.animate(
        CurvedAnimation(parent: opacCtrler1, curve: Curves.decelerate));
    opac2 = opacity2.animate(
        CurvedAnimation(parent: opacCtrler2, curve: Curves.decelerate));

    pageController = PageController();

    _dummyList = _generateDummyPersons(10);

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      RenderBox _box =
          _seeHistoryKey.currentContext!.findRenderObject() as RenderBox;

      Offset position = _box.localToGlobal(Offset.zero);

      center = position;

      print(center);
    });

    super.initState();
  }

  int selectedContainer = 0;

  int selectedIndex = 0;

  void selectUAcc() {
    selectedContainer = 0;
    opacCtrler2.reverse().then((value) {
      //  selectedIndex.value = 0;
      pageController.animateToPage(1,
          duration: const Duration(milliseconds: 500),
          curve: Curves.decelerate);
      animController1.reverse();
      animController2.reverse().then((value) => opacCtrler1.reverse());
    });
  }

  void selectUDetails(int index) {
    selectedContainer = 1;

    opacCtrler1.forward().then((value) {
      selectedIndex = index;
      pageController.animateToPage(1,
          duration: const Duration(milliseconds: 500),
          curve: Curves.decelerate);
      animController1.forward();
      animController2.forward().then((value) => opacCtrler2.forward());
    });
  }

  Fingerprint toFingerprint(Map<String, dynamic> map) {
    bool isEmulator = map["device_details"]['is_emulator'] ?? false;
    bool isRooted = map["device_details"]['is_rooted'] ?? false;
    String ipCountry = map["device_details"]['dns_ip_country'] ?? 'NULL';
    String ipISP = map["device_details"]['dns_ip_isp'] ?? 'NULL';
    String ipIP = map["device_details"]['dns_ip'] ?? 'NULL';
    String deviceCountry = map["device_details"]['device_ip_country'] ?? 'NULL';
    String deviceISP = map["device_details"]['device_ip_isp'] ?? 'NULL';
    String deviceIP = map["device_details"]['device_ip_address'] ?? 'NULL';

    print(map['dns_ip_country']);

    return Fingerprint(
        isEmulator: isEmulator,
        isRooted: isRooted,
        ipCountry: ipCountry,
        ipISP: ipISP,
        ipIP: ipIP,
        deviceCountry: deviceCountry,
        deviceISP: deviceISP,
        deviceIP: deviceIP);
  }

  //  DEBUG
  List<Person> _generateDummyPersons(int turns) {
    List<Person> dummy = [];

    for (int i = 0; i < turns; i++) {
      dummy.add(Person(
          fullName: "Mihai Tira",
          userName: "Mike4544",
          lastIP: "127.0.0.1",
          email: "dummy@dummy.com",
          phoneNo: "+40 7123456789",
          fingerprint: toFingerprint(Fingerprint.dummyInfo),
          isLegit: i % 2 == 0 ? true : false,
          dateCreated: DateTime.now()));
    }

    return dummy;
  }

  List<Person> _dummyList = [];

  final GlobalKey _seeHistoryKey = GlobalKey();

  final activeStyle = ContainerDecorations.whiteContainerDeco;
  final inactiveStyle = ContainerDecorations.whiteContainerDeco
      .copyWith(color: AppColorScheme.lighterGreen);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColorScheme.normalGreen,
        body: Stack(
          children: [
            Padding(
                padding: const EdgeInsets.all(20),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
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
                      AnimatedBuilder(
                        animation: Listenable.merge(
                            [animController1, opacCtrler1, opacCtrler2]),
                        builder: ((context, child) => Row(
                              children: [
                                Expanded(
                                    flex: anim1.value,
                                    child: SizedBox(
                                      child: Column(
                                        children: [
                                          AnimatedContainer(
                                            duration: const Duration(
                                                milliseconds: 500),
                                            curve: Curves.ease,
                                            height: 50,
                                            decoration: selectedContainer == 0
                                                ? activeStyle
                                                : inactiveStyle,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Stack(
                                                alignment: Alignment.center,
                                                children: [
                                                  Positioned(
                                                    left: 25.0 -
                                                        (25 * opac1.value),
                                                    child: Icon(
                                                      Icons
                                                          .person_outline_outlined,
                                                      color:
                                                          selectedContainer == 0
                                                              ? AppColorScheme
                                                                  .normalGreen
                                                              : AppColorScheme
                                                                  .darkGreen,
                                                    ),
                                                  ),
                                                  Positioned(
                                                    left: 25.0 +
                                                        (25 * opac1.value),
                                                    child: Opacity(
                                                      opacity: opac1.value,
                                                      child: Text(
                                                        'User Accounts',
                                                        style: TextSchemes
                                                            .titleStyle,
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          AnimatedContainer(
                                            clipBehavior: Clip.hardEdge,
                                            duration: const Duration(
                                                milliseconds: 500),
                                            curve: Curves.ease,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                .65,
                                            decoration: selectedContainer == 0
                                                ? activeStyle
                                                : inactiveStyle,
                                            child: PageView(
                                              controller: pageController,
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Scrollbar(
                                                    thickness: 3,
                                                    radius:
                                                        const Radius.circular(
                                                            30),
                                                    child: ListView.builder(
                                                      physics:
                                                          const BouncingScrollPhysics(),
                                                      shrinkWrap: true,
                                                      itemCount: 10,
                                                      itemBuilder:
                                                          (context, index) =>
                                                              GestureDetector(
                                                        onTap: () {
                                                          selectUDetails(index);
                                                        },
                                                        child: BigCard(
                                                          person:
                                                              _dummyList[index],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Scrollbar(
                                                    thickness: 3,
                                                    radius:
                                                        const Radius.circular(
                                                            30),
                                                    child: ListView.builder(
                                                      physics:
                                                          const BouncingScrollPhysics(),
                                                      shrinkWrap: true,
                                                      itemCount: 10,
                                                      itemBuilder:
                                                          (context, index) =>
                                                              GestureDetector(
                                                        onTap: () {
                                                          setState(() {
                                                            selectedIndex =
                                                                index;
                                                          });
                                                        },
                                                        child: MiniCard(
                                                          person:
                                                              _dummyList[index],
                                                          selected:
                                                              selectedIndex,
                                                          index: index,
                                                          newIndex:
                                                              selectedIndex,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    )),
                                const SizedBox(
                                  width: 20,
                                ),
                                Expanded(
                                  flex: anim2.value,
                                  child: Column(
                                    children: [
                                      AnimatedContainer(
                                        duration:
                                            const Duration(milliseconds: 500),
                                        curve: Curves.ease,
                                        height: 50,
                                        decoration: selectedContainer == 1
                                            ? activeStyle
                                            : inactiveStyle,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Stack(
                                            alignment: Alignment.center,
                                            children: [
                                              Positioned(
                                                left: 25.0 - (25 * opac2.value),
                                                child: Icon(
                                                  FrontendIcons
                                                      .fingerprint_stroke,
                                                  color: selectedContainer == 1
                                                      ? AppColorScheme
                                                          .normalGreen
                                                      : AppColorScheme
                                                          .darkGreen,
                                                ),
                                              ),
                                              Positioned(
                                                left: 25.0 + (25 * opac2.value),
                                                child: Opacity(
                                                  opacity: opac2.value,
                                                  child: Text(
                                                    'User Details',
                                                    style:
                                                        TextSchemes.titleStyle,
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      AnimatedContainer(
                                        duration:
                                            const Duration(milliseconds: 500),
                                        curve: Curves.ease,
                                        height:
                                            MediaQuery.of(context).size.height *
                                                .65,
                                        decoration: selectedContainer == 1
                                            ? activeStyle
                                            : inactiveStyle,
                                        child: Opacity(
                                            opacity: opac2.value,
                                            child: Stack(
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(5.0),
                                                  child: Scrollbar(
                                                    thickness: 2,
                                                    radius:
                                                        const Radius.circular(
                                                            30),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              15.0),
                                                      child: ListView(
                                                        shrinkWrap: false,
                                                        physics:
                                                            const BouncingScrollPhysics(),
                                                        children: [
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceAround,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Icon(
                                                                Icons
                                                                    .person_outline_outlined,
                                                                color: AppColorScheme
                                                                    .darkGreen,
                                                                size: 50,
                                                              ),
                                                              Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Text(
                                                                    _dummyList[
                                                                            selectedIndex]
                                                                        .fullName,
                                                                    style: TextSchemes
                                                                        .titleStyle
                                                                        .copyWith(
                                                                            color:
                                                                                AppColorScheme.darkGreen),
                                                                  ),
                                                                  const SizedBox(
                                                                    height: 10,
                                                                  ),
                                                                  if (_dummyList[
                                                                          selectedIndex]
                                                                      .isLegit)
                                                                    Container(
                                                                      height:
                                                                          17.5,
                                                                      width: 40,
                                                                      decoration: BoxDecoration(
                                                                          color: AppColorScheme
                                                                              .lighterGreen,
                                                                          borderRadius:
                                                                              BorderRadius.circular(5)),
                                                                      child:
                                                                          FittedBox(
                                                                        fit: BoxFit
                                                                            .scaleDown,
                                                                        child:
                                                                            Padding(
                                                                          padding:
                                                                              const EdgeInsets.all(8.0),
                                                                          child:
                                                                              Row(
                                                                            children: [
                                                                              Icon(
                                                                                Icons.check_rounded,
                                                                                color: AppColorScheme.normalGreen,
                                                                              ),
                                                                              const SizedBox(
                                                                                width: 2.5,
                                                                              ),
                                                                              Text(
                                                                                'Verified',
                                                                                style: TextStyle(color: AppColorScheme.normalGreen),
                                                                              )
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    )
                                                                  else
                                                                    Container(
                                                                      height:
                                                                          17.5,
                                                                      width: 40,
                                                                      decoration: BoxDecoration(
                                                                          color: AppColorScheme
                                                                              .bkgSusRed,
                                                                          borderRadius:
                                                                              BorderRadius.circular(5)),
                                                                      child:
                                                                          FittedBox(
                                                                        fit: BoxFit
                                                                            .scaleDown,
                                                                        child:
                                                                            Padding(
                                                                          padding:
                                                                              const EdgeInsets.all(8.0),
                                                                          child:
                                                                              Row(
                                                                            children: [
                                                                              Icon(
                                                                                Icons.close_rounded,
                                                                                color: AppColorScheme.susRed,
                                                                              ),
                                                                              const SizedBox(
                                                                                width: 2.5,
                                                                              ),
                                                                              Text(
                                                                                'Flagged',
                                                                                style: TextStyle(color: AppColorScheme.susRed),
                                                                              )
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    )
                                                                ],
                                                              )
                                                            ],
                                                          ),
                                                          const SizedBox(
                                                            height: 25,
                                                          ),
                                                          Row(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .max,
                                                            children: [
                                                              Row(
                                                                children: [
                                                                  Icon(
                                                                    Icons
                                                                        .info_outline_rounded,
                                                                    color: Colors
                                                                            .grey[
                                                                        400],
                                                                  ),
                                                                  const SizedBox(
                                                                    width: 5,
                                                                  ),
                                                                  Text(
                                                                    'General\nInformation',
                                                                    style: TextSchemes
                                                                        .titleStyle
                                                                        .copyWith(
                                                                            color:
                                                                                Colors.grey[400],
                                                                            fontSize: 10),
                                                                  )
                                                                ],
                                                              ),
                                                              Divider(
                                                                color: Colors
                                                                    .grey[400],
                                                                thickness: 2,
                                                              )
                                                            ],
                                                          ),
                                                          const SizedBox(
                                                            height: 15,
                                                          ),
                                                          FittedBox(
                                                            fit: BoxFit
                                                                .scaleDown,
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: _dummyList[
                                                                            selectedIndex]
                                                                        .toList()
                                                                        .map((e) =>
                                                                            Padding(
                                                                              padding: const EdgeInsets.all(3.0),
                                                                              child: Text(
                                                                                e[0],
                                                                                style: TextSchemes.titleStyle.copyWith(color: AppColorScheme.darkGreen, fontSize: 10),
                                                                              ),
                                                                            ))
                                                                        .toList()),
                                                                Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: _dummyList[
                                                                            selectedIndex]
                                                                        .toList()
                                                                        .map((e) =>
                                                                            Padding(
                                                                              padding: const EdgeInsets.all(3.0),
                                                                              child: Text(
                                                                                e[1],
                                                                                style: TextStyle(color: Colors.grey, fontSize: 10),
                                                                              ),
                                                                            ))
                                                                        .toList())
                                                              ],
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                            height: 25,
                                                          ),
                                                          Row(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .max,
                                                            children: [
                                                              Row(
                                                                children: [
                                                                  Icon(
                                                                    FrontendIcons
                                                                        .fingerprint_stroke,
                                                                    color: Colors
                                                                            .grey[
                                                                        400],
                                                                  ),
                                                                  const SizedBox(
                                                                    width: 5,
                                                                  ),
                                                                  Text(
                                                                    'Device\nFingerprint',
                                                                    style: TextSchemes
                                                                        .titleStyle
                                                                        .copyWith(
                                                                            color:
                                                                                Colors.grey[400],
                                                                            fontSize: 10),
                                                                  )
                                                                ],
                                                              ),
                                                              Divider(
                                                                color: Colors
                                                                    .grey[400],
                                                                thickness: 2,
                                                              )
                                                            ],
                                                          ),
                                                          const SizedBox(
                                                            height: 15,
                                                          ),
                                                          FittedBox(
                                                            fit: BoxFit
                                                                .scaleDown,
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: _dummyList[
                                                                            selectedIndex]
                                                                        .fingerprint
                                                                        .toList()
                                                                        .map((e) =>
                                                                            Padding(
                                                                              padding: const EdgeInsets.all(3.0),
                                                                              child: Text(
                                                                                e[0],
                                                                                style: TextSchemes.titleStyle.copyWith(color: AppColorScheme.darkGreen, fontSize: 10),
                                                                              ),
                                                                            ))
                                                                        .toList()),
                                                                Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: _dummyList[
                                                                            selectedIndex]
                                                                        .fingerprint
                                                                        .toList()
                                                                        .map((e) =>
                                                                            Padding(
                                                                              padding: const EdgeInsets.all(3.0),
                                                                              child: Text(
                                                                                e[1],
                                                                                style: TextStyle(color: e[1] == true ? AppColorScheme.susRed : Colors.grey, fontSize: 10),
                                                                              ),
                                                                            ))
                                                                        .toList())
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Positioned(
                                                    bottom: 10,
                                                    right: 10,
                                                    child: Stack(
                                                      key: _seeHistoryKey,
                                                      children: [
                                                        Container(
                                                          height: 25,
                                                          width: 75,
                                                          decoration: ContainerDecorations
                                                              .whiteContainerDeco
                                                              .copyWith(
                                                                  color: AppColorScheme
                                                                      .lightGreen),
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(4.0),
                                                            child: FittedBox(
                                                                fit: BoxFit
                                                                    .contain,
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceAround,
                                                                  children: const [
                                                                    Icon(
                                                                      Icons
                                                                          .share_outlined,
                                                                      color: Colors
                                                                          .white,
                                                                    ),
                                                                    SizedBox(
                                                                      width: 5,
                                                                    ),
                                                                    Text(
                                                                        'See connection\nhistory',
                                                                        style: TextStyle(
                                                                            color:
                                                                                Colors.white))
                                                                  ],
                                                                )),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: 25,
                                                          width: 75,
                                                          child: Material(
                                                            color: Colors
                                                                .transparent,
                                                            child: InkWell(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          20),
                                                              onTap: () {
                                                                //  print(position);
                                                                circleController
                                                                    .forward();
                                                              },
                                                            ),
                                                          ),
                                                        )
                                                      ],
                                                    )),
                                              ],
                                            )),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            )),
                      )
                    ],
                  ),
                )),
            const Positioned(
              bottom: 0,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: BottomNBar(style: 2),
              ),
            ),
            AnimatedBuilder(
                animation: circleController,
                builder: ((context, child) => ClipPath(
                    clipper: CircleTransition(
                        center: center, value: circleAnimation.value),
                    child: const MapPage()))),
          ],
        ));
  }
}

class BigCard extends StatelessWidget {
  final Person person;
  const BigCard({super.key, required this.person});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 100,
        decoration: ContainerDecorations.whiteContainerDeco
            .copyWith(color: AppColorScheme.lighterGreen, boxShadow: []),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.person_outline_outlined,
                    color: AppColorScheme.darkGreen,
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Text(
                    person.fullName,
                    style: TextSchemes.titleStyle.copyWith(
                        fontSize: 12.5, color: AppColorScheme.darkGreen),
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Created at: ${DateFormat("dd-MM-yyyy").format(person.dateCreated)}",
                        style: TextSchemes.titleStyle.copyWith(
                            fontSize: 7.5, color: AppColorScheme.darkGreen),
                      ),
                      Text(
                        "Last IP: ${person.lastIP}",
                        style: TextSchemes.titleStyle.copyWith(
                            fontSize: 7.5, color: AppColorScheme.darkGreen),
                      ),
                    ],
                  ),
                  if (person.isLegit)
                    Container(
                      height: 17.5,
                      width: 40,
                      decoration: BoxDecoration(
                          color: AppColorScheme.greishWhite.withOpacity(.75),
                          borderRadius: BorderRadius.circular(5)),
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Icon(
                                Icons.check_rounded,
                                color: AppColorScheme.normalGreen,
                              ),
                              const SizedBox(
                                width: 2.5,
                              ),
                              Text(
                                'Verified',
                                style: TextStyle(
                                    color: AppColorScheme.normalGreen),
                              )
                            ],
                          ),
                        ),
                      ),
                    )
                  else
                    Container(
                      height: 17.5,
                      width: 40,
                      decoration: BoxDecoration(
                          color: AppColorScheme.bkgSusRed,
                          borderRadius: BorderRadius.circular(5)),
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Icon(
                                Icons.close_rounded,
                                color: AppColorScheme.susRed,
                              ),
                              const SizedBox(
                                width: 2.5,
                              ),
                              Text(
                                'Flagged',
                                style: TextStyle(color: AppColorScheme.susRed),
                              )
                            ],
                          ),
                        ),
                      ),
                    )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class MiniCard extends StatefulWidget {
  final Person person;
  int selected;
  int newIndex;
  final int index;
  MiniCard({
    super.key,
    required this.person,
    required this.selected,
    required this.index,
    required this.newIndex,
  });

  @override
  State<MiniCard> createState() => _MiniCardState();
}

class _MiniCardState extends State<MiniCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        height: 50,
        decoration: ContainerDecorations.whiteContainerDeco.copyWith(
            color: AppColorScheme.lightGreen,
            borderRadius: BorderRadius.circular(10),
            boxShadow: widget.selected == widget.index
                ? [
                    const BoxShadow(
                        offset: Offset(0, 4),
                        blurRadius: 10,
                        color: Colors.black12)
                  ]
                : []),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2.5, vertical: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                widget.person.fullName.replaceFirst(' ', '\n'),
                style: TextSchemes.titleStyle
                    .copyWith(fontSize: 10, color: AppColorScheme.darkGreen),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: Container(
                  height: 10,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColorScheme.greishWhite),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: widget.person.isLegit
                        ? Icon(
                            Icons.check_rounded,
                            color: AppColorScheme.normalGreen,
                          )
                        : Icon(
                            Icons.close_rounded,
                            color: AppColorScheme.susRed,
                          ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class CircleTransition extends CustomClipper<Path> {
  final Offset center;
  double value;
  CircleTransition({required this.center, required this.value});

  @override
  Path getClip(Size size) {
    const radius = 10.0;

    Path path = Path();

    path.addOval(Rect.fromCircle(center: center, radius: radius * value));

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    // TODO: implement shouldReclip
    return true;
  }
}

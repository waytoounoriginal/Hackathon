import 'package:flutter/material.dart';
import 'package:animations/animations.dart';

import '../others/color_scheme.dart';
import '../others/frontend_icons_icons.dart';

class BottomNBar extends StatelessWidget {
  final int style;
  const BottomNBar({super.key, required this.style});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (style == 2)
              Align(
                alignment: Alignment.bottomLeft,
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Container(
                      height: 50,
                      width: 100,
                      decoration: ContainerDecorations.whiteContainerDeco
                          .copyWith(color: AppColorScheme.lighterGreen),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Icon(
                            Icons.arrow_back,
                            color: AppColorScheme.darkGreen,
                          ),
                          Text(
                            'Back',
                            style: TextSchemes.titleStyle
                                .copyWith(color: AppColorScheme.darkGreen),
                          )
                        ],
                      )),
                ),
              )
            else
              const SizedBox(),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'dart:math';

import 'package:get/get.dart';
import 'package:locateme/Configuration/Pallette.dart';
import 'package:locateme/Controllers/AppController.dart';
import 'package:locateme/Services/ThemServices.dart';

/// AdvancedDrawer widget.
class AdvancedDrawer extends StatefulWidget {
  const AdvancedDrawer({
    Key key,
    @required this.child,
    @required this.drawer,
    this.controller,
    this.backdropColor,
    this.openRatio = 0.75,
    this.animationDuration = const Duration(milliseconds: 300),
    this.animationCurve = Curves.easeInOut,
    this.childDecoration = const BoxDecoration(
      boxShadow: <BoxShadow>[
        BoxShadow(
          color: Colors.black12,
          blurRadius: 8.0,
        ),
      ],
      borderRadius: const BorderRadius.all(Radius.circular(16)),
    ),
  }) : super(key: key);

  /// Child widget. (Usually widget that represent a screen)
  final Widget child;

  /// Drawer widget. (Widget behind the [child]).
  final Widget drawer;

  /// Controller that controls widget state.
  final AdvancedDrawerController controller;

  /// Backdrop color.
  final Color backdropColor;

  /// Opening ratio.
  final double openRatio;

  /// Animation duration.
  final Duration animationDuration;

  /// Animation curve.
  final Curve animationCurve;

  /// Child container decoration in open widget state.
  final BoxDecoration childDecoration;

  @override
  _AdvancedDrawerState createState() => _AdvancedDrawerState();
}

class _AdvancedDrawerState extends State<AdvancedDrawer>
    with SingleTickerProviderStateMixin {
  AdvancedDrawerController _controller;
  AnimationController _animationController;
  Animation<double> _commonAnimation;

  @override
  void initState() {
    super.initState();

    _controller = widget.controller ?? AdvancedDrawerController();

    _animationController = AnimationController(
      vsync: this,
      duration: widget.animationDuration,
      value: _controller.value.visible ? 1 : 0,
    );

    _commonAnimation = CurvedAnimation(
      parent: _animationController,
      curve: widget.animationCurve,
    );

    _controller.addListener(() {
      _controller.value.visible
          ? _animationController.forward()
          : _animationController.reverse();
    });
  }

  @override
  Widget build(BuildContext context) {
    // final theme = Theme.of(context);
    final screenSize = MediaQuery.of(context).size;

    final drawerScalingAnimation = Tween<double>(
      begin: 0.75,
      end: 1.0,
    ).animate(_commonAnimation);

    final drawerOpacityAnimation = Tween<double>(
      begin: 0.25,
      end: 1.0,
    ).animate(_commonAnimation);

    final screenScalingTween = Tween<double>(
      begin: 1.0,
      end: 0.85,
    ).animate(_commonAnimation);

    final screenTranslateTween = Tween<Offset>(
      begin: Offset(0, 0),
      end: Offset(screenSize.width * widget.openRatio, 0),
    ).animate(_commonAnimation);

    return Material(
      color: widget.backdropColor,
      child: Stack(
        children: <Widget>[
          // -------- DRAWER
          FractionallySizedBox(
            widthFactor: widget.openRatio,
            child: AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return Transform.scale(
                  alignment: Alignment.centerRight,
                  scale: drawerScalingAnimation.value,
                  child: Opacity(
                    opacity: min(drawerOpacityAnimation.value, 1),
                    child: child,
                  ),
                );
              },
              child: Container(
                alignment: Alignment.centerLeft,
                child: widget.drawer,
              ),
            ),
          ),
          // shadow
          AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return Transform.translate(
                offset: screenTranslateTween.value -
                    Offset(
                        Get.locale.languageCode == "en"
                            ? 40
                            : Get.width * 0.89 + 20,
                        0),
                child: Transform.scale(
                  alignment: Alignment.centerLeft,
                  scale: screenScalingTween.value - 0.1,
                  child: Container(
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration.lerp(
                      BoxDecoration(
                        boxShadow: const [],
                        borderRadius: BorderRadius.zero,
                      ),
                      widget.childDecoration,
                      _animationController.value,
                    ),
                    child: child,
                  ),
                ),
              );
            },
            child: Container(
              color: ThemeService().isDarkMode()
                  ? Colors.black12
                  : Colors.white.withAlpha(31),
            ),
          ),
          AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return Transform.translate(
                offset: screenTranslateTween.value -
                    Offset(
                        Get.locale.languageCode == "en" ? 20 : Get.width + 30,
                        0),
                child: Transform.scale(
                  alignment: Alignment.centerLeft,
                  scale: screenScalingTween.value - 0.05,
                  child: Container(
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration.lerp(
                      BoxDecoration(
                        boxShadow: const [],
                        borderRadius: BorderRadius.zero,
                      ),
                      widget.childDecoration,
                      _animationController.value,
                    ),
                    child: child,
                  ),
                ),
              );
            },
            child: Container(
              color:
                  ThemeService().isDarkMode() ? Colors.black38 : Colors.white,
            ),
          ),

          // -------- CHILD
          AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return Transform.translate(
                offset: Get.locale.languageCode == "en"
                    ? screenTranslateTween.value
                    : -screenTranslateTween.value,
                child: Transform.scale(
                  alignment: Alignment.centerLeft,
                  scale: screenScalingTween.value,
                  child: Container(
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration.lerp(
                      BoxDecoration(
                        boxShadow: const [],
                        borderRadius: BorderRadius.zero,
                      ),
                      widget.childDecoration,
                      _animationController.value,
                    ),
                    child: child,
                  ),
                ),
              );
            },
            // child: widget.child,
            child: ValueListenableBuilder<AdvancedDrawerValue>(
              valueListenable: _controller,
              builder: (_, value, child) {
                if (value.visible) {
                  return Stack(
                    children: [
                      child,
                      if (value.visible)
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              // _controller.hideDrawer();
                              Get.find<AppController>()
                                  .handleMenuButtonPressed();
                            },
                            splashColor: mainColor.withOpacity(0.6),
                            highlightColor: Colors.transparent,
                            child: Container(
                              color: Colors.transparent,
                            ),
                          ),
                        ),
                    ],
                  );
                }

                return child;
              },
              child: widget.child,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();

    if (widget.controller == null) {
      _controller.dispose();
    }

    super.dispose();
  }
}

/// Advanced Drawer Controller that manage drawer state.
class AdvancedDrawerController extends ValueNotifier<AdvancedDrawerValue> {
  /// Creates controller with initial drawer state. (Hidden by default)
  AdvancedDrawerController([AdvancedDrawerValue value])
      : super(value ?? AdvancedDrawerValue.hidden());

  /// Shows drawer.
  void showDrawer() {
    value = AdvancedDrawerValue.visible();
  }

  /// Hides drawer.
  void hideDrawer() {
    value = AdvancedDrawerValue.hidden();
  }

  /// Toggles drawer.
  void toggleDrawer() {
    if (value.visible) {
      hideDrawer();
    } else {
      showDrawer();
    }
  }
}

/// AdvancedDrawer state value.
class AdvancedDrawerValue {
  const AdvancedDrawerValue({
    this.visible,
  });

  /// Indicates whether drawer visible or not.
  final bool visible;

  factory AdvancedDrawerValue.hidden() {
    return const AdvancedDrawerValue(
      visible: false,
    );
  }

  factory AdvancedDrawerValue.visible() {
    return const AdvancedDrawerValue(
      visible: true,
    );
  }
}

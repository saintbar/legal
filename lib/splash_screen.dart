import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {

  final Widget firstChild;
  final Widget secondChild;
  final Duration duration;
  final Duration switchDuration;

  const SplashScreen({
    Key? key,
    required this.firstChild,
    required this.secondChild,
    required this.duration,
    required this.switchDuration
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return SplashScreenState();
  }

}

class SplashScreenState extends State<SplashScreen> {

  bool _showSecond = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(widget.duration, () => {
      setState(() { _showSecond = true; })
    });
  }
  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: widget.switchDuration,
      child: _showSecond? widget.secondChild : widget.firstChild,
    );
  }

}
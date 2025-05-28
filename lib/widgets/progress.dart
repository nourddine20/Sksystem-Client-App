// ignore_for_file: unused_field, unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:flutter_application_1/theme/constant.dart';

class PForm extends StatefulWidget {
  final List<Widget> pages;
  final List<PTitle> title;
  PFormController controller;
  Color activeColor, disableColor;
  double? height;
  PForm(
      {required this.pages,
      required this.title,
      required this.controller,
      this.activeColor = primary,
      this.disableColor = Colors.grey,
      this.height = 300});
  @override
  State<PForm> createState() => _PFormState();
}

class _PFormState extends State<PForm> with TickerProviderStateMixin {
  late List<AnimationController> _controllers;
  late List<Animation<double>> _annimations;
  late List<Animation<double>> _animationsOpavity;
  late List<bool> activeColor;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _controllers = List.generate(
        widget.pages.length,
        (index) => AnimationController(
            vsync: this,
            duration: Duration(milliseconds: 200),
            lowerBound: .1));

    _annimations = _controllers
        .map((_controller) =>
            Tween<double>(begin: .05, end: 1).animate(_controller))
        .toList();

    _animationsOpavity = _controllers
        .map((_controller) =>
            Tween<double>(begin: 0, end: 1).animate(_controller))
        .toList();

    activeColor = List.generate(widget.pages.length, (index) => false);

    if (widget.controller != null) {
      widget.controller.addListener(() {
        controlColor(widget.controller.currentPage);
      });
    }
  }

  controlColor(int index) {
    for (var i = 0; i < activeColor.length; i++) {
      if (index == i) {
        if (!_controllers[i].isCompleted) _controllers[index].animateTo(1);
      } else {
        if (_controllers[i].isCompleted) {
          _controllers[i].reverse();
        }
      }
    }

    for (var i = 0; i <= index; i++) {
      activeColor[i] = true;
    }

    for (var i = index + 1; i < activeColor.length; i++) {
      activeColor[i] = false;
    }

    setState(() {});
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

    _controllers.forEach((c) {
      c.dispose();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: widget.pages.map((e) {
        int index = widget.pages.indexOf(e);
        return Stack(
          children: [
            if (index != widget.pages.length - 1)
              Container(
                margin: EdgeInsets.only(left: 2, top: 37),
                child: SizeTransition(
                  sizeFactor: _annimations[index],
                  child: Container(
                      margin: EdgeInsets.only(left: 13, right: 20),
                      width: 3,
                      height: widget.height,
                      color: activeColor[index + 1]
                          ? primary.withOpacity(.8)
                          : Colors.grey),
                ),
              ),
            Column(
              children: [
                Row(
                  children: [
                    InkWell(
                        // onTap: () {
                        //   controlColor(index);
                        // },
                        child: Container(
                      width: 35,
                      height: 35,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: activeColor[index]
                              ? widget.activeColor.withOpacity(.8)
                              : widget.disableColor),
                    )),
                    SizedBox(
                      width: 10,
                    ),
                    widget.title[index]
                  ],
                ),
                Row(
                  children: [
                    SizedBox(
                      width: 50,
                    ),
                    Expanded(
                        child: FadeTransition(
                      opacity: _animationsOpavity[index],
                      child: SizeTransition(
                        sizeFactor: _annimations[index],
                        child: e,
                      ),
                    ))
                  ],
                )
              ],
            )
          ],
        );
      }).toList(),
    ));
  }
}

class PTitle extends StatelessWidget {
  String? title, subTitle;
  Color? activeColor;
  PTitle({this.activeColor, this.subTitle, this.title});
  @override
  Widget build(BuildContext context) {
    if (activeColor == null) activeColor = Colors.black;

    return Column(
      children: [
        Text(
          title!,
          style: TextStyle(
              fontSize: 15, fontWeight: FontWeight.bold, color: activeColor),
        ),
        if (subTitle != null)
          Padding(
            padding:
                EdgeInsets.only(left: 16), // Adjust the left margin as needed
            child: Text(
              subTitle!,
              style: TextStyle(color: Colors.black54),
            ),
          ),
      ],
    );
  }

  // copyWith({String? title, String? subTitle, Color? activeColor}) {
  //   return Column(
  //     children: [
  //       Text(
  //         title!,
  //         style: TextStyle(
  //             fontSize: 15,
  //             fontWeight: FontWeight.bold,
  //             color: activeColor ?? this.activeColor),
  //       ),
  //       Text(subTitle ?? this.subTitle ?? "")
  //     ],
  //   );
  // }
}

class PFormController extends ChangeNotifier {
  PFormController(this.length);
  int _page = -1;
  final int? length;

  nextPage() {
    if (_page < length! - 1) _page++;

    notifyListeners();
  }

  get currentPage => _page;

  set jumpToPage(int p) {
    _page = p;
    notifyListeners();
  }

  prevPage() {
    if (_page > 0) _page--;

    notifyListeners();
  }
}

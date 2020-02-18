
import 'package:flutter/material.dart';

class MyProgressWidget extends StatelessWidget {
  final int progress;

  final double width;
  final double height = 6;
  final double radius = 6;

  MyProgressWidget(this.progress, this.width);

  @override
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(radius)),
          child: Stack(
            children: <Widget>[
              Container(
                width: width,
                height: height,
                decoration: BoxDecoration(color: Colors.black12),
              ),
              Positioned(
                left: 0,
                child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(radius)),
                  child: Container(
                    width: progress / 100 * width,
                    height: height,
                    decoration: BoxDecoration(color: Colors.green),
                  ),
                ),
              )
            ],
          )),
    );
  }
}

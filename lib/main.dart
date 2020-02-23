import 'package:flutter/material.dart';
import 'package:neumorphism_flutter/const.dart';
import 'package:neumorphism_flutter/lightsourcewidget.dart';
import 'package:neumorphism_flutter/slider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Neumorphism',
      debugShowCheckedModeBanner: false,
      home: Neumorphism(title: 'Neumorphic Builder'),
    );
  }
}

class Neumorphism extends StatefulWidget {
  Neumorphism({Key key, this.title}) : super(key: key);

  final String title;

  @override
  NeumorphismState createState() => NeumorphismState();
}

class NeumorphismState extends State<Neumorphism> {
  Widget columnWidget() {
    return Column(
      children: <Widget>[
        Expanded(flex: 4, child: neumorphicContainer()),
        SizedBox(
          height: 20,
        ),
        Expanded(flex: 3, child: neumorphicSliders())
      ],
    );
  }

  Widget rowWidget() {
    return Row(children: <Widget>[
      Expanded(child: neumorphicContainer()),
      SizedBox(
        width: 20,
      ),
      Expanded(child: neumorphicSliders())
    ]);
  }

  Widget lightSource({double angle}) {
    return Container(
      height: 50, //size.width > 400 ? 80 : 50,
      width: 50, //size.width > 400 ? 80 : 50,
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(color: Colors.white, boxShadow: [
        BoxShadow(
            offset: Offset(5, 3),
            blurRadius: 5,
            // spreadRadius: 10,
            color: Colors.grey)
      ]),
      child: Transform.rotate(
        angle: angle,
        child: Icon(
          Icons.highlight,
          color: Colors.yellow,
          size: 50,
        ),
      ),
    );
  }

  Widget neumorphicContainer() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              LightSource(
                angle: 90,
                isEnabled:
                    enabled == LightSourcePosition.topLeft ? true : false,
                position: LightSourcePosition.topLeft,
                onTap: () {
                  setState(() {
                    enabled = LightSourcePosition.topLeft;
                  });
                },
              ),
              LightSource(
                angle: 180,
                isEnabled:
                    enabled == LightSourcePosition.topRight ? true : false,
                position: LightSourcePosition.topRight,
                onTap: () {
                  setState(() {
                    enabled = LightSourcePosition.topRight;
                  });
                },
              )
            ],
          ),
          Container(
            height: 200,
            width: 200,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(borderRadius),
                boxShadow: [
                  BoxShadow(
                    color: Color.fromRGBO(32, 32, 32, intensityValue),
                    offset: getOffsetDirection(),
                    blurRadius: blurRadius,
                    spreadRadius: spreadRadius,
                  )
                ]),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              LightSource(
                angle: 45,
                isEnabled:
                    enabled == LightSourcePosition.bottomLeft ? true : false,
                position: LightSourcePosition.bottomLeft,
                onTap: () {
                  setState(() {
                    enabled = LightSourcePosition.bottomLeft;
                  });
                },
              ),
              LightSource(
                angle: -45,
                isEnabled:
                    enabled == LightSourcePosition.bottomRight ? true : false,
                position: LightSourcePosition.bottomRight,
                onTap: () {
                  setState(() {
                    enabled = LightSourcePosition.bottomRight;
                  });
                },
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget neumorphicSliders() {
    return Container(
      color: Colors.grey[300],
      padding: EdgeInsets.all(20),
      child: Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SliderController(
              value: borderRadius.toString().length > 2
                  ? double.parse(borderRadius.toString().substring(0, 2))
                  : borderRadius,
              label: "Border Radius",
              onChange: (val) => onBorderRadiusChange(val),
              min: BORDER_RADIUS_MIN,
              max: BORDER_RADIUS_MAX,
            ),
            SliderController(
              value: blurRadius.toString().length > 4
                  ? double.parse(blurRadius.toString().substring(0, 4))
                  : blurRadius,
              label: "Blur Radius",
              onChange: (val) => onBlurRadiusChange(val),
              min: BLUR_RADIUS_MIN,
              max: BLUR_RADIUS_MAX,
            ),
            SliderController(
              value: spreadRadius.toString().length > 5
                  ? double.parse(spreadRadius.toString().substring(0, 5))
                  : spreadRadius,
              label: "Spread Radius",
              onChange: (val) => onSpreadRadiusChange(val),
              min: SPREAD_RADIUS_MIN,
              max: SPREAD_RADIUS_MAX,
            ),
            SliderController(
              value: intensityValue.toString().length > 5
                  ? double.parse(intensityValue.toString().substring(0, 5))
                  : intensityValue,
              label: "Intensity",
              onChange: (val) => onIntensityChange(val),
              min: 0.1,
              max: 0.5,
            )
          ],
        ),
      ),
    );
  }

  void onBorderRadiusChange(double value) {
    setState(() {
      borderRadius = value;
    });
  }

  void onBlurRadiusChange(double value) {
    setState(() {
      blurRadius = value;
    });
  }

  void onSpreadRadiusChange(double value) {
    setState(() {
      spreadRadius = value;
    });
  }

  void onIntensityChange(double value) {
    setState(() {
      intensityValue = value;
    });
  }

  Offset getOffsetDirection() {
    switch (enabled) {
      case LightSourcePosition.topLeft:
        return Offset(10, 10);
        break;
      case LightSourcePosition.topRight:
        return Offset(-10, 10);
        break;
      case LightSourcePosition.bottomLeft:
        return Offset(10, -10);
        break;
      case LightSourcePosition.bottomRight:
        return Offset(-10, -10);
        break;
      default:
    }
  }

  Size size;
  double borderRadius = 20;
  double blurRadius = 20;
  double spreadRadius = 10;
  double intensityValue = 0.2;
  LightSourcePosition enabled = LightSourcePosition.bottomLeft;
  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Scaffold(
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          if (constraints.maxWidth > 600)
            return rowWidget();
          else
            return columnWidget();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: null,
        tooltip: 'Info',
        backgroundColor: Colors.white,
        foregroundColor: Colors.grey,
        child: Icon(Icons.info),
      ),
    );
  }
}

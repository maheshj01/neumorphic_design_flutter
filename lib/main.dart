import 'package:flutter/material.dart';
import 'package:neumorphism_flutter/const.dart';
import 'package:neumorphism_flutter/control_bloc.dart';
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
        // SizedBox(
        //   height: 20,
        // ),
        Expanded(flex: 3, child: neumorphicSliders())
      ],
    );
  }

  Widget rowWidget() {
    return Row(children: <Widget>[
      Expanded(child: neumorphicContainer()),
      // SizedBox(
      //   width: 20,
      // ),
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
      color: nightMode ? ThemeData.dark().backgroundColor : Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          StreamBuilder<LightSourcePosition>(
              initialData: LightSourcePosition.topLeft,
              stream: bloc.lightController.stream,
              builder: (context, snapshot) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    LightSource(
                      angle: 90,
                      isEnabled: snapshot.data == LightSourcePosition.topLeft
                          ? true
                          : false,
                      position: LightSourcePosition.topLeft,
                      onTap: () {
                        bloc.lightController.sink
                            .add(LightSourcePosition.topLeft);
                      },
                    ),
                    LightSource(
                      angle: 180,
                      isEnabled: snapshot.data == LightSourcePosition.topRight
                          ? true
                          : false,
                      position: LightSourcePosition.topRight,
                      onTap: () {
                        bloc.lightController.sink
                            .add(LightSourcePosition.topRight);
                      },
                    )
                  ],
                );
              }),
          StreamBuilder<LightSourcePosition>(
              initialData: LightSourcePosition.topLeft,
              stream: bloc.lightController.stream,
              builder: (BuildContext context,
                  AsyncSnapshot<LightSourcePosition> snapshot) {
                return Container(
                  height: 200,
                  width: 200,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: nightMode
                          ? ThemeData.dark().backgroundColor
                          : Colors.white,
                      borderRadius: BorderRadius.circular(borderRadius),
                      boxShadow: [
                        BoxShadow(
                          color: nightMode
                              ? Colors.white.withOpacity(0.2)
                              : Colors.white.withOpacity(intensityValue),
                          offset: Offset(-10, -10),
                          blurRadius: blurRadius,
                          spreadRadius: spreadRadius,
                        ),
                        BoxShadow(
                          color: nightMode
                              ? Colors.white.withOpacity(0.2)
                              : Colors.black.withOpacity(intensityValue),
                          offset: getOffsetDirection(snapshot),
                          blurRadius: blurRadius,
                          spreadRadius: spreadRadius,
                        )
                      ]),
                );
              }),
          StreamBuilder<LightSourcePosition>(
              initialData: LightSourcePosition.topLeft,
              stream: bloc.lightController.stream,
              builder: (context, snapshot) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    LightSource(
                      angle: 45,
                      isEnabled: snapshot.data == LightSourcePosition.bottomLeft
                          ? true
                          : false,
                      position: LightSourcePosition.bottomLeft,
                      onTap: () {
                        bloc.lightController.sink
                            .add(LightSourcePosition.bottomLeft);
                      },
                    ),
                    LightSource(
                      angle: -45,
                      isEnabled:
                          snapshot.data == LightSourcePosition.bottomRight
                              ? true
                              : false,
                      position: LightSourcePosition.bottomRight,
                      onTap: () {
                        bloc.lightController.sink
                            .add(LightSourcePosition.bottomRight);
                      },
                    )
                  ],
                );
              }),
        ],
      ),
    );
  }

  Widget neumorphicSliders() {
    return Container(
      color: Colors.grey[300].withOpacity(0.2),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
                alignment: Alignment.centerRight,
                margin: EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    IconButton(
                        icon: Icon(Icons.refresh),
                        iconSize: 30,
                        onPressed: () {
                          bloc.blurController.add(DEFAULT_BLUR);
                          bloc.radiusController.add(DEFAULT_BORDER);
                          bloc.intensityController.add(DEFAULT_INTENSITY);
                          bloc.spreadController.add(DEFAULT_SPREAD);
                          setState(() {
                            borderRadius = 20;
                            blurRadius = 20;
                            spreadRadius = 10;
                            intensityValue = 0.1;
                            nightMode = false;
                          });
                        }),
                    Wrap(
                      children: <Widget>[
                        IconButton(
                            icon: Icon(Icons.navigation), onPressed: null),
                        Switch(
                            value: nightMode,
                            onChanged: (value) {
                              setState(() {
                                nightMode = value;
                              });
                            }),
                      ],
                    )
                  ],
                )),
            Container(
              height: 1,
              color: Colors.black26,
            ),
            StreamBuilder<String>(
                initialData: DEFAULT_BORDER,
                stream: bloc.radiusController.stream,
                builder:
                    (BuildContext context, AsyncSnapshot<String> snapshot) {
                  return SliderController(
                    value: snapshot.data.length > 2
                        ? double.parse(snapshot.data.substring(0, 2))
                        : double.parse(snapshot.data),
                    label: "Border Radius",
                    onChange: (val) => onBorderRadiusChange(val),
                    min: BORDER_RADIUS_MIN,
                    max: BORDER_RADIUS_MAX,
                  );
                }),
            StreamBuilder<String>(
                stream: bloc.blurController.stream,
                initialData: DEFAULT_BLUR,
                builder:
                    (BuildContext context, AsyncSnapshot<String> snapshot) {
                  return SliderController(
                    value: snapshot.data.length > 4
                        ? double.parse(snapshot.data.substring(0, 4))
                        : double.parse(snapshot.data),
                    label: "Blur Radius",
                    onChange: (val) => onBlurRadiusChange(val),
                    min: BLUR_RADIUS_MIN,
                    max: BLUR_RADIUS_MAX,
                  );
                }),
            StreamBuilder<String>(
                stream: bloc.spreadController.stream,
                initialData: DEFAULT_SPREAD,
                builder:
                    (BuildContext context, AsyncSnapshot<String> snapshot) {
                  return SliderController(
                    value: snapshot.data.length > 5
                        ? double.parse(snapshot.data.substring(0, 5))
                        : double.parse(snapshot.data),
                    label: "Spread Radius",
                    onChange: (val) => onSpreadRadiusChange(val),
                    min: SPREAD_RADIUS_MIN,
                    max: SPREAD_RADIUS_MAX,
                  );
                }),
            StreamBuilder<String>(
                stream: bloc.intensityController.stream,
                initialData: DEFAULT_INTENSITY,
                builder:
                    (BuildContext context, AsyncSnapshot<String> snapshot) {
                  print(snapshot.data);
                  return SliderController(
                    value: snapshot.data.length > 5
                        ? double.parse(snapshot.data.substring(0, 5))
                        : double.parse(snapshot.data),
                    label: "Intensity",
                    onChange: (val) => onIntensityChange(val),
                    min: 0.1,
                    max: 0.5,
                  );
                })
          ],
        ),
      ),
    );
  }

  Widget aboutApp() {
    return Container(
      width: 300,
      child: AlertDialog(
        elevation: 0.5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        title: Center(
          child: Text("About"),
        ),
        content: Text(
            'A Neumorphic design tool built with Flutter for the awesome Flutter Community 💙. \nFound some Issues or have some suggestions feel free to create a issue on this repo @github '),
      ),
    );
  }

  void onBorderRadiusChange(double value) {
    bloc.radiusController.sink.add(value.toString());
    setState(() {
      borderRadius = value;
    });
  }

  void onBlurRadiusChange(double value) {
    bloc.blurController.sink.add(value.toString());
    setState(() {
      blurRadius = value;
    });
  }

  void onSpreadRadiusChange(double value) {
    bloc.spreadController.sink.add(value.toString());
    setState(() {
      spreadRadius = value;
    });
  }

  void onIntensityChange(double value) {
    bloc.intensityController.sink.add(value.toString());
    setState(() {
      intensityValue = value;
    });
  }

  Offset getOffsetDirection(AsyncSnapshot snapshot) {
    switch (snapshot.data) {
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
  bool nightMode = false;
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
        onPressed: () => showDialog(context: (context), child: aboutApp()),
        tooltip: 'Info',
        backgroundColor: Colors.white,
        foregroundColor: Colors.grey,
        child: Icon(Icons.info),
      ),
    );
  }
}

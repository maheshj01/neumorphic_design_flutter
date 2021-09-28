import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:neumorphism_flutter/const.dart';
import 'package:neumorphism_flutter/control_bloc.dart';
import 'package:neumorphism_flutter/lightsourcewidget.dart';
import 'package:neumorphism_flutter/model.dart';
import 'package:neumorphism_flutter/slider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'const.dart';
import 'lightsourcewidget.dart';
import 'slider.dart';

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
  Neumorphism({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  NeumorphismState createState() => NeumorphismState();
}

class NeumorphismState extends State<Neumorphism> {
  Widget columnWidget() {
    return Column(
      children: <Widget>[
        Expanded(flex: 4, child: neumorphicContainer()),
        Expanded(flex: 3, child: neumorphicSliders())
      ],
    );
  }

  Widget rowWidget() {
    return Row(children: <Widget>[
      Expanded(child: neumorphicContainer()),
      Expanded(child: neumorphicSliders())
    ]);
  }

  Widget lightSource({required double angle}) {
    return Container(
      height: 50,
      width: 50,
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(color: Colors.white, boxShadow: [
        BoxShadow(offset: Offset(5, 3), blurRadius: 5, color: Colors.grey)
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
      color: nightMode ? CONTAINER_DARK_COLOR : CONTAINER_WHITE_COLOR,
      padding: EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          StreamBuilder<LightSourcePosition>(
              initialData: LightSourcePosition.topLeft,
              stream: bloc.lightController.stream,
              builder: (context, AsyncSnapshot<LightSourcePosition> snapshot) {
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
                          ? CONTAINER_DARK_COLOR
                          : CONTAINER_WHITE_COLOR,
                      borderRadius: BorderRadius.circular(borderRadius),
                      boxShadow: [
                        BoxShadow(
                          color: nightMode
                              ? ThemeData.dark().backgroundColor
                              : WHITE_LIGHT_COLOR,
                          blurRadius: blurRadius,
                          spreadRadius: spreadRadius,
                        ),
                        BoxShadow(
                          color: nightMode
                              ? ThemeData.dark()
                                  .backgroundColor
                                  .withOpacity(0.1)
                              : Color.fromRGBO(206, 213, 222, intensityValue),
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
      color: Colors.grey[300]!.withOpacity(0.2),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
        child: ListView(
          controller: _scrollController,
          children: <Widget>[
            Container(
                alignment: Alignment.centerRight,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Container(
                        margin: EdgeInsets.all(5),
                        child: IconButton(
                            icon: Icon(Icons.refresh),
                            onPressed: () {
                              bloc.blurController.add(DEFAULT_BLUR);
                              bloc.radiusController.add(DEFAULT_BORDER);
                              bloc.intensityController.add(DEFAULT_INTENSITY);
                              bloc.spreadController.add(DEFAULT_SPREAD);
                              setState(() {
                                borderRadius = double.parse(DEFAULT_BORDER);
                                blurRadius = double.parse(DEFAULT_BLUR);
                                spreadRadius = double.parse(DEFAULT_SPREAD);
                                intensityValue =
                                    double.parse(DEFAULT_INTENSITY);
                              });
                            })),
                    IconButton(
                        icon: Icon(Icons.code),
                        onPressed: () {
                          print('$borderRadius');
                          final model = ContainerModel();
                          model.blurRadius = blurRadius.toString();
                          model.borderRadius = borderRadius.toString();
                          model.spreadRadius = blurRadius.toString();
                          model.intensity = intensityValue.toString();
                          setState(() {
                            dartCode = getDartCode(model: model);
                          });
                          _scrollController.animateTo(
                              _scrollController.position.maxScrollExtent,
                              duration: Duration(milliseconds: 500),
                              curve: Curves.easeIn);
                        }),
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
                    value: snapshot.data!.length > 2
                        ? double.parse(snapshot.data!.substring(0, 2))
                        : double.parse(snapshot.data!),
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
                    value: snapshot.data!.length > 4
                        ? double.parse(snapshot.data!.substring(0, 4))
                        : double.parse(snapshot.data!),
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
                    value: snapshot.data!.length > 5
                        ? double.parse(snapshot.data!.substring(0, 5))
                        : double.parse(snapshot.data!),
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
                  return SliderController(
                    value: snapshot.data!.length > 5
                        ? double.parse(snapshot.data!.substring(0, 5))
                        : double.parse(snapshot.data!),
                    label: "Intensity",
                    onChange: (val) => onIntensityChange(val),
                    min: INTENSITY_MIN,
                    max: INTENSITY_MAX,
                  );
                }),
            codeViewWidget()
          ],
        ),
      ),
    );
  }

  Widget codeViewWidget() {
    return Stack(
      children: <Widget>[
        StreamBuilder<LightSourcePosition>(
            initialData: LightSourcePosition.topLeft,
            stream: bloc.lightController.stream,
            builder: (BuildContext context,
                AsyncSnapshot<LightSourcePosition> snapshot) {
              return Container(
                  alignment: Alignment.center,
                  color: Colors.white,
                  child: Markdown(
                      physics: NeverScrollableScrollPhysics(),
                      styleSheet: MarkdownStyleSheet(
                          code: TextStyle(
                            fontFamily: "monospace",
                            fontSize: 12,
                            color: Colors.black,
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.w300,
                          ),
                          codeblockPadding: EdgeInsets.all(24),
                          codeblockDecoration:
                              BoxDecoration() //boxShadow: _getCodeBoxShadow),
                          ),
                      shrinkWrap: true,
                      data: getDartCode(
                          model: ContainerModel(
                        blurRadius: blurRadius.toString(),
                        borderRadius: borderRadius.toString(),
                        intensity: intensityValue.toString(),
                        spreadRadius: spreadRadius.toString(),
                        offset: getOffsetDirection(snapshot),
                      ))));
            }),
        Positioned(
            top: 0,
            right: 0,
            child: IconButton(
                icon: Icon(
                  Icons.content_copy,
                  color: Colors.black,
                ),
                onPressed: () async {
                  final model = ContainerModel();
                  model.blurRadius = blurRadius.toString();
                  model.borderRadius = borderRadius.toString();
                  model.spreadRadius = blurRadius.toString();
                  model.intensity = intensityValue.toString();
                  dartCode = getDartCode(model: model);
                  final ClipboardData data = ClipboardData(text: dartCode);
                  await Clipboard.setData(data);
                  showInSnackBar('Code Copied to clipboard');
                })),
      ],
    );
  }

  void showInSnackBar(String value) {
    // ScaffoldMessenger.
    ScaffoldMessenger.of(context)
        .showSnackBar(new SnackBar(content: new Text(value)));
  }

  String getDartCode({required ContainerModel model}) {
    return '''
          Container(
                height: 200,
                width: 200,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: Color(0XFFF0F2F5),
                    borderRadius: BorderRadius.circular('${model.borderRadius ?? '20'}'),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0XFFFFFFFF),
                        blurRadius: ${model.blurRadius ?? '20'},
                        spreadRadius: ${model.spreadRadius ?? '20'},
                        offset:${model.offset} 
                      ),
                      BoxShadow(
                        color: Color.fromRGBO(206, 213, 222, ${model.intensity ?? '0.8'}),
                        blurRadius: ${model.blurRadius ?? '20'},
                        spreadRadius: ${model.spreadRadius ?? '20'},
                      )
                    ]),
              );
  ''';
  }

  Widget aboutApp() {
    return Container(
      width: 300,
      child: AlertDialog(
        elevation: 0.5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        title: Container(
          height: 50,
          alignment: Alignment.center,
          child: Text("About"),
        ),
        content: Container(
            height: MediaQuery.of(context).size.height / 5,
            child: RichText(
              text: TextSpan(
                  style: TextStyle(color: Colors.black, fontSize: 16),
                  children: [
                    TextSpan(text: '$ABOUT_MESSAGE'),
                    TextSpan(
                        text: ' @Github ',
                        style: TextStyle(color: Colors.blue),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () => launchRepo()),
                  ]),
            )),
      ),
    );
  }

  launchRepo() async {
    String url = '$REPO_URL';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
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
      case LightSourcePosition.topRight:
        return Offset(-10, 10);
      case LightSourcePosition.bottomLeft:
        return Offset(10, -10);
      case LightSourcePosition.bottomRight:
        return Offset(-10, -10);
      default:
        return Offset(10, 10);
    }
  }

  Size? size;
  double borderRadius = 20;
  double blurRadius = 20;
  double spreadRadius = 10;
  double intensityValue = 0.8;
  bool nightMode = false;
  String dartCode = '';
  ScrollController _scrollController = ScrollController();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  LightSourcePosition enabled = LightSourcePosition.bottomLeft;

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Scaffold(
      key: _scaffoldKey,
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          if (constraints.maxWidth > 600)
            return rowWidget();
          else
            return columnWidget();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () =>
            showDialog(context: (context), builder: (_) => aboutApp()),
        tooltip: 'Info',
        backgroundColor: Colors.white,
        foregroundColor: Colors.grey,
        child: Icon(Icons.info),
      ),
    );
  }
}

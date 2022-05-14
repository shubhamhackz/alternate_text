import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const TextWidget(),
    );
  }
}

class TextWidget extends StatelessWidget {
  const TextWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          alignment: Alignment.center,
          color: Colors.amber,
          child: const AlternateText(
            alternativeTexts: [
              'Avul Pakir Jainulabdeen Abdul Kalam',
              'A. P. Jainulabdeen Abdul Kalam',
              'A. P. J. Abdul Kalam',
              'A. P. J. A. Kalam',
              'A. P. J. A. K.'
            ],
          ),
        ),
      ),
    );
  }
}

class AlternateText extends StatefulWidget {
  final List<String> alternativeTexts;
  const AlternateText({Key? key, required this.alternativeTexts})
      : super(key: key);
  @override
  _AlternateText createState() => _AlternateText();
}

class _AlternateText extends State<AlternateText> {
  late List<String> texts;
  ValueNotifier activeTextIndex = ValueNotifier(0);
  List<double> breakPoints = [];

  @override
  void initState() {
    super.initState();
    texts = widget.alternativeTexts;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, size) {
      var textSpan = TextSpan(
        text: texts[activeTextIndex.value],
        style: const TextStyle(fontSize: 76),
      );
      // Use a textpainter to determine if it will exceed max lines
      var textPainter = TextPainter(
        maxLines: 1,
        textAlign: TextAlign.left,
        textDirection: TextDirection.ltr,
        text: textSpan,
      )..layout(maxWidth: size.maxWidth);
      if (breakPoints.isNotEmpty && breakPoints.last < size.maxWidth) {
        activeTextIndex.value -= 1;
        breakPoints.removeAt(activeTextIndex.value);
      } else if (textPainter.didExceedMaxLines) {
        if (activeTextIndex.value != texts.length - 1) {
          activeTextIndex.value += 1;
          breakPoints.add(size.maxWidth);
        }
      }

      return ValueListenableBuilder(
        valueListenable: activeTextIndex,
        builder: (context, value, _) {
          return Text.rich(
            textSpan,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          );
        },
      );
    });
  }
}

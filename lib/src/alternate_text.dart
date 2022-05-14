part of alternate_text;

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

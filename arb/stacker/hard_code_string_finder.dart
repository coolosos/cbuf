part of stracker;

class HardCodedStringFinder {
  HardCodedStringFinder(this.skipWords);
  final List<String> skipWords;

  bool _shouldInclude(
    String it, {
    required String path,
  }) {
    final bool paramsToString = it.startsWith("\${") && it.endsWith("}");

    if (paramsToString) {
      return false;
    }

    final toStringMethods =
        (it.contains('(') && !it.contains(' (') && it.contains("\$"));
    //package stuff
    if (it.contains('dart') || it.contains('package:') || toStringMethods) {
      return false;
    }

    if (it.contains('{') ||
        it.contains("\$") ||
        it.contains(':') ||
        it.contains(').') ||
        it.contains("\\")) {
      print("\n");
      print(
          'String cannot be replacement. Probably contains some variable. Probably must to be done by hand'
              .colorizeMessage(PrinterStringColor.red, emoji: '👽'));
      print('String was: $it\n'
          .colorizeMessage(PrinterStringColor.red, emoji: '    '));
      print('Check the string on: $path'
          .colorizeMessage(PrinterStringColor.red, emoji: '    '));
      print("\n");
      return false;
    }

    return it.isNotEmpty &&
        !it.contains("assets") &&
        !it.contains(".png") &&
        !it.contains(".jpeg") &&
        !it.contains(".mp3") &&
        !it.contains(".mkv") &&
        !it.contains("\'") &&
        !it.contains("\\") && //emoji
        !it.contains("_") && //most probably api stuff
        !it.contains("/") && //path
        !it.contains("#") && // color stuff
        it.trim().length > 1 && //most probably not needed
        !it.contains("[") && // probably regex
        !it.contains("]") &&
        !it.contains('dart') && //Probably dart import
        !it.contains(".svg") &&
        !(it.startsWith('.') && it.endsWith('.')) &&
        !(it.startsWith('*') && it.endsWith('*')) &&
        !it.contains(')}'); // Ternario
  }

  final RegExp regex = RegExp("\".*?\"");
  final RegExp regexDart = RegExp("'.*?'");

  String extractHardCodedString(String it, String input) {
    return it.replaceAll("\"", "").replaceAll("'", "").trim();
  }

  bool _isJsonParameters({required RegExpMatch match}) {
    final bool jsonParamAccessString =
        match.input.codeUnitAt(match.start - 1) == '['.codeUnits.first &&
            match.input.codeUnitAt(match.end) == ']'.codeUnits.first;
    final bool jsonParamSetString =
        match.input.codeUnitAt(match.end) == ':'.codeUnits.first;
    return (jsonParamAccessString || jsonParamSetString);
  }

  List<String> _obtainStringFormRegex({
    required Iterable<RegExpMatch> regexResult,
    required String path,
  }) {
    final starckList = <String>[];
    for (RegExpMatch e in regexResult) {
      if (_isJsonParameters(match: e)) {
        continue;
      }

      final String stracktedString =
          extractHardCodedString(e.group(0) ?? '', e.input);

      final bool include = _shouldInclude(stracktedString, path: path);
      if (include) {
        starckList.add(stracktedString);
      }
    }
    return starckList;
  }

  List<String> findHardCodedStrings(String content, {required String path}) {
    final strings = <String>[
      ..._obtainStringFormRegex(
        regexResult: regex.allMatches(content).where((e) => e.group(0) != null),
        path: path,
      ),
      ..._obtainStringFormRegex(
        regexResult:
            regexDart.allMatches(content).where((e) => e.group(0) != null),
        path: path,
      ),
    ];
    return strings;
  }
}

library stracker;

import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as path;

import '../../utilities/extension.dart';

import 'languages/dart_stacker/dart_stacker.dart';
import 'languages/language_stracker.dart';

part 'hard_code_string_finder.dart';

class Stracker {
  final List<String> skips;

  final String importString;
  final String l10nString;
  final bool changeModifyFile;
  final bool saveArbFile;

  Stracker({
    required this.skips,
    required this.importString,
    required this.l10nString,
    required this.changeModifyFile,
    required this.saveArbFile,
  });

  Extraction _dartExtractions = Extraction(
    withChanges: false,
    numberOfChanges: 0,
  );

  final Map<String, String> allMessages = {};

  void safeArb({
    required Directory arbOutputDirectory,
  }) {
    final String locale = "es";

    allMessages["@@locale"] = locale;

    allMessages["@@last_modified"] = DateTime.now().toIso8601String();

    String outputFilename = "intl_es.arb";
    final File outputFile =
        File(path.join(arbOutputDirectory.path, outputFilename));
    var encoder = const JsonEncoder.withIndent("  ");

    outputFile.writeAsStringSync(encoder.convert(allMessages));
  }

  void strackAndSafe({
    required Directory startDirectory,
    required Directory arbOutputDirectory,
    bool printLanguajeResult = true,
  }) {
    strack(directory: startDirectory);

    if (printLanguajeResult) {
      printResults();
    }

    if (saveArbFile) {
      safeArb(
        arbOutputDirectory: arbOutputDirectory,
      );
    }
  }

  void printResults() {
    print(
      'Dart string extract to arb: ${_dartExtractions.numberOfChanges} '
          .colorizeMessage(PrinterStringColor.green, emoji: '🚀'),
    );
  }

  void strack({required Directory directory}) {
    List<String> skipWords = [
      "dart:ui",
      "dart:io",
    ];
    print(directory
        .toString()
        .colorizeMessage(PrinterStringColor.yellow, emoji: '📂'));

    for (FileSystemEntity element in directory.listSync()) {
      final bool shouldSkip = skips.contains(path.basename(element.path));
      if (shouldSkip) {
        print('The current $element was skip from iteration from path skip');
        continue;
      }

      if (element is Directory) {
        strack(
          directory: Directory(element.path),
        );
      } else if (element is File) {
        final dart = DartStacker(
                file: element,
                finder: HardCodedStringFinder(skipWords),
                importString: importString,
                allMessages: allMessages,
                l10nString: l10nString)
            .extract(
          saveChanges: changeModifyFile,
        );
        _dartExtractions = _dartExtractions.copyWith(
          withChanges: _dartExtractions.withChanges ? true : dart?.withChanges,
          numberOfChanges:
              _dartExtractions.numberOfChanges + (dart?.numberOfChanges ?? 0),
        );
      }
    }
  }
}

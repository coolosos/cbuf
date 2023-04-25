import 'dart:io';
import 'stracker.dart';
import 'stracker_arguments.dart';
import 'package:args/args.dart';
import 'dart:async';
import 'package:path/path.dart' as path;

void _generatePathIfNotExits(bool createPaths,
    {required Directory sourceDir, required Directory outputDir}) {
  if (createPaths) {
    if (!sourceDir.existsSync()) {
      sourceDir.createSync(recursive: true);
    }

    if (!outputDir.existsSync()) {
      outputDir.createSync(recursive: true);
    }
  }
}

Future<void> main(List<String> arguments) async {
  final ArgParser parser = StrackerArguments().parser;

  if (arguments.isNotEmpty && arguments[0] == 'help') {
    stdout.writeln(parser.usage);
    return;
  }

  final ArgResults result = parser.parse(arguments);

  final String source =
      path.canonicalize(path.absolute(result[StrackerArgumentsKey.source.key]));
  final String output =
      path.canonicalize(path.absolute(result[StrackerArgumentsKey.output.key]));
  final bool createPaths = result[StrackerArgumentsKey.createPath.key];

  final Directory outputDir = Directory(output);
  final Directory sourceDir = Directory(source);

  _generatePathIfNotExits(createPaths,
      outputDir: outputDir, sourceDir: sourceDir);

  final List<String> customSkips =
      ((result[StrackerArgumentsKey.skipsFiles.key] ?? '') as String)
          .split(',');

  final Stracker stracker = Stracker(
    skips: [
      "strings_to_arb.dart",
      "models",
      "provider",
      "generated",
      "gen.dart",
      ...customSkips,
    ],
    importString: result[StrackerArgumentsKey.import.key] ??
        StrackerArguments.kDefaultImport,
    l10nString: result[StrackerArgumentsKey.autogenerate.key] ??
        StrackerArguments.kDefaultl10n,
    changeModifyFile: result[StrackerArgumentsKey.saveModifyFile.key] ?? true,
    saveArbFile: result[StrackerArgumentsKey.saveArb.key] ?? true,
  );

  stracker.strackAndSafe(
    startDirectory: sourceDir,
    arbOutputDirectory: outputDir,
    printLanguajeResult: true,
  );
}

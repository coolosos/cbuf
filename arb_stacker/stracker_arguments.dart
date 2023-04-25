import 'package:args/args.dart';

enum StrackerArgumentsKey {
  source(
    key: 'source',
    abbr: 's',
    help: 'Specify where to search for the arb files.',
  ),
  output(
    key: 'output',
    abbr: 'o',
    help: 'Specify where to save the generated dart files.',
  ),
  createPath(
    key: 'create-paths',
    abbr: 'c',
    help: 'This will create the folders structure recursevly.',
  ),
  saveModifyFile(
    key: 'save-modify-files',
    abbr: 'm',
    help: 'Save current change files',
  ),
  saveArb(
    key: 'save-arb',
    abbr: 'b',
    help: 'Safe the generate arb file',
  ),
  import(
    key: 'import',
    abbr: 'i',
    help: 'Required import that will be added on top of the file',
  ),
  autogenerate(
    key: 'autogenerate',
    abbr: 'a',
    help:
        'Class instanciation that will be contains the arb. Usually S.of(context).StringName',
  ),
  skipsFiles(
    key: 'skip-file',
    abbr: 'f',
    help:
        'Specify which files are going to be skips by the analyzer. Must be a String with comma, like: profile.dart,data.dart,test.dart',
  ),
  ;

  const StrackerArgumentsKey({
    required this.key,
    required this.abbr,
    required this.help,
  });

  final String key;
  final String abbr;
  final String help;
}

class StrackerArguments {
  static const String sourceDefault = './lib/';

  static const String outputDefault = './lib/generated/l10n/';

  static const bool createPathsKeyDefault = true;

  static const String kDefaultImport =
      "import 'package:fi_test/l10n/l10n.dart';";

  static const String kDefaultl10n = "context.l10n";

  static const List<String> kDefaultIgnore = [
    "strings_to_arb.dart",
    "models",
    "provider",
    "generated",
    "g.dart"
  ];

  final ArgParser parser = ArgParser()
    ..addOption(
      StrackerArgumentsKey.source.key,
      abbr: StrackerArgumentsKey.source.abbr,
      help: StrackerArgumentsKey.source.help,
      valueHelp: sourceDefault,
      defaultsTo: sourceDefault,
    )
    ..addOption(
      StrackerArgumentsKey.output.key,
      abbr: StrackerArgumentsKey.output.abbr,
      help: StrackerArgumentsKey.output.help,
      valueHelp: outputDefault,
      defaultsTo: outputDefault,
    )
    ..addFlag(
      StrackerArgumentsKey.createPath.key,
      abbr: StrackerArgumentsKey.createPath.abbr,
      help: StrackerArgumentsKey.createPath.help,
      defaultsTo: createPathsKeyDefault,
    )
    ..addFlag(
      StrackerArgumentsKey.saveModifyFile.key,
      abbr: StrackerArgumentsKey.saveModifyFile.abbr,
      help: StrackerArgumentsKey.saveModifyFile.help,
      defaultsTo: true,
    )
    ..addFlag(
      StrackerArgumentsKey.saveArb.key,
      abbr: StrackerArgumentsKey.saveArb.abbr,
      help: StrackerArgumentsKey.saveArb.help,
      defaultsTo: true,
    )
    ..addOption(
      StrackerArgumentsKey.import.key,
      abbr: StrackerArgumentsKey.import.abbr,
      help: StrackerArgumentsKey.import.help,
      defaultsTo: kDefaultImport,
    )
    ..addOption(
      StrackerArgumentsKey.autogenerate.key,
      abbr: StrackerArgumentsKey.autogenerate.abbr,
      help: StrackerArgumentsKey.autogenerate.help,
      defaultsTo: kDefaultl10n,
    )
    ..addOption(
      StrackerArgumentsKey.skipsFiles.key,
      abbr: StrackerArgumentsKey.skipsFiles.abbr,
      help: StrackerArgumentsKey.skipsFiles.help,
    );
}

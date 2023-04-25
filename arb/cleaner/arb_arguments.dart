import 'package:args/args.dart';

class ArbArguments {
  static const sourceKey = 'source';

  static const sourceDirectoryKey = 'source-directory';

  final ArgParser parser = ArgParser()
    ..addOption(
      sourceKey,
      abbr: 's',
      help: 'Arb to check',
    )
    ..addOption(
      sourceDirectoryKey,
      abbr: 'd',
      help: 'Directory to check if the arb are in used',
      defaultsTo: null,
      mandatory: false,
    );
}

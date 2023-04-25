import 'dart:io';

import 'package:args/args.dart';

import 'assets_cleaner.dart';

import 'package:path/path.dart' as path;

Future<void> main(List<String> arguments) async {
  final ArgParser parser = AssetsArguments().parser;

  if (arguments.isNotEmpty && arguments[0] == 'help') {
    stdout.writeln(parser.usage);
    return;
  }

  final ArgResults result = parser.parse(arguments);

  final Directory assetsDirectory = Directory(
      path.canonicalize(path.absolute(result[AssetsArguments.sourceKey])));
  final Directory sourceDirectory = Directory(path
      .canonicalize(path.absolute(result[AssetsArguments.sourceDirectoryKey])));

  final bool isTypographic = result[AssetsArguments.typographic];

  final AssetsCleaner assetsCleaner = AssetsCleaner(
    assetDirectory: assetsDirectory,
    projectDirectory: sourceDirectory,
    isTypographic: isTypographic,
  );

  assetsCleaner.clean();

  print('\n');
}

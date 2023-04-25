import 'dart:io';

import 'package:args/args.dart';

import 'arb_arguments.dart';
import 'package:path/path.dart' as path;

import 'arb_duplicates/arb_duplicate.dart';
import 'arb_unussed/arb_unussed.dart';

Future<void> main(List<String> arguments) async {
  final ArgParser parser = ArbArguments().parser;

  if (arguments.isNotEmpty && arguments[0] == 'help') {
    stdout.writeln(parser.usage);
    return;
  }

  final ArgResults result = parser.parse(arguments);

  final File sourceFile =
      File(path.canonicalize(path.absolute(result[ArbArguments.sourceKey])));
  final String? sourceDirectory = (result[ArbArguments.sourceDirectoryKey] ==
          null)
      ? null
      : path
          .canonicalize(path.absolute(result[ArbArguments.sourceDirectoryKey]));

  final ArbUnUssed arbUnUssed = ArbUnUssed(
    arbFile: sourceFile,
    directoryPath: sourceDirectory,
  );
  final File? unssedCleanFile = arbUnUssed.clean();

  final ArbDuplicate arbDuplicate = ArbDuplicate(unssedCleanFile ?? sourceFile);

  final File? duplicateClean = arbDuplicate.clean();

  print('\n');
  print(duplicateClean ?? unssedCleanFile);
}

import 'dart:io';
import 'package:path/path.dart' as path;

import '../../../../utilities/extension.dart';
import '../../stracker.dart';
import '../language_stracker.dart';
import '../language_helper.dart';

class DartStacker extends LanguageStracker with StrackerHelper {
  final File file;
  final HardCodedStringFinder finder;
  final String importString;
  final Map<dynamic, dynamic> allMessages;
  final String l10nString;

  const DartStacker({
    required this.file,
    required this.finder,
    required this.importString,
    required this.allMessages,
    required this.l10nString,
  });

  @override
  Extraction? extract({required bool saveChanges}) {
    if (path.extension(file.path) == ".dart") {
      final fileChange = _obtainFileChange();
      if (saveChanges &&
          fileChange.withChanges &&
          (fileChange.fileContent?.isNotEmpty ?? false)) {
        file.writeAsStringSync(fileChange.fileContent!);
      }
      return fileChange;
    }
    return null;
  }

  Extraction _obtainFileChange() {
    String fileContent = file.readAsStringSync();
    final List<String> stringsFounded =
        finder.findHardCodedStrings(fileContent, path: file.toString());
    final fileContainsContext = fileContent.contains("context");
    if (stringsFounded.isNotEmpty) {
      if (!fileContainsContext) {
        return Extraction(
          withChanges: false,
          fileContent: fileContent,
          numberOfChanges: 0,
        );
      }
      print("$file".colorizeMessage(PrinterStringColor.cyan, emoji: '✅'));
      print("String to change: $stringsFounded"
          .colorizeMessage(PrinterStringColor.cyan, emoji: '   '));
      if (!fileContent.contains('l10n')) {
        fileContent = "$importString\n$fileContent";
      }
      final String fileName =
          path.basename(file.path).replaceAll(path.extension(file.path), '');
      for (String hardCodeText in stringsFounded) {
        final String mapKey = formatKeyInfo(hardCodeText, fileName: fileName);
        allMessages[mapKey] = hardCodeText;
        fileContent = fileContent.replaceAll(
            "\"$hardCodeText\"", "$l10nString.${mapKey}");
        fileContent =
            fileContent.replaceAll("'$hardCodeText'", "$l10nString.${mapKey}");
      }
      return Extraction(
        withChanges: true,
        fileContent: fileContent,
        numberOfChanges: stringsFounded.length,
      );
    }
    return Extraction(
      withChanges: false,
      fileContent: fileContent,
      numberOfChanges: stringsFounded.length,
    );
  }
}

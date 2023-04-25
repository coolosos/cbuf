import 'dart:io';

import '../arb_reader.dart';

import '../../../utilities/directory_management.dart';
import '../../../utilities/extension.dart';
import '../../../utilities/printer_helper.dart';

class ArbUnUssed with ArbReader, DirectoryManagement, PrinterHelper {
  ArbUnUssed({
    required this.arbFile,
    required this.directoryPath,
  });
  final File arbFile;
  final String? directoryPath;

  File? clean() {
    if (directoryPath == null) {
      topDivider();
      title(
          'You can clean a directory with -d and the current directory where you use the arb');
      bottomDivider();
      return null;
    }
    topDivider();
    title('CHECKING UN USED KEYS');

    final Map<String, dynamic> arbFormatted = obtainArbMap(arbFile: arbFile);

    arbKeys.addAll(arbFormatted.keys.toSet().toList()
      ..removeWhere((key) => key.contains('@')));

    _checkIfArbKeyExist(directoryToCheck: Directory(directoryPath!));

    if (arbKeys.isEmpty) {
      print('All key will be in use'
          .colorizeMessage(PrinterStringColor.green, emoji: '✅'));
      return null;
    }

    print("${arbKeys.length} wasn't in use"
        .colorizeMessage(PrinterStringColor.yellow, emoji: '📂'));

    print("Key where $arbKeys"
        .colorizeMessage(PrinterStringColor.white, emoji: '     '));

    print(
        'Deleting keys'.colorizeMessage(PrinterStringColor.cyan, emoji: '🚑'));

    for (String keyToDelete in arbKeys) {
      arbFormatted.removeWhere((key, value) => key == keyToDelete);
    }

    return saveGenerateFile(primeFile: arbFile, formattedArb: arbFormatted);
  }

  List<String> arbKeys = [];

  void _checkIfArbKeyExist({
    required Directory directoryToCheck,
  }) {
    navigation(
      directory: directoryToCheck,
      navigationPrevent: (element) {
        return isArbFile(fileToCheck: element);
      },
      onDirectory: (newDirectory) => _checkIfArbKeyExist(
        directoryToCheck: newDirectory,
      ),
      onFile: (file) {
        String fileContent = file.readAsStringSync();
        final List<String> fileArbKeyUsed = [];
        for (String arbKey in arbKeys) {
          if (fileContent.contains(arbKey)) {
            fileArbKeyUsed.add(arbKey);
          }
        }

        for (String usedKey in fileArbKeyUsed) {
          arbKeys.remove(usedKey);
        }
      },
    );
  }
}

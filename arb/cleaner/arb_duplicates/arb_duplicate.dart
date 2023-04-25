import 'dart:io';

import '../arb_reader.dart';
import '../../../utilities/directory_management.dart';
import '../../../utilities/printer_helper.dart';
import 'arb_duplicate_helper.dart';
import '../../../utilities/extension.dart';

class ArbDuplicate
    with ArbDuplicateHelper, ArbReader, DirectoryManagement, PrinterHelper {
  final File arbFile;

  ArbDuplicate(this.arbFile);

  File? clean() {
    topDivider();
    title('checking duplicates');

    final Map<String, dynamic> arbJson = obtainArbMap(arbFile: arbFile);

    final formattedArb = Map.from(arbJson);

    final List duplicateValue = List.from(arbJson.values);

    final cleanValues = List.from(arbJson.values).toSet().toList();

    cleanValues.forEach((element) {
      duplicateValue.remove(element);
    });

    if (duplicateValue.isEmpty) {
      topDivider();
      title('No duplicate fields');
      bottomDivider();
      return null;
    }

    print('Remove ${duplicateValue.length} duplicate values'
        .colorizeMessage(PrinterStringColor.cyan, emoji: '🚑'));
    formattedArb.removeWhere((key, value) => duplicateValue.contains(value));

    print('Added Shared'.colorizeMessage(PrinterStringColor.blue, emoji: '🧠'));
    for (var value in duplicateValue.toSet().toList()) {
      final String arbNamed = arbKey(value);
      formattedArb.addAll({'shared_$arbNamed': value});
    }

    return saveGenerateFile(primeFile: arbFile, formattedArb: formattedArb);
  }
}

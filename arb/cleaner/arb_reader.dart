import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart' as path;

mixin ArbReader {
  Map<String, dynamic> obtainArbMap({required File arbFile}) {
    if (path.extension(arbFile.path) != '.arb') {
      throw Exception('File must be arb file');
    }
    String fileContent = arbFile.readAsStringSync();

    if (fileContent.isEmpty) {
      throw Exception('File must be not empty');
    }

    final Map<String, dynamic> arbJson = jsonDecode(fileContent);

    if (arbJson.isEmpty) {
      throw Exception('Arb must be a json');
    }
    return arbJson;
  }
}

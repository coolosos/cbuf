library assets_cleaner;

import 'dart:io';

import 'package:args/args.dart';

import '../arb__cleaner/directory_management.dart';
import 'package:path/path.dart' as path;

import '../arb__cleaner/printer_helper.dart';
import '../arb_stacker/extensions/extensions.dart';

part 'assets_arguments.dart';

class AssetsCleaner with DirectoryManagement, PrinterHelper {
  final Directory assetDirectory;
  final Directory projectDirectory;
  final bool isTypographic;

  AssetsCleaner({
    required this.assetDirectory,
    required this.projectDirectory,
    required this.isTypographic,
  });

  String directoryName = '';
  final List<String> assetKey = [];

  clean() {
    _obtain_assets_key(assetKey: assetKey, newDirectory: assetDirectory);

    topDivider();
    title('Extracted ${assetKey.length} assets');

    _read_all_directory(newDirectory: projectDirectory);
    if (assetKey.isNotEmpty) {
      print('Total assets to remove: ${assetKey.length}'
          .colorizeMessage(StrackerColor.blue, emoji: '🚑'));
      print(assetKey);
    } else {
      print('No assets to remove'
          .colorizeMessage(StrackerColor.green, emoji: '✅'));
    }
    bottomDivider();
  }

  void _read_all_directory({required Directory newDirectory}) {
    navigation(
      directory: newDirectory,
      onDirectory: (newDirectory) => _read_all_directory(
        newDirectory: newDirectory,
      ),
      onFile: (file) {
        String fileContent = file.readAsStringSync();
        final List<String> fileKeyUsed = [];
        for (String key in assetKey) {
          if (fileContent.contains(key)) {
            fileKeyUsed.add(key);
          }
        }

        for (String usedKey in fileKeyUsed) {
          assetKey.remove(usedKey);
        }
      },
    );
  }

  void _obtain_assets_key({
    required List<String> assetKey,
    required Directory newDirectory,
  }) {
    directoryName = snakeCase(path.basename(newDirectory.path).toLowerCase());
    navigation(
      directory: newDirectory,
      onDirectory: (newDirectory) {},
      onFile: (file) {
        final baseName = path.basenameWithoutExtension(file.path);
        if (!baseName.contains('DS_Store')) {
          String fileName = path.basenameWithoutExtension(file.path);
          String prefix = '';
          if (!isTypographic) {
            fileName = snakeCase(fileName..toLowerCase());
            prefix = (directoryName + '.');
          }
          assetKey.add(prefix + fileName);
        }
      },
    );
  }

  String snakeCase(String value) {
    final snakeCase = value
        .split("_")
        .map(
          (word) => word.length > 1
              ? '${word.substring(0, 1).toUpperCase()}${word.substring(1).toLowerCase()}'
              : word,
        )
        .toList();
    if (snakeCase.isNotEmpty) {
      snakeCase[0] = snakeCase[0].toLowerCase();
    }
    return snakeCase.join('');
  }
}

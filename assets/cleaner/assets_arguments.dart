part of assets_cleaner;

class AssetsArguments {
  static const sourceKey = 'assets-directory';

  static const sourceDirectoryKey = 'source-directory';
  static const typographic = 'typographic';

  final ArgParser parser = ArgParser()
    ..addOption(
      sourceKey,
      abbr: 'a',
      help: 'Asset directory to check',
    )
    ..addOption(
      sourceDirectoryKey,
      abbr: 's',
      help: 'Directory to check if the assets are in used',
      defaultsTo: null,
      mandatory: false,
    )
    ..addFlag(
      typographic,
      abbr: 't',
      defaultsTo: false,
    );
}

// ignore_for_file: public_member_api_docs, sort_constructors_first
abstract class LanguageStracker {
  const LanguageStracker();

  ///Extract all the availables string from file and return a [Extraction]
  Extraction? extract({required bool saveChanges});
}

class Extraction {
  final bool withChanges;
  final String? fileContent;
  final int numberOfChanges;

  ///Contains all important changes of the languaje
  Extraction({
    required this.withChanges,
    this.fileContent,
    required this.numberOfChanges,
  });

  Extraction copyWith({
    bool? withChanges,
    String? fileContent,
    int? numberOfChanges,
  }) {
    return Extraction(
      withChanges: withChanges ?? this.withChanges,
      fileContent: fileContent ?? this.fileContent,
      numberOfChanges: numberOfChanges ?? this.numberOfChanges,
    );
  }
}

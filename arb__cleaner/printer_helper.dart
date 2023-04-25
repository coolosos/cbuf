import 'extension.dart';

mixin PrinterHelper {
  void title(String title) {
    print(title
        .toUpperCase()
        .colorizeMessage(ArbStringColor.magenta, emoji: '✨'));
  }

  void topDivider() {
    print('\n');
    print('----------------------------------------');
  }

  void bottomDivider() {
    print('----------------------------------------');
  }
}

import 'dart:io';

void main() {
  final dir = Directory('lib');
  final files = dir.listSync(recursive: true).whereType<File>().where((f) => f.path.endsWith('.dart'));

  for (final file in files) {
    String content = file.readAsStringSync();
    bool changed = false;

    if (content.contains('backgroundColor: ColorManager.backgroundWhite')) {
      content = content.replaceAll(
          'backgroundColor: ColorManager.backgroundWhite',
          'backgroundColor: Theme.of(context).scaffoldBackgroundColor');
      changed = true;
    }
    
    if (content.contains('backgroundColor: ColorManager.backgroundLight')) {
      content = content.replaceAll(
          'backgroundColor: ColorManager.backgroundLight',
          'backgroundColor: Theme.of(context).scaffoldBackgroundColor');
      changed = true;
    }

    if (content.contains('color: ColorManager.backgroundWhite')) {
      content = content.replaceAll(
          'color: ColorManager.backgroundWhite',
          'color: Theme.of(context).cardColor');
      changed = true;
    }
    
    if (content.contains('color: ColorManager.veryLightBlue')) {
      content = content.replaceAll(
          'color: ColorManager.veryLightBlue',
          'color: Theme.of(context).cardColor');
      changed = true;
    }

    if (changed) {
      file.writeAsStringSync(content);
      print('Updated ${file.path}');
    }
  }
}


// import 'package:cli/cli.dart' as cli;
import 'dart:io';
const version = '0.0.1';

void main(List<String> arguments) {
  if (arguments.isEmpty || arguments.first == 'help') {
    printUsage();
  } else if (arguments.first == 'version') {
    print('Dartpedia CLI version $version');

  // 新增下列兩行
  } else if (arguments.first == 'search') {
    // 加入三元判斷式，在判斷後，呼叫 searchWikipedia 函式
    final inputArgs = arguments.length > 1 ? arguments.sublist(1) : null;
    searchWikipedia(inputArgs);

  } else {
    printUsage();
  }
}

// 在 main() 函式下方，新增下列函式內容，引數的宣告上，使用 ? 表示輸入的資料型態
// 修改 searchWikipedia 函式內容
void searchWikipedia(List<String>? arguments) {
  final String articleTitle;

  // 判斷是否沒有輸入任何文字
  if (arguments == null || arguments.isEmpty) {
    print('Please provide an article title.');

    // 假如沒有輸入任何文字，就等待使用者需要輸入文章的標頭
    articleTitle = stdin.readLineSync() ?? '';

  } else {

    // 否則，就自行加入一個空白字元
    articleTitle = arguments.join(' ');
  }

  // 此處加入提示語句
  print('Looking up articles about "$articleTitle". Please wait.');
  print('Here you go!');

  print('Current article title: $articleTitle');
}


void printUsage() { // Add this new function
  print(
    "The following commands are valid: 'help', 'version', 'search <ARTICLE-TITLE>'"
  );
}
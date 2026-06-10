// import 'package:cli/cli.dart' as cli;
import 'dart:io';
import 'package:http/http.dart' as http;
const version = '0.0.1';

void main(List<String> arguments) {
  if (arguments.isEmpty || arguments.first == 'help') {
    printUsage();
  } else if (arguments.first == 'version') {
    print('Dartpedia CLI version $version');

  // 新增下列兩行
  //} else if (arguments.first == 'search') {
  } else if (arguments.first == 'wikipedia') {
    // 加入三元判斷式，在判斷後，呼叫 searchWikipedia 函式
    final inputArgs = arguments.length > 1 ? arguments.sublist(1) : null;
    searchWikipedia(inputArgs);

  } else {
    printUsage();
  }
}

// 在 main() 函式下方，新增下列函式內容，引數的宣告上，使用 ? 表示輸入的資料型態
// 修改 searchWikipedia 函式內容
void searchWikipedia(List<String>? arguments) async {
  final String articleTitle;

  if (arguments == null || arguments.isEmpty) {
    print('Please provide an article title.');

    // 讀取輸入值
    final inputFromStdin = stdin.readLineSync();

    // 處理空值的情況
    if (inputFromStdin == null || inputFromStdin.trim().isEmpty){
      print('No article title provided. Exiting.');
      return;
      // 如有不合理輸入則離開此函式
    }
    articleTitle = inputFromStdin;
  }else {
    articleTitle = arguments.join(' ');
  }

  print('Looking up articles about "$articleTitle". Please wait.');

// print('Here you go!'); 將此行註解

// 呼叫  getWikipediaArticle() 函式
var articleContent = await getWikipediaArticle(articleTitle);

// print('Current article title: $articleTitle'); 將此行註解
 print(articleContent);
}


void printUsage() { // Add this new function
  print(
    "The following commands are valid: 'help', 'version', 'search <ARTICLE-TITLE>'"
  );
}

Future <String> getWikipediaArticle(String articleTitle) async {
  final url = Uri.https(
    'en.wikipedia.org', // Wikipedia API 網域主機名稱
    '/api/rest_v1/page/summary/$articleTitle', // 文章總結內容的 API 路徑
  );
  final response = await http.get(url); // 製作 HTTP 連線請求

  if (response.statusCode == 200) {
    return response.body;
  }
  return 'Error: Failed to fetch article "$articleTitle". Status code: ${response.statusCode}';
}
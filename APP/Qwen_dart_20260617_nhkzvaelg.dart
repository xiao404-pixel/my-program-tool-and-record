import 'dart:io';
import 'dart:convert';

// ==========================================
// 【進階語法(3)】增強控制台顏色枚舉與擴充方法
// ==========================================
const String ansiEscapeLiteral = '\x1B';
enum ConsoleColor {
  red(242, 93, 80),      // 過重/錯誤
  yellow(249, 248, 196), // 警告/邊緣
  lightBlue(184, 234, 254), // 正常/資訊
  green(100, 200, 100);  // 成功

  const ConsoleColor(this.r, this.g, this.b);
  final int r, g, b;

  String applyForeground(String text) {
    return '$ansiEscapeLiteral[38;2;$r;$g;${b}m$text$ansiEscapeLiteral[0m';
  }
}

// 為 String 增加擴充方法，方便呼叫
extension TextRenderUtils on String {
  String get errorText => ConsoleColor.red.applyForeground(this);
  String get infoText => ConsoleColor.lightBlue.applyForeground(this);
  String get successText => ConsoleColor.green.applyForeground(this);
  String get warningText => ConsoleColor.yellow.applyForeground(this);
}

// ==========================================
// 【進階語法(2)】自訂例外狀況處理類別
// ==========================================
class InvalidInputException implements Exception {
  final String message;
  InvalidInputException(this.message);
  @override
  String toString() => 'InvalidInputException: $message'.errorText;
}

// ==========================================
// 【進階語法(1)】定義資料模型類別
// ==========================================
class BodyRecord {
  final DateTime date;
  final double heightCm;
  final double weightKg;
  final double bmi;

  BodyRecord({
    required this.date,
    required this.heightCm,
    required this.weightKg,
  }) : bmi = _calculateBmiValue(heightCm, weightKg);

  // 靜態方法：純粹的 BMI 計算邏輯
  static double _calculateBmiValue(double heightCm, double weightKg) {
    double heightM = heightCm / 100;
    return weightKg / (heightM * heightM);
  }

  String getBmiStatus() {
    if (bmi < 18.5) return '過輕'.warningText;
    if (bmi < 24) return '正常'.successText;
    if (bmi < 27) return '過重'.warningText;
    return '肥胖'.errorText;
  }

  @override
  String toString() {
    return '日期: ${date.toString().substring(0, 10)} | '
           '身高: ${heightCm}cm | 體重: ${weightKg}kg | '
           'BMI: ${bmi.toStringAsFixed(1)} (${getBmiStatus()})';
  }
  
  // 轉換為 JSON，方便未來使用 dart:io 寫入檔案
  Map<String, dynamic> toJson() => {
    'date': date.toIso8601String(),
    'heightCm': heightCm,
    'weightKg': weightKg,
    'bmi': bmi,
  };
}

// ==========================================
// 【基本語法(1) & (2)】核心應用程式邏輯
// ==========================================
class WeightTrackerApp {
  // 模擬資料庫：儲存身體數值紀錄
  final List<BodyRecord> _records = [];

  // 【進階語法(1)】模擬 Command 執行：計算 BMI
  Future<void> runBmiCommand() async {
    print('\n=== BMI 計算與紀錄 ==='.infoText);
    try {
      double height = await _promptForDouble('請輸入身高 (公分, 例如 170): ');
      double weight = await _promptForDouble('請輸入體重 (公斤, 例如 65): ');

      // 建立紀錄物件
      final newRecord = BodyRecord(
        date: DateTime.now(),
        heightCm: height,
        weightKg: weight,
      );

      // 加入追蹤列表
      _records.add(newRecord);
      
      print('\n✅ 計算成功！'.successText);
      print(newRecord.toString());
      
    } on InvalidInputException catch (e) {
      // 【進階語法(2)】優雅地處理錯誤
      print('\n❌ 輸入錯誤: ${e.message}');
    } catch (e) {
      print('\n❌ 發生未知錯誤: $e');
    }
  }

  // 【進階語法(1)】模擬 Command 執行：查看歷史紀錄
  void runHistoryCommand() {
    print('\n=== 身體數值追蹤紀錄 ==='.infoText);
    if (_records.isEmpty) {
      print('目前尚無紀錄，請先使用 bmi 指令進行計算。'.warningText);
      return;
    }

    for (int i = 0; i < _records.length; i++) {
      print('${i + 1}. ${_records[i].toString()}');
    }
    
    // 示範：如何將紀錄轉為 JSON 字串 (為未來存檔做準備)
    print('\n[系統訊息] 目前資料可序列化為 JSON:'.infoText);
    print(jsonEncode(_records.map((r) => r.toJson()).toList()));
  }

  // 【基本語法(1)】輔助函式：安全地讀取並驗證數字輸入
  Future<double> _promptForDouble(String prompt) async {
    stdout.write(prompt);
    String? input = stdin.readLineSync();
    
    if (input == null || input.trim().isEmpty) {
      throw InvalidInputException('輸入不能為空');
    }
    
    double? value = double.tryParse(input.trim());
    if (value == null || value <= 0) {
      throw InvalidInputException('請輸入有效的正數數字');
    }
    
    return value;
  }
}

// ==========================================
// 【基本語法(1)】程式進入點
// ==========================================
void main(List<String> arguments) async {
  final app = WeightTrackerApp();

  print('========================================'.infoText);
  print('       歡迎使用 Dart 減重輔助程式       '.infoText);
  print('========================================'.infoText);
  print('可用指令:');
  print('  1. bmi     - 計算並紀錄新的 BMI');
  print('  2. history - 查看歷史追蹤紀錄');
  print('  3. exit    - 離開程式');
  print('========================================\n'.infoText);

  while (true) {
    stdout.write('請輸入指令 > '.successText);
    String? command = stdin.readLineSync()?.trim().toLowerCase();

    if (command == 'exit' || command == 'quit') {
      print('感謝使用，祝您減重順利！'.successText);
      break;
    } else if (command == 'bmi') {
      await app.runBmiCommand();
    } else if (command == 'history') {
      app.runHistoryCommand();
    } else {
      print('未知的指令，請重新輸入。'.errorText);
    }
    print(''); // 換行美化輸出
  }
}
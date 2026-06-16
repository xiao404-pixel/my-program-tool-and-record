import 'package:test/test.dart';
import 'package:weight_tracker/weight_tracker.dart';

void main() {
  group('BodyRecord 測試', () {
    test('BMI 計算正確', () {
      // 測試身高 170cm, 體重 65kg
      final record = BodyRecord(
        date: DateTime(2026, 6, 17),
        heightCm: 170,
        weightKg: 65,
      );
      
      // BMI = 65 / (1.7 * 1.7) = 22.49
      expect(record.bmi, closeTo(22.49, 0.01));
    });

    test('BMI 狀態判斷正確 - 正常', () {
      final record = BodyRecord(
        date: DateTime(2026, 6, 17),
        heightCm: 170,
        weightKg: 65,
      );
      
      expect(record.getBmiStatus(), contains('正常'));
    });

    test('BMI 狀態判斷正確 - 過重', () {
      final record = BodyRecord(
        date: DateTime(2026, 6, 17),
        heightCm: 170,
        weightKg: 80,
      );
      
      expect(record.getBmiStatus(), contains('過重'));
    });

    test('toJson 方法正確', () {
      final record = BodyRecord(
        date: DateTime(2026, 6, 17),
        heightCm: 170,
        weightKg: 65,
      );
      
      final json = record.toJson();
      expect(json['heightCm'], equals(170));
      expect(json['weightKg'], equals(65));
      expect(json['date'], isA<String>());
    });

    test('fromJson 方法正確', () {
      final jsonData = {
        'date': '2026-06-17T00:00:00.000',
        'heightCm': 170,
        'weightKg': 65,
        'bmi': 22.49,
      };
      
      final record = BodyRecord.fromJson(jsonData);
      expect(record.heightCm, equals(170));
      expect(record.weightKg, equals(65));
    });
  });

  group('StorageService 測試', () {
    test('StorageService 實例化成功', () {
      final service = StorageService(filePath: 'test_records.json');
      expect(service, isA<StorageService>());
    });
  });
}
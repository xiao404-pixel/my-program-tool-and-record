// lib/models/bmi_record.dart

class BmiRecord {
  final String id;
  final double height; // in cm
  final double weight; // in kg
  final double bmi;
  final DateTime date;
  final String note;

  BmiRecord({
    required this.id,
    required this.height,
    required this.weight,
    required this.bmi,
    required this.date,
    this.note = '',
  });

  /// BMI 分類
  String get category {
    if (bmi < 18.5) return '體重過輕';
    if (bmi < 24.0) return '正常體重';
    if (bmi < 27.0) return '體重過重';
    if (bmi < 30.0) return '輕度肥胖';
    if (bmi < 35.0) return '中度肥胖';
    return '重度肥胖';
  }

  /// 依衛福部台灣標準
  String get categoryEn {
    if (bmi < 18.5) return 'Underweight';
    if (bmi < 24.0) return 'Normal';
    if (bmi < 27.0) return 'Overweight';
    if (bmi < 30.0) return 'Obese I';
    if (bmi < 35.0) return 'Obese II';
    return 'Obese III';
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'height': height,
        'weight': weight,
        'bmi': bmi,
        'date': date.toIso8601String(),
        'note': note,
      };

  factory BmiRecord.fromJson(Map<String, dynamic> json) => BmiRecord(
        id: json['id'] as String,
        height: (json['height'] as num).toDouble(),
        weight: (json['weight'] as num).toDouble(),
        bmi: (json['bmi'] as num).toDouble(),
        date: DateTime.parse(json['date'] as String),
        note: json['note'] as String? ?? '',
      );

  static double calculateBmi(double heightCm, double weightKg) {
    final heightM = heightCm / 100;
    return weightKg / (heightM * heightM);
  }
}

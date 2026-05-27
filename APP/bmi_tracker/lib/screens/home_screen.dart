// lib/screens/home_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../models/bmi_record.dart';
import '../services/storage_service.dart';
import '../theme.dart';
import '../widgets/bmi_gauge.dart';

class HomeScreen extends StatefulWidget {
  final VoidCallback onRecordSaved;
  const HomeScreen({super.key, required this.onRecordSaved});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();
  final _noteController = TextEditingController();
  final _storage = StorageService();

  double? _calculatedBmi;
  bool _saving = false;
  late AnimationController _animCtrl;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _animCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _scaleAnim = CurvedAnimation(parent: _animCtrl, curve: Curves.elasticOut);
  }

  @override
  void dispose() {
    _heightController.dispose();
    _weightController.dispose();
    _noteController.dispose();
    _animCtrl.dispose();
    super.dispose();
  }

  void _calculate() {
    if (!_formKey.currentState!.validate()) return;
    final h = double.parse(_heightController.text);
    final w = double.parse(_weightController.text);
    final bmi = BmiRecord.calculateBmi(h, w);
    setState(() => _calculatedBmi = bmi);
    _animCtrl
      ..reset()
      ..forward();
    FocusScope.of(context).unfocus();
  }

  Future<void> _save() async {
    if (_calculatedBmi == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('請先計算 BMI')),
      );
      return;
    }
    setState(() => _saving = true);
    final h = double.parse(_heightController.text);
    final w = double.parse(_weightController.text);
    final record = BmiRecord(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      height: h,
      weight: w,
      bmi: _calculatedBmi!,
      date: DateTime.now(),
      note: _noteController.text.trim(),
    );
    await _storage.saveRecord(record);
    setState(() {
      _saving = false;
      _calculatedBmi = null;
    });
    _heightController.clear();
    _weightController.clear();
    _noteController.clear();
    _animCtrl.reset();
    widget.onRecordSaved();

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle, color: AppTheme.normal),
              const SizedBox(width: 10),
              Text(
                '已儲存！BMI ${record.bmi.toStringAsFixed(1)} — ${record.category}',
              ),
            ],
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const SizedBox(height: 24),
          _buildInputCard(),
          const SizedBox(height: 20),
          if (_calculatedBmi != null) ...[
            ScaleTransition(scale: _scaleAnim, child: _buildResultCard()),
            const SizedBox(height: 20),
          ],
          _buildBmiTable(),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    final today = DateFormat('yyyy年MM月dd日 EEEE', 'zh').format(DateTime.now());
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '今日測量',
          style: TextStyle(
            color: AppTheme.textSecondary,
            fontSize: 13,
            letterSpacing: 2,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          today,
          style: const TextStyle(
            color: AppTheme.textPrimary,
            fontSize: 22,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  Widget _buildInputCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '輸入身體數據',
                style: TextStyle(
                  color: AppTheme.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: _buildField(
                      controller: _heightController,
                      label: '身高',
                      suffix: 'cm',
                      icon: Icons.height,
                      hint: '170',
                      min: 50,
                      max: 250,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: _buildField(
                      controller: _weightController,
                      label: '體重',
                      suffix: 'kg',
                      icon: Icons.monitor_weight_outlined,
                      hint: '65',
                      min: 10,
                      max: 500,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              TextFormField(
                controller: _noteController,
                style: const TextStyle(color: AppTheme.textPrimary),
                decoration: const InputDecoration(
                  labelText: '備註（選填）',
                  prefixIcon: Icon(
                    Icons.note_alt_outlined,
                    color: AppTheme.textSecondary,
                  ),
                  hintText: '例如：早上空腹、運動後...',
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: _calculate,
                icon: const Icon(Icons.calculate_outlined),
                label: const Text('計算 BMI'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildField({
    required TextEditingController controller,
    required String label,
    required String suffix,
    required IconData icon,
    required String hint,
    required double min,
    required double max,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
      ],
      style: const TextStyle(color: AppTheme.textPrimary),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        suffixText: suffix,
        suffixStyle: const TextStyle(color: AppTheme.textSecondary),
        prefixIcon: Icon(icon, color: AppTheme.textSecondary),
      ),
      validator: (v) {
        if (v == null || v.isEmpty) return '請輸入$label';
        final val = double.tryParse(v);
        if (val == null) return '格式錯誤';
        if (val < min || val > max) return '$min–$max';
        return null;
      },
    );
  }

  Widget _buildResultCard() {
    final bmi = _calculatedBmi!;
    final color = AppTheme.bmiColor(bmi);
    final h = double.tryParse(_heightController.text) ?? 0;
    final w = double.tryParse(_weightController.text) ?? 0;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            BmiGauge(bmi: bmi),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _stat('BMI 值', bmi.toStringAsFixed(2), color),
                _divider(),
                _stat('身高', '${h.toStringAsFixed(0)} cm', AppTheme.textSecondary),
                _divider(),
                _stat('體重', '${w.toStringAsFixed(1)} kg', AppTheme.textSecondary),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: color.withOpacity(0.15),
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: color.withOpacity(0.4)),
              ),
              child: Text(
                _recordCategory(bmi),
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _saving ? null : _save,
              icon: _saving
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.save_outlined),
              label: Text(_saving ? '儲存中...' : '儲存這次記錄'),
            ),
          ],
        ),
      ),
    );
  }

  String _recordCategory(double bmi) {
    if (bmi < 18.5) return '⚠️ 體重過輕';
    if (bmi < 24.0) return '✅ 正常體重';
    if (bmi < 27.0) return '⚠️ 體重過重';
    if (bmi < 30.0) return '🔶 輕度肥胖';
    if (bmi < 35.0) return '🔴 中度肥胖';
    return '🚨 重度肥胖';
  }

  Widget _stat(String label, String value, Color color) {
    return Column(
      children: [
        Text(label, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
        const SizedBox(height: 4),
        Text(value,
            style: TextStyle(color: color, fontSize: 18, fontWeight: FontWeight.w700)),
      ],
    );
  }

  Widget _divider() => Container(
        height: 36,
        width: 1,
        color: AppTheme.divider,
      );

  Widget _buildBmiTable() {
    final ranges = [
      ('體重過輕', '< 18.5', AppTheme.underweight),
      ('正常體重', '18.5 – 23.9', AppTheme.normal),
      ('體重過重', '24.0 – 26.9', AppTheme.overweight),
      ('輕度肥胖', '27.0 – 29.9', AppTheme.obese1),
      ('中度肥胖', '30.0 – 34.9', AppTheme.obese2),
      ('重度肥胖', '≥ 35.0', AppTheme.obese3),
    ];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'BMI 標準（衛福部台灣標準）',
              style: TextStyle(
                color: AppTheme.textPrimary,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 14),
            ...ranges.map((r) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Row(
                    children: [
                      Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: r.$3,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(r.$1,
                            style: const TextStyle(color: AppTheme.textPrimary)),
                      ),
                      Text(r.$2,
                          style: TextStyle(
                              color: r.$3, fontWeight: FontWeight.w600)),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }
}

class ChartData {
  final DateTime timestamp;
  final double value;

  ChartData({
    required this.timestamp,
    required this.value,
  });

  factory ChartData.fromJson(List<dynamic> json) {
    return ChartData(
      timestamp: DateTime.fromMillisecondsSinceEpoch(json[0] as int),
      value: json[1] as double,
    );
  }

  Map<String, dynamic> toJson() => {
    'timestamp': timestamp.millisecondsSinceEpoch,
    'value': value,
  };
} 
class CurrentPeriodResponse {
  final String code;
  final int? period;
  final String? subject;
  final String? message;

  CurrentPeriodResponse({
    required this.code,
    this.period,
    this.subject,
    this.message,
  });

  factory CurrentPeriodResponse.fromJson(Map<String, dynamic> json) {
    return CurrentPeriodResponse(
      code: json['code'] as String,
      period: json['period'] as int?,
      subject: json['subject'] as String?,
      message: json['message'] as String?,
    );
  }

  bool get isInClass => code == 'IN_CLASS';
  bool get isBreakTime => code == 'BREAK_TIME';
  bool get isOutOfClassTime => code == 'OUT_OF_CLASS_TIME';
  bool get isNoSchedule => code == '4808';
}

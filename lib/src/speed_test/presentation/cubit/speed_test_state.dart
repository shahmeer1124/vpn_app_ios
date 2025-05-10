part of 'speed_test_cubit.dart';

enum SpeedTestStatuses { initial, connecting, inProgress, completed }

class SpeedTestState extends Equatable {
  SpeedTestState({
    required this.downloadRate,
    required this.displayRate,
    required this.unitText,
    required this.testInProgress,
    required this.downloadProgress,
    required this.downloadCompletionTime,
    required this.isServerSelectionInProgress,
    this.ip,
    this.asn,
    this.isp,
    this.speedTestStatuses = SpeedTestStatuses.initial,
  });

  factory SpeedTestState.initial() => SpeedTestState(
        downloadRate: 0,
        displayRate: 0,
        unitText: 'Mbps',
        testInProgress: false,
        downloadProgress: '0',
        downloadCompletionTime: 0,
        isServerSelectionInProgress: false,
      );
  final double downloadRate;
  final double displayRate;
  final String unitText;
  final bool testInProgress;
  final String downloadProgress;
  final int downloadCompletionTime;
  final bool isServerSelectionInProgress;
  final String? ip;
  final String? asn;
  final String? isp;
  final SpeedTestStatuses speedTestStatuses;

  SpeedTestState copyWith({
    double? downloadRate,
    double? displayRate,
    String? unitText,
    bool? testInProgress,
    String? downloadProgress,
    int? downloadCompletionTime,
    bool? isServerSelectionInProgress,
    String? ip,
    String? asn,
    String? isp,
    SpeedTestStatuses? speedTestState,
  }) {
    return SpeedTestState(
        downloadRate: downloadRate ?? this.downloadRate,
        displayRate: displayRate ?? this.displayRate,
        unitText: unitText ?? this.unitText,
        testInProgress: testInProgress ?? this.testInProgress,
        downloadProgress: downloadProgress ?? this.downloadProgress,
        downloadCompletionTime:
            downloadCompletionTime ?? this.downloadCompletionTime,
        isServerSelectionInProgress:
            isServerSelectionInProgress ?? this.isServerSelectionInProgress,
        ip: ip ?? this.ip,
        asn: asn ?? this.asn,
        isp: isp ?? this.isp,
        speedTestStatuses: speedTestState ?? speedTestStatuses);
  }

  @override
  List<Object?> get props => [
        downloadRate,
        displayRate,
        unitText,
        testInProgress,
        downloadProgress,
        downloadCompletionTime,
        isServerSelectionInProgress,
        ip,
        asn,
        isp,
        speedTestStatuses
      ];
}

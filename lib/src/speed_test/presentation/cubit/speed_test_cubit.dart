import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/animation.dart';
import 'package:flutter_speed_test_plus/flutter_speed_test_plus.dart';

part 'speed_test_state.dart';
class SpeedTestCubit extends Cubit<SpeedTestState> {
  final FlutterInternetSpeedTest internetSpeedTest;
  Timer? _testTimer;
  AnimationController? _glowController;
  Animation<double>? _glowAnimation;

  SpeedTestCubit({required this.internetSpeedTest, required TickerProvider vsync})
      : super(SpeedTestState.initial()) {
    _initializeGlowAnimation(vsync);
  }

  void _initializeGlowAnimation(TickerProvider vsync) {
    _glowController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: vsync,
    );
    _glowAnimation = Tween<double>(begin: 0.0, end: 10.0).animate(
      CurvedAnimation(parent: _glowController!, curve: Curves.easeInOut),
    );
  }

  double _convertRateToDisplayValue(double rateInMbps) {
    return rateInMbps < 1.0 ? rateInMbps * 1000 : rateInMbps;
  }

  String _getUnitText(double rateInMbps) {
    return rateInMbps < 1.0 ? 'Kbps' : 'Mbps';
  }

  Future<void> startTest() async {
    if (state.testInProgress) return;
    emit(state.copyWith(
      testInProgress: true,
      downloadRate: 0,
      displayRate: 0,
      unitText: 'Mbps',
      downloadProgress: '0',
      downloadCompletionTime: 0,
      ip: null,
      asn: null,
      isp: null,
      isServerSelectionInProgress: false,
      speedTestState: SpeedTestStatuses.connecting
    ));
    _glowController?.repeat(reverse: true);
    _testTimer?.cancel();
    _testTimer = Timer(const Duration(seconds: 60), () {
      if (state.testInProgress) {
        internetSpeedTest.cancelTest();
        _stopTest();
      }
    });
    try {
      await internetSpeedTest.startTesting(
        onStarted: () {
          emit(state.copyWith(testInProgress: true, ));
        },
        onDownloadComplete: (download) {
          final displayRate = _convertRateToDisplayValue(download.transferRate);
          final unitText = _getUnitText(download.transferRate);
          emit(state.copyWith(
            downloadRate: download.transferRate,
            displayRate: displayRate,
            unitText: unitText,
            downloadCompletionTime: download.durationInMillis,
          ));
          _stopTest();
        },
        onCompleted: (_, __) {},
        onProgress: (percent, data) {
          if (data.type == TestType.download) {
            final displayRate = _convertRateToDisplayValue(data.transferRate);
            final unitText = _getUnitText(data.transferRate);
            emit(state.copyWith(
              speedTestState: SpeedTestStatuses.inProgress,
              downloadRate: data.transferRate,
              displayRate: displayRate,
              unitText: unitText,
              downloadProgress: percent.toStringAsFixed(2),
            ));
          }
        },
        onDefaultServerSelectionInProgress: () {
          emit(state.copyWith(isServerSelectionInProgress: true, speedTestState: SpeedTestStatuses.connecting));
        },
        onDefaultServerSelectionDone: (client) {
          emit(state.copyWith(
            isServerSelectionInProgress: false,
            ip: client?.ip,
            asn: client?.asn,
            isp: client?.isp,
          ));
        },
        onError: (errorMessage, speedTestError) {
          print("Speed test error: $errorMessage");
          _stopTest();
        },
        onCancel: () {
          print("Speed test cancelled");
          _stopTest();
        },
      );
    } catch (e) {
      print("Exception during speed test: $e");
      _stopTest();
    }
  }

  void _stopTest() {
    _testTimer?.cancel();
    _glowController?.stop();
    _glowController?.reset();
    emit(state.copyWith(testInProgress: false,speedTestState: SpeedTestStatuses.initial));
  }

  void reset() {
    _testTimer?.cancel();
    emit(state.copyWith(
      downloadRate: 0,
      displayRate: 0,
      unitText: 'Mbps',
      downloadProgress: '0',
      downloadCompletionTime: 0,
      ip: null,
      asn: null,
      isp: null,
      isServerSelectionInProgress: false,
    ));
  }

  Animation<double>? get glowAnimation => _glowAnimation;

  @override
  Future<void> close() {
    _testTimer?.cancel();
    _glowController?.dispose();
    // internetSpeedTest.cancelTest();
    return super.close();
  }
}

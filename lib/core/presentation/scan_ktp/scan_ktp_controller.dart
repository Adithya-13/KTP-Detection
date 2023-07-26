import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ktp_detection/core/application/scan_ktp_service.dart';
import 'package:ktp_detection/core/presentation/scan_ktp/scan_ktp_state.dart';

class ScanKtpController extends StateNotifier<ScanKtpState> {
  final ScanKtpService scanKtpService;
  ScanKtpController(
    this.scanKtpService,
  ) : super(const ScanKtpState());

  /// [INFO]
  /// show into UI
  Future<void> scanKtpInput(File file) async {
    state = state.copyWith(ktpDataValue: const AsyncLoading());

    final result = await scanKtpService.getUserData(file);
    if (result != null) {
      state = state.copyWith(
        ktpDataValue: AsyncData(result),
        ktpData: result,
      );
    } else {
      state = state.copyWith(
        ktpDataValue: const AsyncData(null),
        ktpData: null,
      );
    }
  }
}

final scanKtpControllerProvider =
    StateNotifierProvider<ScanKtpController, ScanKtpState>((ref) {
  final scanKtpService = ref.read(scanKtpServiceProvider);
  return ScanKtpController(scanKtpService);
});

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ktp_detection/core/domain/ktp_data.dart';

class ScanKtpState {
  final AsyncValue<KtpData?> ktpDataValue;
  final KtpData? ktpData;
  const ScanKtpState({
    this.ktpDataValue = const AsyncValue.data(null),
    this.ktpData,
  });

  ScanKtpState copyWith({
    AsyncValue<KtpData?>? ktpDataValue,
    KtpData? ktpData,
  }) {
    return ScanKtpState(
      ktpDataValue: ktpDataValue ?? this.ktpDataValue,
      ktpData: ktpData ?? this.ktpData,
    );
  }
}

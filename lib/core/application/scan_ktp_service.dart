import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ktp_detection/core/data/scan_ktp_repository.dart';
import 'package:ktp_detection/core/domain/ktp_data.dart';

class ScanKtpService {
  final ScanKtpRepository scanKtpRepository;

  ScanKtpService({required this.scanKtpRepository});

  /// [INFO]
  /// get the result of ml kit
  Future<KtpData?> getUserData(File fileImage) async {
    final result = await scanKtpRepository.scanKtp(fileImage: fileImage);

    return result;
  }
}

final scanKtpServiceProvider = Provider<ScanKtpService>((ref) {
  final scanKtpRepository = ref.read(scanKtpRepositoryProvider);
  return ScanKtpService(scanKtpRepository: scanKtpRepository);
});

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:ktp_detection/core/data/modifier/field_detector.dart';
import 'package:ktp_detection/core/data/modifier/ktp_data_converter.dart';
import 'package:ktp_detection/core/domain/ktp_data.dart';

class ScanKtpRepository {
  final TextRecognizer textRecognizer;

  ScanKtpRepository(this.textRecognizer);

  /// [INFO]
  /// process the image into text
  Future<KtpData> scanKtp({required File fileImage}) async {
    /// [INFO]
    /// turn File into InputImage (format that allowed by MLKit Text Recognition)
    final inputImage = InputImage.fromFile(fileImage);

    /// [INFO]
    /// processing image
    final RecognizedText visionText =
        await textRecognizer.processImage(inputImage);

    /// [INFO]
    /// variables to hold the data
    String nikResult = "";
    String nameResult = "";
    String tempatLahirResult = "";
    String tglLahirResult = "";
    String jenisKelaminResult = "";
    String alamatFullResult = "";
    String alamatResult = "";
    String rtrwResult = "";
    String kelDesaResult = "";
    String kecamatanResult = "";
    String agamaResult = "";
    String statusKawinResult = "";
    String pekerjaanResult = "";
    String kewarganegaraanResult = "";

    /// [INFO]
    /// variables to hold the Rect of the Field (the data field positioned)
    Rect? nikRect;
    Rect? namaRect;
    Rect? alamatRect;
    Rect? rtrwRect;
    Rect? kelDesaRect;
    Rect? kecamatanRect;
    Rect? jenisKelaminRect;
    Rect? tempatTanggalLahirRect;
    Rect? agamaRect;
    Rect? statusKawinRect;
    Rect? pekerjaanRect;
    Rect? kewarganegaraanRect;

    /// [INFO]
    /// Search the Field first (not the value)
    try {
      for (int i = 0; i < visionText.blocks.length; i++) {
        for (int j = 0; j < visionText.blocks[i].lines.length; j++) {
          for (int k = 0;
              k < visionText.blocks[i].lines[j].elements.length;
              k++) {
            final data = visionText.blocks[i].lines[j].elements[k];

            debugPrint(
                "${"b$i l$j e$k ${data.text.toLowerCase().trim().replaceAll(" ", "")}"} ${data.boundingBox.center}");

            if (checkNikField(data.text)) {
              nikRect = data.boundingBox;
              debugPrint("nik field detected");
            }

            if (checkNamaField(data.text)) {
              namaRect = data.boundingBox;
              debugPrint("nama field detected");
            }

            if (checkTglLahirField(data.text)) {
              tempatTanggalLahirRect = data.boundingBox;
              debugPrint("tempat tgllahir field detected");
            }

            if (checkJenisKelaminField(data.text)) {
              jenisKelaminRect = data.boundingBox;
              debugPrint("jenis kelamin field detected");
            }

            if (checkAlamatField(data.text)) {
              alamatRect = data.boundingBox;
              debugPrint("alamat field detected");
            }

            if (checkRtRwField(data.text)) {
              rtrwRect = data.boundingBox;
              debugPrint("RT/RW field detected");
            }

            if (checkKelDesaField(data.text)) {
              kelDesaRect = data.boundingBox;
              debugPrint("kelurahan / desa field detected");
            }

            if (checkKecamatanField(data.text)) {
              kecamatanRect = data.boundingBox;
              debugPrint("kecamatan field detected");
            }

            if (checkAgamaField(data.text)) {
              agamaRect = data.boundingBox;
              debugPrint("agama field detected");
            }

            if (checkKawinField(data.text)) {
              statusKawinRect = data.boundingBox;
              debugPrint("statusKawin field detected");
            }

            if (checkPekerjaanField(data.text)) {
              pekerjaanRect = data.boundingBox;
              debugPrint("pekerjaan field detected");
            }

            if (checkKewarganegaraanField(data.text)) {
              kewarganegaraanRect = data.boundingBox;
              debugPrint("kewarganegaraan field detected");
            }
          }
        }
      }
    } catch (e) {
      debugPrint(e.toString());
      throw Exception("iteration failed");
    }

    /// [INFO]
    /// Check if the Field Rect is found
    debugPrint("nik rect $nikRect");
    debugPrint("nama rect $namaRect");
    debugPrint("alamat rect $alamatRect");
    debugPrint("rt rw rect $rtrwResult");
    debugPrint("kelDesa rect $kelDesaRect");
    debugPrint("kecamatan rect $kecamatanRect");
    debugPrint("jenis Kelamin rect $jenisKelaminRect");
    debugPrint("tempatTanggalLahir rect $tempatTanggalLahirRect");
    debugPrint("agama rect $agamaRect");
    debugPrint("statusKawin rect $statusKawinRect");
    debugPrint("pekerjaan rect $pekerjaanRect");
    debugPrint("kewarganegaraan rect $kewarganegaraanRect");

    /// [INFO]
    /// after get the Field Rect, we find the value based on field rect
    try {
      for (int i = 0; i < visionText.blocks.length; i++) {
        for (int j = 0; j < visionText.blocks[i].lines.length; j++) {
          final data = visionText.blocks[i].lines[j];

          if (isInside(data.boundingBox, nikRect)) {
            nikResult = "$nikResult ${data.text}";
            debugPrint("------ nik");
            debugPrint(nikResult);
          }

          if (isInside3Rect(
            isThisRect: data.boundingBox,
            isInside: namaRect,
            andAbove: tempatTanggalLahirRect,
          )) {
            if (data.text.toLowerCase() != "nama") {
              debugPrint("------ name");
              nameResult = ("$nameResult ${data.text}").trim();
              debugPrint(nameResult);
            }
          }

          if (isInside(data.boundingBox, tempatTanggalLahirRect)) {
            final temp = data.text.replaceAll("Tempat/Tgi Lahir", "");
            tempatLahirResult = temp.substring(0, temp.indexOf(',') + 1);
            debugPrint("------ tempat lahir");
            debugPrint(tempatLahirResult);
          }

          if (isInside(data.boundingBox, tempatTanggalLahirRect)) {
            final temp = data.text.replaceAll("Tempat/Tgi Lahir", "");
            final result = temp.substring(0, temp.indexOf(',') + 1);
            debugPrint(result);
            if (result.isNotEmpty) {
              tglLahirResult =
                  temp.replaceAll(result, "").replaceAll(":", "").trim();
            }

            debugPrint("------ tgllahir");
            debugPrint(tglLahirResult);
          }

          if (isInside(data.boundingBox, jenisKelaminRect)) {
            jenisKelaminResult = "$jenisKelaminResult ${data.text}";
            debugPrint("------ jenis kelamin ");
            debugPrint(rtrwResult);
          }

          if (isInside3Rect(
              isThisRect: data.boundingBox,
              isInside: alamatRect,
              andAbove: agamaRect)) {
            alamatFullResult = "$alamatFullResult ${data.text}";
            debugPrint("------ alamat");
            debugPrint(alamatFullResult);
          }

          if (isInside(data.boundingBox, alamatRect)) {
            alamatResult = "$alamatResult ${data.text}";
            debugPrint("------ alamat  ");
            debugPrint(alamatResult);
          }

          if (isInside(data.boundingBox, rtrwRect)) {
            rtrwResult = "$rtrwResult ${data.text}";
            debugPrint("------ rt rw ");
            debugPrint(rtrwResult);
          }

          if (isInside(data.boundingBox, kelDesaRect)) {
            kelDesaResult = "$kelDesaResult ${data.text}";
            debugPrint("------ keldesa");
            debugPrint(rtrwResult);
          }

          if (isInside(data.boundingBox, kecamatanRect)) {
            kecamatanResult = "$kecamatanResult ${data.text}";
            debugPrint("------ kecamatan");
            debugPrint(rtrwResult);
          }

          if (isInside(data.boundingBox, agamaRect)) {
            agamaResult = "$agamaResult ${data.text}";
            debugPrint("------ agama : $agamaResult");
          }

          if (isInside(data.boundingBox, statusKawinRect)) {
            statusKawinResult = "$statusKawinResult ${data.text}";
            debugPrint("------ status kawin result ");
            debugPrint(statusKawinResult);
          }

          if (isInside(data.boundingBox, pekerjaanRect)) {
            pekerjaanResult = "$pekerjaanResult ${data.text}";
            debugPrint("------ status pekerjaan result ");
            debugPrint(pekerjaanResult);
          }

          if (isInside(data.boundingBox, kewarganegaraanRect)) {
            kewarganegaraanResult = "$kewarganegaraanResult ${data.text}";
            debugPrint("------ status kewarganegaraan result ");
            debugPrint(kewarganegaraanResult);
          }
        }
      }
    } catch (e) {
      debugPrint(e.toString());
      throw Exception("iteration failed ");
    }

    /// [INFO]
    /// check the result value
    debugPrint("result before normalization");
    debugPrint("nik : $nikResult");
    debugPrint("nama : $nameResult");
    debugPrint("tempatLahir : $tempatLahirResult");
    debugPrint("tglLahir : $tglLahirResult");
    debugPrint("jenis kelamin : $jenisKelaminResult");
    debugPrint("alamat full : $alamatFullResult");
    debugPrint("rt rw : $rtrwResult");
    debugPrint("kel desa : $kelDesaResult");
    debugPrint("kecamatan : $kecamatanResult");
    debugPrint("agama : $agamaResult");
    debugPrint("status kawin : $statusKawinResult");
    debugPrint("kewarganegaraan : $kewarganegaraanResult");

    /// [INFO]
    /// return with normalization (because some result may not good detection)
    return KtpDataConverter.from(
        namaLengkap: nameResult,
        tanggalLahir: tglLahirResult,
        alamatFull: alamatFullResult,
        agama: agamaResult,
        statusPerkawinan: statusKawinResult,
        pekerjaan: pekerjaanResult,
        nik: nikResult,
        kewarganegaraan: kewarganegaraanResult,
        golDarah: "null",
        tempatLahir: tempatLahirResult,
        berlakuHingga: "null",
        jenisKelamin: jenisKelaminResult,
        alamat: alamatResult,
        kecamatan: kecamatanResult,
        kelDesa: kelDesaResult,
        rtrw: rtrwResult);
  }
}

final scanKtpRepositoryProvider = Provider<ScanKtpRepository>((ref) {
  final textRecognizer = TextRecognizer();

  ref.onDispose(() {
    textRecognizer.close();
  });
  return ScanKtpRepository(textRecognizer);
});

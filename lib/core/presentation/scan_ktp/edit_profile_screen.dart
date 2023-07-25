import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:ktp_detection/constants/colors.dart';
import 'package:ktp_detection/core/presentation/scan_ktp/scan_ktp_controller.dart';
import 'package:ktp_detection/core/presentation/scan_ktp/scan_ktp_screen.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  final TextEditingController tecNik = TextEditingController();

  final TextEditingController tecNama = TextEditingController();

  final TextEditingController tecDate = TextEditingController();

  final TextEditingController tecTempalLahir = TextEditingController();

  final TextEditingController tecKelamin = TextEditingController();

  final TextEditingController tecAlamat = TextEditingController();

  final TextEditingController tecAgama = TextEditingController();

  final TextEditingController tecPerkawinan = TextEditingController();

  final TextEditingController tecPekerjaan = TextEditingController();

  final TextEditingController tecKewarganegaraan = TextEditingController();

  final DateFormat dateFormat = DateFormat("dd-MM-yyyy");

  @override
  Widget build(BuildContext context) {
    final controller = ref.read(scanKtpControllerProvider.notifier);
    ref.listen(
      scanKtpControllerProvider,
      (previous, next) {
        if (previous?.ktpDataValue != next.ktpDataValue) {
          next.ktpDataValue.whenData((value) {
            if (value != null) {
              setState(() {
                tecNik.text = value.nik;
                tecNama.text = value.namaLengkap;
                tecDate.text = value.tanggalLahir;
                tecTempalLahir.text = value.tempatLahir;
                tecKelamin.text = value.jenisKelamin;
                tecAlamat.text = value.alamatFull;
                tecAgama.text = value.agama;
                tecPerkawinan.text = value.statusPerkawinan;
                tecPekerjaan.text = value.pekerjaan;
                tecKewarganegaraan.text = value.kewarganegaraan;
              });
            }
          });
        }
      },
    );

    return Scaffold(
      backgroundColor: appColorSecondaryDarkBlue,
      appBar: AppBar(
        title: const Text("Edit Profile"),
      ),
      body: Container(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 10,
              ),
              const Text(
                "Profile Image",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    child: Icon(
                      Icons.person,
                      size: 30,
                    ),
                  ),
                ],
              ),
              TextFormField(
                controller: tecNik,
                style: TextStyle(color: appColorAccent0Gray),
                decoration: InputDecoration(
                  labelText: 'NIK',
                  labelStyle: TextStyle(color: appColorAccent0Gray),
                ),
              ),
              TextFormField(
                controller: tecNama,
                style: TextStyle(color: appColorAccent0Gray),
                decoration: InputDecoration(
                  labelText: 'Nama Lengkap',
                  labelStyle: TextStyle(color: appColorAccent0Gray),
                ),
              ),
              GestureDetector(
                onTap: () async {
                  DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(1960),
                      lastDate: DateTime(2025));
                  if (picked != null) {
                    tecDate.text = dateFormat.format(picked);
                  }
                },
                child: TextFormField(
                  enabled: false,
                  controller: tecDate,
                  style: TextStyle(color: appColorAccent0Gray),
                  decoration: InputDecoration(
                    labelText: 'Tanggal Lahir',
                    labelStyle: TextStyle(color: appColorAccent0Gray),
                  ),
                ),
              ),
              TextFormField(
                controller: tecKelamin,
                style: TextStyle(color: appColorAccent0Gray),
                decoration: InputDecoration(
                  labelText: 'Jenis Kelamin',
                  labelStyle: TextStyle(color: appColorAccent0Gray),
                ),
              ),
              TextFormField(
                controller: tecAlamat,
                style: TextStyle(color: appColorAccent0Gray),
                decoration: InputDecoration(
                  labelText: 'Alamat',
                  labelStyle: TextStyle(color: appColorAccent0Gray),
                ),
              ),
              TextFormField(
                controller: tecAgama,
                style: TextStyle(color: appColorAccent0Gray),
                decoration: InputDecoration(
                  labelText: 'Agama',
                  labelStyle: TextStyle(color: appColorAccent0Gray),
                ),
              ),
              TextFormField(
                controller: tecPerkawinan,
                style: TextStyle(color: appColorAccent0Gray),
                decoration: InputDecoration(
                  labelText: 'Status Perkawinan',
                  labelStyle: TextStyle(color: appColorAccent0Gray),
                ),
              ),
              TextFormField(
                controller: tecPekerjaan,
                style: TextStyle(color: appColorAccent0Gray),
                decoration: InputDecoration(
                  labelText: 'Pekerjaan',
                  labelStyle: TextStyle(color: appColorAccent0Gray),
                ),
              ),
              TextFormField(
                controller: tecKewarganegaraan,
                style: TextStyle(color: appColorAccent0Gray),
                decoration: InputDecoration(
                  labelText: 'Kewarganegaraan',
                  labelStyle: TextStyle(color: appColorAccent0Gray),
                ),
              ),
              ElevatedButton(
                  onPressed: () async {
                    final result = await Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const CustomCamera(),
                      ),
                    );
                    controller.scanKtpInput(result);
                  },
                  child: const Text("Scan Ktp"))
            ],
          ),
        ),
      ),
    );
  }
}

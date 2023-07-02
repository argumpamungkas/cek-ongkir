import 'dart:convert';

import 'package:cek_ongkir/app/data/models/cost_ongkir_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class HomeController extends GetxController {
  TextEditingController berat = TextEditingController();

  RxString provAsalID = "0".obs;
  RxString kotaAsalID = "0".obs;
  RxString provTujuanID = "0".obs;
  RxString kotaTujuanID = "0".obs;
  RxString kurir = "".obs;
  String apiKey = "fe3500c2f7227acd3e8bb373a8d7d8a3";

  RxBool isLoading = false.obs;

  List<Map<String, String>> courier = [
    {
      "code": "jne",
      "name": "JNE",
      "image":
          "https://jnewsonline.com/wp-content/uploads/2021/11/Foto-2-Naskah-Mengenal-Sosok-Kreator-Logo-%E2%80%98Biru-Tua-Merah-JNE.jpg"
    },
    {
      "code": "pos",
      "name": "POS INDONESIA",
      "image":
          "https://assets.pikiran-rakyat.com/crop/0x0:0x0/x/photo/2021/10/09/2138107074.jpg"
    },
    {
      "code": "tiki",
      "name": "TIKI",
      "image": "https://www.tikibanjarmasin.com/images/Logo-TIKI.png"
    },
  ];

  void cekOngkir() async {
    if (provAsalID != "0" &&
        kotaAsalID != "0" &&
        provTujuanID != "0" &&
        kotaTujuanID != "0" &&
        kurir.isNotEmpty) {
      var url = "https://api.rajaongkir.com/starter/cost";

      try {
        isLoading.value = true;
        var response = await http.post(Uri.parse(url), headers: {
          "key": apiKey,
        }, body: {
          "origin": kotaAsalID.value,
          "destination": kotaTujuanID.value,
          "weight": berat.text,
          "courier": kurir.value,
        });

        isLoading.value = false;

        List result =
            jsonDecode(response.body)['rajaongkir']['results'][0]['costs'];

        List<CostOngkir> costOngkir = CostOngkir.fromJsonList(result);

        Get.defaultDialog(
          title: "ONGKOS KIRIM",
          titlePadding: const EdgeInsets.only(top: 20),
          content: Column(
            children: costOngkir
                .map((e) => ListTile(
                      title: Text("${e.service}"),
                      subtitle: Text("Estimasi ${e.cost?[0].etd} hari"),
                      trailing: Text("Rp. ${e.cost?[0].value}"),
                    ))
                .toList(),
          ),
        );
      } catch (e) {
        Get.defaultDialog(
          title: "GAGAL CEK ONGKIR",
          titlePadding: const EdgeInsets.only(top: 20),
          middleText: "Kegagalan dalam melakukan cek ongkir, $e",
          middleTextStyle: const TextStyle(
            height: 1.5,
          ),
        );
      }
    } else {
      Get.defaultDialog(
        title: "GAGAL CEK ONGKIR",
        titlePadding: const EdgeInsets.only(top: 20),
        middleText: "Lengkapi data form informasi yang disediakan",
        middleTextStyle: const TextStyle(
          height: 1.5,
        ),
      );
    }
  }
}

import 'dart:convert';

import 'package:cek_ongkir/app/data/models/city_model.dart';
import 'package:cek_ongkir/app/data/models/province_model.dart';
import 'package:http/http.dart' as http;
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cek Ongkir'),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text("Lokasi Pengirim"),
          const SizedBox(height: 10),
          DropdownSearch<Province>(
            popupProps: const PopupProps.dialog(
              showSearchBox: true,
            ),
            dropdownDecoratorProps: const DropDownDecoratorProps(
              dropdownSearchDecoration: InputDecoration(
                labelText: "Provinsi",
                border: OutlineInputBorder(),
              ),
            ),
            asyncItems: (String filter) async {
              var url = "https://api.rajaongkir.com/starter/province";
              var response = await http.get(Uri.parse(url), headers: {
                "key": controller.apiKey,
              });
              List<Province> allProvince = Province.fromJsonList(
                  jsonDecode(response.body)["rajaongkir"]["results"]);
              return allProvince;
            },
            onChanged: (value) =>
                controller.provAsalID.value = value?.provinceId ?? "0",
          ),
          const SizedBox(height: 15),
          DropdownSearch<City>(
            popupProps: const PopupProps.dialog(
              showSearchBox: true,
              fit: FlexFit.loose,
            ),
            dropdownDecoratorProps: const DropDownDecoratorProps(
              dropdownSearchDecoration: InputDecoration(
                labelText: "Kota/Kabupaten",
                border: OutlineInputBorder(),
              ),
            ),
            asyncItems: (String filter) async {
              var url =
                  "https://api.rajaongkir.com/starter/city?province=${controller.provAsalID}";
              var response = await http.get(Uri.parse(url), headers: {
                "key": controller.apiKey,
              });
              List<City> allCity = City.fromJsonList(
                  jsonDecode(response.body)["rajaongkir"]["results"]);
              return allCity;
            },
            onChanged: (value) =>
                controller.kotaAsalID.value = value?.cityId ?? "0",
          ),
          const SizedBox(height: 10),
          const Divider(color: Colors.deepPurple),
          const Text("Lokasi Tujuan"),
          const SizedBox(height: 10),
          DropdownSearch<Province>(
            popupProps: const PopupProps.dialog(
              showSearchBox: true,
            ),
            dropdownDecoratorProps: const DropDownDecoratorProps(
              dropdownSearchDecoration: InputDecoration(
                labelText: "Provinsi",
                border: OutlineInputBorder(),
              ),
            ),
            asyncItems: (String filter) async {
              var url = "https://api.rajaongkir.com/starter/province";
              var response = await http.get(Uri.parse(url), headers: {
                "key": controller.apiKey,
              });
              List<Province> allProvince = Province.fromJsonList(
                  jsonDecode(response.body)["rajaongkir"]["results"]);
              return allProvince;
            },
            onChanged: (value) =>
                controller.provTujuanID.value = value?.provinceId ?? "0",
          ),
          const SizedBox(height: 15),
          DropdownSearch<City>(
            popupProps: const PopupProps.dialog(
              showSearchBox: true,
              fit: FlexFit.loose,
            ),
            dropdownDecoratorProps: const DropDownDecoratorProps(
              dropdownSearchDecoration: InputDecoration(
                labelText: "Kota/Kabupaten",
                border: OutlineInputBorder(),
              ),
            ),
            asyncItems: (String filter) async {
              var url =
                  "https://api.rajaongkir.com/starter/city?province=${controller.provTujuanID.value}";
              var response = await http.get(Uri.parse(url), headers: {
                "key": controller.apiKey,
              });
              List<City> allCity = City.fromJsonList(
                  jsonDecode(response.body)["rajaongkir"]["results"]);
              return allCity;
            },
            onChanged: (value) =>
                controller.kotaTujuanID.value = value?.cityId ?? "0",
          ),
          const SizedBox(height: 15),
          DropdownSearch<Map<String, String>>(
            popupProps: PopupProps.dialog(
              fit: FlexFit.loose,
              itemBuilder: (context, item, isSelected) => ListTile(
                leading: Image.network(
                  "${item['image']}",
                  width: 50,
                ),
                title: Text("${item['name']}"),
              ),
            ),
            dropdownDecoratorProps: const DropDownDecoratorProps(
              dropdownSearchDecoration: InputDecoration(
                labelText: "Pilih Kurir",
                border: OutlineInputBorder(),
              ),
            ),
            dropdownBuilder: (context, selectedItem) => Text(
                (selectedItem != null)
                    ? "${selectedItem['name']}"
                    : "Pilih Kurir"),
            items: controller.courier,
            onChanged: (value) => controller.kurir.value = value?['code'] ?? '',
          ),
          const SizedBox(height: 15),
          TextField(
            autocorrect: false,
            controller: controller.berat,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: "Berat (Gram)",
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 15),
          Obx(
            () => OutlinedButton(
              onPressed: () => controller.cekOngkir(),
              style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.deepPurple)),
              child: Text(
                (controller.isLoading.isFalse)
                    ? "Cek Ongkos Kirim"
                    : "Loading...",
                style: TextStyle(color: Colors.deepPurple),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

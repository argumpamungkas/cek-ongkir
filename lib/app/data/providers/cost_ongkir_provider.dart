import 'package:get/get.dart';

import '../models/cost_ongkir_model.dart';

class CostOngkirProvider extends GetConnect {
  @override
  void onInit() {
    httpClient.defaultDecoder = (map) {
      if (map is Map<String, dynamic>) return CostOngkir.fromJson(map);
      if (map is List)
        return map.map((item) => CostOngkir.fromJson(item)).toList();
    };
    httpClient.baseUrl = 'YOUR-API-URL';
  }

  Future<CostOngkir?> getCostOngkir(int id) async {
    final response = await get('costongkir/$id');
    return response.body;
  }

  Future<Response<CostOngkir>> postCostOngkir(CostOngkir costongkir) async =>
      await post('costongkir', costongkir);
  Future<Response> deleteCostOngkir(int id) async =>
      await delete('costongkir/$id');
}

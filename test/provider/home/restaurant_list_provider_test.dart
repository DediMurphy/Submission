import 'package:flutter_test/flutter_test.dart';
import 'package:restaurantapp/data/model/restaurant.dart';
import 'package:restaurantapp/data/model/restaurant_list_response.dart';
import 'package:restaurantapp/data/service/api_service.dart';
import 'package:restaurantapp/provider/home/restaurant_list_provider.dart';
import 'package:restaurantapp/static/restaurant_list_result_state.dart';

// Membuat FakeApiServices untuk testing
class FakeApiServices extends ApiServices {
  final bool shouldFail;

  FakeApiServices({this.shouldFail = false});

  @override
  Future<RestaurantListResponse> getRestaurantList() async {
    if (shouldFail) {
      throw Exception("Failed to fetch data");
    }
    return RestaurantListResponse(
      error: false,
      message: "Success",
      count: 2,
      restaurants: [
        Restaurant(
            id: "1",
            name: "Restaurant A",
            description: "Delicious food",
            rating: 4.5),
        Restaurant(
            id: "2",
            name: "Restaurant B",
            description: "Best in town",
            rating: 4.7),
      ],
    );
  }
}

void main() {
  late RestaurantListProvider provider;
  late FakeApiServices fakeApiServices;

  setUp(() {
    fakeApiServices = FakeApiServices();
    provider = RestaurantListProvider(fakeApiServices);
  });

  test('Memastikan state awal provider harus didefinisikan', () {
    expect(provider.resultState, isA<RestaurantListNoneState>());
  });

  test(
      'Memastikan harus mengembalikan daftar restoran ketika pengambilan data API berhasil',
      () async {
    await provider.fetchRestaurantList();

    expect(provider.resultState, isA<RestaurantListLoadedState>());
    final loadedState = provider.resultState as RestaurantListLoadedState;
    expect(loadedState.data.length, 2);
  });

  test('Memastikan menangkap error jika request API gagal', () async {
    fakeApiServices = FakeApiServices(shouldFail: true);
    provider = RestaurantListProvider(fakeApiServices);

    await provider.fetchRestaurantList();

    expect(provider.resultState, isA<RestaurantListErrorState>());
    final errorState = provider.resultState as RestaurantListErrorState;
    expect(errorState.message, "Exception: Failed to fetch data");
  });
}

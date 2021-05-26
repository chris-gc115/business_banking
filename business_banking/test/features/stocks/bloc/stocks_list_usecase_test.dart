import 'package:business_banking/features/stocks_portfolio/bloc/stocks_usecase.dart';
import 'package:business_banking/features/stocks_portfolio/model/stocks_list_view_model.dart';
import 'package:flutter_test/flutter_test.dart';

main() {
  test('StocksListUsecase initializes and calls create', () {
    final usecase = StocksUseCase((viewModel) {
      expect(viewModel, isA<StocksListViewModel>());
      throw Error();
    });
    usecase.create();
  });
}

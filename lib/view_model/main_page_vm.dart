import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_future/data/postal_code.dart';
import 'package:riverpod_future/logic/main_page_logic.dart';

class MainPageVM {
  late final WidgetRef _ref;
  final _postalcodeProvider = StateProvider<String>((ref) => '');

  get postalcode => _ref.watch(_postalcodeProvider);

  final _apiFamilyProvider = FutureProvider.autoDispose
      .family<PostalCode, String>((ref, postalcode) async {
    final logic = MainPageLogic();
    if (!logic.willProceed(postalcode)) {
      return PostalCode.empty;
    }
    return await logic.getPostalCode(postalcode);
  });

  AsyncValue<PostalCode> postalCodeWithFamily(String postcode) =>
      _ref.watch(_apiFamilyProvider(postcode));

  void setRef(WidgetRef ref) {
    _ref = ref;
  }

  void onPostalCodeChanged(String postalcode) {
    _ref.read(_postalcodeProvider.state).update((state) => postalcode);
  }
}

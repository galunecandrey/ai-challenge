// ignore_for_file: close_sinks
import 'package:injectable/injectable.dart';
import 'package:vitals_arch/vitals_arch.dart' show ViewModel;

const kMaxQuickRepliesNumber = 6;

@injectable
class HomeViewModel extends ViewModel {
  HomeViewModel();
}

import 'package:vitals_utils/vitals_utils.dart' show BaseError, Either;

//ignore: one_member_abstracts
abstract class LaunchService {
  Future<Either<BaseError, bool>> launch(Uri uri);
}

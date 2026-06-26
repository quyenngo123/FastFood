import '../entities/voucher_entity.dart';
import '../repositories/voucher_repository.dart';

class GetVoucherByCodeUseCase {
  final VoucherRepository repository;

  GetVoucherByCodeUseCase(this.repository);

  Future<VoucherEntity?> call(String code) async {
    return await repository.getVoucherByCode(code);
  }
}

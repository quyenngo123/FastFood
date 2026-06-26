import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_vouchers_usecase.dart';
import '../../domain/usecases/get_voucher_by_code_usecase.dart';
import 'voucher_event.dart';
import 'voucher_state.dart';

export 'voucher_event.dart';
export 'voucher_state.dart';

class VoucherBloc extends Bloc<VoucherEvent, VoucherState> {
  final GetVouchersUseCase _getVouchersUseCase;
  final GetVoucherByCodeUseCase _getVoucherByCodeUseCase;

  VoucherBloc({
    required GetVouchersUseCase getVouchersUseCase,
    required GetVoucherByCodeUseCase getVoucherByCodeUseCase,
  })  : _getVouchersUseCase = getVouchersUseCase,
        _getVoucherByCodeUseCase = getVoucherByCodeUseCase,
        super(VoucherInitial()) {
    on<GetVouchersEvent>(_onGetVouchers);
    on<GetVoucherByCodeEvent>(_onGetVoucherByCode);
  }

  Future<void> _onGetVouchers(GetVouchersEvent event, Emitter<VoucherState> emit) async {
    emit(VoucherLoading());
    try {
      final vouchers = await _getVouchersUseCase();
      emit(VoucherLoaded(vouchers));
    } catch (e) {
      emit(VoucherError(e.toString()));
    }
  }

  Future<void> _onGetVoucherByCode(GetVoucherByCodeEvent event, Emitter<VoucherState> emit) async {
    emit(VoucherLoading());
    try {
      final voucher = await _getVoucherByCodeUseCase(event.code);
      emit(VoucherSingleLoaded(voucher));
    } catch (e) {
      emit(VoucherError(e.toString()));
    }
  }
}

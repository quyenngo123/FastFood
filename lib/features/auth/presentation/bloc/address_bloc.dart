import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_addresses_usecase.dart';
import '../../domain/usecases/save_address_usecase.dart';
import '../../domain/usecases/delete_address_usecase.dart';
import '../../domain/usecases/set_default_address_usecase.dart';
import 'address_event.dart';
import 'address_state.dart';

export 'address_event.dart';
export 'address_state.dart';

class AddressBloc extends Bloc<AddressEvent, AddressState> {
  final GetAddressesUseCase _getAddressesUseCase;
  final SaveAddressUseCase _saveAddressUseCase;
  final DeleteAddressUseCase _deleteAddressUseCase;
  final SetDefaultAddressUseCase _setDefaultAddressUseCase;

  AddressBloc({
    required GetAddressesUseCase getAddressesUseCase,
    required SaveAddressUseCase saveAddressUseCase,
    required DeleteAddressUseCase deleteAddressUseCase,
    required SetDefaultAddressUseCase setDefaultAddressUseCase,
  })  : _getAddressesUseCase = getAddressesUseCase,
        _saveAddressUseCase = saveAddressUseCase,
        _deleteAddressUseCase = deleteAddressUseCase,
        _setDefaultAddressUseCase = setDefaultAddressUseCase,
        super(AddressInitial()) {
    on<GetAddressesEvent>(_onGetAddresses);
    on<SaveAddressEvent>(_onSaveAddress);
    on<DeleteAddressEvent>(_onDeleteAddress);
    on<SetDefaultAddressEvent>(_onSetDefaultAddress);
  }

  Future<void> _onGetAddresses(GetAddressesEvent event, Emitter<AddressState> emit) async {
    emit(AddressLoading());
    try {
      final addresses = await _getAddressesUseCase(event.userId);
      emit(AddressLoaded(addresses));
    } catch (e) {
      emit(AddressError(e.toString()));
    }
  }

  Future<void> _onSaveAddress(SaveAddressEvent event, Emitter<AddressState> emit) async {
    emit(AddressLoading());
    try {
      await _saveAddressUseCase(event.address);
      emit(AddressActionSuccess());
      add(GetAddressesEvent(event.address.userId));
    } catch (e) {
      emit(AddressError(e.toString()));
    }
  }

  Future<void> _onDeleteAddress(DeleteAddressEvent event, Emitter<AddressState> emit) async {
    emit(AddressLoading());
    try {
      await _deleteAddressUseCase(event.addressId);
      emit(AddressActionSuccess());
      add(GetAddressesEvent(event.userId));
    } catch (e) {
      emit(AddressError(e.toString()));
    }
  }

  Future<void> _onSetDefaultAddress(SetDefaultAddressEvent event, Emitter<AddressState> emit) async {
    emit(AddressLoading());
    try {
      await _setDefaultAddressUseCase(event.userId, event.addressId);
      emit(AddressActionSuccess());
      add(GetAddressesEvent(event.userId));
    } catch (e) {
      emit(AddressError(e.toString()));
    }
  }
}

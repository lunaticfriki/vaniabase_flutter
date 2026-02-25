import 'package:flutter_bloc/flutter_bloc.dart';
import 'items_write_state.dart';

class ItemsWriteCubit extends Cubit<ItemsWriteState> {
  ItemsWriteCubit() : super(ItemsWriteInitial());
  void emitInitial() => emit(ItemsWriteInitial());
  void emitLoading() => emit(ItemsWriteLoading());
  void emitSuccess() => emit(ItemsWriteSuccess());
  void emitFailure(String error) => emit(ItemsWriteFailure(error));
}

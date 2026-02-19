import 'package:flutter_bloc/flutter_bloc.dart';
import 'items_state.dart';
import '../../domain/entities/item.dart';

class ItemsCubit extends Cubit<ItemsState> {
  ItemsCubit() : super(ItemsInitial());

  void emitLoading() => emit(ItemsLoading());

  void emitLoaded(List<Item> items) => emit(ItemsLoaded(items));

  void emitError(String message) => emit(ItemsError(message));
}

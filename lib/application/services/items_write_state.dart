abstract class ItemsWriteState {
  const ItemsWriteState();
}

class ItemsWriteInitial extends ItemsWriteState {}

class ItemsWriteLoading extends ItemsWriteState {}

class ItemsWriteSuccess extends ItemsWriteState {}

class ItemsWriteFailure extends ItemsWriteState {
  final String errorMessage;

  const ItemsWriteFailure(this.errorMessage);
}

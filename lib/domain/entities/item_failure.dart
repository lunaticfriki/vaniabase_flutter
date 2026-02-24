abstract class ItemFailure {
  final String message;
  const ItemFailure(this.message);
}

class ItemUnexpectedFailure extends ItemFailure {
  const ItemUnexpectedFailure(super.message);
}

class ItemNotFoundFailure extends ItemFailure {
  const ItemNotFoundFailure(super.message);
}

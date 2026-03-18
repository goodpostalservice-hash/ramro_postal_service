class SavedAddressModel {
  final List<int>? selectedId;
  final List<String>? customerName;
  final List<String>? qrData;
  final List<bool>? selectedItems;

  SavedAddressModel(
      {this.selectedId, this.customerName, this.qrData, this.selectedItems});
}

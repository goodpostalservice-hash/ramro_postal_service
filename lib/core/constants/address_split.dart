String splitCoordinateString(String address) {
  List<String> addressParts = address.split(','); // Split the address by commas
  // Remove the last two words (latitude and longitude)
  List<String> remainingParts = addressParts.sublist(
    0,
    addressParts.length - 2,
  );
  String result = remainingParts.join(
    ',',
  ); // Join the remaining parts with commas
  return result;
}

class DonationModel {
  int? quantity = 0;
  String? socialNetwork = '';
  String? message = '';
  int? value = 0;

  DonationModel({required this.quantity, this.socialNetwork, this.message, required this.value});

  DonationModel.fromJson(Map<String, dynamic> json) {
    quantity = json['quantity'];
    socialNetwork = json['socialNetwork'];
    message = json['message'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['quantity'] = this.quantity;
    data['socialNetwork'] = this.socialNetwork;
    data['message'] = this.message;
    data['value'] = this.value;
    return data;
  }
}

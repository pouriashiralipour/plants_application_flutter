// otp_models.dart
class OtpRequestModels {
  OtpRequestModels({this.target, this.purpose = 'register'});

  String? purpose;
  String? target;

  Map<String, dynamic> toJson() => {'target': target, 'purpose': purpose};
}

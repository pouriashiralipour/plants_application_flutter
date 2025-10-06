class OtpRequestModels {
  OtpRequestModels({this.target, this.purpose = 'register'});

  String? purpose;
  String? target;

  Map<String, dynamic> toJson() => {'target': target, 'purpose': purpose};
}

class OtpVerifyModels {
  OtpVerifyModels({required this.code});

  String? code;

  Map<String, dynamic> toJson() => {'code': code};
}

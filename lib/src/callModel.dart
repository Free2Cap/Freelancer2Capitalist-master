class Call {
  String? callerId;
  String? callerName;
  String? callerPic;
  String? receiverId;
  String? receiverName;
  String? receiverPic;
  String? channelId;
  bool? hasDialled;

  Call({
    this.callerId,
    this.callerName,
    this.callerPic,
    this.receiverId,
    this.receiverName,
    this.receiverPic,
    this.channelId,
    this.hasDialled,
  });

  Map<String, dynamic> toMap(Call call) {
    return {
      "callerId": callerId,
      "callerName": callerName,
      "callerPic": callerPic,
      "receiverId": receiverId,
      "receiverName": receiverName,
      "receiverPic": receiverPic,
      "channelId": channelId,
      "hasDialled": hasDialled,
    };
  }

  Call.fromMap(Map<String, dynamic> callMap) {
    callerId = callMap['callerId'];
    callerName = callMap['callerName'];
    callerPic = callMap['callerPic'];
    receiverId = callMap['receiverId'];
    receiverName = callMap['receiverName'];
    receiverPic = callMap['receiverPic'];
    channelId = callMap['channelId'];
    hasDialled = callMap['hasDialled'];
  }
}

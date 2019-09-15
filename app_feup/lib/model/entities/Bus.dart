class Bus{
  String busCode;
  String destination;
  bool direction;

  Bus(String busCode, String destination, bool direction){
    this.busCode =  busCode;
    this.destination = destination;
    this.direction = direction;
  }

  Bus.secConstructor(this.busCode) {
    this.destination = "";
    this.direction = false;
  }

  Map<String, dynamic> toMap() {
    return {
      'busCode': busCode,
      'destination': destination,
      'direction': direction
    };
  }

  String getBusCode(){
    return busCode;
  }
}
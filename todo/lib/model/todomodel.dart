class Todmodel{
  String? id;
  String? userId;
  String? data;

  Todmodel({this.id,this.userId,this.data});

  Todmodel.fromJson(Map<String,dynamic> json){
    id = json['_id'];
    userId=json["userId"]; 
    data=json["data"];
  }

}
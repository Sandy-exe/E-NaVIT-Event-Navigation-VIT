class Notify {
  String? title;
  String? body;
  String? image;
   String? time;
   String? date;

  Notify({
    required this.title,
    required this.body,
    required this.image, 
    required this.time,
    required this.date
  });

  Notify.fromJson(Map<String, dynamic> json) 
    : title = json['title'],
      body = json['body'],
      image = json['image'],
      time = json['time'],
      date = json['date'];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    data['body'] = body;
    data['image'] = image;
    data['time'] = time;
    data['date'] = date;
    return data;
  }
}
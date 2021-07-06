class Contact {
  String first_name;
  String last_name;

  Contact.fromJson(Map json)
      : first_name = json['first_name'],
        last_name = json['last_name'];

  Map toJson() {
    return {'first_name': first_name, 'last_name': last_name};
  }
}

class Contact {
  late final String first_name;
  late final String last_name;
  late final List<dynamic> contact_numbers;
  late String id;

  Contact(this.first_name, this.last_name, this.contact_numbers);

  Contact.fromJson(Map json)
      : first_name = json['first_name'],
        last_name = json['last_name'],
        contact_numbers = json['contact_numbers'],
        id = json['_id'];
  // add contact numbers

  Map toJson() {
    return {
      'first_name': first_name,
      'last_name': last_name,
      'contact_numbers': contact_numbers,
    };
  }
}

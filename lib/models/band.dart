class Band {
  String id;
  String name;
  int votes;

  Band({required this.id, required this.name, required this.votes});

  // constructor that gets new arguments and returns a new instance of the class
  factory Band.formMap(Map<String, dynamic> obj) => Band(
      id: obj.containsKey('id') ? obj['id'] : 'no-id',
      name: obj.containsKey('name') ? obj['name'] : 'no-name',
      votes: obj.containsKey('votes') ? obj['votes'] : 'no-votes');
}

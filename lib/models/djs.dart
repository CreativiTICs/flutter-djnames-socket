class Dj {
  String id;
  String name;
  int votes;

  Dj({this.id, this.name, this.votes});

  //Factory Constructor tiene como objetivo regresar una nueva instancia de la clase
  factory Dj.fromMap(Map<String, dynamic> obj) => Dj(
      id: obj.containsKey('id') ? obj['id'] : 'no-id',
      name: obj.containsKey('name') ? obj['name'] : 'no-name',
      votes: obj.containsKey('votes') ? obj['votes'] : 'no-votes');
}

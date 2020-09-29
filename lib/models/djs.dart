class Djs {
  String id;
  String name;
  int votes;

  Djs({this.id, this.name, this.votes});

  //Factory Constructor tiene como objetivo regresar una nueva instancia de la clase
  factory Djs.fromMap(Map<String, dynamic> obj) =>
      Djs(id: obj['id'], name: obj['name'], votes: obj['votes']);
}

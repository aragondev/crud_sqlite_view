class User {
  static const tblUser = 'users';
  static const colId = 'id';
  static const colNombre = 'nombre';
  static const colDireccion = 'direccion';
  static const colTelefono = 'telefono';

  User({this.id, this.nombre, this.direccion, this.telefono});

  int id;
  String nombre;
  String direccion;
  int telefono;


  User.fromMap(Map<String,dynamic> map){
    id = map[colId];
    nombre = map[colNombre];
    direccion = map[colDireccion];
    telefono = map[colTelefono];
  }

  Map<String, dynamic> toMap(){
    var map = <String, dynamic>{colNombre: nombre, colDireccion: direccion,colTelefono:telefono};
    if (id!=null) {
      map[colId]=id;
    }
    return map;
  }
}

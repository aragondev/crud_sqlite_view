import 'package:crud_sqlite/models/user.dart';
import 'package:flutter/material.dart';
import 'package:crud_sqlite/db/database_helper.dart';

void main() {
  runApp(MyApp());
}
const darkBlueColor = Color(0xff486579);
class MyApp extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lista de usuarios',
      theme: ThemeData(      
        primaryColor: darkBlueColor,                
      ),
      home: MyHomePage(title: 'Lista de usuarios'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);



  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _formKey = GlobalKey<FormState>();
  User _user = User();
  List<User> _users = [];
  DatabaseHelper _dbHelper;

  void initState() {
    super.initState();
    _dbHelper = DatabaseHelper.instance;
    _refreshUserList();
  }

  _refreshUserList() async {
    List<User> x = await _dbHelper.fetchUsers();
    setState(() {
      _users = x;
    });
  }



  //Formulario
    _form() => Container(
        color: Colors.white,
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(labelText: 'Nombre completo'),
                validator: (val) =>
                    (val.length ==0?'Campo obligatorio':null),
                onSaved: (val)=> setState(()=> _user.nombre = val),                
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Direccion'),
                validator: (val) =>
                    (val.length ==0?'Campo obligatorio':null),
                onSaved: (val)=> setState(()=> _user.direccion = val), 
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Telefono'),
                validator: (val) =>
                    val.length < 10 ? '10 characters required' : null,
                onSaved: (val) => setState(() => _user.telefono = int.parse(val)),
                keyboardType: TextInputType.number,
              ),
              Container(
                margin: EdgeInsets.all(10.0),
                child: RaisedButton(
                  onPressed: _onSubmit,
                  child: Text('Guardar'),
                  color: darkBlueColor,
                  textColor: Colors.white,
                ),
              ),
            ],
          ),
        ),
      );


  _onSubmit() async {
  var form = _formKey.currentState;
  if (form.validate()) {
    form.save();
      await _dbHelper.insertUser(_user);
      form.reset();
      await _refreshUserList();
  }
}


  //Lista

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Center(
          child: Text(
            widget.title,
            style: TextStyle(color: darkBlueColor),
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[_form(), _list()],
        ),
      ),
    );
  }  

  _list() => Expanded(
    child: Card(
      margin: EdgeInsets.fromLTRB(20, 30, 20, 0),
      child: Scrollbar(
        child: ListView.builder(
          padding: const EdgeInsets.all(8),
          itemBuilder: (context, index) {
            return Column(
              children: <Widget>[
                ListTile(
                  leading: Icon(
                    Icons.account_circle,
                    color: darkBlueColor,
                    size: 40.0,
                  ),
                  title: Text(
                    _users[index].nombre.toUpperCase(),
                    style: TextStyle(
                        color: darkBlueColor, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(_users[index].direccion),
                      Text(_users[index].telefono.toString())
                    ],
                  ),
                  onTap: () {},
                ),
                Divider(
                  height: 5.0,
                ),
              ],
            );
          },
          itemCount: _users.length,
        ),
      ),
    ),
  );
}

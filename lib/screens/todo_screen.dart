import 'package:flutter/material.dart';
import 'package:full_app/models/todo.dart';
import 'package:full_app/screens/tasks.dart';
import 'package:full_app/services/category_service.dart';
import 'package:full_app/services/todo_service.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

import 'categories_screen.dart';

class TodoScreen extends StatefulWidget {
  @override
  _TodoScreenState createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  var todoTitleController = TextEditingController();
  var todoDescriptionController = TextEditingController();
  var todoDateController = TextEditingController();
  var _selectedValue;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  var _categories = List<DropdownMenuItem>();
  bool _validate = false;
  final GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();
  Color primaryColor = Color(0xff18203d);
  Color secondaryColor = Color(0xff232c51);
  Color logoGreen = Color(0xff25bcbb);

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  @override
  void dispose() {
    todoTitleController.dispose();
    super.dispose();
  }

  _loadCategories() async {
    var _categoryService = CategoryService();
    var categories = await _categoryService.readCategories();
    categories.forEach((category) {
      setState(() {
        _categories.add(DropdownMenuItem(
          child: Text(category['name']),
          value: category['name'],
        ));
      });
    });
  }

  DateTime _dateTime = DateTime.now();

  _selectedTodoDate(BuildContext context) async {
    var _pickedDate = await showDatePicker(
        context: context,
        initialDate: _dateTime,
        firstDate: DateTime(2000),
        lastDate: DateTime(2100));
    if (_pickedDate != null) {
      setState(() {
        _dateTime = _pickedDate;
        todoDateController.text = DateFormat('yyyy-MM-dd').format(_pickedDate);
      });
    }
  }

  _showSuccessSnackBar(message) {
    var _snackBar = SnackBar(
      content: message,
      backgroundColor: Colors.green,
    );
    _globalKey.currentState.showSnackBar(_snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        selectedIconTheme: IconThemeData(color: logoGreen),
        unselectedIconTheme: IconThemeData(color: logoGreen),
        backgroundColor: secondaryColor,
        items: [
          BottomNavigationBarItem(
              icon: GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => TasksPage()));
                  },
                  child: Icon(
                    Icons.home,
                    size: 30.0,
                  )),
              title: Text(
                '',
                style: TextStyle(fontSize: 0.1),
              )),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.no_sim,
                color: secondaryColor,
              ),
              title: Text('')),
          BottomNavigationBarItem(
              icon: GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => CategoriesScreen()));
                  },
                  child: Icon(Icons.category)),
              title: Text(
                '',
                style: TextStyle(fontSize: 0.1),
              )),
        ],
      ),
      backgroundColor: primaryColor,
      key: _globalKey,
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(
                          FontAwesomeIcons.check,
                          color: logoGreen,
                          size: 30.0,
                        ),
                      ),
                      SizedBox(
                        width: 20.0,
                      ),
                      Text(
                        'New Task',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.openSans(
                            fontWeight: FontWeight.w100,
                            color: Colors.white,
                            fontSize: 35,
                            fontStyle: FontStyle.italic),
                      ),
                    ],
                  ),
                  TextFormField(
                    validator: (input) {
                      if (input.isEmpty) {
                        return 'Field can not be empty';
                      }
                    },
                    style: TextStyle(color: Colors.white),
                    cursorColor: logoGreen,
                    controller: todoTitleController,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: logoGreen)),
                      labelText: 'Title',
                      labelStyle: TextStyle(color: Colors.white),
                      hintText: 'Enter Todo',
                      hintStyle: TextStyle(color: Colors.white),
                    ),
                  ),
                  TextFormField(
                    validator: (input) {
                      if (input.isEmpty) {
                        return 'Field can not be empty';
                      }
                    },
                    style: TextStyle(color: Colors.white),
                    cursorColor: Colors.white,
                    controller: todoDescriptionController,
                    decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: logoGreen)),
                        labelText: 'Desription',
                        labelStyle: TextStyle(color: Colors.white),
                        hintText: 'Enter Description',
                        hintStyle: TextStyle(color: Colors.white)),
                  ),
                  TextFormField(
                    validator: (input) {
                      if (input.isEmpty) {
                        return 'Date can not be empty';
                      }
                    },
                    style: TextStyle(color: Colors.white),
                    controller: todoDateController,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: logoGreen)),
                      labelText: 'Date',
                      labelStyle: TextStyle(color: Colors.white),
                      hintStyle: TextStyle(color: Colors.white),
                      hintText: 'Choose a date',
                      prefixIcon: InkWell(
                        onTap: () {
                          _selectedTodoDate(context);
                        },
                        child: Icon(
                          Icons.calendar_today,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  Theme(
                    data:
                        Theme.of(context).copyWith(canvasColor: secondaryColor),
                    child: DropdownButtonFormField(
                        decoration: InputDecoration.collapsed(
                          hintText: "",
                        ),
                        value: _selectedValue,
                        items: _categories,
                        hint: Text(
                          '   Category',
                          style: TextStyle(color: Colors.white),
                        ),
                        style: TextStyle(color: Colors.white),
                        onChanged: (value) {
                          setState(() {
                            _selectedValue = value;
                          });
                        }),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  RaisedButton(
                    onPressed: checkForm,
                    color: logoGreen,
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 35.0, right: 35.0, top: 10.0, bottom: 10.0),
                      child: Text(
                        "Save",
                        style: TextStyle(color: Colors.white, fontSize: 15.0),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void checkForm() async {
    if (_formKey.currentState.validate()) {
      {
        var todoObject = Todo();
        todoObject.title = todoTitleController.text;
        todoObject.description = todoDescriptionController.text;
        todoObject.isFinished = 0;
        todoObject.category = _selectedValue.toString();
        todoObject.todoDate = todoDateController.text;
        var _todoService = TodoService();
        var result = await _todoService.saveTodo(todoObject);
        if (result > 0) {
//                      Navigator.of(context).push(MaterialPageRoute(builder: (context)=> TodoScreen()));
          _showSuccessSnackBar(Text('Created'));
          todoTitleController.clear();
          todoDescriptionController.clear();
          todoDateController.clear();
        }
      }
    }
  }
}

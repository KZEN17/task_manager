import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:full_app/models/todo.dart';
import 'package:full_app/screens/categories_screen.dart';
import 'package:full_app/screens/todo_screen.dart';
import 'package:full_app/services/todo_service.dart';
import 'package:google_fonts/google_fonts.dart';

class TasksPage extends StatefulWidget {
  @override
  _TasksPageState createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> {
  final Color primaryColor = Color(0xff18203d);
  final Color secondaryColor = Color(0xff232c51);
  final Color logoGreen = Color(0xff25bcbb);
  int _page = 0;
  GlobalKey _bottomNavigationKey = GlobalKey();
  TodoService _todoService;
  List<Todo> _todoList = List<Todo>();
  final GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();

  @override
  initState() {
    super.initState();
    getAllTodos();
  }

  getAllTodos() async {
    _todoService = TodoService();
    _todoList = List<Todo>();

    var todos = await _todoService.readTodos();

    todos.forEach((todo) {
      setState(() {
        var model = Todo();
        model.id = todo['id'];
        model.title = todo['title'];
        model.description = todo['description'];
        model.category = todo['category'];
        model.todoDate = todo['todoDate'];
        model.isFinished = todo['isFinished'];
        _todoList.add(model);
      });
    });
  }

  _deleteFormDialog(BuildContext context, todoId) {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (param) {
          return AlertDialog(
            actions: <Widget>[
              FlatButton(
                color: logoGreen,
                onPressed: () => Navigator.of(context).pop(context),
                child: Text(
                  'Cancel',
                  style: GoogleFonts.openSans(color: Colors.white),
                ),
              ),
              FlatButton(
                  color: secondaryColor,
                  onPressed: () async {
                    var result = await _todoService.deleteTodo(todoId);
                    if (result > 0) {
                      Navigator.pop(context);
                      getAllTodos();
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => TasksPage()));
//                      _showSuccessSnackBar(Text(
//                        "Completed",
//                        style: TextStyle(
//                            backgroundColor: logoGreen, color: Colors.white),
//                      ));

                    }
                    print(result);
                  },
                  child: Text(
                    'Delete',
                    style: GoogleFonts.openSans(color: Colors.white),
                  ))
            ],
            title: Text(
              'Great Job!',
              style: GoogleFonts.openSans(color: primaryColor),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(
          FontAwesomeIcons.tasks,
          color: logoGreen,
        ),
        backgroundColor: primaryColor,
        elevation: 0.0,
//        centerTitle: true,
        title: Padding(
          padding: const EdgeInsets.only(top: 20.0, bottom: 10.0),
          child: Text(
            'My Tasks',
            style: GoogleFonts.openSans(
                fontSize: 35.0,
                color: Colors.white,
                fontWeight: FontWeight.w100,
                fontStyle: FontStyle.italic),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      backgroundColor: primaryColor,
      bottomNavigationBar: BottomNavigationBar(
        selectedIconTheme: IconThemeData(color: logoGreen),
        unselectedIconTheme: IconThemeData(color: logoGreen),
        backgroundColor: secondaryColor,
        items: [
          BottomNavigationBarItem(
              icon: GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => CategoriesScreen()));
                  },
                  child: Icon(Icons.category)),
              title: Text(
                'Categories',
                style: TextStyle(color: Colors.white),
              )),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.no_sim,
                color: Colors.grey[800],
              ),
              title: Text('')),
          BottomNavigationBarItem(
              icon: GestureDetector(
                  onTap: () {},
                  child: Icon(
                    Icons.list,
                    color: secondaryColor,
                    size: 30.0,
                  )),
              title: Text(
                '',
                style: TextStyle(fontSize: 0.1),
              )),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 10.0),
        child: ListView.builder(
            itemCount: _todoList.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(3.0),
                child: Card(
                  color: secondaryColor,
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  child: InkWell(
                    onTap: () {
                      _deleteFormDialog(context, _todoList[index].id);
                    },
                    child: ListTile(
                      title: Row(
                        children: <Widget>[
                          Text(
                            _todoList[index].title ?? 'No Title',
                            style: TextStyle(color: Colors.white),
                          )
                        ],
                      ),
                      subtitle: Text(
                        _todoList[index].category ?? 'No Category',
                        style: TextStyle(color: Colors.white54),
                      ),
                      trailing: Text(
                          _todoList[index].todoDate ?? 'No Todo Date',
                          style: TextStyle(color: Colors.white38)),
                    ),
                  ),
                ),
              );
            }),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: logoGreen,
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => TodoScreen()));
        },
        child: Icon(
          Icons.add,
          color: secondaryColor,
          size: 40.0,
        ),
      ),
    );
  }

//  _showSuccessSnackBar(message) {
//    var _snackBar = SnackBar(
//      content: message,
//      backgroundColor: Colors.green,
//    );
//    _globalKey.currentState.showSnackBar(_snackBar);
//  }
}

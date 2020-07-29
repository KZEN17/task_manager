import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:full_app/models/category.dart';
import 'package:full_app/screens/tasks.dart';
import 'package:full_app/screens/todo_screen.dart';
import 'package:full_app/services/category_service.dart';
import 'package:google_fonts/google_fonts.dart';

class CategoriesScreen extends StatefulWidget {
  @override
  _CategoriesScreenState createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  var _categoryNameController = TextEditingController();
  var _categoryDescriptionController = TextEditingController();

  var _category = Category();
  var _categoryService = CategoryService();
  var _editCategoryNameController = TextEditingController();
  var _editCategoryDescriptionController = TextEditingController();
  var category;
  Color primaryColor = Color(0xff18203d);
  Color secondaryColor = Color(0xff232c51);
  Color logoGreen = Color(0xff25bcbb);
  List<Category> _categoryList = List<Category>();

  @override
  void initState() {
    super.initState();
    getAllCategories();
  }

  final GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();

  getAllCategories() async {
    _categoryList = List<Category>();
    var categories = await _categoryService.readCategories();
    categories.forEach((category) {
      setState(() {
        var categoryModel = Category();
        categoryModel.name = category['name'];
        categoryModel.description = category['description'];
        categoryModel.id = category['id'];
        _categoryList.add(categoryModel);
      });
    });
  }

  _editCategory(BuildContext context, categoryId) async {
    category = await _categoryService.readCategoryById(categoryId);
    setState(() {
      _editCategoryNameController.text = category[0]['name'] ?? 'No Name';
      _editCategoryDescriptionController.text =
          category[0]['description'] ?? 'No Description';
    });
    _editFormDialog(context);
  }

  _showFormDialog(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (param) {
          return AlertDialog(
            actions: <Widget>[
              FlatButton(
                color: secondaryColor,
                onPressed: () => Navigator.of(context).pop(context),
                child: Text(
                  'Cancel',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              FlatButton(
                  color: logoGreen,
                  onPressed: () async {
                    _category.name = _categoryNameController.text;
                    _category.description = _categoryDescriptionController.text;

                    var result = await _categoryService.saveCategory(_category);
                    Navigator.pop(context);
                    getAllCategories();
                  },
                  child: Text(
                    'Save',
                    style: TextStyle(color: Colors.white),
                  ))
            ],
            title: Text(
              'Add Category',
              style: TextStyle(color: primaryColor),
            ),
            content: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  TextField(
                    controller: _categoryNameController,
                    decoration: InputDecoration(
                      hintText: 'Enter category',
                      hintStyle: TextStyle(color: logoGreen),
                      labelText: 'Category',
                      labelStyle: TextStyle(color: primaryColor),
                    ),
                  ),
                  TextField(
                    controller: _categoryDescriptionController,
                    decoration: InputDecoration(
                      hintText: 'Enter description',
                      hintStyle: TextStyle(color: logoGreen),
                      labelText: 'Description',
                      labelStyle: TextStyle(color: primaryColor),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  _editFormDialog(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (param) {
          return AlertDialog(
            actions: <Widget>[
              FlatButton(
                color: Colors.orange,
                onPressed: () => Navigator.of(context).pop(context),
                child: Text(
                  'Cancel',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              FlatButton(
                  color: Colors.orange,
                  onPressed: () async {
                    _category.id = category[0]['id'];
                    _category.name = _editCategoryNameController.text;
                    _category.description =
                        _editCategoryDescriptionController.text;
                    var result =
                        await _categoryService.updateCategory(_category);
                    if (result > 0) {
                      Navigator.pop(context);
                      getAllCategories();
                      _showSuccessSnackBar(Text(
                        "Updated",
                        style: TextStyle(
                            backgroundColor: Colors.green, color: Colors.white),
                      ));
                    }
                    print(result);
                  },
                  child: Text(
                    'Update',
                    style: TextStyle(color: Colors.white),
                  ))
            ],
            title: Text('Edit Category'),
            content: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  TextField(
                    controller: _editCategoryNameController,
                    decoration: InputDecoration(
                        hintText: 'Enter category', labelText: 'Category'),
                  ),
                  TextField(
                    controller: _editCategoryDescriptionController,
                    decoration: InputDecoration(
                        hintText: 'Enter description',
                        labelText: 'Description'),
                  ),
                ],
              ),
            ),
          );
        });
  }

  _deleteFormDialog(BuildContext context, categoryId) {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (param) {
          return AlertDialog(
            actions: <Widget>[
              FlatButton(
                color: Colors.green,
                onPressed: () => Navigator.of(context).pop(context),
                child: Text(
                  'Cancel',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              FlatButton(
                  color: Colors.red,
                  onPressed: () async {
                    var result =
                        await _categoryService.deleteCategory(categoryId);
                    if (result > 0) {
                      Navigator.pop(context);
                      getAllCategories();
                      Navigator.of(context).push(MaterialPageRoute(builder: (context)=>CategoriesScreen()));
                    }
                    print(result);
                  },
                  child: Text(
                    'Delete',
                    style: TextStyle(color: Colors.white),
                  ))
            ],
            title: Text('Are you sure you want to delete this category?'),
          );
        });
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
      appBar: AppBar(
        leading: Icon(
          Icons.category,
          color: logoGreen,
        ),
        backgroundColor: primaryColor,
        elevation: 0.0,
//        centerTitle: true,
        title: Padding(
          padding: const EdgeInsets.only(top: 20.0, bottom: 20.0),
          child: Text(
            'Categories',
            textAlign: TextAlign.center,
            style: GoogleFonts.openSans(
                color: Colors.white54,
                fontSize: 35,
                fontWeight: FontWeight.w300,
                fontStyle: FontStyle.italic),
          ),
        ),
      ),
      backgroundColor: primaryColor,
      body: ListView.builder(
          itemCount: _categoryList.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0)),
                color: secondaryColor,
                elevation: 5.0,
                child: ListTile(
                  leading: IconButton(
                      icon: Icon(
                        Icons.edit,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        _editCategory(context, _categoryList[index].id);
                      }),
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        _categoryList[index].name,
                        style: TextStyle(color: Colors.white),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.delete,
                          color: Colors.red,
                        ),
                        onPressed: () {
                          _deleteFormDialog(context, _categoryList[index].id);
                        },
                      )
                    ],
                  ),
                  subtitle: Text(
                    _categoryList[index].description,
                    style: TextStyle(color: Colors.white54),
                  ),
                ),
              ),
            );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showFormDialog(context);
        },
        child: Icon(
          Icons.add,
          size: 40.0,
          color: primaryColor,
        ),
        backgroundColor: logoGreen,
        splashColor: Colors.white,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
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
                    color: logoGreen,
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
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => TodoScreen()));
                  },
                  child: Icon(
                    Icons.description,
                    color: logoGreen,
                  )),
              title: Text(
                '',
                style: TextStyle(fontSize: 0.1),
              )),
        ],
      ),
    );
  }
}

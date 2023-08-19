import 'package:flutter/material.dart';
import 'package:sqlite_notes_app/database_handler.dart';
import 'package:sqlite_notes_app/notes.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DBHelper? dbHelper;
  late Future<List<NotesModel>> notesList;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dbHelper = DBHelper();
    loadData();
  }

  loadData() async {
    notesList = dbHelper!.getNotesList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Notes App SQLite, NUll safety',
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          FutureBuilder(
              future: notesList,
              builder: (context, AsyncSnapshot<List<NotesModel>> snapshot) {
                return ListView.builder(
                    itemCount: snapshot.data?.length,
                    itemBuilder: (context, index) {
                      return Card(
                        child: ListTile(
                          contentPadding: EdgeInsets.all(0),
                          title: Text(
                            snapshot.data![index].title.toString(),
                          ),
                        ),
                      );
                    });
              })
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          dbHelper
              ?.insert(
            NotesModel(
                id: 1,
                title: 'SQLite Notes App',
                description: 'Safa Anwar, software engineering student',
                age: 22,
                email: 'safaanwar@gmail.com'),
          )
              .then((value) {
            print('data added');
          }).onError((error, stackTrace) {
            print(error.toString());
          });
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

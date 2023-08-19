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
          Expanded(
            child: FutureBuilder(
                future: notesList,
                builder: (context, AsyncSnapshot<List<NotesModel>> snapshot) {
                  if(snapshot!.hasData){
                    return ListView.builder(
                        reverse: true,
                        shrinkWrap: true,
                        itemCount: snapshot.data?.length,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: (){
                              dbHelper?.update(NotesModel(
                                  id: snapshot.data![index].id,
                                  title: 'First flutter node',
                                  description: 'Flutter developer',
                                  age: 11,
                                  email: 'safa@gmail.com')
                              );
                              setState(() {
                                notesList=dbHelper!.getNotesList();
                              });
                            },
                            child: Dismissible(
                              direction: DismissDirection.endToStart,
                              background: Container(
                                color: Colors.red,
                                child: Icon(Icons.delete_forever),
                              ),
                              onDismissed: (DismissDirection direction){
                                setState(() {
                                  dbHelper?.delete(snapshot.data![index].id!);
                                  notesList=dbHelper!.getNotesList();
                                  snapshot.data!.remove(snapshot.data![index]);

                                });
                              },
                              key: ValueKey<int>(snapshot.data![index].id!),
                              child: Card(
                                child: ListTile(
                                  contentPadding: EdgeInsets.all(0),
                                  title: Text(
                                    snapshot.data![index].title.toString(),
                                  ),
                                  subtitle: Text(
                                    snapshot.data![index].description.toString(),

                                  ),
                                  trailing: Text(
                                    snapshot.data![index].age.toString(),

                                  ),
                                ),
                              ),
                            ),
                          );
                        });
                  }
                  else{
                    return CircularProgressIndicator();
                  }

                }),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          dbHelper
              ?.insert(
            NotesModel(
                id: 1,
                title: 'Second Notes',
                description: 'Safa Anwar, software engineering student',
                age: 22,
                email: 'safaanwar@gmail.com'),
          )
              .then((value) {
            print('data added');
            setState(() {
              notesList=dbHelper!.getNotesList();
            });
          }).onError((error, stackTrace) {
            print(error.toString());
          });
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

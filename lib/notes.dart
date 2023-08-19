//here we are creating Models

class NotesModel {
  late final int id;
  late final String title;
  late final int age;
  late final String description;
  late final String email;
  NotesModel(
      {required this.id,
      required this.title,
      required this.description,
      required this.age,
      required this.email});
  //creating hashmap
  NotesModel.fromMap(Map<String, dynamic> res)
      : id = res['id'],
        title = res['title'],
        description = res['description'],
        age = res['age'],
        email = res['email'];
  //creating another hashmap
  Map<String, Object> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'age': age,
      'email': email,
    };
  }
}

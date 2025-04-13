
// Create a model

class UserModel{
  // declare variables

  final String title;
  final String description;

  // constructor

 UserModel({required this.title,required this.description,});

 // convert into map

 Map<String,dynamic> toMap(){
   return {
     'title' : title,
     'description' : description,
   };

 }

 // convert from map

 factory UserModel.fromMap(Map<String,dynamic> map){
   return UserModel(
       title: map['title'],
       description: map['description']);
 }


} // end of class

// main function
void main(){
  var userModel = UserModel(title: 'Yaseen Malik', description: 'This is me Yaseen Malik');

  final result = userModel.toMap();

  print(result);

}








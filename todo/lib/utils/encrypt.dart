import 'package:bcrypt/bcrypt.dart';


class Encryptiondecryption{
  static final hashpass = BCrypt.hashpw("123456789", BCrypt.gensalt());
  
}
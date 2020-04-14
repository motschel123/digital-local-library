import 'package:digital_local_library/data/message.dart';
import 'package:scoped_model/scoped_model.dart';

class MessagesModel extends Model{
  List<Message> _messages = <Message>[];
  List<Message> get messages => _messages;

  MessagesModel() {
    
  }
}
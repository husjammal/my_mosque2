import 'package:mymosque/constant/message.dart';

validInput(String val, int min, int max) {
  if (val.length > max) {
    return ("$messageinputMax $max");
  }
  if (val.isEmpty) {
    return ("$messageinputEmpty");
  }
  if (val.length < min) {
    return ("$messageinputMin $min");
  }
}

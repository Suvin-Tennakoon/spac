import 'package:spac/screens/suvin/AddItem.dart';

dynamic formValidator(AllFieldsFormBloc formBloc) {
  if (formBloc.subject.value == "") {
    print("null subject");
    return formBloc.subject;
  }
}

import 'package:flutter_test/flutter_test.dart';
import 'package:time_tracker_flutter_course/app/sign_in/email_sign_in_bloc.dart';
import 'package:time_tracker_flutter_course/app/sign_in/email_sign_in_change_model.dart';
import 'package:time_tracker_flutter_course/app/sign_in/email_sign_in_model.dart';
import 'mocks.dart';

void main(){
  MockAuth mockAuth;
  EmailSignInBloc bloc;

  setUp((){
    mockAuth = MockAuth();
    bloc = EmailSignInBloc(auth: mockAuth);
  });
  
  tearDown((){
    bloc.dispose();
  });

  test('When email is updated'
      'AND password is updated'
      'AND submit is called'
      'THEN modelstream emits the correct event', (){
    expect(bloc.modelStream, emits(EmailSignInModel()));

  });
}
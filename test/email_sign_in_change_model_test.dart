import 'package:flutter_test/flutter_test.dart';
import 'package:time_tracker_flutter_course/app/sign_in/email_sign_in_change_model.dart';
import 'mocks.dart';

void main(){
  MockAuth mockAuth;
  EmailSignInChangeModel model;
  
  setUp((){
    
    mockAuth = MockAuth();
    model = EmailSignInChangeModel(auth: mockAuth);
  });

  test('update email', (){
  var didNotifyListeners = false;
  model.addListener(() => didNotifyListeners = true);
 const sample = 'email@test.com';
 model.updateEmail(sample);

 expect(model.email, sample);
 expect(didNotifyListeners, true);
  });
}
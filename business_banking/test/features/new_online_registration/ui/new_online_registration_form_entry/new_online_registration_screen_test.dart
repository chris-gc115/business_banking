// @dart = 2.9
import 'package:business_banking/features/deposit_check/model/enums.dart';
import 'package:business_banking/features/new_online_registration_form/model/new_online_registration_form_entry/new_online_registration_view_model.dart';
import 'package:business_banking/features/new_online_registration_form/ui/new_online_registration_form_entry/new_online_registration_actions.dart';
import 'package:business_banking/features/new_online_registration_form/ui/new_online_registration_form_entry/new_online_registration_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockOnlineRegistrationPresenterActions extends Mock
    implements NewOnlineRegistrationRequestActions {}

void main() {
  MaterialApp testWidgetSucceed;
  MaterialApp testWidgetFailed;
  MaterialApp testWidgetFailedWithSomeErrors;
  NewOnlineRegistrationViewModel onlineRegistrationViewModelSucceed;
  NewOnlineRegistrationViewModel onlineRegistrationViewModelFailed;
  NewOnlineRegistrationViewModel
      onlineRegistrationViewModelFailedWithSomeValidationErrors;
  MockOnlineRegistrationPresenterActions mockOnlineRegistrationPresenterAction;

  setUp(() {
    onlineRegistrationViewModelSucceed = NewOnlineRegistrationViewModel(
        cardHolderName: 'Tyler',
        cardNumber: '378282246310005',
        email: 'test@test.com',
        userPassword: 'TestPassword@123',
        cardHolderNameStatus: '',
        cardNumberStatus: '',
        userEmailStatus: '',
        userPasswordStatus: '',
        serviceResponseStatus: ServiceResponseStatus.succeed);

    onlineRegistrationViewModelFailed = NewOnlineRegistrationViewModel(
        cardHolderName: '',
        cardNumber: 'test',
        email: 'test',
        userPassword: 'Test',
        cardHolderNameStatus: 'Please, provide a valid name.',
        cardNumberStatus: 'Enter valid credit card number.',
        userEmailStatus: 'Please, provide a valid email.',
        userPasswordStatus:
            'Password should be minimum eight characters, at least one uppercase letter, one lowercase letter and one number.',
        serviceResponseStatus: ServiceResponseStatus.failed);

    onlineRegistrationViewModelFailedWithSomeValidationErrors =
        NewOnlineRegistrationViewModel(
            cardHolderName: 'Tyler',
            cardNumber: 'test',
            email: 'test@test.com',
            userPassword: 'TestPassword',
            cardHolderNameStatus: '',
            cardNumberStatus: 'Enter valid credit card number.',
            userEmailStatus: '',
            userPasswordStatus:
                'Password should be minimum eight characters, at least one uppercase letter, one lowercase letter and one number.',
            serviceResponseStatus: ServiceResponseStatus.failed);

    mockOnlineRegistrationPresenterAction =
        MockOnlineRegistrationPresenterActions();

    testWidgetSucceed = MaterialApp(
      home: NewOnlineRegistrationScreen(
          viewModel: onlineRegistrationViewModelSucceed,
          actions: mockOnlineRegistrationPresenterAction),
    );

    testWidgetFailed = MaterialApp(
      home: NewOnlineRegistrationScreen(
          viewModel: onlineRegistrationViewModelFailed,
          actions: mockOnlineRegistrationPresenterAction),
    );

    testWidgetFailedWithSomeErrors = MaterialApp(
      home: NewOnlineRegistrationScreen(
          viewModel: onlineRegistrationViewModelFailedWithSomeValidationErrors,
          actions: mockOnlineRegistrationPresenterAction),
    );
  });

  Future<void> pumpCreateAccountButton(
      WidgetTester tester, MaterialApp testWidget) async {
    await tester.pumpWidget(testWidget);
    await tester.pumpAndSettle();
    var widget = find.text('Create Account');
    expect(widget, findsOneWidget);
    await tester.tap(widget);
    await tester.pumpAndSettle();
  }

  void verifyParentActions() {
    verify(mockOnlineRegistrationPresenterAction.onUpdateNameParam(any))
        .called(1);
    verify(mockOnlineRegistrationPresenterAction.onUpdateNumberParam(any))
        .called(1);
    verify(mockOnlineRegistrationPresenterAction.onUpdateEmailAddress(any))
        .called(1);
    verify(mockOnlineRegistrationPresenterAction.onUpdatePassword(any))
        .called(1);
    verify(mockOnlineRegistrationPresenterAction.pressCreateButton(
            any, any, any, any, any))
        .called(1);
  }

  tearDown(() {
    onlineRegistrationViewModelSucceed = null;
    onlineRegistrationViewModelFailed = null;
    mockOnlineRegistrationPresenterAction = null;
  });
  group('Online Registration screen', () {
    testWidgets('should shows the Registration screen with static details',
        (tester) async {
      await tester.pumpWidget(testWidgetSucceed);
      await tester.pump(Duration(milliseconds: 500));
      final widgetType = find.byType(NewOnlineRegistrationScreen);
      expect(widgetType, findsOneWidget);
      expect(find.text('Card Holder Name'), findsOneWidget);
      expect(find.text('Credit Card Number'), findsOneWidget);
      expect(find.text('Email for login'), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);
    });

    testWidgets(
        'should call registration form presenter actions on tap of Create Account button',
        (tester) async {
      await pumpCreateAccountButton(tester, testWidgetSucceed);
      verifyParentActions();
    });

    testWidgets('when user enter value It should be findable', (tester) async {
      await tester.pumpWidget(testWidgetSucceed);
      var cardHolderNameWidget =
          find.byKey(const Key('cardHolderName-TxtField'));
      expect(cardHolderNameWidget, findsOneWidget);
      await tester.enterText(cardHolderNameWidget, 'Tyler');

      var cardHolderNumberWidget =
          find.byKey(const Key('cardHolderNumber-TxtField'));
      expect(cardHolderNumberWidget, findsOneWidget);
      await tester.enterText(cardHolderNumberWidget, '378282246310005');

      var userEmailAddressWidget =
          find.byKey(const Key('userEmailAddress-TxtField'));
      expect(userEmailAddressWidget, findsOneWidget);
      await tester.enterText(userEmailAddressWidget, 'test@test.com');

      var userPasswordWidget = find.byKey(const Key('userPassword-TxtField'));
      expect(userPasswordWidget, findsOneWidget);
      await tester.enterText(userPasswordWidget, 'TestPassword@123');

      await pumpCreateAccountButton(tester, testWidgetSucceed);
      expect(find.text('Tyler'), findsOneWidget);
      expect(find.text('378282246310005'), findsOneWidget);
      expect(find.text('test@test.com'), findsOneWidget);
      expect(find.text('TestPassword@123'), findsOneWidget);
    });

    testWidgets('should show errors on view model with status error',
        (tester) async {
      await pumpCreateAccountButton(tester, testWidgetFailed);
      verifyParentActions();
      expect(find.text('Please, provide a valid name.'), findsOneWidget);
      expect(find.text('Enter valid credit card number.'), findsOneWidget);
      expect(find.text('Please, provide a valid email.'), findsOneWidget);
      expect(
          find.text(
              'Password should be minimum eight characters, at least one uppercase letter, one lowercase letter and one number.'),
          findsOneWidget);
    });

    testWidgets('should show some errors on view model with status error',
        (tester) async {
      await pumpCreateAccountButton(tester, testWidgetFailedWithSomeErrors);
      verifyParentActions();
      expect(find.text('Tyler'), findsOneWidget);
      expect(find.text('Enter valid credit card number.'), findsOneWidget);
      expect(find.text('test@test.com'), findsOneWidget);
      expect(
          find.text(
              'Password should be minimum eight characters, at least one uppercase letter, one lowercase letter and one number.'),
          findsOneWidget);
    });
  });
}
import 'package:business_banking/features/side_cash_enrollment/bloc/side_cash_enrollment_bloc.dart';
import 'package:business_banking/features/side_cash_enrollment/model/enrollment_form_view_model.dart';
import 'package:business_banking/features/side_cash_enrollment/ui/side_cash_enrollment_completion_feature_widget.dart';
import 'package:business_banking/features/side_cash_enrollment/ui/side_cash_enrollment_form_screen.dart';
import 'package:clean_framework/clean_framework.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';

class SideCashEnrollmentFormPresenter extends Presenter<SideCashEnrollmentBloc,
    EnrollmentFormViewModel, SideCashEnrollmentFormScreen> {
  final Function(String) testUpdatedSelectedAccount;

  SideCashEnrollmentFormPresenter({this.testUpdatedSelectedAccount});

  @override
  SideCashEnrollmentFormScreen buildScreen(BuildContext context,
      SideCashEnrollmentBloc bloc, EnrollmentFormViewModel viewModel) {
    print("build screen in form called");
    return SideCashEnrollmentFormScreen(
      formViewModel: viewModel,
      updateSelectedAccount: (String account) =>
          testUpdatedSelectedAccount ?? _updateSelectedAccount(account, bloc),
      submitForm: (ctx) => _submitFormAndNavigate(ctx, viewModel),
    );
  }

  @override
  Widget buildLoadingScreen(BuildContext context) {
    return Scaffold(body: Center(child: CircularProgressIndicator()));
  }

  @override
  Stream<EnrollmentFormViewModel> getViewModelStream(
      SideCashEnrollmentBloc bloc) {
    return bloc.enrollmentFormPipe.receive;
  }

  _updateSelectedAccount(String accountString, SideCashEnrollmentBloc bloc) {
    bloc.updateFormWithSelectedAccountEventPipe.send(accountString);
  }

  _submitFormAndNavigate(
      BuildContext context, EnrollmentFormViewModel viewModel) {
    if (viewModel.selectedAccount == null) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("Error"),
              content: Text("Please select an account"),
              actions: [
                FlatButton(
                  child: Text("Okay"),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                )
              ],
            );
          });
      return;
    }
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (ctx) => SideCashEnrollmentCompletionFeatureWidget(),
      ),
      (route) => false,
    );
  }
}
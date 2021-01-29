import 'package:business_banking/features/side_cash_enrollment/bloc/side_cash_enrollment_bloc.dart';
import 'package:business_banking/features/side_cash_enrollment/ui/side_cash_enrollment_advertisement/side_cash_enrollment_advertisement_presenter.dart';
import 'package:clean_framework/clean_framework.dart';
import 'package:flutter/material.dart';


class SideCashEnrollmentAdvertisementFeatureWidget extends StatelessWidget {
  @override
  Widget build(BuildContext build) {
    return BlocProvider<SideCashEnrollmentBloc>(
      create: (_) => SideCashEnrollmentBloc(),
      child: SideCashEnrollmentAdvertisementPresenter(),
    );
  }
}

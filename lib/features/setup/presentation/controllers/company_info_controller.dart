import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fz_hooks/fz_hooks.dart';

final companyInfoControllerProvider =
    StateNotifierProvider<CompanyInfoController, AsyncValue>((ref) {
  return CompanyInfoController();
});

class CompanyInfoController extends StateNotifier<AsyncValue> {
  final companiesDB = "FZ_COMPANIES";

  CompanyInfoController() : super(const AsyncValue.data(null));

  Future<bool> updateCompanyInfo(CompanyModel company) async {
    try {
      state = const AsyncValue.loading();
      await Future.delayed(const Duration(seconds: 1));
      final ref =
          FirebaseFirestore.instance.collection(companiesDB).doc(company.id);
      await ref.set(company.toMap());
      state = const AsyncValue.data(null);
      return true;
    } catch (e, stk) {
      state = AsyncValue.error(e, stk);
      return false;
    }
  }
}

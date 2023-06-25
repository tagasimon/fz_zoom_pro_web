import 'package:field_zoom_pro_web/features/customers/providers/customer_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GetCustomerWidget extends ConsumerWidget {
  final String customerId;
  const GetCustomerWidget({super.key, required this.customerId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userProv = ref.watch(customerByIdProvider(customerId));
    return userProv.when(
      data: (customer) => Text("${customer.name} - ${customer.businessName}"),
      loading: () => const CircularProgressIndicator(),
      error: (error, stackTrace) => const Text('Error'),
    );
  }
}

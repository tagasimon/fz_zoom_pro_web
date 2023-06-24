import 'package:field_zoom_pro_web/core/notifiers/session_notifier.dart';
import 'package:field_zoom_pro_web/features/users/presentation/controllers/users_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fz_hooks/fz_hooks.dart';

import 'package:field_zoom_pro_web/core/providers/regions_provider.dart';

class NewUserScreen extends ConsumerStatefulWidget {
  const NewUserScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<NewUserScreen> createState() => _NewUserScreenState();
}

class _NewUserScreenState extends ConsumerState<NewUserScreen> {
  String _name = "";
  String _email = "";
  String _phoneNumber = "";
  RegionModel? selectedRegion;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final admin = ref.watch(sessionNotifierProvider).loggedInUser!;
    final regionsProv = ref.watch(companyRegionsProv);
    final usersControllerState = ref.watch(usersControllerProvider);
    ref.listen<AsyncValue>(usersControllerProvider,
        (_, state) => state.showSnackBarOnError(context));
    return CallbackShortcuts(
      bindings: <ShortcutActivator, VoidCallback>{
        const SingleActivator(LogicalKeyboardKey.escape): () =>
            context.pop(false),
      },
      child: Focus(
        autofocus: true,
        child: Scaffold(
          appBar: AppBar(title: const Text("REGISTER USER"), centerTitle: true),
          body: regionsProv.when(
            data: (data) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: MediaQuery.sizeOf(context).width * 0.5,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: Form(
                              key: _formKey,
                              child: Column(
                                children: [
                                  const SizedBox(height: 10),
                                  DropdownButton<RegionModel>(
                                    hint: const Text("Select Region"),
                                    isExpanded: true,
                                    value: selectedRegion,
                                    items: data
                                        .map((e) => DropdownMenuItem(
                                            value: e, child: Text(e.name)))
                                        .toList(),
                                    onChanged: (value) {
                                      setState(() => selectedRegion = value!);
                                    },
                                  ),
                                  const SizedBox(height: 10.0),
                                  TextFormField(
                                    textInputAction: TextInputAction.next,
                                    decoration: const InputDecoration(
                                        border: OutlineInputBorder(),
                                        labelText: "Names"),
                                    onChanged: (String val) => _name = val,
                                    validator: (String? val) {
                                      if (val == null || val.isEmpty) {
                                        return 'Name Missing';
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 10.0),
                                  TextFormField(
                                    textInputAction: TextInputAction.next,
                                    decoration: InputDecoration(
                                      border: const OutlineInputBorder(),
                                      labelText:
                                          "User Email @${admin.email.split("@")[1]}",
                                    ),
                                    onChanged: (String val) => _email = val,
                                    keyboardType: TextInputType.emailAddress,
                                    validator: (String? val) {
                                      final domain = admin.email.split("@")[1];
                                      if (val == null || val.isEmpty) {
                                        return 'Email Address Missing';
                                      }
                                      if (val.split("@")[1] != domain) {
                                        return 'Email Address is not valid for this company @$domain';
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 10.0),
                                  TextFormField(
                                    textInputAction: TextInputAction.next,
                                    decoration: const InputDecoration(
                                        border: OutlineInputBorder(),
                                        labelText: "Phone Number"),
                                    onChanged: (String val) =>
                                        _phoneNumber = val,
                                    keyboardType: TextInputType.phone,
                                    validator: (String? val) {
                                      if (val == null || val.isEmpty) {
                                        return 'Phone Number Missing';
                                      } else if (val.length < 10) {
                                        return "Phone Number too Short!!";
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 20.0),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 30.0, vertical: 10.0),
                                        minimumSize: Size(
                                            MediaQuery.sizeOf(context).width *
                                                0.8,
                                            50)),
                                    onPressed: usersControllerState.isLoading
                                        ? null
                                        : () async {
                                            final nav = Navigator.of(context);

                                            if (selectedRegion == null) {
                                              context.showSnackBar(
                                                  'Please Select a Region');
                                              return;
                                            }
                                            if (_formKey.currentState!
                                                .validate()) {
                                              final user = UserModel(
                                                id: DateTime.now()
                                                    .microsecondsSinceEpoch
                                                    .toString(),
                                                role: "Sales Associate",
                                                name: _name,
                                                phoneNumber: _phoneNumber,
                                                email: _email,
                                                companyId: admin.companyId,
                                                regionId: selectedRegion!.id,
                                                level: 1,
                                                createdAt: DateTime.now(),
                                              );
                                              final uid = await ref
                                                  .read(usersControllerProvider
                                                      .notifier)
                                                  .createAssociateAccount(
                                                      email: user.email,
                                                      password: "password!@#");
                                              if (uid == null) {
                                                Fluttertoast.showToast(
                                                    msg: "Error!! Try Again");
                                                return;
                                              }
                                              final userUpdated =
                                                  user.copyWith(id: uid);
                                              final success = await ref
                                                  .read(usersControllerProvider
                                                      .notifier)
                                                  .registerAssociate(
                                                      user: userUpdated);
                                              if (success) {
                                                Fluttertoast.showToast(
                                                    msg:
                                                        "User Registered Successfully");
                                                nav.pop();
                                              }
                                            }
                                          },
                                    child: usersControllerState.isLoading
                                        ? const CircularProgressIndicator()
                                        : const Text(
                                            "REGISTER",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
            loading: () => const Center(
              child: CircularProgressIndicator(),
            ),
            error: (error, stackTrace) {
              return Center(child: Text('Error: $error'));
            },
          ),
        ),
      ),
    );
  }
}

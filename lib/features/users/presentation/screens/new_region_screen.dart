import 'package:field_zoom_pro_web/core/providers/filter_notifier_provider.dart';
import 'package:field_zoom_pro_web/features/users/presentation/controllers/regions_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fz_hooks/fz_hooks.dart';

class NewRegionScreen extends ConsumerStatefulWidget {
  const NewRegionScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<NewRegionScreen> createState() => _NewRegionScreenState();
}

class _NewRegionScreenState extends ConsumerState<NewRegionScreen> {
  // String _name = "";
  final _nameController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final admin = ref.watch(filterNotifierProvider).user!;
    final state = ref.watch(regionsControllerProvider);

    ref.listen<AsyncValue>(regionsControllerProvider,
        (_, state) => state.showSnackBarOnError(context));
    return CallbackShortcuts(
      bindings: <ShortcutActivator, VoidCallback>{
        const SingleActivator(LogicalKeyboardKey.escape): () =>
            context.pop(false),
      },
      child: Focus(
        autofocus: true,
        child: Scaffold(
          appBar: AppBar(title: const Text("NEW REGION"), centerTitle: true),
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.5,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            const SizedBox(height: 10),
                            const SizedBox(height: 10.0),
                            TextFormField(
                              autofocus: true,
                              textInputAction: TextInputAction.next,
                              controller: _nameController,
                              decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: "Region Name"),
                              // onChanged: (String val) => _name = val,
                              validator: (String? val) {
                                if (val == null || val.isEmpty) {
                                  return 'Region Name Missing';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 20.0),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 30.0, vertical: 10.0),
                                  minimumSize: Size(
                                      MediaQuery.of(context).size.width * 0.8,
                                      50)),
                              onPressed: state.isLoading
                                  ? null
                                  : () async {
                                      final nav = Navigator.of(context);
                                      if (_formKey.currentState!.validate()) {
                                        final region = RegionModel(
                                          id: DateTime.now()
                                              .microsecondsSinceEpoch
                                              .toString(),
                                          name: _nameController.text,
                                          companyId: admin.companyId,
                                          lastUpdated: DateTime.now(),
                                          date: DateTime.now(),
                                        );

                                        final success = await ref
                                            .read(regionsControllerProvider
                                                .notifier)
                                            .addNewRegion(regionModel: region);
                                        if (success) {
                                          Fluttertoast.showToast(
                                              msg: "SUCCESS :)");
                                          nav.pop();
                                        }
                                      }
                                    },
                              child: state.isLoading
                                  ? const CircularProgressIndicator()
                                  : const Text(
                                      "SAVE REGION",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:cached_network_image/cached_network_image.dart';
import 'package:field_zoom_pro_web/core/extensions/async_value_extensions.dart';
import 'package:field_zoom_pro_web/core/presentation/controllers/upload_image_controller.dart';
import 'package:field_zoom_pro_web/core/presentation/widgets/company_title_widget.dart';
import 'package:field_zoom_pro_web/features/authentication/providers/auth_provider.dart';
import 'package:field_zoom_pro_web/features/setup/presentation/controllers/company_info_controller.dart';
import 'package:field_zoom_pro_web/features/setup/repositories/company_info_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CompanyHomeScreen extends ConsumerStatefulWidget {
  const CompanyHomeScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<CompanyHomeScreen> createState() => _CompanyHomeScreenState();
}

class _CompanyHomeScreenState extends ConsumerState<CompanyHomeScreen> {
  final _formKey = GlobalKey<FormState>();

  final _companyNameController = TextEditingController();
  final _countryController = TextEditingController();
  final _companyIndustryController = TextEditingController();
  final _logoUrlController = TextEditingController();
  final _companyEmailController = TextEditingController();
  final _companyEmail2Controller = TextEditingController();
  final _companyPhoneController = TextEditingController();
  final _companyPhone2Controller = TextEditingController();
  final _companyAddressController = TextEditingController();
  final _companyCityController = TextEditingController();
  final _companyWebsiteController = TextEditingController();
  final _companyDescriptionController = TextEditingController();
  final _companyFacebookController = TextEditingController();
  final _companyTwitterController = TextEditingController();
  bool isUploading = false;

  @override
  void dispose() {
    _companyNameController.dispose();
    _countryController.dispose();
    _companyIndustryController.dispose();
    _logoUrlController.dispose();
    _companyEmailController.dispose();
    _companyEmail2Controller.dispose();
    _companyPhoneController.dispose();
    _companyPhone2Controller.dispose();
    _companyAddressController.dispose();
    _companyCityController.dispose();
    _companyWebsiteController.dispose();
    _companyDescriptionController.dispose();
    _companyFacebookController.dispose();
    _companyTwitterController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final companyInfoProv = ref.watch(companyInfoStreamProvider);
    final state = ref.watch(companyInfoControllerProvider);
    final state2 = ref.watch(uploadImageControllerProvider);
    ref.listen<AsyncValue>(companyInfoControllerProvider,
        (_, state) => state.showSnackBarOnError(context));
    ref.listen<AsyncValue>(uploadImageControllerProvider,
        (_, state) => state.showSnackBarOnError(context));
    return Scaffold(
      appBar: AppBar(
        title: const CompanyTitleWidget(),
      ),
      body: companyInfoProv.when(
        data: (company) {
          _companyNameController.text = company.companyName;
          _countryController.text = company.country;
          _companyIndustryController.text = company.industry;
          _logoUrlController.text = company.logoUrl;
          _companyEmailController.text = company.adminEmail;
          _companyEmail2Controller.text = company.adminEmail2;
          _companyPhoneController.text = company.phoneNumber;
          _companyPhone2Controller.text = company.phoneNumber2;
          _companyAddressController.text = company.address;
          _companyCityController.text = company.district;
          _companyWebsiteController.text = company.website;
          _companyFacebookController.text = company.facebookUrl;
          _companyTwitterController.text = company.twitterUrl;
          return Center(
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                      child: Form(
                    key: _formKey,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          const SizedBox(height: 10),
                          TextFormField(
                            enabled: false,
                            controller: _companyNameController,
                            decoration: const InputDecoration(
                              labelText: "Company Name",
                              hintText: "Company Name",
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter company name';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            enabled: false,
                            controller: _countryController,
                            decoration: const InputDecoration(
                              labelText: "Country",
                              hintText: "Country",
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter Country';
                              }
                              return null;
                            },
                          ),
                          TextFormField(
                            enabled: false,
                            controller: _companyIndustryController,
                            decoration: const InputDecoration(
                              labelText: "Industry",
                              hintText: "Industry",
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter Industry';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            enabled: false,
                            controller: _companyEmailController,
                            decoration: const InputDecoration(
                              labelText: "Admin Email",
                              hintText: "Admin Email",
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter Admin Email';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            controller: _companyPhoneController,
                            decoration: const InputDecoration(
                              labelText: "Phone Number",
                              hintText: "Phone Number",
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter Phone';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            controller: _companyPhone2Controller,
                            decoration: const InputDecoration(
                              labelText: "Phone Number 2",
                              hintText: "Phone Number 2",
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter Phone 2';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            controller: _companyEmail2Controller,
                            decoration: const InputDecoration(
                              labelText: "Admin Email 2",
                              hintText: "Admin Email 2",
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter Admin Email 2';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            controller: _companyAddressController,
                            decoration: const InputDecoration(
                              labelText: "Address",
                              hintText: "Address",
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter Address';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            controller: _companyCityController,
                            decoration: const InputDecoration(
                              labelText: "City",
                              hintText: "City",
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter Address';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            controller: _companyWebsiteController,
                            decoration: const InputDecoration(
                              labelText: "Website",
                              hintText: "Website",
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter Website';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            controller: _companyFacebookController,
                            decoration: const InputDecoration(
                              labelText: "Facebook",
                              hintText: "Facebook",
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter Facebook Url';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            controller: _companyTwitterController,
                            decoration: const InputDecoration(
                              labelText: "Twitter",
                              hintText: "Twitter",
                            ),
                          ),
                          const SizedBox(height: 10),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              minimumSize: Size(
                                  MediaQuery.of(context).size.width * 0.2, 50),
                            ),
                            onPressed: state.isLoading || state2.isLoading
                                ? null
                                : () async {
                                    if (_formKey.currentState!.validate()) {
                                      final updateComInfo = company.copyWith(
                                          country:
                                              _countryController.text.trim(),
                                          email2: _companyEmail2Controller.text
                                              .trim(),
                                          phoneNumber2: _companyPhone2Controller
                                              .text
                                              .trim(),
                                          address: _companyAddressController
                                              .text
                                              .trim(),
                                          district: _companyCityController.text
                                              .trim(),
                                          facebookUrl:
                                              _companyFacebookController.text
                                                  .trim(),
                                          twitterUrl: _companyTwitterController
                                              .text
                                              .trim(),
                                          lastUpdated: DateTime.now(),
                                          lastUpdatedBy: FirebaseAuth
                                              .instance.currentUser!.email);
                                      final success = await ref
                                          .read(companyInfoControllerProvider
                                              .notifier)
                                          .updateCompanyInfo(updateComInfo);
                                      if (success) {
                                        Fluttertoast.showToast(msg: "SUCCESS");
                                      }
                                    }
                                  },
                            child: state.isLoading || state2.isLoading
                                ? const CircularProgressIndicator()
                                : const Text("SAVE"),
                          ),
                        ],
                      ),
                    ),
                  )),
                  const VerticalDivider(),
                  Expanded(
                    child: Column(
                      children: [
                        const SizedBox(height: 10),
                        Stack(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.grey,
                                  width: 5,
                                ),
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(10),
                                ),
                              ),
                              child: CachedNetworkImage(
                                imageUrl: company.logoUrl,
                                height: 250,
                                width: 250,
                                fit: BoxFit.contain,
                                progressIndicatorBuilder:
                                    (context, url, downloadProgress) => Center(
                                  child: CircularProgressIndicator(
                                      value: downloadProgress.progress),
                                ),
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.error),
                              ),
                            ),
                            Positioned(
                              top: 0,
                              right: 0,
                              child: Container(
                                decoration: const BoxDecoration(
                                  color: Colors.teal,
                                  borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(10),
                                    bottomLeft: Radius.circular(10),
                                  ),
                                ),
                                child: IconButton(
                                  onPressed: state2.isLoading || state.isLoading
                                      ? null
                                      : () async {
                                          final String? downloadUrl = await ref
                                              .read(
                                                  uploadImageControllerProvider
                                                      .notifier)
                                              .getUserDownloadUrl(
                                                  "COMPANY_LOGOS");
                                          if (downloadUrl != null) {
                                            final success = await ref
                                                .read(
                                                    companyInfoControllerProvider
                                                        .notifier)
                                                .updateCompanyInfo(
                                                    company.copyWith(
                                                  logoUrl: downloadUrl,
                                                ));
                                            if (success) {
                                              Fluttertoast.showToast(
                                                  msg: "SUCCESS");
                                            }
                                          }
                                        },
                                  icon: state.isLoading || state2.isLoading
                                      ? const CircularProgressIndicator(
                                          color: Colors.white)
                                      : const Icon(Icons.edit),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        TextButton.icon(
                            style: TextButton.styleFrom(
                                foregroundColor: Colors.red),
                            onPressed: () {
                              ref.read(authRepositoryProvider).signOut();
                            },
                            icon: const Icon(Icons.logout),
                            label: const Text("Logout")),
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        },
        loading: () => const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        ),
        error: (error, stack) {
          debugPrint("Error: $error");
          return const Scaffold(
              body: Center(child: Text("Something went wrong")));
        },
      ),
    );
  }
}

// debugPrint("Error: $error");

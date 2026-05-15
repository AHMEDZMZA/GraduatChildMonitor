import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/managers/app_text_styles.dart';
import '../../../../core/managers/color_manager.dart';
import '../../../../core/router/app_routes.dart';
import '../../../auth/presentation/views/widget/custom_button.dart';
import '../../../auth/presentation/views/widget/custom_text_form_field.dart';
import '../bloc/test_cubit.dart';

class AddChildDataView extends StatefulWidget {
  const AddChildDataView({super.key});

  @override
  State<AddChildDataView> createState() => _AddChildDataViewState();
}

class _AddChildDataViewState extends State<AddChildDataView> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController birthDateController = TextEditingController();
  String? gender = AppStrings.female;
  final _formKey = GlobalKey<FormState>();

  // FIX: track whether the loading dialog is currently shown to avoid
  // double-pop or pop-when-nothing-is-open crashes
  bool _isDialogShowing = false;

  @override
  void dispose() {
    nameController.dispose();
    birthDateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        body: SafeArea(
          child: BlocListener<TestCubit, TestState>(
            listener: (context, state) {
              if (state is AddChildLoading) {
                _isDialogShowing = true;
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder:
                      (context) =>
                          const Center(child: CircularProgressIndicator()),
                );
              } else if (state is AddChildSuccess) {
                // FIX: only pop if the dialog is actually open
                if (_isDialogShowing) {
                  _isDialogShowing = false;
                  Navigator.pop(context);
                }
                Navigator.pushNamed(
                  context,
                  AppRoutes.selectTest,
                  arguments: state.child,
                );
              } else if (state is AddChildFailure) {
                if (_isDialogShowing) {
                  _isDialogShowing = false;
                  Navigator.pop(context);
                }
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 20,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: const CircleAvatar(
                          backgroundColor: ColorManager.buttonBlue,
                          radius: 20,
                          child: Icon(
                            Icons.arrow_back_ios_new,
                            size: 18,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      const SizedBox(height: 60),
                      const Text(
                        AppStrings.addChildTitle,
                        style: AppTextStyles.nunito32w900Black,
                      ),
                      const SizedBox(height: 60),
                      const Text(
                        AppStrings.childNameLabel,
                        style: AppTextStyles.nunito16w900Black,
                      ),
                      const SizedBox(height: 10),
                      CustomTextFormField(
                        isPassword: false,
                        hintText: AppStrings.childNameHint,
                        controller: nameController,
                        keyboardType: TextInputType.name,
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Birth Date',
                        style: AppTextStyles.nunito16w900Black,
                      ),
                      const SizedBox(height: 10),
                      // FIX: wrap in TextFormField with validator so the form
                      // cannot be submitted with an empty birth date
                      TextFormField(
                        controller: birthDateController,
                        readOnly: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select a birth date';
                          }
                          return null;
                        },
                        onTap: () async {
                          FocusScope.of(context).requestFocus(FocusNode());
                          final DateTime? picked = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime.now(),
                            initialEntryMode: DatePickerEntryMode.calendarOnly,
                          );
                          if (picked != null) {
                            birthDateController.text =
                                "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
                          }
                        },
                        decoration: InputDecoration(
                          hintText: 'Select birth date',
                          suffixIcon: const Icon(
                            Icons.calendar_today,
                            color: ColorManager.primaryBlue,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        AppStrings.genderLabel,
                        style: AppTextStyles.nunito16w900Black,
                      ),
                      const SizedBox(height: 10),
                      Column(
                        children: [
                          Row(
                            children: [
                              Radio<String>(
                                value: AppStrings.male,
                                groupValue: gender,
                                activeColor: ColorManager.primaryBlue,
                                onChanged: (value) {
                                  setState(() => gender = value);
                                },
                              ),
                              const Text(
                                AppStrings.maleDisplay,
                                style: TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Radio<String>(
                                value: AppStrings.female,
                                groupValue: gender,
                                activeColor: ColorManager.primaryBlue,
                                onChanged: (value) {
                                  setState(() => gender = value);
                                },
                              ),
                              const Text(
                                AppStrings.femaleDisplay,
                                style: TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 60),
                      CustomButton(
                        text: AppStrings.nextButton,
                        onTap: () {
                          if (_formKey.currentState!.validate()) {
                            context.read<TestCubit>().addChild(
                              name: nameController.text,
                              birthDate: birthDateController.text,
                              gender: gender!,
                              knowsCondition: false,
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

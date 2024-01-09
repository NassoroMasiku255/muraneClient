import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/components/custom_surfix_icon.dart';
import 'package:shop_app/components/form_error.dart';
import 'package:shop_app/models/User.dart';
import 'package:shop_app/provider/user.dart';
import 'package:shop_app/screens/forgot_password/forgot_password_screen.dart';
import 'package:shop_app/screens/home/home_screen.dart';
import 'package:http/http.dart' as http;
import '../../../components/default_button.dart';
import '../../../constants.dart';
import '../../../size_config.dart';

class SignForm extends StatefulWidget {
  @override
  _SignFormState createState() => _SignFormState();
}

class _SignFormState extends State<SignForm> {
  final _formKey = GlobalKey<FormState>();
  String? username;
  String? password;
  bool loading = false;
  bool? remember = false;
  final List<String?> errors = [];
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  void addError({String? error}) {
    if (!errors.contains(error))
      setState(() {
        errors.add(error);
      });
  }

  void removeError({String? error}) {
    if (errors.contains(error))
      setState(() {
        errors.remove(error);
      });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          buildEmailFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          buildPasswordFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          Row(
            children: [
              Checkbox(
                value: remember,
                activeColor: kPrimaryColor,
                onChanged: (value) {
                  setState(() {
                    remember = value;
                  });
                },
              ),
              Text("Remember me"),
              Spacer(),
              GestureDetector(
                onTap: () => Navigator.pushNamed(
                    context, ForgotPasswordScreen.routeName),
                child: Text(
                  "Forgot Password",
                  style: TextStyle(decoration: TextDecoration.underline),
                ),
              )
            ],
          ),
          FormError(errors: errors),
          SizedBox(height: getProportionateScreenHeight(20)),
          DefaultButton(
            text: loading?"Authenticating...":"Continue",
            press: customerLogin,
          ),
        ],
      ),
    );
  }

  TextFormField buildPasswordFormField() {
    return TextFormField(
      obscureText: true,
      controller: passwordController,
      onSaved: (newValue) => password = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kPassNullError);
        } 
        // else if (value.length >= 8) {
        //   removeError(error: kShortPassError);
        // }
        return null;
      },
      validator: (value) {
        if (value!.isEmpty) {
          addError(error: kPassNullError);
          return "";
        } 
        // else if (value.length < 8) {
        //   addError(error: kShortPassError);
        //   return "";
        // }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Password",
        hintText: "Enter your password",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Lock.svg"),
      ),
    );
  }

  TextFormField buildEmailFormField() {
    return TextFormField(
      keyboardType: TextInputType.text,
      controller: phoneController,
      onSaved: (newValue) => username = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kEmailNullError);
        } 
        return null;
      },
      validator: (value) {
        if (value!.isEmpty) {
          addError(error: kEmailNullError);
          return "";
        } 
        return null;
      },
      decoration: InputDecoration(
        labelText: "Phone/Email",
        hintText: "Enter your phone/email",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Mail.svg"),
      ),
    );
  }

  Future<void> customerLogin() async{
    setState(() {
      loading = true;
    });
    Uri apiUrl = Uri.parse("$base_url/login_customer");
    try {
      var response = await http.post(apiUrl,
          headers: {"Content-Type": "application/json"},
          body: jsonEncode({
            "username": phoneController.text,
            "password": passwordController.text,
          }));
      var res = jsonDecode(response.body);
      print(res["code"]);
      if (res["code"] == "200") {
        setState(() {
          loading = false;
        });
        // ignore: use_build_context_synchronously
        Provider.of<UserData>(context, listen: false).setUser(
          User(id: int.parse(res["id"]), phone: res["phone"], name: res["name"])
        );
        Navigator.pushReplacementNamed(context, HomeScreen.routeName);

      } else if (res["code"] == "201") {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Incorrect username or password'),
          backgroundColor: Colors.red,
        ));
        setState(() {
          loading = false;
        });
      } else {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('User not found'),
          backgroundColor: Colors.red,
        ));
        setState(() {
          loading = false;
        });
      }
    } catch (e) {
      print("error: $e");
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Error in catch"),
      ));
    }
  }
}

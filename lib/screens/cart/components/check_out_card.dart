import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/components/default_button.dart';
import 'package:shop_app/models/User.dart';
import 'package:shop_app/provider/cart.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/provider/user.dart';
import '../../../constants.dart';
import '../../../size_config.dart';

// class CheckoutCard extends StatelessWidget {
//   const CheckoutCard({
//     Key? key,
//   }) : super(key: key);

// }

class CheckoutCard extends StatefulWidget {
  const CheckoutCard({super.key});

  @override
  State<CheckoutCard> createState() => _CheckoutCardState();
}

class _CheckoutCardState extends State<CheckoutCard> {
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    List cartitems = Provider.of<Cart>(context, listen: true).cartItem;
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: getProportionateScreenWidth(15),
        horizontal: getProportionateScreenWidth(30),
      ),
      // height: 174,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            offset: Offset(0, -15),
            blurRadius: 20,
            color: Color(0xFFDADADA).withOpacity(0.15),
          )
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(10),
                  height: getProportionateScreenWidth(40),
                  width: getProportionateScreenWidth(40),
                  decoration: BoxDecoration(
                    color: Color(0xFFF5F6F9),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: SvgPicture.asset("assets/icons/receipt.svg"),
                ),
                Spacer(),
                Text("Add voucher code"),
                const SizedBox(width: 10),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 12,
                  color: kTextColor,
                )
              ],
            ),
            SizedBox(height: getProportionateScreenHeight(20)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text.rich(
                  TextSpan(
                    text: "Total:\n",
                    children: [
                      TextSpan(
                        text: "\Tzs${getTotalPrice(cartitems)}",
                        style: TextStyle(fontSize: 16, color: Colors.black),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: getProportionateScreenWidth(190),
                  child: DefaultButton(
                    text: "Check Out",
                    press: () => saveOrder(context),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  getTotalPrice(cartItems) {
    final total = cartItems.fold(
        0, (sum, item) => sum + (double.parse(item["price"]) * int.parse(item["quantity"])));
    return total.toString();
  }

  saveOrder(BuildContext context) {
    List cartitems = Provider.of<Cart>(context, listen: false).cartItem;
    User? user = Provider.of<UserData>(context, listen: false).user;
    print(cartitems);
    Uri apiUrl = Uri.parse("$base_url/save_order");
    try {
      setState(() {
        loading = true;
      });
      http
          .post(apiUrl,
              headers: {"Content-Type": "application/json"},
              body: jsonEncode({
                "custId": "${user!.id}",
                "cart": cartitems,
              }))
          .then((response) {
        var res = jsonDecode(response.body);
        if (res["code"] == 200) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(res["message"]),
            backgroundColor: Colors.green,
          ));
          Provider.of<Cart>(context, listen: false).clearCartItem();
          Provider.of<Cart>(context, listen: false).changeQuantiry(1);
          Navigator.pop(context);
          setState(() {
            loading = false;
          });
        } else if (res["code"] == "201") {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(res["message"]),
            backgroundColor: Colors.red,
          ));
          setState(() {
            loading = false;
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(res["message"]),
            backgroundColor: Colors.red,
          ));
          setState(() {
            loading = false;
          });
        }
      });
    } catch (e) {
      print("here is error : $e");
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Error occoured'),
        backgroundColor: Colors.red,
      ));
      setState(() {
        loading = false;
      });
    }
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/models/User.dart';
import 'package:shop_app/provider/cart.dart';
import 'package:shop_app/provider/user.dart';
import 'package:shop_app/screens/home/home_screen.dart';
import 'package:shop_app/screens/profile/profile_screen.dart';
import 'package:shop_app/screens/sign_in/sign_in_screen.dart';

import '../constants.dart';
import '../enums.dart';
import '../screens/cart/cart_screen.dart';

class CustomBottomNavBar extends StatelessWidget {
  const CustomBottomNavBar({
    Key? key,
    required this.selectedMenu,
  }) : super(key: key);

  final MenuState selectedMenu;

  @override
  Widget build(BuildContext context) {
    User? user = Provider.of<UserData>(context, listen: true).user;
    List cartitems = Provider.of<Cart>(context, listen: true).cartItem;
    final Color inActiveIconColor = Color(0xFFB6B6B6);
    return Container(
      padding: EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            offset: Offset(0, -15),
            blurRadius: 20,
            color: Color(0xFFDADADA).withOpacity(0.15),
          ),
        ],
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(40),
          topRight: Radius.circular(40),
        ),
      ),
      child: SafeArea(
          top: false,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                icon: SvgPicture.asset(
                  "assets/icons/Shop Icon.svg",
                  color: MenuState.home == selectedMenu
                      ? kPrimaryColor
                      : inActiveIconColor,
                ),
                onPressed: () =>
                    Navigator.pushNamed(context, HomeScreen.routeName),
              ),
              IconButton(
                icon: SvgPicture.asset("assets/icons/Heart Icon.svg"),
                onPressed: () {},
              ),
              IconButton(
                icon: Stack(children: [
                  SvgPicture.asset("assets/icons/Cart Icon.svg", ),
                  (cartitems.length > 0)?Padding(
                    padding: const EdgeInsets.only(left:10.0),
                    child: Text("${cartitems.length}", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),),
                  ):SizedBox.shrink(),
                  ],),
                onPressed: () => (cartitems.isEmpty)
                    ? ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('No product found'),
                        backgroundColor: Colors.red,
                      ))
                    : (user?.id != null)
                    ?Navigator.pushNamed(context, CartScreen.routeName)
                    :Navigator.pushNamed(context, SignInScreen.routeName),
              ),
              IconButton(
                icon: SvgPicture.asset(
                  "assets/icons/User Icon.svg",
                  color: MenuState.profile == selectedMenu
                      ? kPrimaryColor
                      : inActiveIconColor,
                ),
                onPressed: () =>
                    Navigator.pushNamed(context, ProfileScreen.routeName),
              ),
            ],
          )),
    );
  }
}

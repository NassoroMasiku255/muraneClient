import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/components/default_button.dart';
import 'package:shop_app/constants.dart';
import 'package:shop_app/models/Product.dart';
import 'package:shop_app/provider/cart.dart';
import 'package:shop_app/size_config.dart';
import 'package:http/http.dart' as http;
import 'color_dots.dart';
import 'product_description.dart';
import 'top_rounded_container.dart';
import 'product_images.dart';

class Body extends StatefulWidget {
  final Product product;
  const Body({super.key, required this.product});

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  bool loadingData = false;
  dynamic details;
  Future<void> _loadProducts() async {
    Uri apiUrl =
        Uri.parse("$base_url/product_details?inv_id=${widget.product.id}");
    setState(() {
      loadingData = true;
    });
    try {
      var response = await http.get(
        apiUrl,
        headers: {"Content-Type": "application/json"},
      );
      var res = jsonDecode(response.body);
      setState(() {
        loadingData = false;
        details = res;
      });
    } catch (e) {
      // ignore: use_build_context_synchronously
      print("here is catch: $e");
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('No product found'),
      ));
      setState(() {
        loadingData = false;
      });
    }
  }

  @override
  void initState() {
    print(widget.product.id);
    _loadProducts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List cartitems = Provider.of<Cart>(context, listen: true).cartItem;
    print(cartitems);
    return ListView(
      children: [
        ProductImages(product: widget.product),
        TopRoundedContainer(
          color: Colors.white,
          child: Column(
            children: [
              ProductDescription(
                product: widget.product,
                pressOnSeeMore: () {},
              ),
              TopRoundedContainer(
                color: Color(0xFFF6F7F9),
                child: Column(
                  children: [
                    ColorDots(product: widget.product),
                    TopRoundedContainer(
                      color: Colors.white,
                      child: Padding(
                        padding: EdgeInsets.only(
                          left: SizeConfig.screenWidth * 0.15,
                          right: SizeConfig.screenWidth * 0.15,
                          bottom: getProportionateScreenWidth(40),
                          top: getProportionateScreenWidth(15),
                        ),
                        child: DefaultButton(
                          text: "Add To Cart",
                          press: () => saveToCart(details),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  saveToCart(product) {
    print(product);
    int? qty = Provider.of<Cart>(context, listen: false).quantity;
    Provider.of<Cart>(context, listen: false).addCartItem({
      "invid": product["inventory"]["id"].toString(),
      "custId":"1",
      "name": product["name"],
      "price": product["inventory"]["amount"].toString(),
      "shopId": product["shopId"].toString(),
      "quantity": qty.toString()
    });
    Provider.of<Cart>(context, listen: false).changeQuantiry(1);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("successful added to cart"),
          backgroundColor: Colors.green,
    ));
    Navigator.pop(context);
  }
}

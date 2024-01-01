import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../../constants.dart';
import '../../../models/Product.dart';
import '../../../size_config.dart';
import 'categories.dart';
import 'discount_banner.dart';
import 'home_header.dart';
import 'product_list.dart';
import 'special_offers.dart';

class Body extends StatefulWidget {
  const Body({super.key});

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  List<Product> products = [];

  Future<void> _loadProducts() async {
    Uri apiUrl = Uri.parse("$base_url/getAllItems");
    try {
      var response = await http.get(
        apiUrl,
        headers: {"Content-Type": "application/json"},
      );
      var res = jsonDecode(response.body);
      for (var element in res["item"]) {
        setState(() {
          products.add(Product(
            id: element["id"],
            images: [
              "assets/images/wireless headset.png",
            ],
            colors: [
              Color(0xFFF6625E),
              Color(0xFF836DB8),
              Color(0xFFDECB9C),
              Colors.white,
            ],
            title: element["name"],
            price: element["price"],
            description: "dfafasd",
            rating: 4.1,
            // isFavourite: true,
          ));
        });
      }
    } catch (e) {
      // ignore: use_build_context_synchronously
      print("here is catch: $e");
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('No product found'),
      ));
    }
  }

  @override
  void initState() {
    _loadProducts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          SizedBox(height: getProportionateScreenHeight(20)),
          HomeHeader(),
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  SizedBox(height: getProportionateScreenWidth(10)),
                  DiscountBanner(),
                  Categories(),
                  SpecialOffers(),
                  SizedBox(height: getProportionateScreenWidth(30)),
                  ProductList(product: products)
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

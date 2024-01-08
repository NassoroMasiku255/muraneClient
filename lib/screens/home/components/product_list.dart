import 'package:flutter/material.dart';
import 'package:shop_app/models/Product.dart';

import '../../../components/product_list_card.dart';
import '../../../size_config.dart';

class ProductList extends StatelessWidget {
final List<Product> product;
ProductList({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child:SingleChildScrollView(
           physics: const BouncingScrollPhysics(),
          // scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              Column(
                children: [
                  ...List.generate(
                    product.length,
                    (index) => ListCard(product: product[index]),
                  ),
                  SizedBox(width: getProportionateScreenWidth(20)),
                ],
              ),
              const SizedBox(width: 10),
               Column(
                children: [
                  ...List.generate(
                    product.length,
                    (index) => ListCard(product: product[index]),
                  ),
                  SizedBox(width: getProportionateScreenWidth(20)),
                ],
              ),
            ],
          ),
        ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:shop_app/models/Product.dart';

import '../../../components/product_list_card.dart';
import '../../../size_config.dart';

class ProductList extends StatelessWidget {
final List<Product> product;
ProductList({super.key, required this.product});
// final List<Product> demoProducts = [
//   Product(
//     id: 1,
//     images: [
//       "assets/images/ps4_console_white_1.png",
//       "assets/images/ps4_console_white_2.png",
//       "assets/images/ps4_console_white_3.png",
//       "assets/images/ps4_console_white_4.png",
//     ],
//     colors: [
//       Color(0xFFF6625E),
//       Color(0xFF836DB8),
//       Color(0xFFDECB9C),
//       Colors.white,
//     ],
//     title: "Wireless Controller for PS4™",
//     price: 64.99,
//     description: "fjd fdaskfjsad fkasdfsdfdsfkasd;jf",
//     rating: 4.8,
//     isFavourite: true,
//     isPopular: true,
//   ),
//   Product(
//     id: 2,
//     images: [
//       "assets/images/Image Popular Product 2.png",
//     ],
//     colors: [
//       Color(0xFFF6625E),
//       Color(0xFF836DB8),
//       Color(0xFFDECB9C),
//       Colors.white,
//     ],
//     title: "Nike Sport White - Man Pant",
//     price: 50.5,
//     description: "fjd fdaskfjsad fkasdfsdfdsfkasd;jf d",
//     rating: 4.1,
//     isPopular: true,
//   ),
//   Product(
//     id: 3,
//     images: [
//       "assets/images/glap.png",
//     ],
//     colors: [
//       Color(0xFFF6625E),
//       Color(0xFF836DB8),
//       Color(0xFFDECB9C),
//       Colors.white,
//     ],
//     title: "Gloves XC Omega - Polygon",
//     price: 36.55,
//     description:  "fjd fdaskfjsad fkasdfsdfdsfkasd;jf d",
//     rating: 4.1,
//     isFavourite: true,
//     isPopular: true,
//   ),
//   Product(
//     id: 4,
//     images: [
//       "assets/images/wireless headset.png",
//     ],
//     colors: [
//       Color(0xFFF6625E),
//       Color(0xFF836DB8),
//       Color(0xFFDECB9C),
//       Colors.white,
//     ],
//     title: "Logitech Head",
//     price: 20.20,
//     description:  "fjd fdaskfjsad fkasdfsdfdsfkasd;jf d",
//     rating: 4.1,
//     isFavourite: true,
//   ),
// ];

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

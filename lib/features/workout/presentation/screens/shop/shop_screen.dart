import 'package:coach_workout/utils/extensions.dart';
import 'package:flutter/material.dart';

/// ===============================
/// MODEL SẢN PHẨM
/// ===============================
class Product {
  final String name;
  final String image; // asset hoặc network
  final double price;
  final double? oldPrice;
  final bool bestSeller;
  final int? salePercent;

  Product({
    required this.name,
    required this.image,
    required this.price,
    this.oldPrice,
    this.bestSeller = false,
    this.salePercent,
  });
}

/// ===============================
/// DỮ LIỆU TẠM (SAU NÀY THAY BẰNG API)
/// ===============================
final List<Product> products = [
  Product(
    name: 'Bộ tạ tay điều chỉnh',
    image: 'assets/images/dumbbell.jpg',
    price: 299,
    salePercent: 25,
    bestSeller: true,
  ),
  Product(
    name: 'Thảm Yoga cao cấp',
    image: 'assets/images/yoga_mat.jpg',
    price: 199,
    bestSeller: true,
  ),
  Product(
    name: 'Bộ dây kháng lực',
    image: 'assets/images/bands.jpg',
    price: 149,

    salePercent: 20,
  ),
  Product(
    name: 'Xà đơn treo cửa',
    image: 'assets/images/pullup.jpg',
    price: 179,
    bestSeller: true,
  ),
  Product(
    name: 'Tạ bình vôi 12kg',
    image: 'assets/images/kettlebell.jpg',
    price: 259,
  ),
  Product(
    name: 'Con lăn massage cơ bắp',
    image: 'assets/images/roller.png',
    price: 99,
    salePercent: 10,
  ),
];

/// ===============================
/// MÀN HÌNH CỬA HÀNG
/// ===============================
class ShopScreen extends StatelessWidget {
  const ShopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF6F7FB),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        titleSpacing: 0,
        title: Padding(
          padding: const EdgeInsets.fromLTRB(16, 19, 10, 16),
          child: SizedBox(
            height: 48,
            width: double.infinity,
            child: TextField(
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: 'Tìm kiếm sản phẩm...',
                filled: true,
                fillColor: context.colorScheme.surface,
                focusColor: context.colorScheme.surface,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
            ),
          ),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 12),
            child: Icon(Icons.shopping_cart_outlined, color: Colors.black),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.builder(
          itemCount: products.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 0.7,
          ),
          itemBuilder: (context, index) {
            return ProductCard(product: products[index]);
          },
        ),
      ),
    );
  }
}

/// ===============================
/// THẺ SẢN PHẨM
/// ===============================
class ProductCard extends StatelessWidget {
  final Product product;
  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 14,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// ===============================
          /// HÌNH ẢNH + NHÃN
          /// ===============================
          AspectRatio(
            aspectRatio: 1.3,
            child: Stack(
              children: [
                Positioned.fill(
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(18),
                    ),
                    child: Image.asset(
                      product.image,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        color: const Color(0xffE0E7FF),
                        child: const Icon(
                          Icons.fitness_center,
                          size: 42,
                          color: Color(0xff2563EB),
                        ),
                      ),
                    ),
                  ),
                ),

                /// NÚT YÊU THÍCH
                Positioned(
                  top: 10,
                  right: 10,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.favorite_border,
                      size: 16,
                      color: Colors.red,
                    ),
                  ),
                ),

                /// NHÃN GIẢM GIÁ
                if (product.salePercent != null)
                  _Tag(
                    text: 'Giảm ${product.salePercent}%',
                    color: Colors.red,
                    top: 10,
                  ),

                /// NHÃN BÁN CHẠY
                if (product.bestSeller)
                  _Tag(
                    text: 'Bán chạy',
                    color: Colors.orange,
                    top: product.salePercent != null ? 38 : 10,
                  ),
              ],
            ),
          ),

          /// ===============================
          /// THÔNG TIN SẢN PHẨM
          /// ===============================
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text(
                      '${product.price.toStringAsFixed(0)}.000₫',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff2563EB),
                      ),
                    ),
                    if (product.oldPrice != null) ...[
                      const SizedBox(width: 6),
                      Text(
                        '${product.oldPrice!.toStringAsFixed(0)}.000₫',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// ===============================
/// WIDGET NHÃN
/// ===============================
class _Tag extends StatelessWidget {
  final String text;
  final Color color;
  final double top;

  const _Tag({required this.text, required this.color, required this.top});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: top,
      left: 8,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 11,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}



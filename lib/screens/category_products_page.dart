import 'package:flutter/material.dart';
import 'package:testproject/helpers/cart_helper.dart';
import 'package:testproject/models/cart_item.dart';
import '../models/product.dart';
import 'product_details_page.dart';

class CategoryProductsPage extends StatelessWidget {
  final String category;
  final List<Product> allProducts;

  CategoryProductsPage({required this.category, required this.allProducts});

  @override
  Widget build(BuildContext context) {
    final products = allProducts.where((p) => p.category == category).toList();

    return Scaffold(
      appBar:  AppBar(
        title: Text(
          category,
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ), backgroundColor: Colors.deepPurple,centerTitle: true,),
      body: GridView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.only(top: 8),
        itemCount: products.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.75,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        itemBuilder: (_, index) {
          final product = products[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ProductDetailsPage(product: product),
                ),
              );
            },
            child: ProductCart(product: product),
          );
        },
      ),
    );
  }
}

class ProductCart extends StatelessWidget {
  const ProductCart({super.key, required this.product});

  final Product product;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        shadowColor: Colors.black,
        elevation: 4,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
                child: Image.network(
                  product.image,
                  width: double.infinity,
                  height: 400,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return CircularProgressIndicator();
                  },
                  errorBuilder: (context, error, stackTrace) => Image(
                    image: NetworkImage(
                      'https://static.vecteezy.com/system/resources/thumbnails/010/127/083/small_2x/top-view-of-electronic-devices-with-notebook-glasses-and-coffee-cup-on-wooden-table-background-free-photo.jpg',
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                product.name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                '\$${product.price.toString()}',
                style: TextStyle(
                  color: Colors.deepPurple,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            // Add to cart icon
            Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                icon: Icon(Icons.add_shopping_cart, color: Colors.deepPurple),
                onPressed: () async {
                  final cartItem = CartItem(
                    id: product.id,
                    name: product.name,
                    image: product.image,
                    price: product.price,
                    quantity: 1,
                  );
                  await CartHelper.addToCart(cartItem);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${product.name} Added to cart'),
                      backgroundColor: Colors.green,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

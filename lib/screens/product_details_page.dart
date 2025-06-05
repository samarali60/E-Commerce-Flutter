import 'package:flutter/material.dart';
import 'package:testproject/screens/cart_page.dart';
import '../models/product.dart';
import '../models/cart_item.dart';
import '../helpers/cart_helper.dart';

class ProductDetailsPage extends StatefulWidget {
  final Product product;

   ProductDetailsPage({required this.product});

  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  int quantity = 1;

  void addToCart() async {
    final cartItem = CartItem(
      id: widget.product.id,
      name: widget.product.name,
      image: widget.product.image,
      price: widget.product.price,
      quantity: quantity,
    );

    await CartHelper.addToCart(cartItem);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Added to cart'), backgroundColor: Colors.green,),
    );
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.push(context,MaterialPageRoute(builder: (_) => CartPage()));
            },
          ),
        ],
        ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
                    Text(product.name, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold,  color: Colors.deepPurple)),
                     SizedBox(height: 12),
                     Text(product.description,style: TextStyle(fontSize: 18,color: Colors.purple)),
                     SizedBox(height: 12),
                    Text("\$${product.price}", style: TextStyle(fontSize: 22,color:  Colors.deepOrange)),
                     SizedBox(height: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: 
                
                Image.network(
                  product.image,
                   width: double.infinity, 
                   height: 250, fit: BoxFit.cover,
                   loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return CircularProgressIndicator();
                  },
                  errorBuilder: (context, error, stackTrace) => Image(
                    image: NetworkImage(
                      'https://static.vecteezy.com/system/resources/thumbnails/010/127/083/small_2x/top-view-of-electronic-devices-with-notebook-glasses-and-coffee-cup-on-wooden-table-background-free-photo.jpg'
                    ),
                    fit: BoxFit.cover,
                  ),
                   )),
                  Row(
                      children: [
                        Text("Quantity:", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold,  color: Colors.deepPurple)),
                        SizedBox(width: 12),
                        IconButton(
                          icon: Icon(Icons.remove ),
                          color:  quantity > 1 ? Colors.deepPurpleAccent : Colors.grey,
                          onPressed: () {
                            if (quantity > 1) {
                              setState(() => quantity--);
                            }
                          },
                        ),
                        Text('$quantity', style:  TextStyle(fontSize: 22, fontWeight: FontWeight.bold,  color: Colors.deepOrange),),
                        IconButton(
                          icon: Icon(Icons.add),
                          color: Colors.deepPurpleAccent,
                          onPressed: () => setState(() => quantity++),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Row(children: [
                       Expanded(
                      child: ElevatedButton(
                        onPressed: addToCart,
                        child: Text("Add to Cart"),
                      ),
                    ),
                    ],)
                   
            ],
          ),
        ),
      ),
    );
  }
}

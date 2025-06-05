import 'package:flutter/material.dart';
import 'package:testproject/models/order.dart';
import 'package:testproject/screens/home.dart';
import 'package:testproject/screens/home_screen.dart';
import '../models/cart_item.dart';
import '../helpers/cart_helper.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  List<CartItem> cartItems = [];

  @override
  void initState() {
    super.initState();
    loadCart();
  }

  Future<void> loadCart() async {
    final items = await CartHelper.getCartItems();
    setState(() {
      cartItems = items;
    });
  }

  void updateQuantity(int index, int change) async {
    setState(() {
      cartItems[index].quantity += change;
      if (cartItems[index].quantity < 1) {
        cartItems[index].quantity = 1;
      }
    });
    await CartHelper.saveCartItems(cartItems);
  }

  void removeItem(int index) async {
    setState(() {
      cartItems.removeAt(index);
    });
    await CartHelper.saveCartItems(cartItems);
  }

  double getTotalPrice() {
    return cartItems.fold(
      0.0,
      (total, item) => total + item.price * item.quantity,
    );
  }

void placeOrder() async {
  if (cartItems.isEmpty) return;

  final total = getTotalPrice();
  final orderItems = cartItems.map((item) => item.toJson()).toList();
  String formattedDate = DateTime.now().toLocal().toString().split('.')[0];

  Order newOrder = Order(
    items: orderItems,
    totalPrice: total,
    date: formattedDate,
  );

  await saveOrder(newOrder); 
  await CartHelper.clearCart(); 

  setState(() => cartItems = []);

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) => AlertDialog(
      title: Text("Order Placed!", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.deepPurple)),
      content: Text("Your total: \$${total.toStringAsFixed(2)}"),
      actions: [
        TextButton(
          onPressed: () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => MyHome()),
          ),
          child: Text("OK", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.deepOrange)),
        ),
      ],
    ),
  );
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(
          "My Cart",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,),
      body: cartItems.isEmpty
          ? Center(
              child: Text(
                "Your cart is empty.",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: cartItems.length,
                    itemBuilder: (_, index) {
                      final item = cartItems[index];
                      return Card(
                        shadowColor: Colors.deepPurpleAccent,
                        elevation: 5,
                        color: Colors.white,
                        margin: EdgeInsets.all(10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: ListTile(
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Image.network(
                              item.image,
                              width: 100,
                              height: 200,
                              fit: BoxFit.cover,
                            ),
                          ),
                          title: Text(item.name),
                          subtitle: Text("\$${item.price}"),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(Icons.remove),
                                color: Colors.deepPurpleAccent,
                                onPressed: () => updateQuantity(index, -1),
                              ),
                              Text(
                                "${item.quantity}",
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.deepOrange,
                                ),
                              ),
                              IconButton(
                                icon: Icon(Icons.add),
                                color: Colors.deepPurpleAccent,
                                onPressed: () => updateQuantity(index, 1),
                              ),
                              IconButton(
                                icon: Icon(Icons.delete),
                                color: Colors.red[900],
                                onPressed: () => removeItem(index),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Total:",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.deepPurple,
                            ),
                          ),
                          Text(
                            "\$${getTotalPrice().toStringAsFixed(2)}",
                            style: TextStyle(fontSize: 18),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: placeOrder,
                        child: Text("Place Order"),
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(double.infinity, 45),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}

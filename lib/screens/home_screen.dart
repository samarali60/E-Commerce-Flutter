import 'dart:convert';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:testproject/helpers/cart_helper.dart';
import 'package:testproject/models/cart_item.dart';
import 'package:testproject/screens/cart_page.dart';
import 'package:testproject/screens/category_products_page.dart';
import 'package:testproject/models/product.dart';
import 'package:testproject/screens/product_details_page.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  String userName = 'User';

  @override
  void initState() {
    super.initState();
    loadUserData();
    fetchProducts();
    fetchCategories();
  }

  List<Product> allProducts = [];
  List<String> categories = [];

  Future<void> fetchProducts() async {
    final url = Uri.parse('https://ib.jamalmoallart.com/api/v1/all/products');
    final response = await http.get(url);
    try {
      if (response.statusCode == 200) {
        final List decoded = json.decode(response.body);
        setState(() {
          allProducts = decoded.map((json) => Product.fromJson(json)).toList();
        });
      } else {
        throw Exception(
          'Failed to load products (Status ${response.statusCode})',
        );
      }
    } catch (e) {
      print('API Error: $e');
    }
  }

  Future<void> fetchCategories() async {
    final url = Uri.parse(
      'https://ib.jamalmoallart.com/api/v1/all/categories/',
    );
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      setState(() {
        categories = data.map((item) => item.toString()).toList();
      });
    } else {
      print('Failed to load categories');
    }
  }

  Future<void> loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString('firstName') ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Welcome, $userName',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        actions: [
          IconButton(
            icon: Icon(Icons.search,color: Colors.white,),
            onPressed: () {
              showSearch(
                context: context,
                delegate: ProductSearchDelegate(allProducts: allProducts),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.shopping_cart, color: Colors.white,),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => CartPage()),
              );
            },
          ),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          buildSlider(),
          SizedBox(height: 16),
          buildCategoryList(),
          SizedBox(height: 16),
          buildSectionTitle('Featured Products'),
          buildProductGrid(),
          SizedBox(height: 16),
          buildSectionTitle('New Arrivals'),
          buildProductGrid(),
        ],
      ),
    );
  }

  CarouselSlider buildSlider() {
    return CarouselSlider(
      items: [
        sliderItem(
          'https://fortec.us/wp-content/uploads/2022/08/7.29-7.jpg',
        ),
        sliderItem('https://cdn.prod.website-files.com/61dfc899a471632619dca9dd/6585d971ed2382b9c3787a8e_Electonic-Devices.png'),
        sliderItem('https://www.shutterstock.com/image-photo/communicator-mockup-tablet-similar-ipad-260nw-306237590.jpg'),
      ],
      options: CarouselOptions(
        height: 200,
        enlargeCenterPage: true,
        autoPlay: true,
        aspectRatio: 16 / 9,
        autoPlayCurve: Curves.fastOutSlowIn,
        enableInfiniteScroll: true,
        autoPlayAnimationDuration: Duration(milliseconds: 800),
        viewportFraction: 0.8,
      ),
    );
  }

  Container sliderItem(String url) {
    return Container(
      margin: EdgeInsets.all(6.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        image: DecorationImage(image: NetworkImage(url), fit: BoxFit.cover),
      ),
    );
  }

  Widget buildCategoryList() {
    if (categories.isEmpty) {
      return Center(child: CircularProgressIndicator());
    }
    return SizedBox(
      height: 30,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (_, __) => SizedBox(width: 12),
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => CategoryProductsPage(
                    category: categories[index],
                    allProducts: allProducts,
                  ),
                ),
              );
            },
            child: Container(
              width: 100,
              height: 30,
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.deepPurple),
                borderRadius: BorderRadius.circular(25),
              ),
              child: Center(
                child: Text(
                  categories[index],
                  style: TextStyle(color: Colors.deepPurple),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.deepPurple,
      ),
    );
  }

  Widget buildProductGrid() {
    if (allProducts.isEmpty) {
      return Center(child: CircularProgressIndicator());
    }

    return GridView.builder(
      itemCount: allProducts.length,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      padding: EdgeInsets.only(top: 8),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.7,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemBuilder: (context, index) {
        final p = allProducts[index];
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => ProductDetailsPage(product: p)),
            );
          },
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            shadowColor: Colors.black,
            elevation: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product image
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(15),
                    ),
                    child: Image.network(
                      p.image,
                      width: double.infinity,
                      height: 400,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, _) => Image.network(
                        'https://static.vecteezy.com/system/resources/thumbnails/010/127/083/small_2x/top-view-of-electronic-devices-with-notebook-glasses-and-coffee-cup-on-wooden-table-background-free-photo.jpg'
                        ,fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),

                // Product name + price
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    p.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    '\$${p.price.toString()}',
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
                    icon: Icon(
                      Icons.add_shopping_cart,
                      color: Colors.deepPurple,
                    ),
                    onPressed: () async {
                      final cartItem = CartItem(
                        id: p.id,
                        name: p.name,
                        image: p.image,
                        price: p.price,
                        quantity: 1,
                      );
                      await CartHelper.addToCart(cartItem);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('${p.name} Added to cart'),
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
      },
    );
  }
}

class ProductSearchDelegate extends SearchDelegate {
  final List<Product> allProducts;

  ProductSearchDelegate({required this.allProducts});

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      if (query.isNotEmpty)
        IconButton(icon: Icon(Icons.clear), onPressed: () => query = ''),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () => close(context, null),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final results = allProducts
        .where((p) => p.name.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (_, index) {
        final product = results[index];
        return ListTile(
          leading: Image.network(
            product.image,
            width: 100,
            height: 100,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Image.network(
                'https://cdn-icons-png.flaticon.com/512/8136/8136031.png',
                width: 100,
                height: 100,
                fit: BoxFit.cover,
              );
            },
          ),

          title: Text(product.name),
          subtitle: Text("\$${product.price.toString()}"),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ProductDetailsPage(product: product),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return buildResults(context);
  }
}

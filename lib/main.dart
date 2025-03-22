import 'package:flutter/material.dart';

//-----GLOBAL VARIABLES-----
final Color mainColor = const Color(0xFF4CAF50);

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Food App',
      theme: ThemeData(
        primarySwatch: Colors.green,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const SplashScreen(),
    );
  }
}

//-----MODELS-----
class Food {
  final int foodId;
  final String foodName;
  final String foodCategory;
  final int foodWeight;
  final String foodType;
  final String foodDescription;
  final String foodImage;
  int foodQuantity;

  Food({
    required this.foodId,
    required this.foodName,
    required this.foodCategory,
    required this.foodWeight,
    required this.foodType,
    required this.foodDescription,
    required this.foodImage,
    this.foodQuantity = 0,
  });
}

//-----DUMMY DATA-----
final List<Food> foods = [
  Food(
    foodId: 1,
    foodName: "Cheese Pizza",
    foodCategory: "Italian",
    foodWeight: 300,
    foodType: "Non-Veg",
    foodDescription: "Delicious pizza with mozzarella cheese",
    foodImage: "assets/pizza.png",
  ),
  Food(
    foodId: 2,
    foodName: "Beef Burger",
    foodCategory: "American",
    foodWeight: 250,
    foodType: "Non-Veg",
    foodDescription: "Juicy beef burger with fresh vegetables",
    foodImage: "assets/burger.png",
  ),
  Food(
    foodId: 3,
    foodName: "Martabak Manis",
    foodCategory: "Indonesian",
    foodWeight: 400,
    foodType: "Veg",
    foodDescription: "Sweet and savory martabak with chocolate filling",
    foodImage: "assets/martabak.png",
  ),
  Food(
    foodId: 4,
    foodName: "Pisang Goreng",
    foodCategory: "Indonesian",
    foodWeight: 200,
    foodType: "Veg",
    foodDescription: "Crispy fried banana with sweet syrup",
    foodImage: "assets/donut.png",
  ),
  Food(
    foodId: 5,
    foodName: "Bakso",
    foodCategory: "Indonesian",
    foodWeight: 350,
    foodType: "Non-Veg",
    foodDescription: "Traditional Indonesian meatball soup",
    foodImage: "assets/placeholder.png",
  ),
];

//-----SHOPPING CART LOGIC-----
class CartService {
  final List<Food> _cartItems = [];

  List<Food> get cartItems => _cartItems;

  void addItem(Food food) {
    final Food? existingItem = _cartItems.firstWhere(
          (item) => item.foodId == food.foodId,
      orElse: () => null,
    );
    if (existingItem != null) {
      existingItem.foodQuantity++;
    } else {
      food.foodQuantity = 1;
      _cartItems.add(food);
    }
  }

  void removeItem(Food food) {
    final Food? existingItem = _cartItems.firstWhere(
          (item) => item.foodId == food.foodId,
      orElse: () => null,
    );
    if (existingItem != null) {
      if (existingItem.foodQuantity > 1) {
        existingItem.foodQuantity--;
      } else {
        _cartItems.remove(existingItem);
      }
    }
  }

  void clearCart() {
    _cartItems.clear();
  }

  int getItemCount() {
    return _cartItems.length;
  }
}

//-----PAGES-----
class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LandingPage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainColor,
      body: Stack(
        children: [
          Align(
            alignment: Alignment.center,
            child: Image.asset('assets/food_icon.png', width: 150, height: 150),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              margin: const EdgeInsets.only(bottom: 80),
              child: const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class LandingPage extends StatelessWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Center(
          child: Icon(Icons.fastfood, color: mainColor, size: 40),
        ),
        actions: const [SizedBox(width: 40, height: 40)],
        iconTheme: IconThemeData(color: mainColor),
      ),
      drawer: Drawer(
        child: Container(
          padding: const EdgeInsets.all(30),
          color: mainColor,
          alignment: Alignment.bottomLeft,
          child: const Icon(Icons.fastfood, color: Colors.white, size: 80),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          AppHeader(),
          AppSearch(),
          Expanded(child: FoodList()),
          AppBottomBar(),
        ],
      ),
    );
  }
}

class DetailsPage extends StatelessWidget {
  final Food food;
  final CartService cartService = CartService();

  const DetailsPage({Key? key, required this.food}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(food.foodName)),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.asset(
              food.foodImage,
              errorBuilder: (context, error, stackTrace) {
                return Image.asset('assets/placeholder.png');
              },
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Category: ${food.foodCategory}"),
                  Text("Weight: ${food.foodWeight}g"),
                  Text("Type: ${food.foodType}"),
                  Text("Description: ${food.foodDescription}"),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () {
                cartService.addItem(food);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("${food.foodName} added to cart")),
                );
              },
              child: const Text("Add to Cart"),
            ),
          ],
        ),
      ),
    );
  }
}

class CartPage extends StatelessWidget {
  final CartService cartService;

  const CartPage({Key? key, required this.cartService}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Shopping Cart")),
      body: cartService.cartItems.isEmpty
          ? const Center(child: Text("Your cart is empty"))
          : ListView.builder(
        itemCount: cartService.cartItems.length,
        itemBuilder: (context, index) {
          final food = cartService.cartItems[index];
          return ListTile(
            leading: Image.asset(
              food.foodImage,
              errorBuilder: (context, error, stackTrace) {
                return Image.asset('assets/placeholder.png');
              },
            ),
            title: Text("${food.foodName} (${food.foodQuantity})"),
            subtitle: Text("${food.foodWeight}g - ${food.foodType}"),
            trailing: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                cartService.removeItem(food);
              },
            ),
          );
        },
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
              onPressed: () {
                cartService.clearCart();
              },
              child: const Text("Clear Cart"),
            ),
            ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text("Checkout"),
                    content: const Text("Thank you for your order!"),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text("OK"),
                      ),
                    ],
                  ),
                );
              },
              child: const Text("Checkout"),
            ),
          ],
        ),
      ),
    );
  }
}

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Favorites")),
      body: const Center(
        child: Text("This is the Favorites Page"),
      ),
    );
  }
}

//-----WIDGETS-----
class AppHeader extends StatelessWidget {
  const AppHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 30, top: 30, right: 30),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.grey[300],
            radius: 25,
            child: const Text(
              'U',
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'Hello, User',
                style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
              Text(
                'Good Morning',
                style: TextStyle(color: mainColor, fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class AppSearch extends StatelessWidget {
  const AppSearch({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Discover',
            style: TextStyle(fontWeight: FontWeight.w900, fontSize: 25),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 50,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: const [
                      Icon(Icons.search, color: Colors.grey),
                      SizedBox(width: 10),
                      Text('Search', style: TextStyle(color: Colors.grey)),
                    ],
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(left: 10),
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: mainColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.tune, color: Colors.white),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class FoodList extends StatelessWidget {
  const FoodList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: foods.length,
      itemBuilder: (context, index) {
        final food = foods[index];
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => DetailsPage(food: food)),
            );
          },
          child: Container(
            alignment: Alignment.bottomLeft,
            padding: const EdgeInsets.all(20),
            margin: const EdgeInsets.all(10),
            width: 150,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              image: DecorationImage(
                image: AssetImage(food.foodImage),
                fit: BoxFit.cover,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  food.foodName,
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
                Text(
                  food.foodCategory,
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class AppBottomBar extends StatefulWidget {
  const AppBottomBar({Key? key}) : super(key: key);

  @override
  AppBottomBarState createState() => AppBottomBarState();
}

class AppBottomBarState extends State<AppBottomBar> {
  List<AppBottomBarItem> barItems = [
    AppBottomBarItem(icon: Icons.home, label: 'Home', isSelected: true),
    AppBottomBarItem(icon: Icons.shopping_cart, label: 'Cart', isSelected: false),
    AppBottomBarItem(icon: Icons.favorite_border, label: 'Favorites', isSelected: false),
    AppBottomBarItem(icon: Icons.person_outline, label: 'Profile', isSelected: false),
  ];

  final CartService cartService = CartService();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset.zero,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(barItems.length, (index) {
          final currentBarItem = barItems[index];
          Widget barItemWidget;

          if (currentBarItem.isSelected) {
            barItemWidget = Container(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: mainColor,
              ),
              child: Row(
                children: [
                  Icon(currentBarItem.icon, color: Colors.white),
                  const SizedBox(width: 5),
                  Text(
                    currentBarItem.label,
                    style: const TextStyle(color: Colors.white),
                  ),
                ],
              ),
            );
          } else {
            barItemWidget = Stack(
              alignment: Alignment.center,
              children: [
                IconButton(
                  icon: Icon(currentBarItem.icon, color: Colors.grey),
                  onPressed: () {
                    setState(() {
                      for (var item in barItems) {
                        item.isSelected = item == currentBarItem;
                      }
                      if (currentBarItem.label == 'Cart') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => CartPage(cartService: cartService)),
                        );
                      } else if (currentBarItem.label == 'Favorites') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const FavoritesPage()),
                        );
                      }
                    });
                  },
                ),
                if (currentBarItem.icon == Icons.shopping_cart && cartService.getItemCount() > 0)
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        '${cartService.getItemCount()}',
                        style: const TextStyle(color: Colors.white, fontSize: 10),
                      ),
                    ),
                  ),
              ],
            );
          }
          return barItemWidget;
        }),
      ),
    );
  }
}

//-----MODELS & WIDGET MODELS-----
class AppBottomBarItem {
  IconData? icon;
  bool isSelected;
  String label;

  AppBottomBarItem({this.icon, this.label = '', this.isSelected = false});
}
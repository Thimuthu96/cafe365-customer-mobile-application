import 'package:flutter/material.dart';

import 'src/app/modules/Dining/view/dining_menu_screen.dart';
import 'src/app/modules/Dining/view/qr_scan_screen.dart';
import 'src/app/modules/categories/views/category-screen.dart';
import 'src/app/modules/checkout/views/delivery_screen.dart';
import 'src/app/modules/checkout/views/order_payment.dart';
import 'src/app/modules/home/widgets/just_for_you_list.dart';
import 'src/app/modules/home/widgets/tending_list.dart';
import 'src/app/modules/login/views/login.dart';
import 'src/app/modules/mainscreen/views/main-screen.dart';
import 'src/app/modules/mainscreen/views/order-type-screen.dart';
import 'src/app/modules/order/views/myOrders.dart';
import 'src/app/modules/order/views/orders.dart';
import 'src/app/modules/order/widgets/order_success.dart';
import 'src/app/modules/register/views/register.dart';
import 'src/app/modules/search-ui/view/searchScreen.dart';
import 'src/app/modules/splash/views/splash_screen.dart';
import 'src/app/modules/wishlist/views/wishlist.dart';

// final Map<String, WidgetBuilder> routes = {
// '/': (BuildContext context) => const SplashScreen(),
// '/login': (BuildContext context) => const LoginPage(),
// '/main-screen': (BuildContext context) => const MainScreen(),
// '/signup': (BuildContext context) => SignUpPage(),
// '/categories': (BuildContext context) => const CategoryPage(),
// '/add-delivery': (BuildContext context) => AddDelivery(),
// '/payment-option': (BuildContext context) => const PaymentScreen(),
// '/order-success': (BuildContext context) => const OrderSuccess(),
// '/wishlist': (BuildContext context) => const Wishlist(),
// '/orders': (BuildContext context) => const Orders(),
// '/search-ui': (BuildContext context) => const SearchScreen(),
// '/my-orders': (BuildContext context) => MyOrders(),
// '/trending-list': (BuildContext context) => TrendingList(),
// '/justForYou-list': (BuildContext context) => JustForYouList(),
// '/qr-scan': (BuildContext context) => QrScanScreen(),
// };

class CustomRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case '/login':
        return MaterialPageRoute(builder: (_) => const LoginPage());
      case '/main-screen':
        return MaterialPageRoute(builder: (_) => const MainScreen());
      case '/signup':
        return MaterialPageRoute(builder: (_) => SignUpPage());
      case '/categories':
        return MaterialPageRoute(builder: (_) => const CategoryPage());
      case '/add-delivery':
        return MaterialPageRoute(builder: (_) => AddDelivery());
      case '/payment-option':
        return MaterialPageRoute(builder: (_) => const PaymentScreen());
      case '/order-success':
        return MaterialPageRoute(builder: (_) => const OrderSuccess());
      case '/wishlist':
        return MaterialPageRoute(builder: (_) => const Wishlist());
      case '/orders':
        return MaterialPageRoute(builder: (_) => const Orders());
      case '/search-ui':
        return MaterialPageRoute(builder: (_) => const SearchScreen());
      case '/my-orders':
        return MaterialPageRoute(builder: (_) => MyOrders());
      case '/trending-list':
        return MaterialPageRoute(builder: (_) => TrendingList());
      case '/justForYou-list':
        return MaterialPageRoute(builder: (_) => JustForYouList());
      case '/qr-scan':
        String orderType = args.toString();
        return MaterialPageRoute(
            builder: (_) => QrScanScreen(
                  orderType: orderType,
                ));
      case '/dining-web-view':
        String url = args.toString();
        return MaterialPageRoute(
          builder: (_) => DiningMenuScreen(
            loadingRequestUrl: url,
          ),
        );
      default:
        return MaterialPageRoute(
            builder: (_) => OrderTypeScreen()); //need to create 404 error page
    }
  }
}

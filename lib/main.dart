import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:artistry_admin_web/adminAddProduct.dart';
import 'package:artistry_admin_web/dashboard_page.dart';
import 'package:artistry_admin_web/users_page.dart';
import 'package:artistry_admin_web/orders_page.dart';
import 'package:artistry_admin_web/adminproducts_page.dart';
import 'package:artistry_admin_web/addcat_page.dart';
//import 'package:artistry_admin_web/showCat.dart';
import 'package:artistry_admin_web/loginPage.dart';


void main() {
  runApp(const AdminApp());
}

class AdminApp extends StatefulWidget {
  const AdminApp({super.key});

  @override
  State<AdminApp> createState() => _AdminAppState();
}

class _AdminAppState extends State<AdminApp> {
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(1440, 1024),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp.router(
          debugShowCheckedModeBanner: false,
          theme: ThemeData.dark(),
          routerConfig: _router,
        );
      },
    );
  }
}

// Router configuration
final GoRouter _router = GoRouter(
  initialLocation: '/login',
  routes: [
       GoRoute(
      path: '/login', 
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: '/dashboard', 
      builder: (context, state) => const AdminScaffold(child: DashboardScreen()),
    ),
    GoRoute(
      path: '/admin/users', 
      builder: (context, state) => const AdminScaffold(child: UsersPage()),
    ),
    GoRoute(
      path: '/user/orders', 
      builder: (context, state) => const AdminScaffold(child: OrdersPage()),
    ),
    GoRoute(
      path: '/admin/addProduct',
      builder: (context, state) => const AdminScaffold(child: AddProduct()),
    ),
    GoRoute(
      path:'/admin/getProducts',
      builder: (context, state) => const AdminScaffold(child: AdminProducts()),
    ),
    // GoRoute(
    //   path:'/admin/addCategory',
    //   builder:(context, state) => const AdminScaffold(child: AddCategory()),
    // ),
  ],
);

// Shared scaffold that includes the side menu
class AdminScaffold extends StatelessWidget {
  final Widget child;
  const AdminScaffold({required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          const SideMenu(),
          Expanded(child: child),
        ],
      ),
    );
  }
}

// Side menu implementation
class SideMenu extends StatelessWidget {
  const SideMenu({super.key});

  @override
  Widget build(BuildContext context) {
    // Get current route to highlight active item
    final String currentRoute = GoRouterState.of(context).uri.path;
    
    return Container(
      width: 250,
      height: double.infinity, // Make it full height
      padding: const EdgeInsets.all(16),
      color: Colors.grey[900],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              "Admin Panel", 
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: ListView(
              children: [
                MenuItem(
                  title: "Dashboard", 
                  route: '/dashboard',
                  icon: Icons.dashboard,
                  isActive: currentRoute == '/dashboard',
                ),
                MenuItem(
                  title: "Admin Products",
                   route: '/admin/getProducts', 
                   icon: Icons.incomplete_circle,
                   isActive: currentRoute == '/admin/getProducts',
                   ),
                MenuItem(
                  title: "Users", 
                  route: '/admin/users',
                  icon: Icons.people,
                  isActive: currentRoute == '/admin/users',
                ),
                MenuItem(
                  title: "Add Products", 
                  route: '/admin/addProduct',
                  icon: Icons.add_shopping_cart,
                  isActive: currentRoute == '/admin/addProduct',
                ),
                MenuItem(
                  title: "Orders", 
                  route: '/user/orders',
                  icon: Icons.settings,
                  isActive: currentRoute == '/user/orders',
                ),
                // MenuItem(
                //   title: "Category", 
                //   route: '/admin/addCategory', 
                //   icon: Icons.category,
                //   isActive: currentRoute == '/admin/addCategory'
                //   )
              ],
            ),
          ),
          // Footer area if needed
          const Divider(color: Colors.grey),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.grey),
            title: const Text("Logout", style: TextStyle(color: Colors.grey)),
            onTap: () {
              // Handle logout
            },
          ),
        ],
      ),
    );
  }
}

// Individual menu item widget
class MenuItem extends StatelessWidget {
  final String title;
  final String route;
  final IconData icon;
  final bool isActive;

  const MenuItem({
    required this.title, 
    required this.route, 
    required this.icon,
    this.isActive = false,
    super.key
  });

  @override
Widget build(BuildContext context) {
  return Container(
    margin: const EdgeInsets.only(bottom: 8),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(8),
      // Change background color when active
      color: isActive 
        ? const Color.fromARGB(255, 247, 215, 3).withOpacity(0.2) 
        : Colors.transparent,
    ),
    child: ListTile(
      leading: Icon(
        icon,
        // Change icon color when active
        color: isActive 
          ? const Color.fromARGB(255, 247, 215, 3) 
          : Colors.grey,
      ),
      title: Text(
        title, 
        style: TextStyle(
          // Change text color when active
          color: isActive 
            ? const Color.fromARGB(255, 247, 215, 3) 
            : Colors.white,
          fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
        )
      ),
      onTap: () => GoRouter.of(context).go(route),
      selected: isActive,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),
  );
}
}
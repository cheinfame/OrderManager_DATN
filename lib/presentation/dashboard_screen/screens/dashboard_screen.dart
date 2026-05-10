import 'package:flutter/material.dart';
import 'package:packare_manage_web/presentation/dashboard_screen/screens/order_tab.dart';
import 'package:packare_manage_web/presentation/order_screen/screen/order_detail_screen.dart';
import '../../global_widgets/custom_app_bar.dart';
import '../../global_widgets/drawer.dart';
import '../../user_screen/screen/user_detail_screen.dart';
import 'user_tab.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  bool _isDrawerOpen = true;
  final Duration _animationDuration = Duration(milliseconds: 300);
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();
  int _selectedIndex = 0; // Track the selected index

  void _onDrawerItemTap(int index) {
    setState(() {
      _selectedIndex = index; // Update the selected index
      switch (index) {
        case 0:
          _navigatorKey.currentState?.pushReplacementNamed('/');
          break;
        case 1:
          _navigatorKey.currentState?.pushReplacementNamed('/orders'); // Change this line
          break;
        case 2:
          _navigatorKey.currentState?.pushReplacementNamed('/users');
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Packare',
        onMenuPressed: () {
          setState(() {
            _isDrawerOpen = !_isDrawerOpen;
          });
        },
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth > 900) {
            return Row(
              children: [
                _buildDrawer(MediaQuery.of(context).size.width * 0.2),
                Expanded(
                  flex: _isDrawerOpen ? 4 : 1,
                  child: Navigator(
                    key: _navigatorKey,
                    initialRoute: '/',
                    onGenerateRoute: (settings) {
                      WidgetBuilder builder;
                      switch (settings.name) {
                        case '/':
                          builder = (BuildContext _) => _buildTabs();
                          break;
                        case '/orders': // Change this line
                          builder = (BuildContext _) => OrderTabView();
                          break;
                        case '/users':
                          builder = (BuildContext _) => UserTabView();
                          break;
                        case '/user/:id': // Route for individual user details
                          final args = settings.arguments;
                          if (args is String) {
                            // If the argument is a String (accountId), navigate to UserDetailScreen
                            return MaterialPageRoute(
                              builder: (_) => UserDetailScreen(
                                accountId: args,
                              ),
                            );
                          }
                          // If the argument is not a String, or if no argument is provided, return an error route
                          return _errorRoute();
                        case '/order/:id': // Route for individual user details
                          final args = settings.arguments;
                          if (args is String) {
                            // If the argument is a String (accountId), navigate to UserDetailScreen
                            return MaterialPageRoute(
                              builder: (_) => OrderDetailScreen(
                                orderId: args,
                              ),
                            );
                          }
                          // If the argument is not a String, or if no argument is provided, return an error route
                          return _errorRoute();
                        default:
                          builder = (BuildContext _) => _buildTabs();
                      }
                      return MaterialPageRoute(builder: builder, settings: settings);
                    },
                  ),
                ),
              ],
            );
          } else {
            return Stack(
              children: [
                Navigator(
                  key: _navigatorKey,
                  initialRoute: '/',
                  onGenerateRoute: (settings) {
                    WidgetBuilder builder;
                    switch (settings.name) {
                      case '/':
                        builder = (BuildContext _) => _buildTabs();
                        break;
                      case '/orders': // Change this line
                        builder = (BuildContext _) => OrderTabView();
                        break;
                      case '/users':
                        builder = (BuildContext _) => UserTabView();
                        break;
                      default:
                        builder = (BuildContext _) => _buildTabs();
                    }
                    return MaterialPageRoute(builder: builder, settings: settings);
                  },
                ),
                _buildDrawer(MediaQuery.of(context).size.width),
              ],
            );
          }
        },
      ),
    );
  }

  Widget _buildTabs() {
    return Row(
      children: [
        Expanded(
          child: Container(
            color: _selectedIndex == 0 ? Colors.grey.shade900 : Colors.grey.shade200,
            padding: EdgeInsets.all(8),
            child: Text('Tab 1'),
          ),
        ),
        Expanded(
          child: GestureDetector(
            onTap: () => _onDrawerItemTap(1), // Handle tap to switch to OrderTabView
            child: Container(
              color: _selectedIndex == 1 ? Colors.grey.shade900 : Colors.grey.shade300,
              padding: EdgeInsets.all(8),
              child: Text('Orders'), // Change this line
            ),
          ),
        ),
        Expanded(
          child: Container(
            color: _selectedIndex == 2 ? Colors.grey.shade900 : Colors.grey.shade400,
            padding: EdgeInsets.all(8),
            child: Text('Tab 3'),
          ),
        ),
      ],
    );
  }

  Widget _buildDrawer(double width) {
    return AnimatedContainer(
      duration: _animationDuration,
      curve: Curves.easeInOut,
      width: _isDrawerOpen ? width : 0,
      child: buildDrawer(_selectedIndex, _onDrawerItemTap),
    );
  }

  // Error route
  MaterialPageRoute _errorRoute() {
    return MaterialPageRoute(
      builder: (_) => const Scaffold(
        body: Center(
          child: Text('Error: Page not found'),
        ),
      ),
    );
  }
}

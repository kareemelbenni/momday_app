import 'package:flutter/material.dart';
import 'package:momday_app/app_state_manager.dart';
import 'package:momday_app/momday_app.dart';
import 'package:momday_app/momday_navigator.dart';
import 'package:momday_app/momday_localizations.dart';
import 'package:momday_app/search/momday_search_delegate.dart';
import 'package:momday_app/search/search_helpers.dart';
import 'package:momday_app/styles/momday_colors.dart';

import '../styles/momday_colors.dart';
import '../styles/momday_colors.dart';
import '../styles/momday_colors.dart';
import '../styles/momday_colors.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();

  static _MainScreenState of(BuildContext context) {
    return context.ancestorStateOfType(const TypeMatcher<_MainScreenState>());
  }
}

class _MainScreenState extends State<MainScreen> {
  @override
  void initState() {
    super.initState();
    SearchHelper().init();
  }

  int _currentIndex = 0;

  final _navigatorKeys =
      List.generate(5, (int index) => GlobalKey<NavigatorState>());
  final _focusScopeNodes = List.generate(5, (_) => FocusScopeNode());

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return !await _navigatorKeys[_currentIndex].currentState.maybePop();
      },
      child: Scaffold(
        drawer: MomdayDrawer(
          navigationCallback: this.navigateToTab,
        ),
        backgroundColor: Colors.white,
        body: SafeArea(
            child: Stack(
                children: List.generate(
                    5, (int index) => this._buildOffstageNavigator(index)))),
        bottomNavigationBar: Theme(
          data: ThemeData(
            canvasColor: MomdayColors.MomdayDarkBlue,
            primaryColor: MomdayColors.Momdaypink,
          ),
          child: BottomNavigationBar(
              currentIndex: this._currentIndex,
              type: BottomNavigationBarType.fixed,
              onTap: (index) {
                setState(() {
                  this._currentIndex = index;
                });
                FocusScope.of(this.context)
                    .setFirstFocus(this._focusScopeNodes[index]);
              },
              items: <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                    icon: ImageIcon(
                      AssetImage('assets/images/logo_small.png'),
                      color: this._currentIndex != 0 ? Colors.white : null,
                    ),
                    title: Text(
                      tTitle(context, 'home'),
                      style: TextStyle(
                        color: this._currentIndex != 0 ? Colors.white : null,
                      ),
                    )),
                BottomNavigationBarItem(
                    icon: Icon(
                      Icons.star_border,
                      color: this._currentIndex != 1 ? Colors.white : null,
                    ),
                    title: Text(
                      tTitle(context, 'celebrities'),
                      style: TextStyle(
                        color: this._currentIndex != 1 ? Colors.white : null,
                      ),
                    )),
                BottomNavigationBarItem(
                    icon: Icon(
                      Icons.shopping_cart,
                      color: this._currentIndex != 2 ? Colors.white : null,
                    ),
                    title: Text(
                      tTitle(context, 'shop'),
                      style: TextStyle(
                        color: this._currentIndex != 2 ? Colors.white : null,
                      ),
                    )),
                BottomNavigationBarItem(
                    icon: Icon(
                      Icons.share,
                      color: this._currentIndex != 3 ? Colors.white : null,
                    ),
                    title: Text(
                      tTitle(context, 'activities'),
                      style: TextStyle(
                        color: this._currentIndex != 3 ? Colors.white : null,
                      ),
                    )),
                BottomNavigationBarItem(
                    icon: Icon(
                      Icons.chat_bubble_outline,
                      color: this._currentIndex != 4 ? Colors.white : null,
                    ),
                    title: Text(
                      tTitle(context, 'momsay'),
                      style: TextStyle(
                        color: this._currentIndex != 4 ? Colors.white : null,
                      ),
                    )),
              ]),
        ),
      ),
    );
  }

  void navigateToTab(int tabIndex, [String route]) {
    setState(() {
      this._currentIndex = tabIndex;
    });

    FocusScope.of(this.context).setFirstFocus(this._focusScopeNodes[tabIndex]);

    if (route != null) {
      this._navigatorKeys[tabIndex].currentState.pushNamed(route);
    }
  }

  Widget _buildOffstageNavigator(int tabIndex) {
    return Offstage(
      offstage: this._currentIndex != tabIndex,
      child: MomdayNavigator.of(tabIndex, this._navigatorKeys[tabIndex],
          this._focusScopeNodes[tabIndex]),
    );
  }

  startSearch() async {
    SearchCriteria searchCriteria = await showSearch(
        context: this
            .context, // for some reason, only the context that contains the scaffold works
        delegate: MomdaySearchDelegate());

    if (searchCriteria != null) {
      this.navigateToTab(2, '/product-listing?${searchCriteria.toString()}');
    }
  }

  Widget getMomdayBar() {
    return Stack(children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Builder(
            builder: (context) {
              return IconWithNumber(
                isButton: true,
                iconData: Icons.menu,
                number: AppStateManager.of(context).notifications?.length,
                onTap: () {
                  Scaffold.of(context).openDrawer();
                },
              );
            },
          ),
          Row(
            children: <Widget>[
              // Put them in builders to give them separate context
              // That way, not the whole thing subscribes to AppStateManager change
//                Container(
//                  margin: EdgeInsetsDirectional.only(start: 15),
//                  child: IconButton(
//                    icon: Icon(Icons.search),
//                    onPressed: () async {
//                      this.startSearch();
//                    },
//                  ),
//                ),
              Builder(
                builder: (context) {
                  return IconWithNumber(
                    iconData: Icons.favorite,
                    isButton: true,
                    onTap: () {
                      this.navigateToTab(2, '/wishlist');
                    },
                    number:
                        AppStateManager.of(context).wishlist.products.length,
                  );
                },
              ),
              Builder(
                builder: (context) {
                  return IconWithNumber(
                    iconData: Icons.shopping_cart,
                    isButton: true,
                    onTap: () {
                      this.navigateToTab(2, '/cart');
                    },
                    number: AppStateManager.of(context).cart.products.length,
                  );
                },
              ),
            ],
          ),
        ],
      ),
      Positioned(
        top: 8.0,
        bottom: 0.0,
        left: 0.0,
        right: 0.0,
        child: Align(
          child: Center(
            child: FlatButton(
              splashColor: Colors.transparent,
              child: Image(
                image: AssetImage('assets/images/logo_full.png'),
                height: 40.0,
                fit: BoxFit.fitHeight,
              ),
              onPressed: () {
                this.navigateToTab(0);
              },
            ),
          ),
        ),
      ),
    ]);
  }
}

typedef NavigationCallback(int index, [String path]);

class MomdayDrawer extends StatelessWidget {
  final NavigationCallback navigationCallback;

  MomdayDrawer({this.navigationCallback});

  @override
  Widget build(BuildContext context) {
    var appStateManager = AppStateManager.of(context);
    var languageCode = Localizations.localeOf(context).languageCode;
    var isLoggedIn = appStateManager.account.isLoggedIn;
    var isCelebrity = appStateManager.account.isCelebrity;

    List<Widget> initialChildren = !isLoggedIn
        ? [
            ListTile(
              leading: Image(
                colorBlendMode: BlendMode.xor,
                image: AssetImage('assets/images/logo_full_white.png'),
                fit: BoxFit.fill,
                width: 200.0,
              ),
              contentPadding: EdgeInsetsDirectional.only(
                  top: 80.0, bottom: 10.0, start: 40.0),
            ),
            Divider(
              color: MomdayColors.MomdayDarkBlue,
            )
          ]
        : [];

    return Theme(
      data: ThemeData(
          canvasColor: MomdayColors.Momdaypink,
          brightness: Brightness.dark,
          textTheme: TextTheme(
              body2: TextStyle(fontWeight: FontWeight.w500, fontSize: 20.0)),
          iconTheme:
              IconThemeData(size: 28.0, color: Colors.white, opacity: 0.9),
          dividerColor: Colors.black),
      child: Padding(
        padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.75,
          child: Drawer(
              child: ListView(
            padding: EdgeInsets.zero,
            children: initialChildren
              ..addAll([
                isLoggedIn
                    ? ListTile(
                        leading: Icon(Icons.person_outline),
                        title: Text(tTitle(context, 'my_account')),
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 12.0, horizontal: 16.0),
                        onTap: () {
                          Navigator.of(context).pop();
                          Navigator.of(context).pushNamed('/my-account');
                        },
                      )
                    : Ink(
                        color: MomdayColors.MomdayBlue,
                        child: ListTile(
                            leading: Icon(
                              Icons.person_outline,
                              color: MomdayColors.MomdayDarkBlue,
                            ),
                            title: Text(
                              tTitle(context, 'log_in') +
                                  ' | ' +
                                  tTitle(context, 'sign_up'),
                              style:
                                  TextStyle(color: MomdayColors.MomdayDarkBlue),
                            ),
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 12.0, horizontal: 16.0),
                            onTap: () {
                              Navigator.of(context).pop();
                              Navigator.of(context).pushNamed('/login');
                            })),
              ])
              ..addAll(isCelebrity
                  ? [
                      ListTile(
                        leading: Icon(Icons.shop),
                        title: Text(tTitle(context, 'my_store')),
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 12.0, horizontal: 16.0),
                        onTap: () {
                          Navigator.of(context).pop();
                          MainScreen.of(context).navigateToTab(1,
                              '/celebrity/${appStateManager.account.customerId}');
                        },
                      ),
                      Divider()
                    ]
                  : [])
//              ..addAll(isLoggedIn?
//              [
//                ListTile(
//                  leading: Icon(Icons.style),
//                  title: Text(tTitle(context, 'my_list')),
//                  contentPadding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
//                  onTap: () {
//                    this.navigationCallback(2, '/my-list');
//                    Navigator.of(context).pop();
//                  },
//                ),
//                Divider(),
//                ListTile(
//                  leading: IconWithNumber(
//                    isButton: false,
//                    iconData: Icons.notifications_none,
//                    number: appStateManager.notifications?.length,
//                  ),
//                  title: Text(tTitle(context, 'notifications')),
//                  contentPadding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
//                  onTap: () {
//                    this.navigationCallback(2, '/wishlist');
//                    Navigator.of(context).pop();
//                  },
//                ),
//                Divider(),
//                ListTile(
//                  leading: IconWithNumber(
//                    isButton: false,
//                    iconData: Icons.favorite_border,
//                    number: appStateManager.wishlist?.products?.length,
//                  ),
//                  title: Text(tTitle(context, 'wishlist')),
//                  contentPadding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
//                  onTap: () {
//                    this.navigationCallback(2, '/wishlist');
//                    Navigator.of(context).pop();
//                  },
//                ),
//                Divider(),
//              ] : [])
              ..addAll([
                Ink(
                  child: ListTile(
                    leading: Icon(
                      Icons.smartphone,
                      color: MomdayColors.MomdayDarkYellow,
                    ),
                    title: Text(
                      tTitle(context, 'about'),
                      style: TextStyle(color: MomdayColors.MomdayDarkYellow),
                    ),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                  ),
                  color: MomdayColors.MomdayDarkGreen,
                ),
                Ink(
                  child: ListTile(
                    leading: Icon(
                      Icons.language,
                      color: MomdayColors.MomdayRed,
                    ),
                    title: Text(languageCode == 'en' ? 'العربية' : 'English',
                        style: TextStyle(color: MomdayColors.MomdayRed)),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                    onTap: () async {
                      if (languageCode == 'en') {
                        MomdayApp.updateLocale(context, Locale('ar'));
                      } else {
                        MomdayApp.updateLocale(context, Locale('en'));
                      }
                    },
                  ),
                  color: MomdayColors.Momdaypink,
                ),
                Ink(
                  child: ListTile(
                    leading: Icon(
                      Icons.help_outline,
                      color: MomdayColors.Momdaypink,
                    ),
                    title: Text(
                        tUpper(
                          context,
                          'faq',
                        ),
                        style: TextStyle(color: MomdayColors.Momdaypink)),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                  ),
                  color: MomdayColors.MomdayDarkBlue,
                ),
                Ink(
                  child: ListTile(
                    leading: Icon(Icons.mail_outline, color: Colors.white),
                    title: Text(
                      tTitle(context, 'contact_us'),
                      style: TextStyle(color: Colors.white),
                    ),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                  ),
                  color: MomdayColors.MomdayDarkYellow,
                ),
              ]),
          )),
        ),
      ),
    );
  }
}

class IconWithNumber extends StatelessWidget {
  final IconData iconData;
  final int number;
  final GestureTapCallback onTap;
  final bool isButton;
  IconWithNumber(
      {this.iconData, this.number, this.onTap, this.isButton = false});

  @override
  Widget build(BuildContext context) {
    return Stack(overflow: Overflow.visible, children: [
      this.isButton
          ? IconButton(
              icon: Icon(this.iconData),
              color: MomdayColors.MomdayDarkBlue,
              onPressed: this.onTap,
            )
          : Icon(
              this.iconData,
            ),
      number > 0
          ? PositionedDirectional(
              end: isButton ? 5.0 : -5.0,
              top: isButton ? 10.0 : -3.0,
              height: 14.0,
              width: 14.0,
              child: GestureDetector(
                onTap: onTap,
                child: Container(
                  alignment: Alignment.center,
                  foregroundDecoration: BoxDecoration(
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(25.0)),
                  decoration: BoxDecoration(
                      color: MomdayColors.MomdayGold, shape: BoxShape.circle),
                  child: Text(
                    number.toString(),
                    style: TextStyle(
                        color: MomdayColors.MomdayGray, fontSize: 10.0),
                  ),
                ),
              ),
            )
          : Container(
              height: 0.0,
              width: 0.0,
            )
    ]);
  }
}

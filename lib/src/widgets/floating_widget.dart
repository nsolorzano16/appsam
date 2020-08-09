import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MenuItemCostum {
  final Function onpressed;
  final IconData icon;

  MenuItemCostum({@required this.onpressed, @required this.icon});
}

class FloatingMenuCustom extends StatelessWidget {
  final List<MenuItemCostum> items = [
    MenuItemCostum(
        icon: Icons.search,
        onpressed: () {
          print('hola');
        }),
    MenuItemCostum(
        icon: Icons.notifications,
        onpressed: () {
          print('hola');
        }),
    MenuItemCostum(
        icon: Icons.supervised_user_circle,
        onpressed: () {
          print('hola');
        }),
    MenuItemCostum(
        icon: Icons.supervised_user_circle,
        onpressed: () {
          print('hola');
        }),
  ];

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => new _MenuModel(),
      child: _FloatingMenuBackground(
        child: _MenuItems(menuItems: items),
      ),
    );
  }
}

class _FloatingMenuBackground extends StatelessWidget {
  final Widget child;

  const _FloatingMenuBackground({Key key, @required this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: child,
      width: 250,
      height: 60,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(100.0),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black38,
            // offset: Offset(10, 10),
            blurRadius: 10,
            spreadRadius: -5,
          ),
        ],
      ),
    );
  }
}

class _MenuItems extends StatelessWidget {
  final List<MenuItemCostum> menuItems;

  const _MenuItems({Key key, this.menuItems}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(
            menuItems.length,
            (index) => _MenuButton(
                  index: index,
                  item: menuItems[index],
                )));
  }
}

class _MenuButton extends StatelessWidget {
  final int index;
  final MenuItemCostum item;

  const _MenuButton({Key key, this.index, this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final itemSelected = Provider.of<_MenuModel>(context).itemSelected;

    return IconButton(
        highlightColor: Colors.transparent,
        splashColor: Colors.white.withOpacity(0.1),
        icon: Icon(
          item.icon,
          size: (itemSelected == index) ? 30 : 20,
          color: (itemSelected == index) ? Colors.black : Colors.blueGrey,
        ),
        onPressed: () {
          Provider.of<_MenuModel>(context, listen: false).itemSelected = index;
          item.onpressed();
        });
  }
}

class _MenuModel with ChangeNotifier {
  int _itemSelected = 0;

  int get itemSelected => this._itemSelected;

  set itemSelected(int index) {
    this._itemSelected = index;
    notifyListeners();
  }
}

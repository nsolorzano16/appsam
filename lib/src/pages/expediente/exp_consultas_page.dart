import 'package:appsam/src/models/expediente_model.dart';
import 'package:flutter/material.dart';

const duration = Duration(milliseconds: 300);

class ExpConsultas extends StatefulWidget {
  final List<Consulta> consultas;

  const ExpConsultas({@required this.consultas});

  @override
  _ExpConsultasState createState() => _ExpConsultasState();
}

class _ExpConsultasState extends State<ExpConsultas> {
  int _currentPage = 0;
  List<Consulta> get _consultas => widget.consultas;

  @override
  Widget build(BuildContext context) {
    return Container(
        // color: Color.fromRGBO(255, 244, 233, 1),
        color: Colors.blue,
        child: Column(
          children: <Widget>[
            Expanded(
                child: PageView.builder(
              itemCount: _consultas.length,
              onPageChanged: (page) {
                setState(() {
                  _currentPage = page;
                });
              },
              controller: PageController(viewportFraction: 0.8),
              itemBuilder: (_, index) => AnimatedOpacity(
                opacity: _currentPage == index ? 1.0 : 0.5,
                duration: duration,
                child: _ItemConsulta(
                  consulta: _consultas[index],
                  itemSelected: _currentPage == index,
                ),
              ),
            ))
          ],
        ));
  }
}

class _ItemConsulta extends StatefulWidget {
  final bool itemSelected;
  final Consulta consulta;

  const _ItemConsulta({Key key, this.itemSelected, this.consulta})
      : super(key: key);

  @override
  __ItemConsultaState createState() => __ItemConsultaState();
}

class __ItemConsultaState extends State<_ItemConsulta> {
  bool _selected = false;
  Consulta get _consulta => widget.consulta;
  bool get _itemSelected => widget.itemSelected;

  @override
  Widget build(BuildContext context) {
    if (!_itemSelected) _selected = false;
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final itemHeight =
            constraints.maxHeight * (_itemSelected ? 0.40 : 0.42);
        final itemWidth = constraints.maxWidth * 0.90;

        final borderRadius = BorderRadius.circular(15);
        final backWidth = _selected ? itemWidth * 1.05 : itemWidth;
        final backHeight = _selected ? itemHeight * 1.2 : itemHeight;

        return Container(
          color: Colors.red[100],
          alignment: Alignment.center,
          child: GestureDetector(
            onTap: _onTap,
            onVerticalDragUpdate: _onVerticalDrag,
            child: Stack(
              children: <Widget>[
                _BackItem(
                    backHeight: backHeight,
                    backWidth: backWidth,
                    selected: _selected,
                    itemHeight: itemHeight),
                _FrontItem(
                    itemHeight: itemHeight,
                    itemWidth: itemWidth,
                    selected: _selected,
                    consulta: _consulta)
              ],
            ),
          ),
        );
      },
    );
  }

  void _onTap() {
    if (_selected) {
      final page = TravelConceptDetailPage(
        location: _consulta,
      );
      Navigator.of(context).push(
        PageRouteBuilder(
            transitionDuration: const Duration(milliseconds: 700),
            pageBuilder: (_, animation1, __) => page,
            transitionsBuilder: (_, animation1, animation2, child) {
              return FadeTransition(
                opacity: animation1,
                child: child,
              );
            }),
      );
    } else {
      setState(() {
        _selected = !_selected;
      });
    }
  }

  void _onVerticalDrag(DragUpdateDetails details) {
    if (details.primaryDelta > 3.0) {
      setState(() {
        _selected = false;
      });
    }
  }

  Widget _buildStar({bool starSelected = true}) => Expanded(
        child: Icon(
          Icons.star,
          size: 20,
          color: starSelected ? Colors.blueAccent : Colors.grey,
        ),
      );
}

class _FrontItem extends StatelessWidget {
  const _FrontItem({
    Key key,
    @required this.itemHeight,
    @required this.itemWidth,
    @required bool selected,
    @required Consulta consulta,
  })  : _selected = selected,
        _consulta = consulta,
        super(key: key);

  final double itemHeight;
  final double itemWidth;
  final bool _selected;
  final Consulta _consulta;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedContainer(
          decoration: BoxDecoration(boxShadow: [
            BoxShadow(
              color: Colors.grey,
              blurRadius: 7,
            )
          ], borderRadius: BorderRadius.circular(20), color: Colors.white),
          duration: duration,
          height: itemHeight,
          width: itemWidth,
          margin: EdgeInsets.only(bottom: _selected ? itemHeight * 1.3 : 0),
          child: Stack(
            children: <Widget>[
              Positioned.fill(
                  child: Hero(
                      tag: _consulta.preclinica.preclinicaId,
                      child: Container()))
            ],
          )),
    );
  }
}

class _BackItem extends StatelessWidget {
  const _BackItem({
    Key key,
    @required this.backHeight,
    @required this.backWidth,
    @required bool selected,
    @required this.itemHeight,
  })  : _selected = selected,
        super(key: key);

  final double backHeight;
  final double backWidth;
  final bool _selected;
  final double itemHeight;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedContainer(
          decoration: BoxDecoration(boxShadow: [
            BoxShadow(
              color: Colors.grey,
              blurRadius: 7,
            )
          ], borderRadius: BorderRadius.circular(20), color: Colors.white),
          duration: duration,
          height: backHeight,
          width: backWidth,
          margin: EdgeInsets.only(top: _selected ? itemHeight * 0.5 : 0),
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 60,
              ),
              Text('txto 1'),
              Text('txto'),
              Text('txto'),
              Text('txto'),
              Text('txto'),
              Text('txto'),
            ],
          )),
    );
  }
}

class TravelConceptDetailPage extends StatelessWidget {
  final Consulta location;

  const TravelConceptDetailPage({Key key, this.location}) : super(key: key);

  void _onVerticalDrag(
    DragUpdateDetails details,
    BuildContext context,
  ) {
    if (details.primaryDelta > 3.0) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          GestureDetector(
            onVerticalDragUpdate: (details) =>
                _onVerticalDrag(details, context),
            child: Hero(
              tag: location.preclinica.preclinicaId,
              child: Image.network(
                'https://previews.123rf.com/images/djvstock/djvstock1610/djvstock161004214/64799755-teen-girl-character-avatar-vector-illustration-design.jpg',
                fit: BoxFit.cover,
              ),
            ),
          ),
          ...List.generate((20), (index) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(
                      'https://previews.123rf.com/images/djvstock/djvstock1610/djvstock161004214/64799755-teen-girl-character-avatar-vector-illustration-design.jpg'),
                  radius: 15,
                ),
                title: Text('The Dart Side'),
                subtitle: Text(
                    'Come to the Dart Side :) ..... $index\nline 22222 \nline 33'),
              ),
            );
          })
        ],
      ),
    );
  }
}

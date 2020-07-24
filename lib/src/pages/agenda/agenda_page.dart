import 'package:appsam/src/extensions/color_ext.dart';
import 'package:appsam/src/models/eventos_model.dart';
import 'package:appsam/src/models/usuario_model.dart';
import 'package:appsam/src/pages/agenda/agendaDetalle_page.dart';
import 'package:appsam/src/providers/calendarioFecha_service.dart';
import 'package:appsam/src/utils/storage_util.dart';
import 'package:appsam/src/utils/utils.dart';
import 'package:appsam/src/widgets/drawer.dart';
import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

const double itemSize = 70;

class AgendaPage extends StatefulWidget {
  static final String routeName = 'agenda';

  @override
  _AgendaPageState createState() => _AgendaPageState();
}

class _AgendaPageState extends State<AgendaPage> with TickerProviderStateMixin {
  Map<DateTime, List> _events;

  List _selectedEvents;
  final UsuarioModel _usuario =
      usuarioModelFromJson(StorageUtil.getString('usuarioGlobal'));
  Future<List<EventosModel>> eventosFuture;

  final eventoService = new EventosService();
  AnimationController _animationController;
  CalendarController _calendarController;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    _events = {};

    _selectedEvents = [];
    _calendarController = CalendarController();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _animationController.forward();
    _scrollController.addListener(onListen);
  }

  @override
  void dispose() {
    _animationController.dispose();
    _calendarController.dispose();
    _scrollController.removeListener(onListen);
    super.dispose();
  }

  void onListen() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (_usuario.rolId == 2) {
      eventosFuture = eventoService.getEventos(_usuario.usuarioId);
    } else if (_usuario.rolId == 3) {
      eventosFuture = eventoService.getEventos(_usuario.asistenteId);
    }

    return WillPopScope(
      child: Scaffold(
        backgroundColor: colorFondoApp(),
        drawer: MenuWidget(),
        appBar: AppBar(
          title: Text('Agenda'),
        ),
        body: FutureBuilder(
          future: eventosFuture,
          builder: (BuildContext context,
              AsyncSnapshot<List<EventosModel>> snapshot) {
            if (!snapshot.hasData) return loadingIndicator(context);
            return Container(
              child: Column(
                children: <Widget>[
                  //_buildTableCalendar(),
                  _buildTableCalendarWithBuilders(snapshot.data),
                  const SizedBox(
                    height: 10.0,
                  ),
                  const SizedBox(height: 8.0),
                  Expanded(child: _buildEventList()),
                ],
              ),
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () =>
              Navigator.pushReplacementNamed(context, 'crear_agenda'),
          child: Icon(Icons.add),
        ),
      ),
      onWillPop: () async => false,
    );
  }

  void _onDaySelected(DateTime day, List events, List holidays) {
    print('CALLBACK: _onDaySelected');
    setState(() {
      _selectedEvents.clear();
      _selectedEvents.addAll(events);
    });
  }

  void _onVisibleDaysChanged(
      DateTime first, DateTime last, CalendarFormat format) {
    print('CALLBACK: _onVisibleDaysChanged');
    // _selectedEvents = [];
    // setState(() {});
  }

  void _onCalendarCreated(
      DateTime first, DateTime last, CalendarFormat format) {
    print('CALLBACK: _onCalendarCreated');
  }

  // More advanced TableCalendar configuration (using Builders & Styles)
  Widget _buildTableCalendarWithBuilders(List<EventosModel> eventos) {
    eventos.forEach((item) {
      Map<DateTime, List<dynamic>> mapTemp = {item.date: item.events};
      _events.addAll(mapTemp);
    });
    return TableCalendar(
      locale: 'es_ES',
      calendarController: _calendarController,
      events: _events,
      initialCalendarFormat: CalendarFormat.month,
      formatAnimation: FormatAnimation.slide,
      startingDayOfWeek: StartingDayOfWeek.sunday,
      availableGestures: AvailableGestures.all,
      availableCalendarFormats: const {
        CalendarFormat.month: '',
      },
      calendarStyle: CalendarStyle(
        outsideDaysVisible: false,
        weekendStyle: TextStyle().copyWith(color: Colors.red[800]),
      ),
      daysOfWeekStyle: DaysOfWeekStyle(
        weekendStyle: TextStyle().copyWith(color: Colors.red[600]),
      ),
      headerStyle: HeaderStyle(
        centerHeaderTitle: true,
        formatButtonVisible: false,
      ),
      builders: CalendarBuilders(
        selectedDayBuilder: (context, date, _) {
          return FadeTransition(
            opacity: Tween(begin: 0.0, end: 1.0).animate(_animationController),
            child: Container(
              margin: const EdgeInsets.all(4.0),
              padding: const EdgeInsets.only(top: 5.0, left: 6.0),
              color: Colors.red,
              width: 100,
              height: 100,
              child: Text(
                '${date.day}',
                style:
                    TextStyle().copyWith(fontSize: 16.0, color: Colors.white),
              ),
            ),
          );
        },
        todayDayBuilder: (context, date, _) {
          return Container(
            margin: const EdgeInsets.all(4.0),
            padding: const EdgeInsets.only(top: 5.0, left: 6.0),
            color: Colors.orange,
            width: 100,
            height: 100,
            child: Text(
              '${date.day}',
              style: TextStyle().copyWith(fontSize: 16.0, color: Colors.white),
            ),
          );
        },
        markersBuilder: (context, date, events, holidays) {
          final children = <Widget>[];

          if (events.isNotEmpty) {
            children.add(
              Positioned(
                right: 1,
                bottom: 1,
                child: _buildEventsMarker(date, events),
              ),
            );
          }

          return children;
        },
      ),
      onDaySelected: (date, events) {
        _onDaySelected(date, events, events);
        _animationController.forward(from: 0.0);
      },
      onVisibleDaysChanged: _onVisibleDaysChanged,
      onCalendarCreated: _onCalendarCreated,
    );
  }

  Widget _buildEventsMarker(DateTime date, List events) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: _calendarController.isSelected(date)
            ? Colors.brown[500]
            : _calendarController.isToday(date)
                ? Colors.brown[300]
                : Colors.blue[400],
      ),
      width: 25.0,
      height: 25.0,
      child: Center(
        child: Text(
          (events.length > 9) ? '+10' : '${events.length}',
          style: TextStyle().copyWith(
            color: Colors.white,
            fontSize: 12.0,
          ),
        ),
      ),
    );
  }

  Widget _buildEventList() {
    final format = DateFormat.Hm('es_Es');
    return ListView(
      children: _selectedEvents
          .map((event) => Container(
                margin: EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.0),
                    border: Border.all(
                        width: 3,
                        color: HexColor.fromHex(event.colorPrimario))),
                child: ListTile(
                  dense: true,
                  title: Text('Título: ${event.notas}'),
                  subtitle: Text(
                    'Hora inicio: ${format.format(event.inicio)} - Hora fin: ${format.format(event.fin)} ',
                    style: TextStyle(color: Colors.black),
                  ),
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    color: HexColor.fromHex(event.colorSecundario),
                  ),
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute<void>(
                        builder: (BuildContext context) {
                      return AgendaDetallePage(
                        evento: event,
                      );
                    }));
                  },
                ),
              ))
          .toList(),
    );
  }
}

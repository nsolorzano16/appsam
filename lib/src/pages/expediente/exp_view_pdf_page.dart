import 'package:appsam/src/providers/consulta_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_full_pdf_viewer/flutter_full_pdf_viewer.dart';

class ViewPDFPage extends StatefulWidget {
  final int pacienteId;
  final int doctorId;

  const ViewPDFPage({@required this.pacienteId, @required this.doctorId});

  @override
  _ViewPDFPageState createState() => _ViewPDFPageState();
}

class _ViewPDFPageState extends State<ViewPDFPage> {
  int get _pacienteId => widget.pacienteId;
  int get _doctorId => widget.doctorId;

  final ConsultaService _consultaService = new ConsultaService();
  String pathPDf = '';
  bool loading = true;

  @override
  void initState() {
    _consultaService.getExpedientePDF(_pacienteId, _doctorId).then((f) {
      setState(() {
        pathPDf = f.path;
        loading = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return (pathPDf.isNotEmpty && !loading)
        ? PDFViewerScaffold(
            path: pathPDf,
            appBar: AppBar(
              title: Text('Expediente'),
            ),
          )
        : Scaffold(
            appBar: AppBar(
              title: Text('Expediente'),
            ),
            body: Center(child: CircularProgressIndicator()),
          );
  }
}

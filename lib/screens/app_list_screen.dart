import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'app_form_screen.dart';
import 'package:app_manager/models/app_model.dart';

class AppListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Catálogo de Aplicativos'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('apps').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Erro ao carregar dados.'));
          }

          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          // Agrupando aplicativos por categoria
          final apps = snapshot.data!.docs.map((doc) => AppModel.fromMap(doc.data() as Map<String, dynamic>, doc.id)).toList();
          final Map<String, List<AppModel>> appsByCategory = {};

          for (var app in apps) {
            if (!appsByCategory.containsKey(app.category)) {
              appsByCategory[app.category] = [];
            }
            appsByCategory[app.category]!.add(app);
          }

          // Exibindo categorias
          return ListView(
            children: appsByCategory.keys.map((category) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      category,
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(
                    height: 150,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: appsByCategory[category]!.length,
                      itemBuilder: (context, index) {
                        final app = appsByCategory[category]![index];
                        return GestureDetector(
                          onTap: () => _showAppDetails(context, app),
                          child: Card(
                            child: Container(
                              width: 120,
                              padding: EdgeInsets.all(8.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(app.title, style: TextStyle(fontWeight: FontWeight.bold)),
                                  SizedBox(height: 8),
                                  Text(app.description, maxLines: 2, overflow: TextOverflow.ellipsis),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              );
            }).toList(),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AppFormScreen()),
        ),
        child: Icon(Icons.add),
      ),
    );
  }

  // Método para mostrar detalhes do aplicativo em um popup
  void _showAppDetails(BuildContext context, AppModel app) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(app.title),
          content: Text(app.description),
          actions: [
            TextButton(
              child: Text('Fechar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }



  Future<void> _deleteApp(BuildContext context, String docId) async {
    try {
      await FirebaseFirestore.instance.collection('apps').doc(docId).delete();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Aplicativo excluído com sucesso!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao excluir aplicativo.')),
      );
    }
  }
}
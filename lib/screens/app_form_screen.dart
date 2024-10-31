import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AppFormScreen extends StatefulWidget {
  final String? docId;
  final String? title;
  final String? description;
  final String? category;

  AppFormScreen({this.docId, this.title, this.description, this.category});

  @override
  _AppFormScreenState createState() => _AppFormScreenState();
}

class _AppFormScreenState extends State<AppFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _categoryController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.title != null) {
      _titleController.text = widget.title!;
    }
    if (widget.description != null) {
      _descriptionController.text = widget.description!;
    }
    if (widget.category != null) {
      _categoryController.text = widget.category!;
    }
  }

  Future<void> _saveApp() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      if (widget.docId == null) {
        // Adicionar novo aplicativo
        await FirebaseFirestore.instance.collection('apps').add({
          'title': _titleController.text,
          'description': _descriptionController.text,
          'category': _categoryController.text,
        });
      } else {
        // Atualizar aplicativo existente
        await FirebaseFirestore.instance.collection('apps').doc(widget.docId).update({
          'title': _titleController.text,
          'description': _descriptionController.text,
          'category': _categoryController.text,
        });
      }
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Aplicativo salvo com sucesso!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao salvar aplicativo.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.docId == null ? 'Novo Aplicativo' : 'Editar Aplicativo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              SizedBox(height: 30),
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(labelText: 'Título'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o título';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Descrição'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira a descrição';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _categoryController,
                decoration: InputDecoration(labelText: 'Categoria'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira a categoria';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveApp,
                child: Text('Salvar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

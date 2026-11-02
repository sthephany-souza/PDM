import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Contato {
  final String nome;
  final String telefone;
  final String email;

  Contato({
    required this.nome,
    required this.telefone,
    required this.email,
  });

  Map<String, dynamic> toMap() {
    return {
      'nome': nome,
      'telefone': telefone,
      'email': email,
    };
  }

  factory Contato.fromMap(Map<String, dynamic> map) {
    return Contato(
      nome: map['nome'] ?? '',
      telefone: map['telefone'] ?? '',
      email: map['email'] ?? '',
    );
  }
}

class Agenda extends StatefulWidget {
  const Agenda({super.key});

  @override
  State<Agenda> createState() => AgendaState();
}

class AgendaState extends State<Agenda> {
  List<Contato> _contatos = [];
  List<Contato> _contatosFiltrados = [];

  final TextEditingController _buscaController = TextEditingController();
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _telefoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _carregarContatos();
  }

  // Persistência: Carregar dados salvos
  Future<void> _carregarContatos() async {
    final prefs = await SharedPreferences.getInstance();
    final String? contatosJson = prefs.getString('contatos');

    if (contatosJson != null) {
      final List<dynamic> jsonList = jsonDecode(contatosJson);
      setState(() {
        _contatos = jsonList.map((map) => Contato.fromMap(map)).toList();
        _contatosFiltrados = List.from(_contatos);
      });
    }
  }

  // Persistência: Salvar dados
  Future<void> _salvarContatos() async {
    final prefs = await SharedPreferences.getInstance();
    final String jsonList = jsonEncode(
      _contatos.map((c) => c.toMap()).toList(),
    );
    await prefs.setString('contatos', jsonList);
  }

  // Funcionalidade de Busca por Nome
  void _filtrarContatos(String query) {
    setState(() {
      _contatosFiltrados = _contatos
          .where((contato) =>
              contato.nome.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  // Adicionar novo contato
  void _adicionarContato() {
    if (_nomeController.text.isEmpty || _telefoneController.text.isEmpty) {
      return;
    }

    final novoContato = Contato(
      nome: _nomeController.text.trim(),
      telefone: _telefoneController.text.trim(),
      email: _emailController.text.trim(),
    );

    setState(() {
      _contatos.add(novoContato);
      _filtrarContatos(_buscaController.text);
    });

    _salvarContatos();

    _nomeController.clear();
    _telefoneController.clear();
    _emailController.clear();
    Navigator.of(context).pop();
  }

  // Excluir contato
  void _removerContato(int index) {
    setState(() {
      final contatoRemovido = _contatosFiltrados[index];
      _contatos.remove(contatoRemovido);
      _filtrarContatos(_buscaController.text);
    });
    _salvarContatos();
  }

  // Modal para formulário de cadastro
  void _exibirFormulario() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          top: 16,
          left: 16,
          right: 16,
          bottom: MediaQuery.of(ctx).viewInsets.bottom + 16,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Novo Contato',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            TextField(
              controller: _nomeController,
              decoration: const InputDecoration(labelText: 'Nome'),
            ),
            TextField(
              controller: _telefoneController,
              decoration: const InputDecoration(labelText: 'Telefone'),
              keyboardType: TextInputType.phone,
            ),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'E-mail'),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _adicionarContato,
              child: const Text('Salvar'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agenda Telefônica'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Column(
        children: [
          // Campo de Busca
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              controller: _buscaController,
              onChanged: _filtrarContatos,
              decoration: InputDecoration(
                labelText: 'Buscar por nome',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
          // Lista de Contatos
          Expanded(
            child: _contatosFiltrados.isEmpty
                ? const Center(child: Text('Nenhum contato encontrado.'))
                : ListView.builder(
                    itemCount: _contatosFiltrados.length,
                    itemBuilder: (context, index) {
                      final contato = _contatosFiltrados[index];
                      return ListTile(
                        leading: CircleAvatar(
                          child: Text(contato.nome[0].toUpperCase()),
                        ),
                        title: Text(contato.nome),
                        subtitle: Text('${contato.telefone}\n${contato.email}'),
                        isThreeLine: true,
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _removerContato(index),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _exibirFormulario,
        child: const Icon(Icons.add),
      ),
    );
  }
}
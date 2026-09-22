import 'dart:io';

void main() {
  print("=== TechStorage - Gestão de Inventário ===");

  stdout.write("Digite o nome da categoria de produtos: ");
  String categoria = stdin.readLineSync() ?? ""; // ✅ ERRO DE COMPILAÇÃO - Corrigido

  // Lista de produtos representados por Mapas
  List<Map<String, dynamic>> inventario = [];

  // O loop abaixo deveria rodar 3 vezes para cadastrar 3 produtos
  for (var i = 1; i <= 3; i++) {
    stdout.write("\nNome do Produto $i: ");
    String nomeProd = stdin.readLineSync() ?? ""; // ✅ ERRO DE COMPILAÇÃO - Corrigido

    stdout.write("Preço do Produto $i: ");
    String? valorPreco = stdin.readLineSync();

    double precoProd = double.tryParse(valorPreco ?? "") ?? 0.0; // ✅ ERRO DE COMPILAÇÃO - Corrigido

    // ✅  Criando o mapa do produto - Feito
    Map<String, dynamic> produto = {
      "nome": nomeProd, 
      "preco": precoProd
    };

    inventario.add(produto);
  }

  print("\n--- Processando Relatório de Depreciação ---");

  // ✅ Chamada de função confusa com parâmetros posicionais idênticos - Corrgido
  // ✅ O desenvolvedor queria passar: categoria, inventario, e taxa de desconto (15%) - Corrgido
  exibirECalcularRelatorio( cat: categoria, itens: inventario, taxa: 0.15);
}

double calcularDepreciacao(double preco, double taxa) => preco * (1 - taxa);// ✅ ERRO DE COMPILAÇÃO/EXECUÇÃO - Corrgido

String formatarItem(Map<String, dynamic> item, double taxa) => "Produto: ${item['nome']} | Preço Depreciado: R\$ ${calcularDepreciacao((item['preco'] as num).toDouble(), taxa).toStringAsFixed(2)}";

// ✅ ERRO DE COMPILAÇÃO E MÁ PRÁTICA: Parâmetros posicionais confusos. - Corrigido
// ✅ ERRO DE COMPILAÇÃO: O tipo de retorno e os tipos internos do mapa estão gerando conflito. - Corrigido
void exibirECalcularRelatorio({
  required List<Map<String, dynamic>> itens,
  required String cat,
  required  taxa,
}) {
  print("Categoria Analisada: $cat");

  // ✅ O desenvolvedor tentou atualizar o preço de cada item subtraindo a taxa,
  // mas o Dart reclama de tipos e mutabilidade. - Corrgido
  // ✅ O objetivo era atualizar o mapa e mostrar na tela usando Arrow Function se possível - Corrgido
  itens.forEach((item) => print(formatarItem(item, taxa)));
}

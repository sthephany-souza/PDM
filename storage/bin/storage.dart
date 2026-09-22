import 'dart:io';

void main() {
  print("=== TechStorage - Gestão de Inventário ===");

  stdout.write("Digite o nome da categoria de produtos: ");
  String? categoria = stdin.readLineSync(); // ✅ ERRO DE COMPILAÇÃO - Corrigido

  // Lista de produtos representados por Mapas
  List<Map<String, dynamic>> inventario = [];

  // O loop abaixo deveria rodar 3 vezes para cadastrar 3 produtos
  for (var i = 1; i <= 3; i++) {
    stdout.write("\nNome do Produto $i: ");
    String? nomeProd = stdin.readLineSync(); // ✅ ERRO DE COMPILAÇÃO - Corrigido

    stdout.write("Preço do Produto $i: ");
    double precoProd = double.parse(
      stdin.readLineSync()!,
    ); // ✅ ERRO DE COMPILAÇÃO - Corrigido

    // Criando o mapa do produto
    var produto = {
      "nome": nomeProd, 
      "preco": precoProd
    };

    inventario.add(produto);
  }

  print("\n--- Processando Relatório de Depreciação ---");

  // Chamada de função confusa com parâmetros posicionais idênticos
  // O desenvolvedor queria passar: categoria, inventario, e taxa de desconto (15%)
  exibirECalcularRelatorio(inventario, categoria!, 0.15);
}

// ✅ ERRO DE COMPILAÇÃO E MÁ PRÁTICA: Parâmetros posicionais confusos. - Corrigido
// ✅ ERRO DE COMPILAÇÃO: O tipo de retorno e os tipos internos do mapa estão gerando conflito. - Corrigido
void exibirECalcularRelatorio(
  List<Map<String, dynamic>> itens,
  String cat,
  double taxa,
) {
  print("Categoria Analisada: $cat");

  // O desenvolvedor tentou atualizar o preço de cada item subtraindo a taxa,
  // mas o Dart reclama de tipos e mutabilidade.
  for (var item in itens) {
    double precoOriginal = item["preco"];// ✅ ERRO DE COMPILAÇÃO/EXECUÇÃO - Corrgido
    double novoPreco = precoOriginal - (precoOriginal * taxa);

    // O objetivo era atualizar o mapa e mostrar na tela usando Arrow Function se possível
    print("Produto: ${item['nome']} | Preço Depreciado: R\$ $novoPreco");
  }
}
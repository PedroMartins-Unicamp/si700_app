# Planejo

Protótipo Flutter de um planejador financeiro pessoal para o trabalho **Interface Gráfica — SI700**. A interface segue as telas de `context/Planejo_Documento_Projeto_1(1).pdf`; o escopo da entrega segue **`context/enunciado_01.pdf`** e **`context/screenshot_2026-10-07_19-22-44.png`**.

## Executar

```sh
flutter pub get
flutter run
```

Para navegador: `flutter run -d chrome`. Para Android, selecione um emulador ou dispositivo em `flutter devices` e execute `flutter run -d <id>`.

A tela inicial é pública. Toque no botão **+** e depois em **Explorar demonstração** para registrar lançamentos. Também é possível preencher e-mail fictício e senha de seis caracteres na tela de acesso. Esse fluxo é uma simulação de interface: não autentica usuários nem guarda senhas.

## Requisitos do enunciado

| Critério | Implementação e onde demonstrar |
| --- | --- |
| Coleta de informações | Novo lançamento: `Form`, `TextFormField` com validação, `SegmentedButton` para receita/despesa, `ChoiceChip` para categoria, `showDatePicker`, `DropdownButtonFormField` para pagamento e `SwitchListTile` para recorrência. Metas: campos e `Slider` de progresso. |
| Interação com o usuário | `SnackBar` após salvar lançamento/meta; `AlertDialog` para informações e seleção do mês; `showModalBottomSheet` ao tocar em um lançamento. |
| Mostrando dados ou opções | `ListView` na tela **Lançamentos**, com valores, imagens de categoria, agrupamento por data, busca e filtros. |
| Navegação | `BottomNavigationBar` inferior para Início, Lançamentos, Metas e Perfil; `Navigator.push/pop` com `MaterialPageRoute` para formulários, relatórios e Premium. |
| Temática | Saldo, receitas/despesas em reais, gráficos de barras por categoria, metas de economia e identidade verde/azul-marinho do Planejo. |

## Telas e comportamento

- **Início público:** apresentação, resumo ilustrativo e atalhos.
- **Acesso:** formulário demonstrativo; botões Google/Apple e recuperação abrem explicações sobre a versão futura.
- **Novo lançamento:** validação de valor e descrição, tipo, categoria, data, pagamento e recorrência. Salvar atualiza a lista, o saldo e os relatórios.
- **Lançamentos:** consulta por mês, busca, filtros de receita/despesa e detalhes de cada item.
- **Metas:** criação e atualização do valor guardado, inclusive por slider. O valor da meta é independente dos lançamentos.
- **Relatórios:** resumo e barras de despesas por categoria do mês atual.
- **Perfil/Premium:** apresentação do plano proposto e confirmação com recibo **simulado**, sem cobrança. Voltar ao início mantém a sessão demonstrativa.

Os exemplos somam R$ 5.200,00 em receitas e R$ 2.720,00 em despesas, reproduzindo o saldo de R$ 2.480,00 do protótipo. As datas são ajustadas para o mês atual. Valores são representados em centavos inteiros; o formulário aceita `89,90` e `1.234,56`.

## Organização

```text
lib/
  main.dart                  Inicialização, idioma pt-BR e MaterialApp
  models.dart                Lançamentos, categorias, metas e dados ilustrativos
  planejo_controller.dart    Estado em memória com ChangeNotifier/InheritedNotifier
  ui/
    app_theme.dart           Cores e tema
    formatters.dart          Moeda, datas e validação de valores
    widgets.dart             Componentes visuais reutilizáveis
    screens/                 Telas do aplicativo
assets/
  categories/                Imagens locais de categorias
  fonts/                     Fontes locais e licença
```

## Prévias

Capturas do aplicativo em uma tela de 390 × 844 pixels:

[Início](docs/previews/home.png) · [Acesso](docs/previews/auth.png) · [Novo lançamento](docs/previews/entry.png) · [Lançamentos](docs/previews/transactions.png) · [Confirmação](docs/previews/confirmation.png)

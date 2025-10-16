# 🟣 EncurtaLinkApp

Projeto desenvolvido como parte de um desafio técnico da **Nubank**.  
O objetivo do app é **encurtar links** e **exibir uma lista** dos links encurtados de forma simples e eficiente.

---

## 🚀 Tecnologias Utilizadas

- [Flutter 3.29.3](https://docs.flutter.dev/) — Framework principal
- [Provider](https://pub.dev/packages/provider) — Gerenciamento de estado
- [Go Router](https://pub.dev/packages/go_router) — Gerenciamento de rotas
- [Shared Preferences](https://pub.dev/packages/shared_preferences) — Persistência local
- [Shimmer](https://pub.dev/packages/shimmer) — Efeito de loading
- [Mocktail](https://pub.dev/packages/mocktail) — Mocks em testes
- [Logging](https://pub.dev/packages/logging) — Log estruturado

---

## 🧭 Arquitetura

O projeto segue a **arquitetura oficial recomendada pelo Flutter**, baseada em **MVVM** (Model-View-ViewModel):

lib/
├── core/ →  Temas, dimensões e utilitários
├── data/ → Repositórios e fontes de dados (API, local, etc)
├── domain/ → Modelos e casos de uso (regras de negócio)
├── util/ → Result, e Command
├── feature/
│ └── home/ → View, ViewModel e componentes da tela principal
└── main.dart → Ponto de entrada da aplicação


✅ **Motivos para usar MVVM**:
- Separação clara de responsabilidades.
- Facilidade para testar ViewModels isoladamente.
- Evolução do código de forma mais sustentável.

---


## 🧪 Testes

O projeto utiliza **mocktail** para criação de fakes e mocks nos testes de unidade.

### Decisões Técnicas

MVVM + Provider: facilita a reatividade e separação clara entre UI e lógica.

Result Pattern: uso da classe Result para tratar sucesso e erro de forma elegante.

Arquitetura em camadas: inspirada em boas práticas da comunidade Flutter oficial.

Testabilidade: foco em ViewModels e Widgets com mocks de dependências.

### Principais Dependências
| Pacote                 | Versão  | Descrição                       |
| ---------------------- | ------- | ------------------------------- |
| **flutter**            | 3.29.3  | SDK base                        |
| **provider**           | ^6.1.2  | Gerenciamento de estado reativo |
| **go_router**          | ^14.6.2 | Gerenciamento de rotas          |
| **shimmer**            | ^3.0.0  | Efeito shimmer de carregamento  |
| **shared_preferences** | ^2.3.5  | Armazenamento local             |
| **mocktail**           | ^1.0.2  | Mocking em testes unitários     |
|                        |         |                                 |
|                        |         |                                 |

Confira o relatório completo de cobertura de testes gerado automaticamente:  
👉 [Ver relatório de cobertura](./coverage_report/index.htm)

Para rodar os testes:

```bash
flutter test


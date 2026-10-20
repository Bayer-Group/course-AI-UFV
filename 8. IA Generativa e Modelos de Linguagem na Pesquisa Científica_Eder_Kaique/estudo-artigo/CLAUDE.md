# Projeto: estudo e reprodução de Meuwissen, Hayes & Goddard (2001)

## Material
- Artigo em `artigo/Meuwissen_Hayes_Goddard_GS.pdf`.
- Texto do artigo disponível para busca com Grep.

## Regras de estudo (obrigatórias)
- Toda afirmação sobre o artigo deve indicar a origem: (Seção X, p. Y),
  (Fig. N), (Tab. N).
- Separe sempre com rótulos explícitos:
  - **[ARTIGO]** o que o texto afirma;
  - **[INFERÊNCIA]** o que você deduz a partir dele;
  - **[CONHECIMENTO GERAL]** o que vem de fora do artigo.
- Se algo não está no artigo, responda "NÃO CONSTA NO ARTIGO" e diga onde
  procurou. Não invente valores.
- Não confunda este artigo com outros trabalhos dos mesmos autores sobre
  seleção genômica ou mapeamento de QTL. Se usar outro artigo, cite-o
  explicitamente.
- Não reproduza trechos longos; explique com suas palavras.

## Regras de reprodução
- Todo parâmetro de simulação vem de `config/parametros_artigo.yaml`.
- Cada entrada do YAML tem o campo `fonte` com a página do artigo.
- Parâmetro não informado: `status: suposto`, valor null, nota justificando.
- Registrar desvios em `DESVIOS.md` com impacto esperado.
- Semente fixa; documentar número de repetições e justificar reduções.

## Forma de trabalho
- Uma etapa do `PLANO.md` por sessão; salvar notas em `notas/` ao final.
- Antes de escrever código, apresentar um plano e aguardar aprovação.

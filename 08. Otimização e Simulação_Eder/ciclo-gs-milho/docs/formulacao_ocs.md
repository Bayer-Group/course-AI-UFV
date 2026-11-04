# Formulação: Seleção por Contribuição Ótima (OCS)

## 1. Variáveis de decisão

Vetor **c** ∈ ℝⁿ, onde n é o número de candidatos.

- cᵢ: contribuição genética do indivíduo i para a próxima geração.
- Interpretação: proporção dos gametas que cada candidato fornece ao pool da progênie.

## 2. Função objetivo

Maximizar o valor genético médio esperado da progênie:

$$\max_{\mathbf{c}}\ \mathbf{c}^\top \hat{\mathbf{g}}$$

onde **ĝ** é o vetor de GEBVs dos candidatos (VanRaden 2008, estimados por GBLUP/RR-BLUP).

## 3. Restrições

### 3.1 Coancestria máxima (restrição quadrática)

$$\frac{1}{2}\,\mathbf{c}^\top \mathbf{G}\,\mathbf{c} \leq \theta$$

- **G**: matriz de parentesco genômico de VanRaden (2008), método 1.
  Gᵢⱼ = ZZᵀ / [2 Σₖ pₖ(1−pₖ)], com Z = M − 2p.
- O fator 1/2 converte parentesco em coancestria (para espécie monoica,
  coancestria entre dois indivíduos = Gᵢⱼ/2).
- θ: coancestria-alvo derivada de ΔF (ver seção 4).

### 3.2 Soma das contribuições (espécie monoica)

$$\sum_{i=1}^{n} c_i = 1$$

> **Atenção:** em espécies dioicas (bovinos, equinos), a convenção é
> sum(c_machos) = 1/2 e sum(c_fêmeas) = 1/2. Em milho (monoica), a
> soma total é 1. Usar a convenção animal em milho subestima a
> coancestria ao dobro.

### 3.3 Não-negatividade

$$c_i \geq 0 \quad \forall\, i$$

Contribuições negativas não têm interpretação biológica.

## 4. Derivação de θ a partir de ΔF

A coancestria evolui por geração segundo:

$$C_{t+1} = C_t + \Delta F\,(1 - C_t)$$

Dado ΔF desejado e a coancestria atual C_t (coancestria média do grupo parental
calculada a partir de **G**), o valor-alvo para a próxima geração é:

$$\theta = C_t + \Delta F\,(1 - C_t)$$

Referência para ΔF em programas de melhoramento: valores típicos entre 0,5% e
1,0% por geração mantêm tamanho efetivo Nₑ entre 50 e 100
(relação ΔF ≈ 1/2Nₑ).

## 5. Tipo de problema e método

| Aspecto | Classificação |
|:--------|:--------------|
| Função objetivo | Linear em **c** |
| Restrição de coancestria | Quadrática convexa em **c** |
| Restrição de soma e não-negatividade | Linear em **c** |
| **Tipo do problema** | **Programação Quadrática (QP) convexa** |

A função objetivo é linear e a restrição quadrática define um conjunto viável
convexo. O problema admite **ótimo global garantido** e pode ser resolvido
eficientemente por solvers QP (e.g. `quadprog::solve.QP`).

### Forma penalizada (equivalente, usada na implementação)

Em vez de impor θ como restrição explícita, resolve-se a forma penalizada:

$$\max_{\mathbf{c}}\ \mathbf{c}^\top \hat{\mathbf{g}} - \lambda\,\frac{1}{2}\mathbf{c}^\top\mathbf{G}\,\mathbf{c}$$

Para cada λ > 0 a solução é o ótimo global. Uma busca por bisseção em λ
encontra o valor que satisfaz exatamente a restrição c'Gc/2 = θ.

**Justificativa do método:** o problema é convexo de pequena a média escala
(até ~10³ candidatos). O QP resolve em frações de segundo e fornece a solução
exata — que serve de gabarito obrigatório para qualquer heurística posterior.

## 6. Referências primárias

- **Meuwissen, T. H. E. (1997).** Maximizing the response of selection with a
  predefined rate of inbreeding. *Journal of Animal Science*, 75(4), 934–940.
  — Formulação original da OCS e derivação da restrição de coancestria.

- **VanRaden, P. M. (2008).** Efficient methods to compute genomic predictions.
  *Journal of Dairy Science*, 91(11), 4414–4423.
  — Método 1 para a matriz de parentesco genômico **G**.

- **Woolliams, J. A. et al. (2015).** Genetic contributions and their
  optimization. *Journal of Animal Breeding and Genetics*, 132(2), 89–99.
  — Revisão abrangente da teoria de contribuições genéticas ótimas.

# Correções pendentes no PowerPoint

**Arquivo:** `Otimização da seleção e tomada de decisão.pptx`

Gerado automaticamente pela análise de alinhamento Rmd ↔ pptx.

---

## A. Fórmulas — Converter para OMML (Equation Editor)

No PowerPoint: **Inserir → Equação** e digitar a fórmula em LaTeX-like.
Alternativa: selecionar o texto da fórmula → copiar → colar no campo de equação.

| Slide | Fórmula atual (texto plano) | LaTeX para colar no Equation Editor |
|-------|----------------------------|-------------------------------------|
| 5 | `max c'ĝ s.a. c'Gc/2 ≤ θ, Σc=1, c≥0` | `\max_{\mathbf{c}} \mathbf{c}^\top \hat{\mathbf{g}} \quad \text{s.a.} \quad \frac{1}{2}\mathbf{c}^\top\mathbf{G}\mathbf{c} \leq \theta, \quad \sum c_i = 1, \quad c_i \geq 0` |
| 5 | `C_{t+1} = C_t + ΔF(1-C_t)` | `C_{t+1} = C_t + \Delta F (1 - C_t)` |
| 6 | `c'Gc/2 = Σⱼ(p'ⱼ-pⱼ)²/Σⱼpⱼqⱼ` | `\frac{1}{2}\mathbf{c}^\top\mathbf{G}\mathbf{c} = \frac{\sum_j (p'_j - p_j)^2}{\sum_j p_j q_j}` |
| 10 | `max c'ĝ - λ c'Gc/2` | `\max_{\mathbf{c}} \mathbf{c}^\top\hat{\mathbf{g}} - \lambda \frac{1}{2}\mathbf{c}^\top\mathbf{G}\mathbf{c}` |
| 12 | `a + F·(b-c)` | `\mathbf{v} = \mathbf{a} + F \cdot (\mathbf{b} - \mathbf{c})` |
| 24 | `b = P⁻¹Ga` | `\mathbf{b} = \mathbf{P}^{-1}\mathbf{G}\mathbf{a}` |

**Dica:** no PowerPoint, ao digitar no campo de equação, use `\` para comandos
LaTeX (e.g. `\frac`, `\sum`, `\theta`). O editor converte automaticamente.

---

## B. Parâmetros numéricos — Alinhar com scripts/YAML

Os scripts e `config/parametros.yaml` usam:
- `n_cruzamentos: 20`
- `dh_por_cruzamento: 10`
- `N_CICLOS <- 5L` (em `R/06_experimento_ocs.R`)
- Candidatos: o número real depende do banco (verificar `n` ao rodar `R/00_simula_completo.R`)

| Slide | Texto atual | Corrigir para |
|-------|------------|---------------|
| 13 (título) | "200 candidatos da coorte 3, ΔF = 3%" | "N candidatos da coorte mais recente, ΔF = 3%" (N = saída do script) |
| 14 (tabela) | Números de ganho/coancestria/razão | Atualizar com saída de `R/02_ocs_exata.R` e `R/03_ocs_de.R` |
| 17 (divider) | "20 ciclos" | "5 ciclos" |
| 18 | "50 cruzamentos, 4 DH por cruzamento" | "20 cruzamentos, 10 DH por cruzamento" |
| 19 (tabela) | Resultados de 20 ciclos | Atualizar com `reports/experimento_ocs.csv` (5 ciclos) |
| 20 (imagem) | Figura de 20 ciclos | Substituir por `reports/experimento_ocs.png` atual |
| 21 (tabela ΔF) | ΔF realizado de 20 ciclos | Recalcular de `reports/experimento_ocs.csv` |

**Procedimento para atualizar números:**

1. Abrir terminal no diretório `ciclo-gs-milho/`
2. Rodar: `Rscript R/00_simula_completo.R` (mostra N de candidatos, C_min, C_trunc, theta)
3. Rodar: `Rscript R/02_ocs_exata.R` (mostra ganho QP, coancestria, contribuintes)
4. Rodar: `Rscript R/03_ocs_de.R` (mostra ganho DE contínua/discreta e razão vs QP)
5. Rodar: `Rscript R/06_experimento_ocs.R` (gera `reports/experimento_ocs.csv` e `.png`)
6. Copiar os números para as tabelas dos slides

---

## C. Outras correções pontuais

| Slide | Correção |
|-------|----------|
| 5 | Adicionar nota: "(simplificação de primeiro ciclo; o código calcula C_min real com contribuições uniformes)" |
| 6 | Referência a `tests/test_ocs.R` — agora o arquivo existe, OK |
| 15 (imagem) | Verificar que corresponde a `reports/fronteira_ganho_coancestria.png` atual |

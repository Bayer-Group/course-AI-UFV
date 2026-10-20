# Decisões da análise

Leia antes de decidir algo novo. Uma decisão por linha; não apague, acrescente.

| Data | Decisão | Motivo | Quem |
|---|---|---|---|
| 2026-11 | Valor de PROD fora de 2.000–20.000 kg/ha vira NA, com registro | Converter unidade (ex.: 9,01 "em t/ha") é palpite sem evidência | equipe |
| 2026-11 | IDs normalizados antes de checar duplicatas e contar genótipos | Sem normalizar, uma mesma linhagem conta como genótipos diferentes | equipe |
| 2026-11 | Testemunhas DH24 entram no modelo, fora do ranking | Conectam ambientes; não são candidatas | equipe |
| 2026-10-20 | nrow real = 2426 (PGO 809, SLG 809, UDI 808); spec dizia 2425 | Contagem direta do CSV bruto prevalece | orientando |
| 2026-10-20 | QC de id_fora_padrao checa o valor original (não normalizado) contra a regex | Normalização é correção (Etapa 03); QC deve reportar o que está errado no bruto | orientando |
| 2026-10-20 | IDs com separador errado (espaço/hífen: DH25 0138, DH25-0287) não são corrigidos automaticamente na Etapa 03 | toupper+trimws não resolve erro estrutural; ficam no curado com valor original e exigem confirmação manual | orientando |
| 2026-10-20 | BLUPs do modelo conjunto extraídos do efeito principal germoplasma_nome (não da interação) | Efeito principal captura o valor médio de testcross; interação genotipo:ambiente é residual de estabilidade | orientando |
| 2026-10-20 | DH25 0138 e DH25-0287 (IDs pendentes) entram no modelo conjunto com o nome não-padrão; não aparecem no ranking porque não começam com DH25_ | Decisão conservadora: não assumir correção sem confirmação do responsável | orientando |

# Etapa 04: análise individual e conjunta
# Entradas: data/processado/03_curado.rds, config/parametros.yaml
# Saídas:   output/04_individual.csv, output/04_conjunta_componentes.csv,
#           output/04_conjunta_blups.csv
# Premissas: dados de parcela; modelos e h² conforme o CLAUDE.md;
#            testemunhas DH24 no modelo, ranking só das DH25

source("R/funcoes.R")
par <- yaml::read_yaml("config/parametros.yaml")
d <- readRDS(file.path(par$caminhos$processado, "03_curado.rds"))

ind <- analise_individual(d, r = par$delineamento$n_blocos)
print(ind, digits = 3)

cj <- analise_conjunta(d)
print(cj$componentes)
blups <- cj$blups[startsWith(cj$blups$genotipo, par$ids$prefixo_ranking), ]
blups$posicao <- seq_len(nrow(blups))
cat("Genotipos no modelo:", nrow(cj$blups), "\n")
print(head(blups, 10))

write.csv(ind, file.path(par$caminhos$output, "04_individual.csv"), row.names = FALSE)
write.csv(cj$componentes, file.path(par$caminhos$output, "04_conjunta_componentes.csv"),
          row.names = FALSE)
write.csv(blups, file.path(par$caminhos$output, "04_conjunta_blups.csv"), row.names = FALSE)

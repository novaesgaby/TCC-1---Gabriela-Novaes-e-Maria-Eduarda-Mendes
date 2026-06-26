# ==============================================================================
# MODELO (.mod) - Estrutura e Regras (biocombustível)
# ==============================================================================

# CONJUNTOS (Índices)
set T; # Período de tempo (t)
set K; # Projeto de planta de britagem (k)
set P; # Zona de produção (p)
set C; # Possível localização da planta de britagem (c)
set U; # Usina de biodiesel (u)

# PARAMETROS
param alfa;                           # Percentagem de óleo na semente oleaginosa
param beta{K};                        # Eficiência de britagem de uma planta tipo k
param gama{P, T};                     # Produtividade de oleaginosas na zona p no período t
param AZ{P, T};                       # Tamanho médio da área de terra na zona p no período t
param CC{K};                          # Custo unitário de britagem de uma planta tipo k
param D{U, T};                        # Demanda de óleo vegetal da planta de biodiesel u no período t
param GTC{P, C};                      # Custo unitário de transporte de p para c
param IC{K, T};                       # Custo de instalação da planta de britagem tipo k no período t
param OTC{C, U};                      # Custo unitário de transporte de óleo de c para u
param OC{U, T};                       # Custo do óleo vegetal para usina u no período t
param PC{P};                          # Custo unitário de produção de oleaginosas na zona p
param TF{T};                          # Número mínimo de famílias a serem alocadas no período t
param W_barra{K};                     # Capacidade anual da planta de britagem tipo k
param Z_barra{P, T};                  # Área total disponível da zona p no período t

# VARIÁVEIS DE DECISÃO
var y{C, K, T} binary;                # Decisão de instalar a planta {0,1}
var z{P, T} >= 0;                     # Tamanho da área p alocada
var gx{P, C, T} >= 0;                 # Quantidade de oleaginosas transportadas de p para c
var ox{C, U, T} >= 0;                 # Quantidade de óleo vegetal transportado de c para u
var w{C, K, T} >= 0;                  # Quantidade de sementes trituradas em c pela planta k
var v{U, T} >= 0;                     # Quantidade de óleo vegetal comprada por u

# FUNÇÃO OBJETIVO (Minimizar Custos)
minimize Custo_Total:
    sum{c in C, k in K, t in T} (IC[k,t] * y[c,k,t]) +
    sum{p in P, c in C, t in T} (GTC[p,c] * gx[p,c,t]) +
    sum{c in C, u in U, t in T} (OTC[c,u] * ox[c,u,t]) +
    sum{p in P, t in T} (PC[p] * z[p,t]) +
    sum{c in C, k in K, t in T} (CC[k] * w[c,k,t]) +
    sum{u in U, t in T} (OC[u,t] * v[u,t]);

# RESTRIÇÕES
s.t. Atendimento_Demanda{u in U, t in T}:
    sum{c in C} ox[c,u,t] + v[u,t] >= D[u,t];

s.t. Limite_Area{p in P, t in T}:
    z[p,t] <= Z_barra[p,t];

s.t. Minimo_Familias{t in T}:
    sum{p in P} (z[p,t] / AZ[p,t]) >= TF[t];

s.t. Producao_Zona{p in P, t in T}:
    sum{c in C} gx[p,c,t] = gama[p,t] * z[p,t];

s.t. Balanco_Trituracao{c in C, t in T}:
    sum{p in P} gx[p,c,t] = sum{k in K} w[c,k,t];

s.t. Producao_Oleo{c in C, t in T}:
    sum{u in U} ox[c,u,t] = sum{k in K} (alfa * beta[k] * w[c,k,t]);

s.t. Capacidade_Planta{c in C, k in K, t in T}:
    w[c,k,t] <= W_barra[k] * sum{t_linha in T: t_linha <= t} y[c,k,t_linha];

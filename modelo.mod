# ==========================================
# 1. CONJUNTOS (SETS)
# ==========================================
set FORNECEDORES;
set BIORREFINARIAS;

# ==========================================
# 2. PARÂMETROS (PARAMETERS)
# ==========================================
param capacidade{BIORREFINARIAS};
param custo_transporte{FORNECEDORES, BIORREFINARIAS};

# ==========================================
# 3. VARIÁVEIS DE DECISÃO (VARIABLES)
# ==========================================
var x{FORNECEDORES, BIORREFINARIAS} >= 0;

# ==========================================
# 4. FUNÇÃO OBJETIVO (OBJECTIVE FUNCTION)
# ==========================================
minimize Custo_Total: 
   sum{f in FORNECEDORES, b in BIORREFINARIAS} custo_transporte[f,b] * x[f,b];

# ==========================================
# 5. RESTRIÇÕES (CONSTRAINTS)
# ==========================================
subject to Limite_Capacidade{b in BIORREFINARIAS}:
   sum{f in FORNECEDORES} x[f,b] <= capacidade[b];

end;

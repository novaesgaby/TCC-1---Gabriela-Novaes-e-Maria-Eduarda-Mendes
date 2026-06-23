set FORNECEDORES;
set BIORREFINARIAS;

param capacidade{BIORREFINARIAS};
param demanda{BIORREFINARIAS};
param custo_transporte{FORNECEDORES, BIORREFINARIAS};

var x{FORNECEDORES, BIORREFINARIAS} >= 0;

minimize Custo_Total: 
   sum{f in FORNECEDORES, b in BIORREFINARIAS} custo_transporte[f,b] * x[f,b];

subject to Limite_Capacidade{b in BIORREFINARIAS}:
   sum{f in FORNECEDORES} x[f,b] <= capacidade[b];

subject to Atender_Demanda{b in BIORREFINARIAS}:
   sum{f in FORNECEDORES} x[f,b] >= demanda[b];

end;

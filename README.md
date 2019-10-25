## acomod2

Função para verificar numericamente se um sistema  de segunda ordem é estável;

Se temos um sistema de segunda ordem `G(s)` chamamos assim:

```
[ estavel, tempo  ] = acomod2(t, sys, criterio, round_p)
```

onde:

  - t: Vetor de tempo do sistema de segunda ordem sys;
  - sys: Vetor com pontos do sistema de segunda ordem;
  - criterio: Valor para em relação ao qual o sistema
    é considerado estável. Por padrão vale 0.02. Ex:
      
      * Se criterio = 0.05, o sistema é estável
      se o erro for menor que 5% do valor final
      alcançado.
  - round_p: Número de casas decimais a serem levadas
    em consideração no arredondamento necessário para
    obter o valor final com a moda estatística do ve-
    tor sys. Por padrão vale 4

RETORNO:
  - estavel: booleano que representa se o sistema é estável
    ou não;
  - tempo: tempo de acomodação. Se o sistema for instável 
    valerá NaN.

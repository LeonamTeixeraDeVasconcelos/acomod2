function [ estavel, tempo ]= acomod2 ( t, sys, criterio = 0.02, round_p = 4 )
  % Verifica se o sistema de segunda ordem sys (vetor de pontos) é 
  % estável e se sim, em qual tempo se estabiliza.
  %
  % PARAMS:
  %   - t: Vetor de tempo do sistema de segunda ordem sys;
  %   - sys: Vetor com pontos do sistema de segunda ordem;
  %   - criterio: Valor para em relação ao qual o sistema
  %     é considerado estável. Por padrão vale 0.02. Ex:
  %       
  %       Se criterio = 0.05, o sistema é estável
  %       se o erro for menor que 5% do valor final
  %       alcançado.
  %
  %   - round_p: Número de casas decimais a serem levadas
  %     em consideração no arredondamento necessário para
  %     obter o valor final com a moda estatística do ve-
  %     tor sys. Por padrão vale 4
  %
  % RETORNO:
  %   - estavel: booleano que representa se o sistema é estável
  %     ou não;
  %   - tempo: tempo de acomodação. Se o sistema for instável 
  %     valerá NaN.
  % 
  
  % Arredonda em 'round_p' casas decimais, o vetor
  % 'S' passado por parâmetro 
  S = round ( sys .* 10^round_p ) ./ 10^round_p;
  
  % Calcula a moda de S: valor final em um sistema estável;
  [ M, F, C ] = mode(S);
 
  erro  = [];  % cache de erros para verificação de padrão (crescente,
               % decrescente, estável).
               
  tempo = 0;   % tempo de acomodação
  
  cache = 10;  % tamanho máximo da cache de erro
  
  state = 1;   % estado do erro: 2 estável, 1 crescente, 0 decrescente
  
  state_c = 1; % cache do estado de erro anterior
  
  cond = 0;    % condição de quebra do loop externo
  
  for i = 1:1:max(size(S))
    % Verifica se o tamanho da cache do erro está 
    % de acordo com o tamanho máximo
    %
    % - Se sim, adiciona o erro novo calculado
    %
    % - Se não, faz um shift de 1 elemento pra
    % esquerda e adiciona o novo elemento na
    % última posição da nova cache de erros.
    if (max(size(erro)) < cache )
      % adiciona novo erro à cache de erros;
      erro = [ erro abs(M - S(i)) ];
    else
      % shift de 1 elemento à esquerda;
      erro = shift(erro, max(size(erro)) - 1);
      % adiciona novo erro na última posição 
      % da cache, agora deslocada
      erro(max(size(erro))) = abs(M - S(i));
      
      % faz a verificação de estado do erro      
      for j = 2:1:max(size(erro))
        % verifica se está crescendo
        if ( erro (j) > erro (j-1))
          state = 1;
        % verifica se está decrescendo
        elseif (erro (j) < erro (j-1)) 
          state = 0;
        % verifica se está estabilizado
        else
          state = 2;
        endif;
        
        % Caso o estado do erro anterior seja
        % estável e o erro atual também, temos
        % que o erro está estável e o cálculo 
        % pode parar.
        %
        % Para que a condição de quebra seja 
        % atingida, o erro máximo deve ser 
        % menor que certo limite em relação 
        % ao valor final do sistema. Esse li-
        % mite é igual à:
        %     erro_max < criterio * M;
        if ( state_c == 2 && state == 2 && max(erro) <= criterio * M)
          cond = 1;
          break;
        endif 
        % atualiza o estado anterior
        state_c = state;   
      endfor;
    endif;
    
    % Verifica se a condição de quebra do loop foi
    % atingida;
    if (cond == 1)
      tempo = t(i);
      estavel = true;
      break;
    else
      estavel = false;
      tempo = NaN;
    endif;
  endfor
 
endfunction;
// Version 0.9
//DDM - Differential-Difference Model
function [F, G] = getFG(ptp)
	ptp_type = typeof(ptp);
	select ptp_type
    case 'ptp1' then
      [F, G] = drm1(ptp.lambda, ptp.a, ptp.h, ptp.blocks, ptp.GU1type, ...
                           ptp.GU2type, ptp.alpha1, ptp.alpha2);
    case 'ptp2' then
      [F, G] = drm2(ptp.lambda1, ptp.lambda2, ptp.a1, ptp.a2, ptp.h1, ...
			ptp.h2, ptp.blocks1, ptp.blocks2, ptp.Rk, ptp.GU1type, ...
			ptp.GU2type,	ptp.alpha1, ptp.alpha2);
    case 'ptp2_1' then
      [F, G] = drm2_1(ptp.lambda1, ptp.lambda2, ptp.a1, ptp.a2, ptp.h1, ...
			ptp.h2, ptp.blocks1, ptp.blocks2, ptp.GU1type, ...
			ptp.GU2type,	ptp.alpha1, ptp.alpha2);			
    case 'ptp3' then
      [F, G] = drm3(ptp.lambda1, ptp.lambda2, ptp.lambda3, ptp.a1, ptp.a2, ...
			ptp.h1, ptp.h2, ptp.h3, ptp.blocks1, ptp.blocks2, ptp.GU1type, ...
			ptp.GU2type, ptp.alpha1, ptp.alpha2);
    case 'ptp4' then
      [F, G] = drm4(ptp.lambda, ptp.a, ptp.blocks, ptp.GUtype, ...
			ptp.alpha, ptp.R, ptp.Rk, ptp.h);			
    case 'ptp5' then
      [F, G] = drm5(ptp.lambda, ptp.a, ptp.delta, ptp.m, ptp.blocks, ...
			ptp.GUtype, ptp.alpha);
    case 'ptp6' then
      [F, G] = drm6(ptp.lambda1, ptp.lambda2, ptp.a1, ptp.a2, ptp.h1, ...
			ptp.delta2, ptp.m2, ptp.blocks1, ptp.blocks2, ptp.Rk, ptp.GUtype, ...
			ptp.alpha);
    case 'ptp6_1' then
      [F, G] = drm6_1(ptp.lambda1, ptp.lambda2, ptp.a1, ptp.a2, ptp.h1, ...
                           ptp.delta2, ptp.m2, ptp.blocks1, ptp.blocks2, ptp.GUtype, ptp.alpha);
    case 'ptp6_2' then
      [F, G] = drm6_2(ptp.lambda1, ptp.lambda2, ptp.lambda3, ptp.a1, ptp.a2, ptp.a3, ptp.h1, ptp.h2, ...
                           ptp.delta3, ptp.m3, ptp.blocks1, ptp.blocks2, ptp.blocks3, ptp.GUtype, ptp.alpha);      
    case 'ptp7' then
      [F, G] = drm7(ptp.lambda1, ptp.lambda2, ptp.lambda3, ptp.a1, ptp.a2, ptp.a3,...
                    ptp.h1, ptp.h2, ptp.h3, ptp.blocks1, ptp.blocks2, ptp.blocks3,...
                    ptp.GU1type, ptp.GU2type, ptp.alpha1, ptp.alpha2);
    case 'ptp8' then
      [F, G] = drm8(ptp.lambda1, ptp.lambda2, ptp.a1, ptp.a2, ptp.h, ptp.Rk, ptp.blocks);   
    case 'ptp8_1' then
      [F, G] = drm8_1(ptp.lambda1, ptp.lambda2, ptp.lambda3, ptp.a1, ptp.a2, ptp.a3, ptp.h1, ptp.h2, ptp.blocks1,...
                           ptp.blocks2, ptp.Rk1, ptp.Rk2);                                   
  end
endfunction

// *********
// Однородный ПТП
// ***********

function [F, G] = drm1(lambda, a, h, blocks, GU1type, GU2type, alpha1, alpha2)
  //Расчёт вспомогательных переменных
  delta = h / (blocks - 1);
  b = a / delta^2;
  d = a / (lambda * delta);
  //Расчёт матрицы обратных связей F
  F = zeros(blocks, blocks);
  for i = 1:1:blocks - 1;
    F(i, i) = -2 * b;
    F(i, i + 1) = b;
    F(i + 1, i) = b;
  end;
  F(1, 2) = 2 * b;
  F(blocks, blocks - 1) = 2 * b;
  F(blocks, blocks) = -2 * b;
  select GU1type
    case 1 then
      F(1, :) = [];
      F(:, 1) = [];
    case 2 then
      F(1, 1) = -2 * b;
    case 3 then
      F(1, 1) = -2 * (b + alpha1 * d);
  end
  select GU2type
    case 1 then
      F(size(F, 'r'), :) = [];
      F(:, size(F, 'c')) = [];
    case 2 then
      F(blocks, blocks) = -2 * b;
    case 3 then
      F(size(F, 'r'), size(F, 'c')) = -2 * (b + alpha2 * d);
  end
  //Расчёт матрицы управления G
  G = zeros(blocks, 2);
  select GU1type
    case 1 then
      G(1, :) = [];
      G(1, 1) = b;
    case 2 then
      G(1, 1) = 2 * d;
    case 3 then
      G(1, 1) = 2 * d * alpha1;
  end
  select GU2type
    case 1 then
      G(size(G, 'r'), :) = [];
      G(size(G, 'r'), 2) = b;
    case 2 then
      G(size(G, 'r'), 2) = 2 * d; 
    case 3 then
      G(size(G, 'r'), 2) = 2 * d * alpha2;
  end
endfunction

// *********
// Двухсоставной неоднородный ПТП с контактным тепловым сопротивлением
// ***********

function [F, G] = drm2(lambda1, lambda2, a1, a2, h1, h2, blocks1, blocks2, ...
Rk, GU1type, GU2type, alpha1, alpha2)
  //Расчёт вспомогательных переменных
  delta1 = h1 / (blocks1 - 1);
  delta2 = h2 / (blocks2 - 1);
  b1 = a1 / delta1^2;
  b2 = a2 / delta2^2;
  d1 = a1 / (lambda1 * delta1);
  d2 = a2 / (lambda2 * delta2);
  blocks = blocks1 + blocks2;
  //Расчёт матрицы обратных связей F
  F = zeros(blocks, blocks);
  for i=1:1:blocks1 - 1;
    F(i, i) = -2 * b1;
    F(i, i + 1) = b1;
    F(i + 1, i) = b1;
  end;
  F(1, 2) = 2 * b1;
  F(blocks1, blocks1 - 1) = 2 * b1;
  F(blocks1, blocks1) = - 2 *(b1 + d1 / Rk);
  F(blocks1, blocks1 + 1) = 2 * d1 / Rk;
  for i = blocks1 + 1:1:blocks - 1;
    F(i, i) = - 2 * b2;
    F(i, i + 1) = b2;
    F(i + 1, i) = b2;
  end;
  F(blocks1 + 1, blocks1) = 2 * d2 / Rk;
  F(blocks1 + 1, blocks1 + 1) = - 2 *(b2 + d2 / Rk);
  F(blocks1 + 1, blocks1 + 2) = 2 * b2;
  F(blocks, blocks - 1) = 2 * b2;
  F(blocks, blocks) = -2 * b2;
 select GU1type
    case 1 then
      F(1, :) = [];
      F(:, 1) = [];
    case 2 then
      F(1, 1) = -2 * b1;
    case 3 then
      F(1, 1) = -2 * (b1 + alpha1 * d1);
  end
  select GU2type
    case 1 then
      F(size(F, 'r'), :) = [];
      F(:, size(F, 'c')) = [];
    case 2 then
      F(blocks, blocks) = -2 * b2;
    case 3 then
      F(size(F, 'r'), size(F, 'c')) = -2 * (b2 + alpha2 * d2);
  end
  //Расчёт матрицы управления G
  G = zeros(blocks, 2);
  select GU1type
    case 1 then
      G(1, :) = [];
      G(1, 1) = b1;
    case 2 then
      G(1, 1) = 2 * d1;
    case 3 then
      G(1, 1) = 2 * d1 * alpha1;
  end
  select GU2type
    case 1 then
      G(size(G, 'r'), :) = [];
      G(size(G, 'r'), 2) = b2;
    case 2 then
      G(size(G, 'r'), 2) = 2 * d2; 
    case 3 then
      G(size(G, 'r'), 2) = 2 * d2 * alpha2;
  end
endfunction

// *********
// Двухсоставной неоднородный ПТП с идеальным контактом
// ***********

function [F, G] = drm2_1(lambda1, lambda2, a1, a2, h1, h2, blocks1, blocks2, ...
GU1type, GU2type, alpha1, alpha2)
  //Расчёт вспомогательных переменных
  delta1 = h1 / (blocks1 - 1);
  delta2 = h2 / (blocks2 - 1);
  b1 = a1 / delta1^2;
  b2 = a2 / delta2^2;
  d1 = a1 / (lambda1 * delta1);
  d2 = a2 / (lambda2 * delta2);
  blocks = blocks1 + blocks2;
  //Расчёт матрицы обратных связей F
  F = zeros(blocks - 1, blocks - 1);
  for i=1:1:blocks1 - 1;
    F(i, i) = -2 * b1;
    F(i, i + 1) = b1;
    F(i + 1, i) = b1;
  end;
  F(1, 2) = 2 * b1;
  F(blocks1, blocks1 - 1) = 2 * lambda1 / (delta1 * (1/d1 + 1/d2));
  F(blocks1, blocks1) = -2 * (lambda1/delta1 + lambda2/delta2) / (1/d1 + 1/d2);
  F(blocks1, blocks1 + 1) = 2 * lambda2 / (delta2 * (1/d1 + 1/d2));
  F(blocks1 + 1, blocks1) = b2;  
  for i = blocks1+1:1:blocks - 2;
    F(i, i) = - 2 * b2;
    F(i, i + 1) = b2;
    F(i + 1, i) = b2;
  end;  
  F(blocks - 1, blocks - 2) = 2 * b2;
  F(blocks - 1, blocks - 1) = -2 * b2;
 select GU1type
    case 1 then
      F(1, :) = [];
      F(:, 1) = [];
    case 2 then
      F(1, 1) = -2 * b1;
    case 3 then
      F(1, 1) = -2 * (b1 + alpha1 * d1);
  end
  select GU2type
    case 1 then
      F(size(F, 'r'), :) = [];
      F(:, size(F, 'c')) = [];
    case 2 then
      F(blocks - 1, blocks - 1) = -2 * b2;
    case 3 then
      F(size(F, 'r'), size(F, 'c')) = -2 * (b2 + alpha2 * d2);
  end
  //Расчёт матрицы управления G
  G = zeros(blocks - 1, 2);
  select GU1type
    case 1 then
      G(1, :) = [];
      G(1, 1) = b1;
    case 2 then
      G(1, 1) = 2 * d1;
    case 3 then
      G(1, 1) = 2 * d1 * alpha1;
  end
  select GU2type
    case 1 then
      G(size(G, 'r'), :) = [];
      G(size(G, 'r'), 2) = b2;
    case 2 then
      G(size(G, 'r'), 2) = 2 * d2; 
    case 3 then
      G(size(G, 'r'), 2) = 2 * d2 * alpha2;
  end
endfunction

// *********
// Комбинированный ПТП с воздушной прослойкой
// ***********

function [F, G] = drm3(lambda1, lambda2, lambda3, a1, a2, h1, h2, h3, ...
blocks1, blocks2, GU1type, GU2type, alpha1, alpha2)
  //Расчёт вспомогательных переменных
  delta1 = h1 / (blocks1 - 1);
  delta2 = h2 / (blocks2 - 1);
  b1 = a1 / delta1^2;
  b2 = a2 / delta2^2;
  d1 = a1 / (lambda1 * delta1);
  d2 = a2 / (lambda2 * delta2);
  blocks = blocks1 + blocks2;
  sigma = lambda3 / h3;
  //Расчёт матрицы обратных связей F
  F = zeros(blocks, blocks);
  for i=1:1:blocks1 - 1;
    F(i, i) = -2 * b1;
    F(i, i + 1) = b1;
    F(i + 1, i) = b1;
  end;
  F(1, 2) = 2 * b1;
  F(blocks1, blocks1 - 1) = 2 * b1;
  F(blocks1, blocks1) = - 2 * (b1 + sigma * d1);
  F(blocks1, blocks1 + 1) = 2 * sigma * d1;
  for i = blocks1 + 1:1:blocks - 1;
    F(i, i) = - 2 * b2;
    F(i, i + 1) = b2;
    F(i + 1, i) = b2;
  end;  
  F(blocks1 + 1, blocks1) = 2 * sigma * d2;
  F(blocks1 + 1, blocks1 + 1) = - 2 * (b2 + sigma * d2);
  F(blocks1 + 1, blocks1 + 2) = 2 * b2;
  F(blocks, blocks - 1) = 2 * b2;
  F(blocks, blocks) = -2 * b2;
  select GU1type
    case 1 then
      F(1, :) = [];
      F(:, 1) = [];
    case 2 then
      F(1, 1) = -2 * b1;
    case 3 then
      F(1, 1) = -2 * (b1 + alpha1 * d1);
  end
  select GU2type
    case 1 then
      F(size(F, 'r'), :) = [];
      F(:, size(F, 'c')) = [];
    case 2 then
      F(blocks, blocks) = -2 * b2;
    case 3 then
      F(size(F, 'r'), size(F, 'c')) = -2 * (b2 + alpha2 * d2);
  end
  //Расчёт матрицы управления G
  G = zeros(blocks, 2);
  select GU1type
    case 1 then
      G(1, :) = [];
      G(1, 1) = b1;
    case 2 then
      G(1, 1) = 2 * d1;
    case 3 then
      G(1, 1) = 2 * d1 * alpha1;
  end
  select GU2type
    case 1 then
      G(size(G, 'r'), :) = [];
      G(size(G, 'r'), 2) = b2;
    case 2 then
      G(size(G, 'r'), 2) = 2 * d2;
    case 3 then
      G(size(G, 'r'), 2) = 2 * d2 * alpha2;
  end
endfunction

// *********
// ПТП типа Гардона
// ***********

function [F, G] = drm4(lambda, a, blocks, GUtype, alpha, R, Rk, h)
  //Расчёт вспомогательных переменных
  delta = R / (blocks - 1);
  b = a / delta^2;
  //Расчёт матрицы обратных связей F
  F = zeros(blocks, blocks);
  F(1, 1)   = - 4 * b;
  F(1, 2)   = 4 * b;
  for i = 2:1:blocks - 1
    m = (i - 1) * 2;
    F(i, i - 1) = b * (m - 1) / m;
    F(i, i) = - 2 * b;
    F(i, i + 1) = b * (m + 1) / m;
  end
  F(blocks, blocks - 1) = b * (8 * blocks - 12) / (4 * blocks - 5);
  F(blocks, blocks) = - b * (8 * blocks - 12) / (4 * blocks - 5) - (8 * blocks - 8) * a / ((4 * blocks - 5) * delta * lambda * Rk);
  //Расчёт матрицы управления G
  for i = 1:1:blocks;
    G(i,  1) = a / (lambda * h);
    G(i,  2) = 0;
  end;
  G(blocks, 2) = a * (8 * blocks - 8) / (lambda * delta * Rk * (4 * blocks - 5));
endfunction

// *********
// Однородный ПТП типа полуограниченного тела
// ***********

function [F, G] = drm5(lambda, a, delta, m, blocks, GUtype, alpha)
  //Расчёт вспомогательных переменных
  c = 2^m;
  b = a / delta^2;
  d = a / (lambda * delta);
  //Расчёт матрицы обратных связей F
  for i = 1:1:blocks;
    for j = 1:1:blocks;
      F(i, j) =  0;
    end;
    F(i, i) = -2 * b / c^(-4 + 2 * i);
  end;
  for i=2:1:blocks - 1;
    F(i, i + 1) = 2 * b / ((1 + c) * c^(-4 + 2 * i));
    F(i + 1, i) = 2 * b / ((1 + c) * c^(-3 + 2 * i));
  end;
  F(1, 1)   = -2 * b;
  F(1, 2)   = 2 * b;
  F(2, 1)   = b;
  F(2, 2)   = -b * (1 + 2 / (1 + c));
  F(2, 3)   = 2 * b / (1 + c);
  F(blocks, blocks) = -2 * b / ((1 + c) * c^(-5 + 2 * blocks));
  select GUtype
    case 1 then
      F(1, :) = [];
      F(:, 1) = [];
    case 2 then
      F(1, 1) = -2 * b;
    case 3 then
      F(1, 1) = -2 * (b + alpha * d);
  end
  //Расчёт матрицы управления G
  G = zeros(blocks, 2);
  select GUtype
    case 1 then
      G(1, :) = [];
      G(1, 1) = b;
    case 2 then
      G(1, 1) = 2 * d;
    case 3 then
      G(1, 1) = 2 * d * alpha;
  end
endfunction

// *********
// Однородный ПТП на полуограниченном теле с контактным тепловым сопротивлением
// ***********

function [F, G] = drm6(lambda1, lambda2, a1, a2, h1, delta2, m2, blocks1, ...
blocks2, Rk, GUtype, alpha)
  //Расчёт вспомогательных переменных
  c = 2^m2;
  delta1 = h1 / (blocks1 - 1);
  b1 = a1 / delta1^2;
  b2 = a2 / delta2^2;
  d1 = a1 / (lambda1 * delta1);
  d2 = a2 / (lambda2 * delta2);
  //Расчёт матрицы обратных связей F
  F = zeros(blocks1 + blocks2, blocks1 + blocks2);
  for i = 1:1:blocks1 - 1;
    F(i, i) = -2 * b1;
    F(i, i + 1) = b1;
    F(i + 1, i) = b1;
  end;
  F(1, 2) = 2 * b1;
  F(blocks1, blocks1 - 1) = 2 * b1;
  F(blocks1, blocks1) = -2 * (b1 + d1 / Rk);
  F(blocks1, blocks1 + 1) = 2 * d1 / Rk;
  for i = blocks1 + 2:1:blocks1 + blocks2 - 1;
    F(i, i) = -2 * b2 / c^(-4 + 2 * (i - blocks1));
    F(i, i + 1) = 2 * b2 / ((1 + c) * c^(-4 + 2 * (i - blocks1)));
    F(i + 1, i) = 2 * b2 / ((1 + c) * c^(-3 + 2 * (i - blocks1)));
  end;
  F(blocks1 + 1, blocks1) = 2 * d2 / Rk;
  F(blocks1 + 1, blocks1 + 1) = -2 * (b2 + d2 / Rk);
  F(blocks1 + 1, blocks1 + 2) = 2 * b2;
  F(blocks1 + 2, blocks1 + 1) = b2;
  F(blocks1 + 2, blocks1 + 2) = -b2 * (1 + 2 / (1 + c));
  F(blocks1 + 2, blocks1 + 3) = 2 * b2 / (1 + c);
  F(blocks1 + blocks2, blocks1 + blocks2) = -2 * b2 / ...
	((1 + c) * c^(-5 + 2 * blocks2));
  select GUtype
    case 1 then
      F(1, :) = [];
      F(:, 1) = [];
    case 2 then
      F(1, 1) = -2 * b1;
    case 3 then
      F(1, 1) = -2 * (b1 + alpha * d1);
  end
  //Расчёт матрицы управления G
  G = zeros(blocks1 + blocks2, 2);
  select GUtype
    case 1 then
      G(1, :) = [];
      G(1, 1) = b1;
    case 2 then
      G(1, 1) = 2 * d1;
    case 3 then
      G(1, 1) = 2 * d1 * alpha;
  end
endfunction

// *********
// Однородный ПТП на полуограниченном теле с идеальным тепловым контактом
// ***********

function [F, G] = drm6_1(lambda1, lambda2, a1, a2, h1, delta2, m2, blocks1, ...
blocks2, GUtype, alpha)
  //Расчёт вспомогательных переменных
  c = 2^m2;
  delta1 = h1 / (blocks1 - 1);
  b1 = a1 / delta1^2;
  b2 = a2 / delta2^2;
  d1 = a1 / (lambda1 * delta1);
  d2 = a2 / (lambda2 * delta2);
  //Расчёт матрицы обратных связей F
  F = zeros(blocks1 + blocks2 - 1, blocks1 + blocks2 - 1);
  for i = 1:1:blocks1 - 1;
    F(i, i) = -2 * b1;
    F(i, i + 1) = b1;
    F(i + 1, i) = b1;
  end;
  F(1, 2) = 2 * b1;
  F(blocks1, blocks1 - 1) = 2 * lambda1 / (delta1 * (1/d1 + 1/d2));
  F(blocks1, blocks1) = -2 * (lambda1/delta1 + lambda2/delta2) / (1/d1 + 1/d2);
  F(blocks1, blocks1 + 1) = 2 * lambda2 / (delta2 * (1/d1 + 1/d2));
  for i = blocks1 + 1:1:blocks1 + blocks2 - 2;
    F(i, i) = -2 * b2 / c^(-4 + 2 * (i - blocks1));
    F(i, i + 1) = 2 * b2 / ((1 + c) * c^(-4 + 2 * (i - blocks1 + 1)));
    F(i + 1, i) = 2 * b2 / ((1 + c) * c^(-3 + 2 * (i - blocks1 + 1)));
  end;
  F(blocks1 + 1, blocks1) = b2;
  F(blocks1 + 1, blocks1 + 1) = -b2 * (1 + 2 / (1 + c));
  F(blocks1 + 1, blocks1 + 2) = 2 * b2 / (1 + c);
  F(blocks1 + blocks2 - 1, blocks1 + blocks2 - 1) = -2 * b2 / ...
	((1 + c) * c^(-5 + 2 * blocks2));
  select GUtype
    case 1 then
      F(1, :) = [];
      F(:, 1) = [];
    case 2 then
      F(1, 1) = -2 * b1;
    case 3 then
      F(1, 1) = -2 * (b1 + alpha * d1);
  end
  //Расчёт матрицы управления G
  G = zeros(blocks1 + blocks2 - 1, 2);
  select GUtype
    case 1 then
      G(1, :) = [];
      G(1, 1) = b1;
    case 2 then
      G(1, 1) = 2 * d1;
    case 3 then
      G(1, 1) = 2 * d1 * alpha;
  end
endfunction

function [F, G] = drm6_2(lambda1, lambda2, lambda3, a1, a2, a3, h1, h2, delta3, m3, blocks1, ...
blocks2, blocks3, GUtype, alpha)
  //Расчёт вспомогательных переменных
  c = 2^m3;
  delta1 = h1 / (blocks1 - 1);
  delta2 = h2 / (blocks2 - 1);
  b1 = a1 / delta1^2;
  b2 = a2 / delta2^2;
  b3 = a3 / delta3^2;  
  d1 = a1 / (lambda1 * delta1);
  d2 = a2 / (lambda2 * delta2);
  d3 = a3 / (lambda3 * delta3);  
  //Расчёт матрицы обратных связей F
  F = zeros(blocks1 + blocks2 + blocks3 - 2, blocks1 + blocks2 + blocks3 - 2);
  for i = 1:1:blocks1 - 1;
    F(i, i) = -2 * b1;
    F(i, i + 1) = b1;
    F(i + 1, i) = b1;
  end;
  F(1, 2) = 2 * b1;  
  F(blocks1, blocks1 - 1) = 2 * lambda1 / (delta1 * (1/d1 + 1/d2));
  F(blocks1, blocks1) = -2 * (lambda1/delta1 + lambda2/delta2) / (1/d1 + 1/d2);
  F(blocks1, blocks1 + 1) = 2 * lambda2 / (delta2 * (1/d1 + 1/d2));
  for i = blocks1 + 1:1:blocks1 + blocks2 - 2;
    F(i, i) = - 2 * b2;
    F(i, i + 1) = b2;
    F(i + 1, i) = b2;
  end;
  F(blocks1 + 1, blocks1) = 2 * b2;
  F(blocks1 + blocks2 - 1, blocks1 + blocks2 - 2) = 2 * lambda2 / (delta2 * (1/d2 + 1/d3));
  F(blocks1 + blocks2 - 1, blocks1 + blocks2 - 1) = -2 * (lambda2/delta2 + lambda3/delta3) / (1/d2 + 1/d3);
  F(blocks1 + blocks2 - 1, blocks1 + blocks2) = 2 * lambda3 / (delta3 * (1/d2 + 1/d3));
  for i = blocks1 + blocks2:1:blocks1 + blocks2 + blocks3 - 3;
    F(i, i) = -2 * b3 / c^(-4 + 2 * (i - blocks1 - blocks2 + 1));
    F(i, i + 1) = 2 * b3 / ((1 + c) * c^(-4 + 2 * (i - blocks1 - blocks2 + 2)));
    F(i + 1, i) = 2 * b3 / ((1 + c) * c^(-3 + 2 * (i - blocks1 - blocks2 + 2)));
  end;
  F(blocks1 + blocks2, blocks1 + blocks2 - 1) = b3;
  F(blocks1 + blocks2, blocks1 + blocks2) = -b3 * (1 + 2 / (1 + c));
  F(blocks1 + blocks2, blocks1 + blocks2 + 1) = 2 * b3 / (1 + c);
  F(blocks1 + blocks2 + blocks3 - 2, blocks1 + blocks2 + blocks3 - 2) = -2 * b3 / ...
	((1 + c) * c^(-5 + 2 * blocks3));
  select GUtype
    case 1 then
      F(1, :) = [];
      F(:, 1) = [];
    case 2 then
      F(1, 1) = -2 * b1;
    case 3 then
      F(1, 1) = -2 * (b1 + alpha * d1);
  end
  //Расчёт матрицы управления G
  G = zeros(blocks1 + blocks2 + blocks3 - 2, 2);
  select GUtype
    case 1 then
      G(1, :) = [];
      G(1, 1) = b1;
    case 2 then
      G(1, 1) = 2 * d1;
    case 3 then
      G(1, 1) = 2 * d1 * alpha;
  end
endfunction

// *********
// Батарейный ПТП
// ***********

function [F, G] = drm7(lambda1, lambda2, lambda3, a1, a2, a3, h1, h2, h3,...
    blocks1, blocks2, blocks3, GU1type, GU2type, alpha1, alpha2)
  //Расчёт вспомогательных переменных
  delta1 = h1 / (blocks1 - 1);
  delta2 = h2 / (blocks2 - 1);
  delta3 = h3 / (blocks3 - 1);
  b1 = a1 / delta1^2;
  b2 = a2 / delta2^2;
  b3 = a3 / delta3^2;
  d1 = a1 / (lambda1 * delta1);
  d2 = a2 / (lambda2 * delta2);
  d3 = a3 / (lambda3 * delta3);
  blocks = blocks1 + blocks2 + blocks3;
  //Расчёт матрицы обратных связей F
  F = zeros(blocks - 2, blocks - 2);
  for i=1:1:blocks1 - 1;
    F(i, i) = -2 * b1;
    F(i, i + 1) = b1;
    F(i + 1, i) = b1;
  end;
  F(1, 2) = 2 * b1;
  F(blocks1, blocks1 - 1) = 2 * lambda1 / (delta1 * (1/d1 + 1/d2));
  F(blocks1, blocks1) = -2 * (lambda1/delta1 + lambda2/delta2) / (1/d1 + 1/d2);
  F(blocks1, blocks1 + 1) = 2 * lambda2 / (delta2 * (1/d1 + 1/d2));
  F(blocks1 + 1, blocks1) = b2;  
  for i = blocks1 + 1:1:blocks1 + blocks2 - 2;
    F(i, i) = - 2 * b2;
    F(i, i + 1) = b2;
    F(i + 1, i) = b2;
  end; 
  for i = blocks1 + blocks2 - 1:1:blocks - 3;
    F(i, i) = - 2 * b3;
    F(i, i + 1) = b3;
    F(i + 1, i) = b3;  
  end;  
  F(blocks1 + blocks2 - 1, blocks1 + blocks2 - 2) = 2 * lambda2 / (delta2 * (1/d2 + 1/d3));
  F(blocks1 + blocks2 - 1, blocks1 + blocks2 - 1) = -2 * (lambda2/delta2 + lambda3/delta3) / (1/d2 + 1/d3);
  F(blocks1 + blocks2 - 1, blocks1 + blocks2) = 2 * lambda3 / (delta3 * (1/d2 + 1/d3));
  F(blocks - 2, blocks - 3) = 2 * b3;
  F(blocks - 2, blocks - 2) = -2 * b3;
 select GU1type
    case 1 then
      F(1, :) = [];
      F(:, 1) = [];
    case 2 then
      F(1, 1) = -2 * b1;
    case 3 then
      F(1, 1) = -2 * (b1 + alpha1 * d1);
  end
  select GU2type
    case 1 then
      F(size(F, 'r'), :) = [];
      F(:, size(F, 'c')) = [];
    case 2 then
      F(size(F, 'r'), size(F, 'c')) = -2 * b3;
    case 3 then
      F(size(F, 'r'), size(F, 'c')) = -2 * (b3 + alpha2 * d3);
  end
  //Расчёт матрицы управления G
  G = zeros(blocks - 2, 2);
  select GU1type
    case 1 then
      G(1, :) = [];
      G(1, 1) = b1;
    case 2 then
      G(1, 1) = 2 * d1;
    case 3 then
      G(1, 1) = 2 * d1 * alpha1;
  end
  select GU2type
    case 1 then
      G(size(G, 'r'), :) = [];
      G(size(G, 'r'), 2) = b3;
    case 2 then
      G(size(G, 'r'), 2) = 2 * d3; 
    case 3 then
      G(size(G, 'r'), 2) = 2 * d3 * alpha2;
  end
endfunction

// *********
// Высокотемпературный ПТП без защитной пластины
// ***********

function [F, G] = drm8(lambda1, lambda2, a1, a2, h, Rk, blocks)
  //Расчёт вспомогательных переменных
  delta = h / (blocks - 1);
  b2 = a2 / delta^2;
  cro1 = lambda1 / a1;
  cro2 = lambda2 / a2;
  //Расчёт матрицы обратных связей F
  F = zeros(blocks, blocks);
  for i = 1:1:blocks - 1;
    F(i, i) = -2 * b2;
    F(i, i + 1) = b2;
    F(i + 1, i) = b2;
  end;
  F(1, 1) = - 4 * lambda2 / (delta^2 * (cro1 + 3*cro2));
  F(1, 2) = 4 * lambda2 / (delta^2 * (cro1 + 3*cro2));
  F(blocks, blocks - 1) = 4 * lambda2 / (delta^2 * (cro1 + 3*cro2));
  F(blocks, blocks) = - (4 * lambda2 / (delta^2 * (cro1 + 3*cro2))) + (4 * lambda2 / (delta * Rk * (cro1 + 3*cro2)));
  //Расчёт матрицы управления G
  G = zeros(blocks, 2);
  G(1, 1) = 4 / (delta * (cro1 + 3*cro2));
  G(blocks, 2) = 4 / (delta * Rk * (cro1 + 3*cro2));
endfunction

// *********
// Высокотемпературный ПТП с защитной пластиной
// ***********

function [F, G] = drm8_1(lambda1, lambda2, lambda3, a1, a2, a3, h1, h2, blocks1, blocks2, Rk1, Rk2)
  //Расчёт вспомогательных переменных
  delta1 = h1 / (blocks1 - 1);
  delta2 = h2 / (blocks2 - 1);
  b3 = a3 / delta1^2;
  b2 = a2 / delta2^2;
  d1 = a1 / (lambda1 * delta1);
  d2 = a2 / (lambda2 * delta2);
  cro1 = lambda1 / a1;
  cro2 = lambda2 / a2;
  cro3 = lambda3 / a3;  
  blocks = blocks1 + blocks2;
  //Расчёт матрицы обратных связей F
  F = zeros(blocks - 1, blocks - 1);
  F(1, 1) = - 2 * b3;
  F(1, 2) = 2 * b3;
  for i=2:1:blocks1 - 1;
    F(i, i - 1) = b3;
    F(i, i) = - b3 - 1/(cro3 * delta1 * Rk1);
    F(i, i + 1) = 1/(cro3 * delta1 * Rk1);
  end;
  F(blocks1, blocks1 - 1) = 4 / (delta2 * Rk1 * (cro1 + 3 * cro2));
  F(blocks1, blocks1) = - ( 4 / (delta2 * Rk1 * (cro1 + 3 * cro2)) + 4 * lambda2 / (delta2^2 * (cro1 + 3 * cro2)));
  F(blocks1, blocks1 + 1) = 4 * lambda2 / (delta2^2 * (cro1 + 3 * cro2));
  for i = blocks1+1:1:blocks - 2;
    F(i, i - 1) = b2;
    F(i, i) = - 2 * b2;
    F(i, i + 1) = b2;
  end;  
  F(blocks - 1, blocks - 2) = 4 * lambda2 / (delta2^2 * (cro1 + 3 * cro2));
  F(blocks - 1, blocks - 1) = - (4 * lambda2 / (delta2^2 * (cro1 + 3 * cro2)) + 4 / (delta2 * Rk2 * (cro1 + 3 * cro2)));
  //Расчёт матрицы управления G
  G = zeros(blocks - 1, 2);
  G(1, 1) = 2 / (delta1 * cro3);
  G(blocks - 1, 2) = 4 / (delta2 * Rk2 * (cro1 + 3*cro2));  
endfunction
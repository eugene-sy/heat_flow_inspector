function [Hqa, Hqb] = getHH(To, F, G, H, U2, dt, sp_length, qa, qb, dq, dt_count)
  rule_orig = tlist(['spline';'A']);
  rule_orig.A = [0 qa; dt * sp_length qb];
  U1 = getU(rule_orig, dt, sp_length);
  Y_orig = getYT(To, F, G, H, [U1, U2], dt, dt_count);
  rule_qa = tlist(['spline';'A']);
  rule_qa.A = [0 qa * (1 + dq); dt * sp_length qb];
  U1_qa = getU(rule_qa, dt, sp_length);
  Y_qa = getYT(To, F, G, H, [U1_qa, U2], dt, dt_count);
  rule_qb = tlist(['spline';'A']);
  rule_qb.A = [0 qa; dt * sp_length qb * (1 + dq)];
  U1_qb = getU(rule_qb, dt, sp_length);
  Y_qb = getYT(To, F, G, H, [U1_qb, U2], dt, dt_count);
  for j = 1:1:dt_count
    for i = 1:1:size(Y_orig, 'r')
      Hqa(i, j) = ( Y_qa(i, j) - Y_orig(i, j) ) / (qa * dq);
      Hqb(i, j) = ( Y_qb(i, j) - Y_orig(i, j) ) / (qb * dq);   
    end
  end
endfunction

function [x, y, z] = getSDO(Hqa, Hqb, sp_length, B)
  A = zeros(2, 2);
  for j = 1:1:sp_length
    A = A + [Hqa(:, j) Hqb(:, j)]' * [Hqa(:, j) Hqb(:, j)];
  end
  inv_A = inv(A);
  delta_qa = sqrt(inv_A(1, 1) * B); 
  delta_qb = sqrt(inv_A(2, 2) * B);
  x = -delta_qa:(2 * delta_qa / 100):delta_qa;
  y = -delta_qb:(2 * delta_qb / 100):delta_qb;
  z = zeros(length(x), length(x));
  for i = 1:length(x)
    for j = 1:length(y)
      z(i, j) = A(1, 1) * x(i)^2 + 2 * A(1, 2) * x(i) * y(j) + A(2, 2) * y(j)^2 - B;
    end
  end
endfunction
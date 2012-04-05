function [Q_new, Q_hist, P_hist, HH_hist, K_hist, delta_qa, delta_qb] = getQ(T, F, G, H, U2, dt, sp_length, Q, dq, P, R, Eps, Yreal, B)
  Q_hist = [];
  P_hist = [];
  HH_hist = [];
  K_hist = [];
  
  for place = 1: 1: sp_length;
    [Hqa, Hqb] = getHH(T, F, G, H, U2, dt, sp_length, Q(1), Q(2), dq, place);  
    HH = [Hqa(:, place) Hqb(:, place)];
    rule_new = tlist(['spline';'A']);
    rule_new.A = [0 Q(1); dt * sp_length Q(2)];
    U1_new = getU(rule_new, dt, sp_length);
    Y = getYT(T, F, G, H, [U1_new, U2], dt, place);
    K = P * HH' * inv(HH * P * HH' + R);    
    Q = Q + K * (Yreal(:, place + 1) - Y(:, place));
    P = P - K * HH * P;
    Q_hist = [Q_hist Q];
    P_hist = [P_hist [ P(1, 1); P(2, 2) ] ];
    HH_hist = [HH_hist; HH];
    K_hist = [K_hist K];  
  end;
  A = zeros(2, 2);
  for j = 1:1:sp_length
    A = A + [Hqa(:, j) Hqb(:, j)]' * [Hqa(:, j) Hqb(:, j)];
  end
  inv_A = inv(A);
  if Eps(1, 1) == 0 then sigma = 0.1;
  else sigma = Eps(1, 1);
  end
  delta_qa = sigma * sqrt(inv_A(1, 1) * B); 
  delta_qb = sigma * sqrt(inv_A(2, 2) * B);  
    
  Q_new = Q;
  
endfunction

function [QQ, QQQ, YY, PP, HHH, KK, delta_q] = getQYall(To, F, G, H, U2, dt, sp_length, qo, dq, po, R, Eps, sp_total, Yreal, B)
  QQ = [];
  QQQ = [];
  YY = [];
  PP = [];
  HHH = [];
  QA = [];
  QB = [];
  KK = [];  
  delta_q = [];    
  T = To;
  Q = [qo; qo];
  rule_new = tlist(['spline';'A']);
  for sp_number  = 1: 1: sp_total
    U2_copied = U2(1 + (sp_number - 1) * sp_length:1 + sp_number * sp_length);
    P = [po 0; 0 po];
    [Q, Q_hist, P_hist, HH_hist, K_hist, delta_qa, delta_qb] = getQ(T, F, G, H, U2_copied, dt, sp_length, Q, dq, P, R, Eps,...
        Yreal(:, 1 + (sp_number - 1) * sp_length:1 + sp_number * sp_length), B);
    rule_new.A = [0 Q(1); dt * sp_length Q(2)];
    U1_new = getU(rule_new, dt, sp_length);
    [Y, T] = getYT(T, F, G, H, [U1_new, U2_copied], dt, sp_length);
    YY = [YY Y];
    PP = [PP [ po; po] P_hist ];
    HHH = [HHH; HH_hist];
    KK = [KK K_hist];
    QQ(1, sp_number) = Q(1);
    QQ(1, sp_number + 1) = Q(2);
    delta_q(1, sp_number) = delta_qa;
    delta_q(1, sp_number + 1) = delta_qb;
    QQQ = [QQQ Q_hist];
    Q(1) = Q(2);
    Q(2) = qo;
    
  end
endfunction
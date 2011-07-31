// Version 0.9
function [Y, T] = getYT(To, F, G, H, UU, dt, dt_count)
  T = To;
  I = eye(size(T, 'r'),size(T, 'r'));
  FF = expm(F * dt);
  for step = 1:1:dt_count
    U = [UU(step, 1); UU(step, 2)];
    T = FF * T + 0.5 * (I + FF) * G * U * dt;
    Y(:,step) = H * T; 
  end
endfunction

function [Y] = getYall(To, F, G, H, UU, dt, sp_length, sp_total, Eps)
  Y(:,1) = H * To;
  T = To;
  I = eye(size(T, 'r'),size(T, 'r'));
  FF = expm(F * dt);
  for step = 2:1: sp_length * sp_total + 1
    U = [UU(step - 1, 1); UU(step - 1, 2)];
    T = FF * T + 0.5 * (I + FF) * G * U * dt;
    Y(:,step) = H * T + getRandomError(Eps);
  end
endfunction

function [Err] = getRandomError(Eps)
  for i = 1:1:size(Eps, 'r')
    if Eps(i) == 0
      Err(i) = 0;
    else
      Err(i) = grand(1,1,'nor', 0, Eps(i));
      while abs(Err(i)) > 2 * Eps(i)
        Err(i) = grand(1,1,'nor', 0, Eps(i));      
      end
    end
  end
endfunction
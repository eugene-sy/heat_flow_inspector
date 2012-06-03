// Version 1.1
// разница между стационарной системой и системой реального времени заключается в
// дополнении уранений праметром tau0 - начальный момент времени для расчета


function [U] = getURT(rule, dt, sp_length, tau0)
  rule_type = typeof(rule);
  select rule_type
    case "linear" then
      U = linearRT(rule.a, rule.b, dt, sp_length, tau0);
    case "harmonic" then
      U = harmonicRT(rule.a, rule.b, rule.w, dt, sp_length, tau0)
    case "exponential" then
      U = exponentialRT(rule.a, rule.b, rule.w, dt, sp_length, tau0)
    case "impulse" then
      U = impulseRT(rule.A, dt, sp_length, tau0);
    case "spline" then
      U = splineRT(rule.A, dt, sp_length, tau0);
  end
endfunction

function [U] = linearRT(a, b, dt, sp_length, tau0)
  U = zeros(sp_length + 1, 1);
  for step = 1: 1: sp_length + 1
    U(step, 1) = a + b * ((step - 1) * dt + tau0);
  end
endfunction

function [U] = harmonicRT(a, b, w, dt, sp_length, tau0)
  U = zeros(sp_length + 1, 1);
  for step = 1: 1: sp_length + 1
    U(step, 1) = a + b * sin(w * ((step - 1) * dt + tau0));
  end
endfunction

function [U] = exponentialRT(a, b, w, dt, sp_length, tau0)
  U = zeros(sp_length + 1, 1);
  for step = 1: 1: sp_length + 1
    U(step, 1) = a + b * exp(w * ((step - 1) * dt + tau0));
  end
endfunction

function [U] = impulseRT(A, dt, sp_length, tau0)
  U = zeros(sp_length + 1, 1);
  for step = 1: 1: sp_length + 1
    for row = 1: 1: size(A, 'r')
      if ((step - 1) * dt + tau0) >= A(row, 1) & ((step - 1) * dt + tau0) < A(row, 1) + A(row, 2) then
        U(step, 1) = A(row, 3);
      end
    end
  end
endfunction

function [U] = splineRT(A, dt, sp_length, tau0)
  U = zeros(sp_length + 1, 1);
  for step = 1: 1: sp_length + 1
    for row = 1: 1: size(A, 'r') - 1
      if ((step - 1) * dt + tau0) >= A(row, 1) & ((step - 1) * dt + tau0) <= A(row + 1, 1) then
        U(step, 1) = A(row, 2) * (A(row + 1, 1) - ((step - 1) * dt + tau0)) / ...
          (A(row + 1, 1) - A(row, 1)) + A(row + 1, 2) * ...
          (((step - 1) * dt + tau0) - A(row, 1)) / (A(row + 1, 1) - A(row, 1));
      end
    end
  end
endfunction
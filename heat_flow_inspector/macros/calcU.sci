// Version 0.9
function [U] = getU(rule, dt, sp_length)
  rule_type = typeof(rule);
  select rule_type
    case "linear" then
      U = linear(rule.a, rule.b, dt, sp_length);
    case "harmonic" then
      U = harmonic(rule.a, rule.b, rule.w, dt, sp_length)
    case "exponential" then
      U = exponential(rule.a, rule.b, rule.w, dt, sp_length)
    case "impulse" then
      U = impulse(rule.A, dt, sp_length);
    case "spline" then
      U = spline(rule.A, dt, sp_length);
  end
endfunction

function [U] = linear(a, b, dt, sp_length)
  U = zeros(sp_length + 1, 1);
  for step = 1: 1: sp_length + 1
    U(step, 1) = a + b * (step - 1) * dt;
  end
endfunction

function [U] = harmonic(a, b, w, dt, sp_length)
  U = zeros(sp_length + 1, 1);
  for step = 1: 1: sp_length + 1
    U(step, 1) = a + b * sin(w * (step - 1) * dt);
  end
endfunction

function [U] = exponential(a, b, w, dt, sp_length)
  U = zeros(sp_length + 1, 1);
  for step = 1: 1: sp_length + 1
    U(step, 1) = a + b * exp(w * (step - 1) * dt);
  end
endfunction

function [U] = impulse(A, dt, sp_length)
  U = zeros(sp_length + 1, 1);
  for step = 1: 1: sp_length + 1
    for row = 1: 1: size(A, 'r')
      if (step - 1) * dt >= A(row, 1) & (step - 1) * dt < A(row, 1) + A(row, 2) then
        U(step, 1) = A(row, 3);
      end
    end
  end
endfunction

function [U] = spline(A, dt, sp_length)
  U = zeros(sp_length + 1, 1);
  for step = 1: 1: sp_length + 1
    for row = 1: 1: size(A, 'r') - 1
      if (step - 1) * dt >= A(row, 1) & (step - 1) * dt <= A(row + 1, 1) then
        U(step, 1) = A(row, 2) * (A(row + 1, 1) - (step - 1) * dt) / ...
        (A(row + 1, 1) - A(row, 1)) + A(row + 1, 2) * ...
        ((step - 1) * dt - A(row, 1)) / (A(row + 1, 1) - A(row, 1));
      end
    end
  end
endfunction
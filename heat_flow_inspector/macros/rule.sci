// Version 0.84
function [rule] = getRule(rule_name)
  select rule_name
  case 'linear' then
    rule = tlist(['linear';'a';'b']);
    rule.a = 0;
    rule.b = 0;
  case 'harmonic' then			
    rule = tlist(['harmonic';'a';'b';'w']);
    rule.a = 10000;
    rule.b = 10000;
    rule.w = 4 * %pi ;
  case 'exponential' then
    rule = tlist(['exponential';'a';'b';'w']);
    rule.a = 10000;
    rule.b = 10000;
    rule.w = 1.1 ;
  case 'impulse' then
    rule = tlist(['impulse';'A']);
    rule.A = [0 0.5 5000; 0.5 0.5 1000; 1 1 3000];
  case 'spline' then
    rule = tlist(['spline';'A']);
    rule.A = [0 5000; 0.5 1000; 1 3000];
  end
endfunction

function [desc] = getRuleDesc(rule)
  rule_type = typeof(rule);
  select rule_type
  case "linear" then
    desc = "Линейная: "+string(rule.a)+" + "+string(rule.b)+" * t";
  case "harmonic" then
    desc = "Синус: "+string(rule.a)+" + "+string(rule.b)+" * sin("+string(rule.w)+" * t)";
  case "exponential" then
    desc = "Экспонента: "+string(rule.a)+" + "+string(rule.b)+" * exp("+string(rule.w)+" * t)";
  case "impulse" then
    desc = "Импульсы: "+strcat(sci2exp(rule.A));
  case "spline" then
    desc = "B-сплайны: "+strcat(sci2exp(rule.A));
  end
endfunction
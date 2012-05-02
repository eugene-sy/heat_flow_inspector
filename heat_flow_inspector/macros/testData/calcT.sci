function T = constT(startT, sp_length)
	for i = 1:1:sp_length + 1;
		T(1, i) = startT;
	end
endfunction

function T = linearT(startT, a, tau0, dt)
	for i = 1:1:sp_length + 1;
		T(1, i) = startT + a * (tau0 +  dt * i);
	end
endfunction

function T = harmonicalT(startT, w, tau0, dt)
	for i = 1:1:sp_length + 1;
		T(1, i) = startT + sin(w * ((i - 1) * dt + tau0));
	end
endfunction
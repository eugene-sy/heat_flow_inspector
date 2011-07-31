// Version 0.87

function [ptp] = getPTP(ptp_name)
//HFR - Heat Flow Receiver
  select ptp_name
    case 'ptp1' then
      //HFR-1
      ptp = tlist(['ptp1'; 'name_ru';'lambda';'a';'h';'blocks';'GU1type';...
      'GU2type';'alpha1';'alpha2']);
      ptp.name_ru = 'Однородный ПТП';
      ptp.lambda = 15;
      ptp.a = 3.8e-6;
      ptp.h = 0.005;
      ptp.blocks = 11;
      ptp.GU1type = 2;
      ptp.GU2type = 2;
      ptp.alpha1 = 0;
      ptp.alpha2 = 0;
    case 'ptp2' then
      //HFR-2
      ptp = tlist(['ptp2'; 'name_ru';'lambda1';'lambda2';'a1';'a2';'h1';'h2';...
      'blocks1';'blocks2';'Rk';'GU1type';'GU2type';'alpha1';'alpha2']);
      ptp.name_ru = 'Двухсоставной неоднородный ПТП с контактным тепловым сопротивлением';
      ptp.lambda1 = 31;
      ptp.lambda2 = 20;
      ptp.a1 = 8e-6;
      ptp.a2 = 6.7e-6;
      ptp.h1 = 0.002;
      ptp.h2 = 0.003;
      ptp.blocks1 = 11;
      ptp.blocks2 = 11;
      ptp.Rk = 0.0001;
      ptp.GU1type = 2;
      ptp.GU2type = 2;
      ptp.alpha1 = 0;
      ptp.alpha2 = 0;
    case 'ptp2_1' then
      //HFR-2.1
      ptp = tlist(['ptp2_1'; 'name_ru';'lambda1';'lambda2';'a1';'a2';'h1';'h2';...
      'blocks1';'blocks2';'GU1type';'GU2type';'alpha1';'alpha2']);
      ptp.name_ru = 'Двухсоставной неоднородный ПТП с идеальным контактом';
      ptp.lambda1 = 31;
      ptp.lambda2 = 20;
      ptp.a1 = 8e-6;
      ptp.a2 = 6.7e-6;
      ptp.h1 = 0.002;
      ptp.h2 = 0.003;
      ptp.blocks1 = 11;
      ptp.blocks2 = 11;
      ptp.GU1type = 2;
      ptp.GU2type = 2;
      ptp.alpha1 = 0;
      ptp.alpha2 = 0;      
    case 'ptp3' then
      //HFR-3
      ptp = tlist(['ptp3'; 'name_ru';'lambda1';'lambda2';'lambda3';'a1';'a2';...
      'h1';'h2';'h3';'blocks1';'blocks2';'GU1type';'GU2type';'alpha1';'alpha2']);
      ptp.name_ru = 'Комбинированный ПТП с воздушной прослойкой';
      ptp.lambda1 = 18;
      ptp.lambda2 = 91;
      ptp.lambda3 = 0.026; //Air
      ptp.a1 = 4.6e-6;
      ptp.a2 = 3.1e-5;
      ptp.h1 = 0.001;
      ptp.h2 = 0.003;
      ptp.h3 = 1e-5; //Air
      ptp.blocks1 = 7;
      ptp.blocks2 = 9;
      ptp.GU1type = 2;
      ptp.GU2type = 2;
      ptp.alpha1 = 0;
      ptp.alpha2 = 0;
    case 'ptp4' then
      //HFR-4
      ptp = tlist(['ptp4'; 'name_ru';'lambda';'a';...
      'blocks';'GUtype';'alpha';'R';'Rk';'h']);
      ptp.name_ru = 'ПТП типа Гардона';
      ptp.lambda = 23.3;
      ptp.a = 6.145e-6;
      ptp.blocks = 11;
      ptp.GUtype = 2;
      ptp.alpha = 0;
      ptp.R = 2.5e-3;
      ptp.Rk = 1e-4;
      ptp.h = 1e-4;
    case 'ptp5' then
      //HFR-5
      ptp = tlist(['ptp5'; 'name_ru';'lambda';'a';'delta';'m';'blocks';'GUtype';...
      'alpha']);
      ptp.name_ru = 'Однородный ПТП типа полуограниченного тела';
      ptp.lambda = 40;
      ptp.a = 1.0e-5;
      ptp.delta = 0.0004;
      ptp.m = 0.2;
      ptp.blocks = 23;
      ptp.GUtype = 2;
      ptp.alpha = 0;
    case 'ptp6' then
      //HFR-6
      ptp = tlist(['ptp6'; 'name_ru';'lambda1';'lambda2';'a1';'a2';'h1';'delta2';...
      'm2';'blocks1';'blocks2';'Rk';'GUtype';'alpha']);
      ptp.name_ru = 'Однородный ПТП на полуограниченном теле с контактным тепловым сопротивлением';
      ptp.lambda1 = 15;
      ptp.lambda2 = 0.7;
      ptp.a1 = 3.83e-6;
      ptp.a2 = 2.19e-7;
      ptp.h1 = 0.002;
      ptp.delta2 = 0.0002;
      ptp.m2 = 0.2;
      ptp.blocks1 = 11;
      ptp.blocks2 = 23;
      ptp.Rk = 1e-3;
      ptp.GUtype = 2;
      ptp.alpha = 0;
    case 'ptp6_1' then
      //HFR-6.1
      ptp = tlist(['ptp6_1'; 'name_ru';'lambda1';'lambda2';'a1';'a2';'h1';...
      'delta2';'m2';'blocks1';'blocks2';'GUtype';'alpha']);
      ptp.name_ru = 'Однородный ПТП на полуограниченном теле с идеальным тепловым контактом';
      ptp.lambda1 = 0.35;
      ptp.lambda2 = 40;
      ptp.a1 = 1.47e-7;
      ptp.a2 = 1.0e-5;
      ptp.h1 = 0.0005;
      ptp.delta2 = 0.0001;
      ptp.m2 = 0.2;
      ptp.blocks1 = 11;
      ptp.blocks2 = 23;
      ptp.GUtype = 2;
      ptp.alpha = 0;
    case 'ptp6_2' then
      //HFR-6.2
      ptp = tlist(['ptp6_2';'name_ru';'lambda1';'lambda2';'lambda3';'a1';'a2';'a3';'h1';'h2';'delta3';'m3';...
      'blocks1';'blocks2';'blocks3';'GUtype';'alpha']);
      ptp.name_ru = 'Двухсоставной неоднородный ПТП на полуограниченном теле с идеальным тепловым контактом';
      ptp.lambda1 = 25;
      ptp.lambda2 = 0.2;
      ptp.lambda3 = 0.452;
      ptp.a1 = 7.38e-6;
      ptp.a2 = 8.85e-8;
      ptp.a3 = 2.5e-7;
      ptp.h1 = 0.00003;
      ptp.h2 = 0.00001;
      ptp.delta3 = 0.00003;
      ptp.m3 = 0.2;
      ptp.blocks1 = 2;
      ptp.blocks2 = 2;
      ptp.blocks3 = 23;
      ptp.GUtype = 2;
      ptp.alpha = 0;
    case 'ptp7' then
      //HFR-7
      ptp = tlist(['ptp7'; 'name_ru';'lambda1';'lambda2';'lambda3';...
      'a1';'a2';'a3';'h1';'h2';'h3';'blocks1';'blocks2';'blocks3';...
      'GU1type';'GU2type';'alpha1';'alpha2']);
      ptp.name_ru = 'Батарейный ПТП';
      ptp.lambda1 = 0.2;
      ptp.lambda2 = 0.7;
      ptp.lambda3 = 0.2;
      ptp.a1 = 1.1e-7;
      ptp.a2 = 2.2e-7;
      ptp.a3 = 1.1e-7;
      ptp.h1 = 0.1e-3;
      ptp.h2 = 1.3e-3;
      ptp.h3 = 0.1e-3;
      ptp.blocks1 = 3;
      ptp.blocks2 = 6;
      ptp.blocks3 = 3;
      ptp.GU1type = 2;
      ptp.GU2type = 2;
      ptp.alpha1 = 0;
      ptp.alpha2 = 0;      
    case 'ptp8' then
      //HFR-8
      ptp = tlist(['ptp8'; 'name_ru';'lambda1'; 'lambda2'; 'a1'; 'a2'; 'h'; 'Rk'; 'blocks']);
      ptp.name_ru = 'Высокотемпературный ПТП без защитной пластины';
      ptp.lambda1 = 75.3;
      ptp.lambda2 = 2.36;
      ptp.a1 = 26.7e-6;
      ptp.a2 = 1.1e-6;      
      ptp.h = 0.002;
      ptp.Rk = 1e-3;
      ptp.blocks = 11;
    case 'ptp8_1' then
      //HFR-8.1
      ptp = tlist(['ptp8_1'; 'name_ru';'lambda1'; 'lambda2'; 'lambda3'; 'a1'; 'a2'; 'a3'; 'h1'; 'h2';...
      'blocks1'; 'blocks2'; 'Rk1'; 'Rk2']);
      ptp.name_ru = 'Высокотемпературный ПТП с защитной пластиной';
      ptp.lambda1 = 75.3;
      ptp.lambda2 = 2.36;
      ptp.lambda3 = 28.1;
      ptp.a1 = 26.7e-6;
      ptp.a2 = 1.1e-6;
      ptp.a3 = 3.6e-6
      ptp.h1 = 0.001;
      ptp.h2 = 0.002;
      ptp.blocks1 = 3;
      ptp.blocks2 = 11;
      ptp.Rk1 = 1e-3;
      ptp.Rk2 = 1e-3;
  end
endfunction

function [blocks] = getBlocks(ptp);
	ptp_type = typeof(ptp);
	select ptp_type
      case 'ptp1' then
        blocks = ptp.blocks;
        if ptp.GU1type == 1 then blocks = blocks - 1; end;
        if ptp.GU2type == 1 then blocks = blocks - 1; end;
      case 'ptp2' then
        blocks = ptp.blocks1 + ptp.blocks2;
        if ptp.GU1type == 1 then blocks = blocks - 1; end;
        if ptp.GU2type == 1 then blocks = blocks - 1; end;
      case 'ptp2_1' then
        blocks = ptp.blocks1 + ptp.blocks2 - 1;
        if ptp.GU1type == 1 then blocks = blocks - 1; end;
        if ptp.GU2type == 1 then blocks = blocks - 1; end;
      case 'ptp3' then
        blocks = ptp.blocks1 + ptp.blocks2;
        if ptp.GU1type == 1 then blocks = blocks - 1; end;
        if ptp.GU2type == 1 then blocks = blocks - 1; end;
      case 'ptp4' then
        blocks = ptp.blocks;
        if ptp.GUtype == 1 then blocks = blocks - 1; end;
      case 'ptp5' then
        blocks = ptp.blocks;
        if ptp.GUtype == 1 then blocks = blocks - 1; end;
      case 'ptp6' then
        blocks = ptp.blocks1 + ptp.blocks2;
        if ptp.GUtype == 1 then blocks = blocks - 1; end;
      case 'ptp6_1' then
        blocks = ptp.blocks1 + ptp.blocks2 - 1;
        if ptp.GUtype == 1 then blocks = blocks - 1; end;
      case 'ptp6_2' then
        blocks = ptp.blocks1 + ptp.blocks2 + ptp.blocks3 - 2;
        if ptp.GUtype == 1 then blocks = blocks - 1; end;
      case 'ptp7' then
        blocks = ptp.blocks1 + ptp.blocks2 + ptp.blocks3 - 2;
        if ptp.GU1type == 1 then blocks = blocks - 1; end;
        if ptp.GU2type == 1 then blocks = blocks - 1; end;
      case 'ptp8' then
        blocks = ptp.blocks;
      case 'ptp8_1' then
        blocks = ptp.blocks1 + ptp.blocks2 - 1;        
    end
endfunction

function [GU1type] = getGU1type(ptp)
	ptp_type = typeof(ptp);
	select ptp_type
      case 'ptp1' then
        GU1type = ptp.GU1type;
      case 'ptp2' then
        GU1type = ptp.GU1type;
      case 'ptp2_1' then
        GU1type = ptp.GU1type;
      case 'ptp3' then
        GU1type = ptp.GU1type;
      case 'ptp4' then
        GU1type = ptp.GUtype;
      case 'ptp5' then
        GU1type = ptp.GUtype;
      case 'ptp6' then
        GU1type = ptp.GUtype;
      case 'ptp6_1' then
        GU1type = ptp.GUtype;
      case 'ptp6_2' then
        GU1type = ptp.GUtype;
      case 'ptp7' then
        GU1type = ptp.GU1type;
      case 'ptp8' then
        GU1type = 2;    
      case 'ptp8_1' then
        GU1type = 2;              
    end
endfunction

function [GU2type] = getGU2type(ptp)
	ptp_type = typeof(ptp);
	select ptp_type
      case 'ptp1' then
        GU2type = ptp.GU2type;
      case 'ptp2' then
        GU2type = ptp.GU2type;
      case 'ptp2_1' then
        GU2type = ptp.GU2type;
      case 'ptp3' then
        GU2type = ptp.GU2type;
      case 'ptp4' then
        GU2type = 4;
      case 'ptp5' then
        GU2type = 2;
      case 'ptp6' then
        GU2type = 2;
      case 'ptp6_1' then
        GU2type = 2;
      case 'ptp6_2' then
        GU2type = 2;
      case 'ptp7' then
        GU2type = ptp.GU2type;
      case 'ptp8' then
        GU2type = 4;       
      case 'ptp8_1' then
        GU2type = 4;             
    end
endfunction
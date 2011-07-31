try
 getversion('scilab');
catch
 error('Scilab 5.0 or more is required.');
end;

exec(get_absolute_file_path("loader.sce")+"etc\"+"heat_flow_inspector.start");

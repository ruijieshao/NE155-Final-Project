function ruijie_shao_ne155_final_project()
[n,hx,hy,tolerance,D,sigma,S]=file_reader('inputdata.txt');
phi=transport_solver(n,hx,hy,D,sigma,S,tolerance);
end
function ruijie_shao_ne155_final_project()
[n,hx,hy,tolerance,D,sigma,S]=file_input('inputdata.txt');
phi=transport_solver(n,hx,hy,D,sigma,S,tolerance);
file_output(phi,n);
end
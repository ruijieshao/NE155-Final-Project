function ruijie_shao_ne155_final_project(file_in,file_out)
[n,hx,hy,tolerance,D,sigma,S]=file_input(file_in);
phi=transport_solver(n,hx,hy,D,sigma,S,tolerance);
file_output(phi,n,file_out);
end
function [T_proc] = time_procedure(N,u)

T_proc = N * (2048+144) * 64 * power(2,-u) * (1/(4096 * 480e3));




end
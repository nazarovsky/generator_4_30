% run this to generate all signals ~23 Gb ~ 30 min on i3 550 3.2 Ghz
clear all; clc;

run('gen01_4_30_frequency.m');
run('gen02_4_30_magnitude.m');
run('gen03_4_30_flicker.m');
run('gen04_4_30_k2u_k0u.m');
run('gen05_4_30_17th_harmonic.m');
run('gen06_4_30_2th_harmonic.m');
run('gen07_4_30_5_5th_interharmonic.m');



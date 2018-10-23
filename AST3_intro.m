function data = AST3_intro

% initailze
clear; clc

% get inputs
disp('Welcome to Antisaccade by Jan R. Wessel');
data(1).Nr = input('Subject Number: ');
data.age = input('Age? ');
data.gender = input('Gender? (m/f) ','s');
data.hand = input('Handedness? (l/r) ','s');
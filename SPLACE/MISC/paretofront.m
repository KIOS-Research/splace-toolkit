%{
Copyright (c) 2009, Yi Cao
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are
met:

    * Redistributions of source code must retain the above copyright
      notice, this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above copyright
      notice, this list of conditions and the following disclaimer in
      the documentation and/or other materials provided with the distribution

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
POSSIBILITY OF SUCH DAMAGE.
%}

function [] = paretofront(varargin)
% PARETOFRONT returns the logical Pareto Front of a set of points.
% 
%       synopsis:   front = paretofront(M)
%
%
%   INPUT ARGUMENT
%
%       - M         n x m array, of which (i,j) element is the j-th objective
%                   value of the i-th point;
%
%   OUTPUT ARGUMENT
%
%       - front     n x 1 logical vector to indicate if the corresponding 
%                   points are belong to the front (true) or not (false).
%
% By Yi Cao at Cranfield University, 31 October 2007
%
% Example 1: Find the Pareto Front of a circumference
% 
% alpha = [0:.1:2*pi]';
% x = cos(alpha);
% y = sin(alpha);
% front = paretofront([x y]);
% 
% hold on;
% plot(x,y);
% plot(x(front), y(front) , 'r');
% hold off
% grid on
% xlabel('x');
% ylabel('y');
% title('Pareto Front of a circumference');
% 
% Example 2:  Find the Pareto Front of a set of 3D random points
% X = rand(100,3);
% front = paretofront(X);
% 
% hold on;
% plot3(X(:,1),X(:,2),X(:,3),'.');
% plot3(X(front, 1) , X(front, 2) , X(front, 3) , 'r.');
% hold off
% grid on
% view(-37.5, 30)
% xlabel('X_1');
% ylabel('X_2');
% zlabel('X_3');
% title('Pareto Front of a set of random points in 3D');
% 
% 
% Example 3: Find the Pareto set of a set of 1000000 random points in 4D
%            The machine performing the calculations was a 
%            Intel(R) Core(TM)2 CPU T2500 @ 2.0GHz, 2.0 GB of RAM
%            
% X = rand(1000000,4);
% t = cputime;
% paretofront(X);
% cputime - t
% 
% ans =
% 
%    1.473529

error('mex file absent, type ''mex paretofront.c'' to compile');

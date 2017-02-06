function [xout, yout, iout, jout] = NearestJoint(xin, yin, lx, ly)

iout = [round(xin(1)/lx) ; round(xin(2)/lx)];
xout = lx*iout;
jout = [round(yin(1)/ly) ; round(yin(2)/ly)];
yout = ly*jout;

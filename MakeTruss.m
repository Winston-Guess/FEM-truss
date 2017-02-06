disp('Setting up a rectangular truss')
nx = 2; % Number of joints in each row of links
lx = 3; % Length of horizontal links (in x direction)
ny = 2; % Number of joints in each column of links
ly = 2; % Length of vertical links (in y direction)

% Number of links allowed
nLinks = nx*(ny - 1) + ny*(nx - 1) + (nx - 1)*(ny - 1);

nLoads = 2; % Number of loads allowed

figure(1)
for i = 1:nx
    for j = 1:ny
        plot(lx*i,ly*j,'ro')
        hold on
    end
end
LinkInfo = zeros(nLinks,4);
for i = 1:nLinks
    title('Click on the joints to make the links')
    [xx,yy] = ginput(2);
    [xx, yy, ii, jj] = NearestJoint(xx, yy, lx, ly);
    plot(xx,yy,'b-')
    LinkInfo(i,:) = [ii(1) , jj(1) , ii(2) , jj(2)];
end

title('Click on the joint that will be the fixed support')
[xfs,yfs] = ginput(1);
ifs = round(xfs/lx);
jfs = round(yfs/ly);
plot(lx*ifs,ly*jfs,'go')

title('Click on the joint that will be the roller support')
[xrs,yrs] = ginput(1);
irs = round(xrs/lx);
jrs = round(yrs/ly);
plot(lx*irs,ly*jrs,'co')

xL = zeros(nLoads,1); yL = zeros(nLoads,1);
iL = zeros(nLoads,1); jL = zeros(nLoads,1);
Load = zeros(nLoads,1); Lang = zeros(nLoads,1);

for k = 1:nLoads
    title('Click on the joint that carries a load')
    [xL(k), yL(k)] = ginput(1);
    iL(k) = round(xL(k)/lx);
    jL(k) = round(yL(k)/ly);
    plot(lx*iL,ly*jL,'yo')
    title('Follow MATLAB prompt intructions')
    Load(k) = input('Input the magnitude of the load: ');
    Lang(k) = input('Input the direction of the load in radians: ');
end

save 'Truss.mat' nx ny lx ly nLinks nLoads LinkInfo ifs jfs irs jrs iL jL Load Lang;

hold off
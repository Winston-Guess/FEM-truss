load 'Truss.mat'

nJoints = nx*ny;

coeffx = zeros(nJoints,nLinks + 3);
coeffy = zeros(nJoints,nLinks + 3);

RHSx = zeros(nJoints,1);
RHSy = zeros(nJoints,1);

for k=1:nLinks
    [i1, j1, i2, j2] = LinkEnds(LinkInfo, k);
    ang = atan2((j2-j1)*ly,(i2-i1)*lx);
    
    J = JointNum(i1, j1, nx, ny);
    coeffx(J,k) = cos(ang);
    coeffy(J,k) = sin(ang);
    
    J = JointNum(i2, j2, nx, ny);
    coeffx(J,k) = -cos(ang);
    coeffy(J,k) = -sin(ang);
end

for k = 1:nLoads
    J = JointNum(iL(k), jL(k), nx, ny);
    RHSx(J) = -Load(k)*cos(Lang(k));
    RHSy(J) = -Load(k)*sin(Lang(k));
end

J = JointNum(ifs, jfs, nx, ny);
coeffx(J,nLinks+1) = 1;
coeffy(J,nLinks+2) = 1;

J = JointNum(irs, jrs, nx, ny);
coeffy(J,nLinks+3) = 1;

Force = [coeffx;coeffy]\[RHSx;RHSy];
disp(Force)

jx = zeros(nJoints,1);
jy = zeros(nJoints,1);
Fx = zeros(nJoints,1);
Fy = zeros(nJoints,1);
% clear previous figure
clf
hold on
for k=1:nLinks
    if Force(k)>=10e-10
        colour = 'm-';
    elseif Force(k)<=-10e-10
        colour = 'b-';
    else
        colour = 'r-';
    end
    [i1, j1, i2, j2] = LinkEnds(LinkInfo, k);
    plot(i1*lx,j1*ly,'ro',[i1 i2]*lx,[j1 j2]*ly,colour)
    text((i2-i1)*lx/2+i1*lx,(j2-j1)*ly/2+j1*ly,num2str(Force(k)))
    
    ang = atan2((j2-j1)*ly,(i2-i1)*lx);
    J = JointNum(i1, j1, nx, ny);
    Fx(J) = Fx(J) + Force(k)*cos(ang);
    Fy(J) = Fx(J) + Force(k)*sin(ang);
    jx(J) = i1*lx;
    jy(J) = j1*ly;
        
    J = JointNum(i2, j2, nx, ny);
    Fx(J) = Fx(J) -Force(k)*cos(ang);
    Fy(J) = Fx(J) -Force(k)*sin(ang);
    jx(J) = i2*lx;
    jy(J) = j2*ly;
end

for j=1:nJoints
   Magnitude = sqrt(Fx(j)^2 + Fy(j)^2);
   angle = atan(Fy(j)/Fx(j));
   text(jx(j), jy(j),num2str(Magnitude))
   Arrow(jx(j), jy(j), angle, ly/3, 'y-')
end
fscomps = strcat(num2str(Force(nLinks+1)),',',num2str(Force(nLinks+2)));
text(ifs*lx, jfs*ly-0.2,fscomps)

Arrow(ifs*lx-ly/3, jfs*ly, 0, ly/3, 'g-')
Arrow(ifs*lx, jfs*ly-ly/3, 0.5*pi(), ly/3, 'g-')

text(irs*lx, jrs*ly-0.2,num2str(Force(nLinks+3)))
Arrow(irs*lx, jrs*ly-ly/3, 0.5*pi(), ly/3, 'c-')
figure(1)

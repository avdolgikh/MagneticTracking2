% function M=Babic_24(Rp,Rs,pc,n,tol)
%
% Returns the mutual inductance between two circular loops of radius Rp and Rs (with Rp >= Rs),
% whose centers are separated by a vector pc=[xc,yc,zc], and normal to the plane of secondary loop
% is n=[a,b,c], with absolute tolerance "tol" (default: 1e-10)
%
% All dimensions must be in "meters" and angles in "radians"
%
% The formula used in this function is the one provided by:
% S. Babic, F. Sirois, C. Akyel and C. Girardi, IEEE Trans. Magn., 2010, at press.
%
% The units have been adapted to the S.I. system
%
% Programmed by F. Sirois and S. Babic
% Ecole Polytechnique de Montreal, June 2009

function M=Babic_24(Rp,Rs,pc,n,tol)

if nargin==4,
   tol=1e-13;
elseif nargin<4 || nargin >5,
   error('Wrong number of parameters in function call (Babic_24.m)!');
end

% Recovery of parameters
xc=pc(1); yc=pc(2); zc=pc(3); 
a=n(1); b=n(2); c=n(3); 

% Preliminary computations
alpha=Rs/Rp; beta=xc/Rp; gamma=yc/Rp; delta=zc/Rp;

% Integration, Romberg method (adaptation from author below)
%   Author: Martin Kacenak,
%           Department of Informatics and Control Engineering,
%           Faculty of BERG, Technical University of Kosice,
%           B.Nemcovej 3, 04200 Kosice, Slovak Republic
%   E-mail: ma.kac@post.cz
%   Date:   february 2001
% (Any other numerical integration method would work as well)

decdigs=abs(floor(log10(tol)));
rom=zeros(2,decdigs);
romall=zeros(1,(2^(decdigs-1))+1);   
romall=feval('f24',0:2*pi/2^(decdigs-1):2*pi,alpha,beta,gamma,delta,a,b,c);
h=2*pi;
rom(1,1)=h*(romall(1)+romall(end))/2;
for i=2:decdigs
   step=2^(decdigs-i+1);
   % trapezoidal approximations
   rom(2,1)=(rom(1,1)+h*sum(romall((step/2)+1:step:2^(decdigs-1))))/2;
   % Richardson extrapolation
   for k=1:i-1
      rom(2,k+1)=((4^k)*rom(2,k)-rom(1,k))/((4^k)-1);
   end
   rom(1,1:i)=rom(2,1:i);
   h=h/2;
end
M=4e-7*Rs*rom(1,decdigs);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Integrand function  
function f=f24(p,h,e,g,d,a,b,c)
   h2=h*h; e2=e*e; g2=g*g; a2=a*a; b2=b*b; c2=c*c;
   l2=(a*a+c2); l=sqrt(l2); L2=(l2+b*b); L=sqrt(L2); l2L2=L2*l2; lL=l*L;
   sp=sin(p); cp=cos(p); cp2=cp.*cp; sp2=sp.*sp;
   if l==0,
      p1=0; p2=-g*sign(b); p3=0; p4=-e*sign(b); p5=d;
      V=sqrt( e2+g2+ h2*cp2-2*h*e*sign(b)*cp );
   else
      p1=g*c/l; p2=-(e*l2+g*a*b)/lL; p3=h*c/L; p4=(g*l2-e*a*b-d*b*c)/lL; p5=(d*a-e*c)/l;
      V=sqrt( (e2+g2) + h2*( (1-b2*c2/l2L2)*cp2 + c2/l2*sp2 + a*b*c/(l2*L)*sin(2*p) ) - 2*h/lL*(e*a*b-g*l2)*cp - 2*h*e*c/l*sp );
   end
   A= (1+e2+g2+h2+d*d) + 2*h*(p4*cp+p5*sp);
   m=4*V./(A+2*V); k=sqrt(m);
   [K,E]=ellipke(m);
   %[K,E]=FastEllipKE(m);
   PSI=(1-0.5*m).*K-E;
   f=(p1*cp+p2*sp+p3).*PSI./(k.*V.^1.5);
 
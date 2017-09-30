function yilan()
addpath('GerekliSnakeKutuphanesi\dipimage');
dip_initialise;
r1=imread('yilan.png');
rg1=rgb2gray(r1);
figure(1);
imshow(rg1);
title('Bölgeden 4 Nokta seçiniz');
img = noise(rg1,'gaussian',20);
[ax,ay]=ginput(4);
aortx=mean(ax);
aorty=mean(ay);
fark_x=0;
fark_y=0;
for i=1:4
    for j=1:4
    if(ax(i)-ax(j)>fark_x)
        fark_x=ax(i)-ax(j);
    end
    if(ay(i)-ay(j)>fark_y)
        fark_y=ay(i)-ay(j);
    end
    end
end
x = aortx+(fark_x/2)*cos(0:0.1:2*pi)';
y = aorty+(fark_y/2)*sin(0:0.1:2*pi)';
hold on, plot([x;x(1)],[y;y(1)],'g')

alfa = 0.001;
beta = 0.1;
gamma = 100;
dongu = 50;

N = length(x);
a = gamma*(2*alfa+6*beta)+1;
b = gamma*(-alfa-4*beta);
c = gamma*beta;
P = diag(repmat(a,1,N));
P = P + diag(repmat(b,1,N-1), 1) + diag(b,-N+1);
P = P + diag(repmat(b,1,N-1),-1) + diag(b,N-1);
P = P + diag(repmat(c,1,N-2), 2) + diag([c,c],-N+2);
P = P + diag(repmat(c,1,N-2),-2) + diag([c,c], N-2);
P = inv(P);

% dýþ enerji hesabý
f = gradient(gradmag(img,30));

for ii = 1:dongu
   coords = [x,y];
   fex = get_subpixel(f{1},coords,'linear');
   fey = get_subpixel(f{2},coords,'linear');
   x = P*(x+gamma*fex);
   y = P*(y+gamma*fey);
   if mod(ii,5)==0
      plot([x;x(1)],[y;y(1)],'b')
   end
end
title('Nesne kýrmýzý çizgi ile iþaretlendi.');
plot([x;x(1)],[y;y(1)],'r','LineWidth',3);
end
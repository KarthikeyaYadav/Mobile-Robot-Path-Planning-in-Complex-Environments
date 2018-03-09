
%optimzation of sine function
clc;
clear all;
close all;
%generation of input samples
x=rand(1,100)-0.5;
for k=1:100  
if x(k)<=0
    x_bin(k)=0;
else
    x_bin(k)=1;
end
end

%chromosome generation 
chr1=x_bin(1:10);
chr2=x_bin(11:20);
chr3=x_bin(21:30);
chr4=x_bin(31:40);
chr5=x_bin(41:50);
chr6=x_bin(51:60);
chr7=x_bin(61:70);
chr8=x_bin(71:80);
chr9=x_bin(81:90);
chr10=x_bin(91:100);
%ten sample chromozomes initial population
  
     
chr=[chr1; chr2; chr3; chr4; chr5; chr6; chr7; chr8; chr9; chr10];

 for d=1:10
  
%decimal conversion

% dec1=bin2dec('chr1');
% dec2=bin2dec(chr2);
% dec3=bin2dec(chr3);
% dec4=bin2dec(chr4);
% dec5=bin2dec(chr5);
% dec6=bin2dec(chr6(1:10));
% dec7=bin2dec(chr7(1:10));
% dec8=bin2dec(chr8(1:10));
% dec9=bin2dec(chr9(1:10));
% dec10=bin2dec(chr10(1:10));
%specifieng particular range 
y=[512 256 128 64 32 16 8 4 2 1];
dec1=y*(chr1)';
dec2=y*(chr2)';
dec3=y*chr3';
dec4=y*chr4';
dec5=y*chr5';
dec6=y*chr6';
dec7=y*chr7';
dec8=y*chr8';
dec9=y*chr9';
dec10=y*chr10';
min_r=0; %finding out maximum value in 0 to 2*pi range
max_r=2*pi;
L=10;     %no of intial population 
act_val_1=(min_r+(max_r-min_r)*dec1)/(2^L-1);
act_val_2=(min_r+(max_r-min_r)*dec2)/(2^L-1);
act_val_3=(min_r+(max_r-min_r)*dec3)/(2^L-1);
act_val_4=(min_r+(max_r-min_r)*dec4)/(2^L-1);
act_val_5=(min_r+(max_r-min_r)*dec5)/(2^L-1);
act_val_6=(min_r+(max_r-min_r)*dec6)/(2^L-1);
act_val_7=(min_r+(max_r-min_r)*dec7)/(2^L-1);
act_val_8=(min_r+(max_r-min_r)*dec8)/(2^L-1);
act_val_9=(min_r+(max_r-min_r)*dec9)/(2^L-1);
act_val_10=(min_r+(max_r-min_r)*dec10)/(2^L-1);
%fitness evalution
f_1=sin(act_val_1);
f_2=sin(act_val_2);
f_3=sin(act_val_3);
f_4=sin(act_val_4);
f_5=sin(act_val_5);
f_6=sin(act_val_6);
f_7=sin(act_val_7);
f_8=sin(act_val_8);
f_9=sin(act_val_9);
f_10=sin(act_val_10);
x_f=[f_1 f_2 f_3 f_4 f_5 f_6 f_7 f_8 f_9 f_10];
c_max=sort(x_f(1,:),'descend');
 %c_min=sort(x_f(1,:),'ascend');

%cross over-


for i=1:10
    for j=1:10
        if c_max(i)==x_f(j)
            ngchr(i,:)=chr(j,:); %next generation chromozome sorted from chr based on fitness
        end
    end
end
%probability of cross over
pc=0.8;
num_cross=pc*10;
k=1;
for i=1:num_cross
%randomly selection of two chromozomes for cross over    
ran1=ceil(rand(1,1)*10); %ceil round offs to nearer values
ran2=ceil(rand(1,1)*10);
ran_ngchr1=ngchr(ran1,:);%randomly selected new chromozomes
ran_ngchr2=ngchr(ran2,:);
% child=ran_ngchr1
ran3=ceil(rand(1,1)*10);
ran4=ran3+1; %from the randomly generated nexth position
z(k,:)=[ran_ngchr1(1:ran3) ran_ngchr2(ran4:10)]; %store cross over results i,e two childs in z
z(k+1,:)=[ran_ngchr2(1:ran3) ran_ngchr1(ran4:10)];%swapping
k=k+2;
end
%mutation
k=1;

ran7=0.1*16*10;%num of iterations mutation should occur total 10,crossover result 16 muatation 16 times

for i=1:ran7
    ran5=ceil(rand(1,1)*10);%position to be mutated
ran6=ceil(rand(1,1)*16);%select the cross over child
 ran_cross_child(i,:)=z(ran6,:);
    if ran_cross_child(i,ran5)==0
         ran_cross_child(i,ran5)=1;
    else 
        ran_cross_child(i,ran5)=0;
    end
  
end
  apend_mat=[chr;z;ran_cross_child];
 dec_apend_mat=y*(apend_mat)';
 min_r=0;
max_r=2*pi;
L=10;
act_val_apend_mat=(min_r+(max_r-min_r)*dec_apend_mat)/(2^L-1);
f_apend_mat=sin(act_val_apend_mat);
c_max_apend_mat=sort(f_apend_mat(1,:),'descend');
c_min_apend_mat=sort(x_f(1,:),'ascend');
for i=1:10
    for j=1:42
        if c_max_apend_mat(i)==f_apend_mat(j)
            ngchr1(i,:)=apend_mat(j,:);
        end
    end
end

chr=ngchr1;
c_max1(d)=c_max_apend_mat(1,1);
   end
 
 
plot(c_max1)

    
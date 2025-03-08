function exp=expand(I,a)
[t1 t2]=size(I);
ImageEXP=zeros(t1+2*a,t2+2*a);
%srodek

for i=a+1:1:t1+a
    for j=a+1:1:t2+a
        ImageEXP(i,j)=I(i-a,j-a);
    end;
end;

%lewy prawy

for i=1:1:t1
    for j=1:1:a
        ImageEXP(i+a,j)=I(i,a+1-j);
        ImageEXP(i+a,2*a+t2+1-j)=I(i,t2-a+j);
    end;
end;

%gora dol

for j=1:1:t2
    for i=1:1:a
        ImageEXP(i,j+a)=I(a+1-i,j);
        ImageEXP(a+t1+i,j+a)=I(t1-i+1,j);
    end;
end;

%rogi

for i=1:1:a
    for j=1:1:a
    
        ImageEXP(i,j)=ImageEXP(i,2*a+1-j);
        ImageEXP(i,a+t2+j)=ImageEXP(i,t2-j+a+1);
        ImageEXP(a+t1+i,j)=ImageEXP(a+t1+i,2*a+1-j);
        ImageEXP(a+t1+i,a+t2+j)=ImageEXP(a+t1+i,a+t2-j+1);
        
    end;
end;


exp=ImageEXP;
end
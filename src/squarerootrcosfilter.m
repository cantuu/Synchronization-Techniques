% Adapted from Mathuranathan Viswanathan. The original code can be found in:
% <https://www.gaussianwaves.com/2011/04/square-root-raised-cosine-filter-matchedsplit-filter-implementation-2/>

function response=squarerootrcosfilter(roll_off, spam, sps)
   
  a=roll_off;
  t=-spam:1/sps:spam;

  p=zeros(1,length(t));
  for i=1:1:length(t)
      if t(i)==0
          p(i)= (1-a)+4*a/pi;
      else if t(i)==1/(4*a) || t(i)==-1/(4*a)
             p(i)=a/sqrt(2)*((1+2/pi)*sin(pi/(4*a))+(1-2/pi)*cos(pi/(4*a)));
            else
              p(i) = (sin(pi*t(i)*(1-a))+4*a*t(i).*cos(pi*t(i)*(1+a)))./(pi*t(i).*(1-(4*a*t(i)).^2));
           end
      end
  end
  response=p./sqrt(sum(p.^2)); %Normalization to unit energy
end

%% [EOF]
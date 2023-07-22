function f = age_structured_population(p,Years)
close all
N_init = round(100*rand(3,1));
Initial_Population = sprintf( '%d\n',N_init)
A = [0 p p; 0.5 0 0; 0 0.25 0];
Matrix_A = sprintf('%1.2f %1.2f %1.2f\n',A)
for k = 1:Years
N(:,k) = A^k * N_init;
end
%generate the plot
ph = plot(0:Years,[N_init N],'o-');
legend(ph,'N_0[t]','N_1[t]','N_2[t]','Location','best')
%label the axes
set(gca,'FontSize',14,'FontWeight','b','FontAngle','i')
xlabel('t')
ylabel('Age-structured Population')
f = 1;
end


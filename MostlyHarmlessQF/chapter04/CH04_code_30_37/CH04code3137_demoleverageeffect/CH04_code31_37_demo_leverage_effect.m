%Using SP500 and VIX data to demo leverage-effect
clear
close
%load SP500_VIX.mat
% or load csv file
    Nums=csvread('SP500_VIX.csv');
    SP500=Nums(:,2);
    VIX=Nums(:,3);

r_sp=diff(log(SP500)); %returns of SP500 prices
chg_vix=diff(log(VIX));%changes of VIX
scatter(r_sp,chg_vix);
grid on
X=[ones(length(chg_vix),1),chg_vix];%perparing regressors cotaining constant term
results=fols(r_sp,X);%OLS

range_chg_vix=[min(chg_vix):0.001:max(chg_vix)];
y_hat=results.beta(1)+results.beta(2)*range_chg_vix;
hold on
plot(y_hat,range_chg_vix,'r','LineWidth',2);

ylabel('Returns');
xlabel('Changes of VIX')

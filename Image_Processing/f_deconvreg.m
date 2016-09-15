function [Reimage, lagra] = f_deconvreg(I,PSF,Noise_info)
% 约束最小二乘滤波器
% 函数输入: 
%        I: 输入的二维图像矩阵
%        PSF: 退化函数的空域模板
%        Noise_info: 噪声功率
% 函数输出: 
%        Reimage: 约束最小平方滤波图像
%        lagra: 指定约束最小平方的最佳复原参数y

LR = [1e-9 1e9];    % 复原参数搜索范围

sizeI = size(I);    % 求解输入图像维数

% 转化PSF函数到期望的维数:光传递函数OTF
otf = psf2otf(PSF,sizeI);

% regop：通过计算拉普拉斯算子计算图像的平滑性
% 此处的二维矩阵与method3中相同
regop = [0 1 0; 1 -4 1; 0 1 0];

% 转化PSF函数到期望的维数:光传递函数OTF  
REGOP = psf2otf(regop,sizeI);
 
fftnI = fftn(I);
R2 = abs(REGOP).^2;
H2 = abs(otf).^2;
 
% 计算LAGRA值
R4G2 = (R2.*abs(fftnI)).^2;
H4 = H2.^2;
R4 = R2.^2;
H2R22 = 2*H2.*R2;
ScaledNoiseinfo = Noise_info * prod(sizeI);
lagra = fminbnd(@ResOffset,LR(1),LR(2),[],R4G2,H4,R4,H2R22,ScaledNoiseinfo);
%--------------此处利用fminbnd函数进行有约束的一元函数最小值求解-------------%


% 重构图像
Denominator = H2 + lagra*R2;    % 公式中分母
Numerator = conj(otf).*fftnI;   % 公式中分子

% 保证Denominator中的最小值取为sqrt(eps)
Denominator = max(Denominator, sqrt(eps));
Reimage = real(ifftn(Numerator./Denominator));   % 取实部
end


% 计算反向卷积残差-留数计算
% Parseval公式
function f = ResOffset(LAGRA,R4G2,H4,R4,H2R22,ScaledNP)
Residuals = R4G2./(H4 + LAGRA*H2R22 + LAGRA^2*R4 + sqrt(eps));
f = abs(LAGRA^2*sum(Residuals(:)) - ScaledNP);
end

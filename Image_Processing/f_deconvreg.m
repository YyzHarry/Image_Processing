function [Reimage, lagra] = f_deconvreg(I,PSF,Noise_info)
% Լ����С�����˲���
% ��������: 
%        I: ����Ķ�άͼ�����
%        PSF: �˻������Ŀ���ģ��
%        Noise_info: ��������
% �������: 
%        Reimage: Լ����Сƽ���˲�ͼ��
%        lagra: ָ��Լ����Сƽ������Ѹ�ԭ����y

LR = [1e-9 1e9];    % ��ԭ����������Χ

sizeI = size(I);    % �������ͼ��ά��

% ת��PSF������������ά��:�⴫�ݺ���OTF
otf = psf2otf(PSF,sizeI);

% regop��ͨ������������˹���Ӽ���ͼ���ƽ����
% �˴��Ķ�ά������method3����ͬ
regop = [0 1 0; 1 -4 1; 0 1 0];

% ת��PSF������������ά��:�⴫�ݺ���OTF  
REGOP = psf2otf(regop,sizeI);
 
fftnI = fftn(I);
R2 = abs(REGOP).^2;
H2 = abs(otf).^2;
 
% ����LAGRAֵ
R4G2 = (R2.*abs(fftnI)).^2;
H4 = H2.^2;
R4 = R2.^2;
H2R22 = 2*H2.*R2;
ScaledNoiseinfo = Noise_info * prod(sizeI);
lagra = fminbnd(@ResOffset,LR(1),LR(2),[],R4G2,H4,R4,H2R22,ScaledNoiseinfo);
%--------------�˴�����fminbnd����������Լ����һԪ������Сֵ���-------------%


% �ع�ͼ��
Denominator = H2 + lagra*R2;    % ��ʽ�з�ĸ
Numerator = conj(otf).*fftnI;   % ��ʽ�з���

% ��֤Denominator�е���СֵȡΪsqrt(eps)
Denominator = max(Denominator, sqrt(eps));
Reimage = real(ifftn(Numerator./Denominator));   % ȡʵ��
end


% ���㷴�����в�-��������
% Parseval��ʽ
function f = ResOffset(LAGRA,R4G2,H4,R4,H2R22,ScaledNP)
Residuals = R4G2./(H4 + LAGRA*H2R22 + LAGRA^2*R4 + sqrt(eps));
f = abs(LAGRA^2*sum(Residuals(:)) - ScaledNP);
end

% ��������Լ����С���˷��˲�

%����ƽ��ֵ��ת��Ϊ�Ҷ�ͼ��,����������Ϊdouble
Initialimage = im2double( imread('Penguins.jpg') );
[row, col, color] = size(Initialimage);
Grayimage = zeros(row, col);
for i = 1:row
    for j = 1:col
        summ = 0;
        for k = 1:color
            summ = summ + Initialimage(i,j,k)/3;
        end
        Grayimage(i,j) = summ;
    end
end

% ͼ���˻�����
PSF = fspecial('motion',20,10);      %�����˲����ӣ�����Ϊ�˶�ģ����������㶨���
Blur = imfilter(Grayimage,PSF,'conv','circular');      %ͼ���˲�ʵ���˻���ͨ��������
m = 0;
V = 0.04;
BlurandNoise = imnoise(Blur,'gaussian',m,V);      %��Ӹ�˹����
subplot(221), imshow(Initialimage);
title('ԭͼ��');
subplot(222), imshow(Grayimage);
title('�Ҷ�ͼ��');
subplot(223), imshow(Blur);
title('�˻�ͼ��');
subplot(224), imshow(BlurandNoise);
title('�����˻�ͼ');

% ������ʵ��Լ����С���˷��˲�

%----------------------------Լ����С���˷�ԭ��----------------------------%
% Լ����С���˷��˲���Լ�������Ĺؼ��Ǹ�����׵�����ƽ������С
% ��Ѹ�ԭ��Ϊ f(x,y)=(H'H + ��*C'C)^(-1)*H'g,�ڴ˻����ϵõ���Ƶ����ʽΪ
%               F = [ H'/( ||H||^2+��||C||^2) ] * G
% ���� [C(m,n)] = [0 1 0; 1 -4 1; 0 1 0],����ɢ��һƵ���溯��
% ����һ�����Ե����Ĳ�������ͨ����������������
%               ||g - Hf||^2 = ||n||^2
% ���ﵽ���Ž�

C = [0 1 0; 1 -4 1; 0 1 0];
CFT = psf2otf(C,[row,col]);      %��C������ɢת��ΪƵ���溯��
CF = abs(CFT).^2;
HFT = fft2(PSF,row,col);
HF = abs(HFT).^2;
GFT = fft2(BlurandNoise);      %�˻�����Ƶ��

%-----------------------����ͨ�������㷨�õ�gammaʹ����ﵽ����--------------------%
rate = 0.001;
a = 1e4;
gamma = 2.87;

% ||n||^2�ϺõĹ����� MN[V+m^2],����M��N����ͼ���ά��,V��m^2�ֱ�������������������ֵƽ��
Noise_info = row * col *(V + m^2);

IsContinue = true;
cnt = 0;      %��������
while (IsContinue && cnt<100)   % ���Ƶ�������С��100��
    Fun = GFT.*( conj(HFT)./(HF + gamma*CF) );
    
    R = BlurandNoise - HFT.*( ifft2(Fun) );
    % ��ʱӦ��r��2-����
    r = abs(R).^2;
    s = sum(r(:));
    
    Reimage = ifft2(Fun);      %Լ����С���˷��˲�ʵ��ͼ��ԭ
    
    if (s > Noise_info + a)
        gamma = gamma - rate;
    elseif (s < Noise_info - a)
        gamma = gamma + rate;
    else
        IsContinue = false;
    end
    cnt = cnt + 1;
end

% �˲�Ч��չʾ
figure(2);
subplot(121), imshow(BlurandNoise), title('�����˻�ͼ��');
subplot(122), imshow(Reimage), title('��ԭͼ��3:Լ����С���˷��˲�');

% �ɽ����֪��Լ����С���˷��˲��Ը��������е������������Ҫ����ά���˲�
% ���ڵ����������˲��������������ȣ�ʵ�鱨���лḽͼ��
% �����ڵ����������̣�������������õ���ֵ������������ֵ�ϴ󣬲�֪�Ƿ�ûŪ����ԭ��ʽ
% ���µ������̽���һ��������У���������ֵֻ�����ֶ�����ȷ����Χ����Ч��û�к�����
% ������matlab�Դ�����deconvreg�����˲�Ч������ʵ�鱨���л���з���
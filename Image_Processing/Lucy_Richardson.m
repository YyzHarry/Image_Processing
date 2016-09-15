function Reimage = Lucy_Richardson(BlurandNoise, len, xita, num)
% Lucy_Richardson�˲���
% �������: 
%         BlurandNoise:  �����ͼ�����
%         len:   ģ����ת���ȣ�ģ�������ظ���
%         xita: ģ����ת��
% ---------------len��xitaΪ����ͼ���˻�����ʱ�˶�ģ������
%         num: ��������
% �������: 
%         Reimage: �ع��˲�ͼ��

BlurandNoise = medfilt2(abs(BlurandNoise));  % �ڵ���ǰ����ֵ�˲�����һ���̶ȵĽ���

Blurtmp = BlurandNoise; % ��ʼ����Ŀ�꺯��Ϊԭģ������
% ����չ����PSF
PSF = fspecial('motion',len,xita);
% ת��PSF������������ά��
OTF = psf2otf(PSF,size(BlurandNoise));

for i = 1 : num
    GFT = fft2(Blurtmp);    % ת����Ƶ��
    Ftemp = OTF .* GFT;   % Ƶ����� = ʱ����
    iFtemp = ifft2(Ftemp); % ����Ҷ���任��ת����ʱ��
    % ģ��ǰ �� ȥģ����ı�ֵ
    Ftemp2 = BlurandNoise ./(iFtemp + eps);  %�˴�������eps �������������ʱ���ͼ��Ϊȫ��
    iFtemp2 = fft2(Ftemp2);   % ת����Ƶ��
    Correlation = OTF .* iFtemp2; % �������������
    iCorrelation = ifft2(Correlation);% ����Ҷ���任��ת����ʱ��
    % ������Ƶ�ȥģ��ͼ�����
    Fini = iCorrelation .* Blurtmp;
    Blurtmp = Fini;
end

Reimage = abs(Blurtmp); % �ع��˲�ͼ��

end

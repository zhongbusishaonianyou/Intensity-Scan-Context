function intensity_dis=calculate_intensity_dis(isc1,isc2, angle,sectors,rings)
   min_dis= 1.0;  
    %���������ת�Ƕ�����10�е��ܶ����ƶ�
for i=angle-10:angle+10
      isc_shift=circshift(isc2,i,2);     
      diff=abs(isc1-isc_shift);
      diff_temp= sum(diff(:))/(sectors*rings*255);   
         if diff_temp<min_dis
            min_dis=diff_temp;
        end      
end
      intensity_dis= min_dis;

 end
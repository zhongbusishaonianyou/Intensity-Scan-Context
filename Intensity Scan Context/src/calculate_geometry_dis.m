function  [min_dis,angle_shift] = calculate_geometry_dis(isc1,isc2,sectors,rings)
min_dis=1;angle_shift=0;
for col_idx=1:sectors
    isc=circshift(isc2,col_idx,2);
    sim=xor(isc1,isc);
    hamming_dis=sum(sim(:))/(sectors*rings);
    if hamming_dis<min_dis
      min_dis=hamming_dis;
      angle_shift = col_idx;
    end
end
end


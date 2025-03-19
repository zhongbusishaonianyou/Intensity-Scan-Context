function best_score=is_loop_pair(isc1, isc2,resolution)
      sectors = resolution(2);
      rings   = resolution(1);
    [~,angle]= calculate_geometry_dis(isc1,isc2,sectors,rings);
    intensity_score = calculate_intensity_dis(isc1,isc2,angle,sectors,rings);   
    best_score=intensity_score;

 end
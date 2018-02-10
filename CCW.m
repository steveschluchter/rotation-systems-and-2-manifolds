function [ ccw ] = CCW(A,B,C)
%%% returns the orientation of three points
    ccw = (C(2)-A(2)) * (B(1)-A(1)) > (B(2)-A(2)) * (C(1)-A(1));
end


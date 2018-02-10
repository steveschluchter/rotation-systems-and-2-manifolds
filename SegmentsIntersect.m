function [ intersect ] = SegmentsIntersect(A,B,C,D)
%%% given 4 points, returns true if segment from A to B intersects segment
%%% from C to D

    intersect = (CCW(A,C,D) ~= CCW(B,C,D)) & (CCW(A,B,C) ~= CCW(A,B,D));
    %intersect = (CCW(A,B,C) ~= CCW(A,B,D)) & (CCW(C,D,A) ~= CCW(C,D,B));

end

